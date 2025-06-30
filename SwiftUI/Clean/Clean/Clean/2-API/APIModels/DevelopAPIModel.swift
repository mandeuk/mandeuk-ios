//
//  DevelopAPIModel.swift
//  Clean
//
//  Created by Inho Lee on 6/18/25.
//
import Alamofire

///api/develop/devlogin
struct DevLoginModel: APIRequest {
    var path: String { ApiAddress.Develop.devlogin.urlString }
    var method: HTTPMethod { .get }
    var parameters: Parameter? = nil
    var response: BaseResponse<Response>? = nil
    var files: [any MediaAttachable]? = nil
    
    struct Parameter: Codable {
        let userId: Int
    }
    struct Response: Codable {
    }
    
    static var errorMessages: [Int : String] {
        return [:]
    }
    static var mock: BaseResponse<Response> {
        .init(
            statusCode: 200,
            message: "로그인 성공",
            data: Response()
        )
    }
}
