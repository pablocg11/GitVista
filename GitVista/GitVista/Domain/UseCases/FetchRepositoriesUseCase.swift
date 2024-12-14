import Foundation

protocol FetchRepositoriesUseCaseProtocol {
    func exectute(_ username: String) async throws -> Result<[Repository], DomainError>
}

final class FetchRepositoriesUseCase: FetchRepositoriesUseCaseProtocol {
    private let repository: GitHubRepositoriesRepositoryProtocol
    
    init(repository: GitHubRepositoriesRepositoryProtocol) {
        self.repository = repository
    }
    
    func exectute(_ username: String) async throws -> Result<[Repository], DomainError> {
        return try await repository.getRepositoriesByUser(username)
    }
}
