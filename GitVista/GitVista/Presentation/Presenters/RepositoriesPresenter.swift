import Foundation

final class RepositoriesPresenter {
    private weak var delegate: RepositoriesPresenterDelegate?
    private var username: String = ""
    private let repository: GitHubRepositoriesRepositoryProtocol

    init(delegate: RepositoriesPresenterDelegate, repository: GitHubRepositoriesRepositoryProtocol) {
        self.delegate = delegate
        self.repository = repository
    }

    func updateUsername(_ username: String) {
        self.username = username
    }

    var currentUsername: String {
        return username
    }

    func fetchRepositories() {
        guard !username.isEmpty else {
            delegate?.render(errorMessage: "Please enter a username.")
            return
        }

        delegate?.renderLoading()

        Task {
            do {
                let result = try await repository.getRepositoriesByUser(username)
                switch result {
                case .success(let repositories):
                    delegate?.render(repositories: repositories)
                case .failure(let error):
                    delegate?.render(errorMessage: "Failed to fetch repositories: \(error.localizedDescription)")
                }
            } catch {
                delegate?.render(errorMessage: "Unexpected error occurred.")
            }
        }
    }
}
