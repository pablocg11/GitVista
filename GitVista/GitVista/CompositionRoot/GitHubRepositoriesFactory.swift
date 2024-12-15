import Foundation

final class GitHubRepositoriesFactory {
    func createView() -> RepositoriesView {
        let store = createRepositoriesStore()
        let presenter = createPresenter(store: store)
        return RepositoriesView(store: store, presenter: presenter)
    }
    
    private func createPresenter(store: RepositoriesStore) -> RepositoriesPresenter {
        return RepositoriesPresenter(delegate: store, repository: createGitHubRepositoriesRepository())
    }
    
    private func createRepositoriesStore() -> RepositoriesStore {
        return RepositoriesStore()
    }
    
    private func createGitHubRepositoriesRepository() -> GitHubRepositoriesRepositoryProtocol {
        return GitHubRepositoriesRepository(apiDataSource: createAPIDataSource(),
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
