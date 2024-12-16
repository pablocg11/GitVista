import Foundation

protocol GitHubUserProfileRepositoryProtocol {
    func getUserProfileInfo(_ username: String) async throws -> Result<UserProfile, DomainError>
}

final class GitHubUserProfileRepository: GitHubUserProfileRepositoryProtocol {
    private let apiDataSource: APIGitHubDataSourceProtocol
    private let errorMapper: DomainErrorMapper

    init(apiDataSource: APIGitHubDataSourceProtocol, errorMapper: DomainErrorMapper) {
        self.apiDataSource = apiDataSource
        self.errorMapper = errorMapper
    }
    
    func getUserProfileInfo(_ username: String) async throws -> Result<UserProfile, DomainError> {
        let result = try await apiDataSource.getProfileInfo(username)
        
        switch result {
        case .success(let userProfileInfoDTO):
            guard !userProfileInfoDTO.login.isEmpty else {
                return .failure(.userNotFound)
            }
            
            let userProfile = UserProfile(dto: userProfileInfoDTO)
            return .success(userProfile)
        case .failure(let error):
            return .failure(errorMapper.map(error: error))
        }
    }
}
