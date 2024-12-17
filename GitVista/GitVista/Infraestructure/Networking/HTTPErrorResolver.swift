import Foundation

class HTTPErrorsResolver {
    func resolve(errorCode: Int, headers: [AnyHashable: Any]) -> HTTPClientError {
        switch errorCode {
        case 200..<300:
            return .generic
        case 403:
            if let remainingRequests = headers["x-ratelimit-remaining"] as? String, remainingRequests == "0" {
                return .tooManyRequest
            } else {
                return .clientError 
            }
        case 429:
            return .tooManyRequest
        case 400..<500:
            return .clientError
        case 500..<600:
            return .serverError
        default:
            return .responseError
        }
    }
    
    func resolve(error: Error) -> HTTPClientError {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .badURL:
                return .badURL
            case .timedOut:
                return .responseError
            case .cannotFindHost, .cannotConnectToHost:
                return .clientError
            case .networkConnectionLost, .notConnectedToInternet:
                return .serverError
            default:
                return .generic
            }
        }
        
        return .generic
    }
}
