import Foundation

class HTTPErrorsResolver {
    func resolve(errorCode: Int) -> HTTPClientError {
        switch errorCode {
        case 200..<300:
            return .generic
        case 400..<500:
            if errorCode == 429 {
                return .tooManyRequest
            } else {
                return .clientError
            }
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
