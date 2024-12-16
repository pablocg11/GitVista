import Foundation

protocol GetUserProfileInfoUseCaseProtocol {
    func execute(_ username: String) async throws -> Result<UserProfile, DomainError>
}

final class GetUserProfileInfoUseCase: GetUserProfileInfoUseCaseProtocol {
    private let repository: GitHubUserProfileRepositoryProtocol
    
    init(repository: GitHubUserProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(_ username: String) async throws -> Result<UserProfile, DomainError> {
        return try await repository.getUserProfileInfo(username)
    }
}
