import Foundation

class GitHubStore: ObservableObject {
    enum State {
        case initial
        case loading
        case error(message: String)
        case loadedInfo(userProfile: UserProfile, repositories: [Repository])
    }

    @Published var state: State = .initial
    @Published var isLoadingMore: Bool = false
}

extension GitHubStore: GitHubPresenterDelegate {
    func renderLoading() {
        DispatchQueue.main.async {
            self.state = .loading
            self.isLoadingMore = false
        }
    }

    func renderLoadingMore() {
        DispatchQueue.main.async {
            self.isLoadingMore = true
        }
    }

    func renderUserInfo(_ userProfile: UserProfile, repositories: [Repository]) {
        DispatchQueue.main.async {
            self.state = .loadedInfo(userProfile: userProfile, repositories: repositories)
            self.isLoadingMore = false
        }
    }

    func render(errorMessage: String) {
        DispatchQueue.main.async {
            self.state = .error(message: errorMessage)
            self.isLoadingMore = false
        }
    }
}
