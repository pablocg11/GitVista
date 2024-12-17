import Foundation

final class PresentationErrorMapper {
    func map(error: DomainError?) -> String {
        guard let error = error else {
            return "Something went wrong. Please try again later."
        }
        
        switch error {
        case .invalidUsername:
            return "The provided username is invalid. Please check and try again."
        case .invalidRepository:
            return "The repository name is invalid. Please verify and try again."
        case .userNotFound:
            return "User not found. Please ensure the username is correct."
        case .privateUser:
            return "This user's profile is private. Access is restricted."
        case .noRepositories:
            return "No repositories found for this user."
        case .repositoryAccessDenied:
            return "Access to this repository is denied. Check permissions."
        case .networkUnavailable:
            return "Network is unavailable. Please check your internet connection."
        case .timeout:
            return "The request timed out. Please try again."
        case .unauthorized:
            return "You are unauthorized to perform this action. Please log in again."
        case .rateLimitExceeded:
            return "You have exceeded the request rate limit. Please wait and try again later."
        case .parsingError:
            return "Failed to process the response. Please try again."
        case .unknownError:
            return "An unknown error occurred. Please try again later."
        case .noDataAvailable:
            return "No data is available. Please try again later."
        case .validationError(message: let message):
            return message
        }
    }
}
