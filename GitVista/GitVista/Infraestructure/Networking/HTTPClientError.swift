import Foundation

enum HTTPClientError: Error {
    case clientError
    case serverError
    case generic
    case parsingError
    case tooManyRequest
    case badURL
    case emptyData
    case responseError
}
