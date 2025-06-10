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
    var parameters: Parameter? { get }
    var encoder: ParameterEncoder { get }
    var errorMessages: [Int: String] { get }
}


protocol MediaAttachable: Encodable, Equatable {
    var withName: RequestBodyKey { get }
    var imageData: Data? { get }
    var conversionType: MediaConversionType? { get }
}

protocol FileMediaAttachable: MediaAttachable {
    var withName: RequestBodyKey { get }
    var imageData: Data? { get }
    var imageURL: URL? { get }
    var conversionType: MediaConversionType? { get }
    
    init(withName: RequestBodyKey, imageData: Data?, imageURL: URL?, conversionType: MediaConversionType?)
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
    
    var errorMessages: [Int: String] {
        return [:]
    }
}





enum RequestBodyKey: String, Encodable, Equatable {
    case image = "images"
    case video = "video"
    case originalProfileImg = "originalProfileImg"
    case croppedProfileImg = "croppedProfileImg"
    case profileImage = "profileImage"
}

enum MediaConversionType: Encodable, Equatable {
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
