import Foundation

protocol APIGitHubDataSourceProtocol {
    func fetchGitHubRepositories(_ username: String, page: Int, pageSize: Int) async throws -> Result<[RepositoryDTO], HTTPClientError>
    func getProfileInfo(_ username: String) async throws -> Result<UserProfileDTO, HTTPClientError>
}

final class APIGitHubDataSource: APIGitHubDataSourceProtocol {
    private let httpClient: HTTPClientProtocol
    private let pageSize: Int = 14
    private let baseURL = "https://api.github.com/users/"
    
    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }
    
    func getProfileInfo(_ username: String) async throws -> Result<UserProfileDTO, HTTPClientError> {
        let request = HTTPRequest(baseUrl: baseURL,
                                  path: "\(username)",
                                  method: .get)
        
        let response = await httpClient.makeRequest(request)
        
        switch response {
        case .success(let data):
            do {
                let userProfileDTO = try JSONDecoder().decode(UserProfileDTO.self, from: data)
                return .success(userProfileDTO)
            } catch {
                return .failure(.parsingError)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func fetchGitHubRepositories(_ username: String, page: Int, pageSize: Int) async throws -> Result<[RepositoryDTO], HTTPClientError> {
        let request = HTTPRequest(baseUrl: baseURL,
                                  path: "\(username)/\(Paths.repositories.rawValue)",
                                  queryParams: [
                                                  "page": "\(page)",
                                                  "per_page": "\(pageSize)"
                                              ],
                                  method: .get)
        
        let response = await httpClient.makeRequest(request)
        
        switch response {
        case .success(let data):
            do {
                let repositoriesDTO = try JSONDecoder().decode([RepositoryDTO].self, from: data)
                return .success(repositoriesDTO)
            } catch {
                return .failure(.parsingError)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
