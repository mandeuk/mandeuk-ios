//
//  AlamoAPI.swift
//  Clean
//
//  Created by Inho Lee on 6/9/25.
//

import SwiftUI
import Alamofire
import SDWebImageWebPCoder


class APIClient {
    static private let maxFileSize = 1024 * 1024 * 10 // 10MB
    
    static func execute<T: APIRequest>(_ request: T) async -> Result<BaseResponse<T.Response>, APIError> {
        do {
            // 이메일 인증시 Captcha 토큰을 헤더에 넣어야 합니다.
            var headers = URLSessionConfiguration.af.default.headers
            if request.path == ApiAddress.User.emailSendCode,
               let captchaToken = UserDefaults.standard.value(forKey: "captchaToken") as? String {
                headers.add(name: "captchatoken", value: captchaToken)
            }
            print("@LOG API request : \(request.path), \(request.method.rawValue)")
            // API 실행
            let result = await AF.request(
                request.path,
                method: request.method,
                parameters: request.parameters,
                encoder: request.encoder,
                headers: headers
            ) { $0.timeoutInterval = 100 }.serializingData().response
            print("@LOG API response : \(result)")
            // API 결과 처리
            return try processResponse(result, for: request)
        } catch {
            return .failure(error as? APIError ?? APIError(statusCode: error.asAFError?.responseCode ?? 0, message: error.localizedDescription))
        }
         
    }
    
    static func execute<T: APIRequest, F: MediaAttachable>(
        _ request: T,
        files: [F]
    ) async -> Result<BaseResponse<T.Response>, APIError> {
        do {
            // 파일 업로드시 multipart/form-data 를 헤더에 명시 해줘야 합니다.
            var headers = URLSessionConfiguration.af.default.headers
            headers.add(name: "Content-Type", value: "multipart/form-data")
            
            let multipartFormData = MultipartFormData()
            try appendParameters(request.parameters, to: multipartFormData)// 일반 파라미터를 FormData에 추가
            await appendMediaFiles(files, to: multipartFormData)// 파일 데이터를 FormData에 추가
            
            // API 실행
            let result = await AF.upload(
                multipartFormData: multipartFormData,
                to: request.path,
                method: request.method,
                headers: headers
            ) { $0.timeoutInterval = 100 }.serializingData().response
            
            // API 결과 처리
            return try processResponse(result, for: request)
        } catch {
            return .failure(error as? APIError ?? APIError(statusCode: error.asAFError?.responseCode ?? 0, message: error.localizedDescription))
        }
    }
    
    
    
    private static func processResponse<T: APIRequest>(
        _ result: AFDataResponse<Data>,
        for request: T
    ) throws -> Result<BaseResponse<T.Response>, APIError> {
        guard let code = result.response?.statusCode else {
            throw APIError(statusCode: 0, message: "API failed")
        }
        
        if code >= 500 {
            throw APIError(
                statusCode: code,
                message: request.errorMessages[code] ?? APIError.defaultMessage(forStatusCode: code)
            )
        }
        
        guard let data = result.data,
              let json: T.Response = decodeResponse(from: data/*, type: T.Response.self*/) else {
            return .success(BaseResponse(statusCode: code, message: "Success", data: nil))
        }
        
        return .success(BaseResponse(statusCode: code, message: "Success", data: json))
    }
    
    
    
    // MARK: Multipart - Append Param
    private static func appendParameters(_ parameters: Encodable, to formData: MultipartFormData) throws {
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(parameters)
        
        guard let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            throw APIError(statusCode: 400, message: "API Parameter encode error")
        }
        
        for (key, value) in jsonObject {
            if value is NSNull {
//                formData.append(NSNull(), withName: key)
            } else if let data = "\(value)".data(using: .utf8) {
                formData.append(data, withName: key)
            }
        }
    }
    
    // MARK: Multipart - Append Media
    private static func appendMediaFiles<F: MediaAttachable>(_ files: [F], to formData: MultipartFormData) async {
        for file in files {
            guard let imageData = file.imageData,
                  let conversionType = file.conversionType else { continue }
            
            switch conversionType {
            case .image:
                // 정적인 이미지 파일은 무조건 webp로 변환하여 용량 줄인 후 업로드
                let imageWebp = await convertImageDataToWebP(data: imageData)
                if let imageWebp {
                    formData.append(
                        imageWebp,
                        withName: file.withName.rawValue,
                        fileName: "\(UUID().uuidString).webp",
                        mimeType: "image/webp"
                    )
                }
                
            case .gif:
                // gif는 인코딩 시간이 너무 길어 용량 제한으로 막은 후 원본으로 업로드
                if imageData.count >= maxFileSize {
                    print("10MB 미만으로 제한")
                } else {
                    formData.append(
                        imageData,
                        withName: file.withName.rawValue,
                        fileName: "\(UUID().uuidString).gif",
                        mimeType: "image/gif"
                    )
                }
                
            case .video:
                formData.append(
                    imageData,
                    withName: file.withName.rawValue,
                    fileName: "\(UUID().uuidString).mp4",
                    mimeType: "video/mp4"
                )
            }
        }
        
    }
    
    // MARK: Multipart - Convert To WebP
    private static func convertImageDataToWebP(data: Data) async -> Data? {
        let startTime = CFAbsoluteTimeGetCurrent()// 인코딩 시간 측정용 시작시간
        guard let uiImage = UIImage(data: data) else { return nil }
        
        let webpData = SDImageWebPCoder.shared.encodedData(
            with: uiImage,
            format: .webP,
            options: [
                .encodeMaxPixelSize: CGSize(width: 1500, height: 1500),
                .encodeMaxFileSize: maxFileSize
            ]
        )
        
        if webpData != nil {
            let endTime = CFAbsoluteTimeGetCurrent()
            print("\n⚠️ Image encoding result in WebP format\n- DATA Size: \(String(describing: webpData?.count)) bytes,\n- EncodeTime: \(endTime - startTime) seconds\n")
        }
        
        return webpData
    }
    
    
    // MARK: deleteFiles
    func deleteFiles(urls: [URL]) {
        let fileManager = FileManager.default
        urls.forEach { url in
            do {
                try fileManager.removeItem(at: url)
                print("File deletion successful: \(url)")
            } catch {
                print("File deletion error: \(error)")
            }
        }
    }
}
