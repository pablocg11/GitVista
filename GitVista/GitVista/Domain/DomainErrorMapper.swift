import Foundation

final class DomainErrorMapper {
    func map(error: HTTPClientError?) -> DomainError {
        guard let error = error else { return .unknownError }
        
        switch error {
        case .clientError:
            return .invalidUsername
        case .serverError:
            return .networkUnavailable
        case .tooManyRequest:
            return .rateLimitExceeded
        case .badURL:
            return .invalidUsername
        case .emptyData:
            return .noRepositories
        case .responseError:
            return .userNotFound
        case .parsingError:
            return .parsingError
        case .generic:
            return .unknownError
        }
    }
}
