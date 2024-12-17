import Foundation

protocol GitHubRepositoriesRepositoryProtocol {
    func getRepositoriesByUser(_ username: String, page: Int, pageSize: Int) async throws -> Result<[Repository], DomainError>
}

final class GitHubRepositoriesRepository: GitHubRepositoriesRepositoryProtocol {
    private let apiDataSource: APIGitHubDataSourceProtocol
    private let errorMapper: DomainErrorMapper
    
    init(apiDataSource: APIGitHubDataSourceProtocol, errorMapper: DomainErrorMapper) {
        self.apiDataSource = apiDataSource
        self.errorMapper = errorMapper
    }
    
    func getRepositoriesByUser(_ username: String, page: Int, pageSize: Int) async throws -> Result<[Repository], DomainError> {
        let result = try await apiDataSource.fetchGitHubRepositories(username, page: page, pageSize: pageSize)
        
        switch result {
        case .success(let repositoriesDTO):
            guard !repositoriesDTO.isEmpty else {
                return .failure(.noRepositories)
            }
            
            let repositories = repositoriesDTO.map { Repository(dto: $0) }
            return .success(repositories)
            
        case .failure(let error):
            return .failure(errorMapper.map(error: error))
        }
    }
}
