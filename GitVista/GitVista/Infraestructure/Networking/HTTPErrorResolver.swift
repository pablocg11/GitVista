import Foundation

class HTTPErrorsResolver {
    func resolve(errorCode: Int) -> HTTPClientError {
        guard errorCode != 429 else {
            return .tooManyRequest
        }
        
        guard errorCode < 500 else {
            return .clientError
        }
                
        return .serverError
    }
    
    func resolve(error: Error) -> HTTPClientError {
        return .generic
    }
}
