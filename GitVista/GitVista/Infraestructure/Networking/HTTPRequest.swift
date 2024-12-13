import Foundation

struct HTTPRequest {
    let baseUrl: String
    let path: String
    let queryParams: [String: Any]?
    let method: HTTPMethod
    
    init(baseUrl: String, path: String, queryParams: [String: Any]? = nil, method: HTTPMethod) {
        self.baseUrl = baseUrl
        self.path = path
        self.queryParams = queryParams
        self.method = method
    }
}
