import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct URLEncodedFormField: Sendable {
    let name: String
    let value: String
}

protocol NetworkRequest {
    var endpoint: URL? { get }
    var httpMethod: HttpMethod { get }
    var dto: Encodable? { get }
    var urlEncodedFormFields: [URLEncodedFormField] { get }
}

extension NetworkRequest {
    var httpMethod: HttpMethod { .get }
    var dto: Encodable? { nil }
    var urlEncodedFormFields: [URLEncodedFormField] { [] }
}
