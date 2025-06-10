import Foundation
import Alamofire

struct GetIosVersionCheckModel: APIRequest {
    var path: String { ApiAddress.Version.getIosVersionCheck.url }
    var method: HTTPMethod { .get }
    var parameters: Parameter?
    var response: Response? = nil
    var errorMessages: [Int : String] {
        return [:]
    }
    
    struct Parameter: Encodable { }
    struct Response: Codable { let data: ResData? }
    struct ResData: Codable {
        var id: Int?
        var platform: String?
        var version: String?
        var isForce: Int?
        var createdAt: Date?
    }
}
