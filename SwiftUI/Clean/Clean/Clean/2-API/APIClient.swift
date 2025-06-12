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
    static private let apiDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            if dateString.isEmpty {
                return Date(timeIntervalSince1970: 0)
            }
            
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            if let date = isoFormatter.date(from: dateString) {
                return date
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(dateString)")
            }
        })
        
        return decoder
    }()
    
    // MARK: API Request
    static func request<T: APIRequest>(_ request: T) async -> Result<BaseResponse<T.Response>, APIError> {
        
        do {
            // MARK: - 기본 변수 설정
            var headers = URLSessionConfiguration.af.default.headers/// - 기본 헤더 불러오기
            var dataRequest: DataRequest
            
            
            // MARK: - API Upload 케이스
            if let files = request.files {
                /// 헤더 설정 - "Content-Type" : "multipart/form-data" 를 헤더에 명시 해줘야 합니다.
                headers.add(.contentType("multipart/form-data"))
                
                
                /// FormData 설정
                let multipartFormData = MultipartFormData()
                try appendParameters(request.parameters, to: multipartFormData)// 일반 파라미터를 FormData에 추가
                await appendMediaFiles(files, to: multipartFormData)// 파일 데이터를 FormData에 추가
                
                
                /// DataRequest 생성
                dataRequest = AF.upload(
                    multipartFormData: multipartFormData,
                    to:      request.path,
                    method:  request.method,
                    headers: headers,
                    requestModifier: {
                        $0.timeoutInterval = 100
                    }
                )
            }
            // MARK: - API 일반 케이스
            else {
                /// 헤더 설정 - 이메일 인증 요청 API에는 Captcha 토큰을 헤더에 넣어야 합니다.
                if request.path == ApiAddress.User.emailSendCode,
                   let captchaToken = UserDefaults.standard.value(forKey: "captchaToken") as? String {
                    headers.add(name: "captchatoken", value: captchaToken)
                }
                
                
                /// DataRequest 생성
                dataRequest = AF.request(
                    request.path,
                    method:     request.method,
                    parameters: request.parameters,
                    encoder:    request.encoder,
                    headers:    headers,
                    requestModifier: {
                        $0.timeoutInterval = 100
                    }
                )
            }
            
            
            // MARK: API 요청 전송
            print("@API : \(String(describing: request.path))")
            let result = await dataRequest.serializingDecodable(/// `serializingDecodable` : API요청과 동시에 Decode를 하겠다!
                BaseResponse<T.Response>.self,  /// Decode할 Type 입력
                decoder: apiDecoder             /// 커스텀 Decoder 주입
            ).result
            
            
            // MARK: API 결과 처리
            switch result {
            case .success(let value):
                if value.statusCode >= 400 {
                    throw APIError(
                        statusCode: value.statusCode,
                        message: request.errorMessages[value.statusCode]
                    )
                }
                return .success(value)
            case .failure(let err):
                throw APIError(
                    statusCode: err.responseCode ?? 0,
                    message: err.errorDescription
                )
            }
        } catch {
            // MARK: 오류 발생 처리
            return .failure(
                error as? APIError ??
                APIError(
                    statusCode: error.asAFError?.responseCode ?? 0,
                    message: error.asAFError?.errorDescription ?? "API Failure"
                )
            )
        }
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
                //formData.append(Data(), withName: key)
            } else if let data = "\(value)".data(using: .utf8) {
                formData.append(data, withName: key)
            }
        }
    }
    
    // MARK: Multipart - Append Media
    private static func appendMediaFiles(_ files: [any MediaAttachable], to formData: MultipartFormData) async {
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
}


