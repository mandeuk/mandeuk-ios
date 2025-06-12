import Foundation
import Alamofire

struct GetIosVersionCheckModel: APIRequest {
    var path: String { ApiAddress.Version.getIosVersionCheck.url }
    var method: HTTPMethod { .get }
//    var encoder: ParameterEncoder { .json }
    
    var parameters: Parameter? = nil
    var response: Response? = nil
    var files: [any MediaAttachable]? = nil
    
    var errorMessages: [Int : String] {
        return [:]
    }
    
    struct Parameter: Codable { }
    struct Response: Codable {
        var id: Int?
        var platform: String?
        var version: String?
        var isForce: Int?
        var createdAt: Date?
    }
}


struct DeleteModel: APIRequest {
    var path: String { ApiAddress.User.deleteUser }
    var method: HTTPMethod { .delete }
    
    var parameters: Parameter? = nil
    var response: Response? = nil
    var files: [any MediaAttachable]? = nil
    
    var errorMessages: [Int : String] {
        return [
            452:"사용자가 존재하지 않습니다.",
            453:"유효하지 않은 탈퇴 유형입니다."
        ]
    }
    
    struct Parameter: Codable {
        let deleteType: Int
        let deleteReason: String
    }
    struct Response: Codable {
    }
}
