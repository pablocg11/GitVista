import Foundation

protocol APIGitHubDataSourceProtocol {
    func fetchGitHubRepositories(_ username: String) async throws -> Result<[RepositoryDTO], HTTPClientError>
}

final class APIGitHubDataSource: APIGitHubDataSourceProtocol {
    private let httpClient: HTTPClientProtocol
    private let baseURL = "https://api.github.com/users/"
    
    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }
    
    func fetchGitHubRepositories(_ username: String) async throws -> Result<[RepositoryDTO], HTTPClientError> {
        let request = HTTPRequest(baseUrl: baseURL,
                                  path: "\(username)/\(Paths.repositories.rawValue)",
                                  method: .get)
        
        let response = await httpClient.makeRequest(request)
        
        switch response {
        case .success(let data):
            do {
                let repositories = try JSONDecoder().decode([RepositoryDTO].self, from: data)
                return .success(repositories)
            } catch {
                return .failure(.parsingError)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
    
    private func handleError(error: HTTPClientError?) -> HTTPClientError {
        guard let error = error else { return .generic }
        
        return error
    }
}