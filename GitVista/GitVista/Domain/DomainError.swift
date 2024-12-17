enum DomainError: Error {
    case invalidUsername
    case invalidRepository
    case userNotFound
    case privateUser
    case noRepositories
    case repositoryAccessDenied
    case networkUnavailable
    case timeout
    case unauthorized
    case rateLimitExceeded
    case unknownError
    case parsingError
    case noDataAvailable
    case validationError(message: String) 
}
