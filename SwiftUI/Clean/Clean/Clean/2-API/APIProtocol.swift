//
//  APIProtocol.swift
//  Clean
//
//  Created by Inho Lee on 6/9/25.
//

import Alamofire
import SwiftUI
import PhotosUI

// MARK: APIRequest
protocol APIRequest {
    associatedtype Parameter: Encodable
    associatedtype Response: Codable
    
    var path: String { get }
    var method: HTTPMethod { get }
    var encoder: ParameterEncoder { get }
    var parameters: Parameter? { get }
    var response: BaseResponse<Response>? { get set } //Response? { get set }
    var files: [any MediaAttachable]? { get }
    
    static var errorMessages: [Int: String] { get }
    static var mock: BaseResponse<Response> { get }
}
extension APIRequest {
    var encoder: ParameterEncoder {
        switch method {
        case .get, .delete:
            return URLEncodedFormParameterEncoder.default
        default:
            return JSONParameterEncoder.default
        }
    }
    var files: [any MediaAttachable]? {
        return nil
    }
    var errorMessages: [Int: String] {
        return [:]
    }
}



// MARK: MediaAttachable
protocol MediaAttachable: Encodable, Equatable {
    var withName: RequestBodyKey { get }
    var imageData: Data? { get }
    var imageURL: URL? { get }
    var conversionType: MediaConversionType? { get }
}
enum RequestBodyKey: String, Codable, Equatable {
    case image = "images"
    case video = "video"
    case originalProfileImg = "originalProfileImg"
    case croppedProfileImg = "croppedProfileImg"
    case profileImage = "profileImage"
}
enum MediaConversionType: Codable, Equatable {
    case image
    case gif
    case video
    
    static func determineType(from item: PhotosPickerItem) -> MediaConversionType? {
        switch item.supportedContentTypes.first {
        case .gif:
            return .gif
        case .image, .jpeg, .png, .heic, .heif, .tiff, .webP, .rawImage:
            return .image
        case .video, .movie, .quickTimeMovie, .mpeg, .mpeg2Video, .mpeg4Movie, .avi:
            return .video
        default:
            return .none
        }
    }
}



// MARK: APIClient
protocol APIClientProtocol {
//    func request<T: APIRequest>(_ request: T) async -> Result<BaseResponse<T.Response>, APIError>
    func request<T: APIRequest>(_ request: T) async throws -> T//BaseResponse<T.Response>
}
private struct APIClientKey: EnvironmentKey {
    static let defaultValue: APIClientProtocol = APIClient()
}
extension EnvironmentValues {
    var apiClient: APIClientProtocol {
        get { self[APIClientKey.self] }
        set { self[APIClientKey.self] = newValue }
    }
}
