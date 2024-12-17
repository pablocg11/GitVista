import Foundation

protocol FetchRepositoriesUseCaseProtocol {
    func execute(_ username: String) async throws -> Result<[Repository], DomainError>
}

final class FetchRepositoriesUseCase: FetchRepositoriesUseCaseProtocol {
    private let repository: GitHubRepositoriesRepositoryProtocol
    
    init(repository: GitHubRepositoriesRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(_ username: String) async throws -> Result<[Repository], DomainError> {
        return try await repository.getRepositoriesByUser(username)
    }
}
