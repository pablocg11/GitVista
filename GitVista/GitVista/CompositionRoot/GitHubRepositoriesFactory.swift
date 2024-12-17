import Foundation

final class GitHubRepositoriesFactory {
    func createView() -> RepositoriesView {
        let store = createGitHubStore()
        let presenter = createPresenter(store: store)
        return RepositoriesView(store: store, presenter: presenter)
    }
    
    private func createPresenter(store: GitHubStore) -> GitHubPresenter {
        return GitHubPresenter(delegate: store,
                               fetchRepositoriesUseCase: createFetchGitHubRepositoriesUseCase(),
                               getUserProfileInfoUseCase: createGetGitHubUserProfileInfoUseCase(),
                               presentationErrorMapper: PresentationErrorMapper())
    }
    
    private func createGitHubStore() -> GitHubStore {
        return GitHubStore()
    }
    
    private func createFetchGitHubRepositoriesUseCase() -> FetchRepositoriesUseCaseProtocol {
        return FetchRepositoriesUseCase(repository: createGitHubRepositoriesRepository())
    }
    
    private func createGetGitHubUserProfileInfoUseCase() -> GetUserProfileInfoUseCaseProtocol {
        return GetUserProfileInfoUseCase(repository: createGitHubUserProfileInfoRepository())
    }
    
    private func createGitHubRepositoriesRepository() -> GitHubRepositoriesRepositoryProtocol {
        return GitHubRepositoriesRepository(apiDataSource: createAPIDataSource(),
                                            errorMapper: DomainErrorMapper())
    }
    
    private func createGitHubUserProfileInfoRepository() -> GitHubUserProfileRepository {
        return GitHubUserProfileRepository(apiDataSource: createAPIDataSource(),
                                           errorMapper: DomainErrorMapper())
    }
    
    private func createAPIDataSource() -> APIGitHubDataSourceProtocol {
        return APIGitHubDataSource(httpClient: createAPIClient())
    }
    
    private func createAPIClient() -> HTTPClientProtocol {
        return HTTPClient(errorsResolver: HTTPErrorsResolver(),
                          requestBuilder: HTTPRequestBuilder())
    }
}
