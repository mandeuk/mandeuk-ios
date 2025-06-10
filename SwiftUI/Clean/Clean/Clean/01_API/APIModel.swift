import Foundation
import Alamofire

struct BaseResponse<T: Codable> : Codable{
    let statusCode: Int
    let message: String?
    let data: T?
}

struct AnyEncodable: Encodable {
    private let encodable: Encodable
    
    init(_ encodable: Encodable) {
        self.encodable = encodable
    }
    
    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}

struct APIError: Error, Codable {
    let statusCode: Int
    let message: String
    static func defaultMessage(forStatusCode statusCode: Int) -> String {
        switch statusCode {
        case 500:
            return "500_defalut_error_msg"//.localized()
        default:
            return "unknown_error_defalut_msg"//.localized()
        }
    }
    
    init(statusCode: Int, message: String?) {
        self.statusCode = statusCode
        self.message = message ?? APIError.defaultMessage(forStatusCode: statusCode)
    }
}

enum APIAction<T: APIRequest> {
    case request(T.Parameter)
    case success(BaseResponse<T.Response>)
    case failed(Error)
}
