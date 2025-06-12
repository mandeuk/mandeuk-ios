//
//  APIProtocol.swift
//  Clean
//
//  Created by Inho Lee on 6/9/25.
//

import Alamofire
import SwiftUI
import PhotosUI

protocol APIRequest {
    associatedtype Parameter: Encodable
    associatedtype Response: Codable
    
    var path: String { get }
    var method: HTTPMethod { get }
    var encoder: ParameterEncoder { get }
    var errorMessages: [Int: String] { get }
    
    var parameters: Parameter? { get }
    var response: Response? { get set }
    var files: [any MediaAttachable]? { get }
}

protocol MediaAttachable: Encodable, Equatable {
    var withName: RequestBodyKey { get }
    var imageData: Data? { get }
    var imageURL: URL? { get }
    var conversionType: MediaConversionType? { get }
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
