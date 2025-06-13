import Foundation
import Alamofire

struct GetIosVersionCheckModel: APIRequest {
    var path: String { ApiAddress.Version.getIosVersionCheck.urlString }
    var method: HTTPMethod { .get }
    var parameters: Parameter? = nil
    var response: Response? = nil
    var files: [any MediaAttachable]? = nil
    
    struct Parameter: Codable { }
    struct Response: Codable {
        var id: Int?
        var platform: String?
        var version: String?
        var isForce: Int?
        var createdAt: Date?
    }
    
    static var errorMessages: [Int : String] {
        return [:]
    }
    static var mock: BaseResponse<Response> {
        .init(
            statusCode: 200,
            message: "OK",
            data: .init(
                id: 1,
                platform: "iOS",
                version: "1.2.3",
                isForce: 0,
                createdAt: Date()
            )
        )
    }
}


struct DeleteModel: APIRequest {
    var path: String { ApiAddress.User.deleteUser.urlString }
    var method: HTTPMethod { .delete }
    var parameters: Parameter? = nil
    var response: Response? = nil
    var files: [any MediaAttachable]? = nil
    
    struct Parameter: Codable {
        let deleteType: Int
        let deleteReason: String
    }
    struct Response: Codable {
    }
    
    static var errorMessages: [Int : String] {
        return [
            452:"사용자가 존재하지 않습니다.",
            453:"유효하지 않은 탈퇴 유형입니다."
        ]
    }
    static var mock: BaseResponse<Response> {
        .init(
            statusCode: 200,
            message: "탈퇴 완료",
            data: Response()
        )
    }
}
