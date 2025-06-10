//
//  APIDecoder.swift
//  Clean
//
//  Created by Inho Lee on 6/9/25.
//

import Foundation

func decodeResponse<T: Codable>(from data: Data) -> T? {
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
    
    do {
        let decodedData = try decoder.decode(T.self, from: data)
        return decodedData
    } catch {
        print("JSON Decoding Error: \(error)")
        return nil
    }
}
//
//func decodeResponse<T: Codable>(from data: Data, type: T.Type) -> T? {
//    
//    let decoder = JSONDecoder()
//    decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
//        let container = try decoder.singleValueContainer()
//        let dateString = try container.decode(String.self)
//        
//        if dateString.isEmpty {
//            return Date(timeIntervalSince1970: 0)
//        }
//        
//        let isoFormatter = ISO8601DateFormatter()
//        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
//        
//        if let date = isoFormatter.date(from: dateString) {
//            return date
//        } else {
//            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(dateString)")
//        }
//    })
//    
//    do {
//        let decodedData = try decoder.decode(type, from: data)
//        return decodedData
//    } catch {
//        print("JSON Decoding Error: \(error)")
//        return nil
//    }
//}
