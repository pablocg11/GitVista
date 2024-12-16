import Foundation

class GitHubStore: ObservableObject {
    enum State {
        case loading
        case initial
        case error(message: String)
        case loadedInfo(userProfile: UserProfile, repositories: [Repository])
    }
    
    @Published var state: State = .initial
}

extension GitHubStore: GitHubPresenterDelegate {
    func renderLoading() {
        DispatchQueue.main.async {
            self.state = .loading
        }
    }
    
    func renderUserInfo(_ userProfile: UserProfile, repositories: [Repository]) {
        DispatchQueue.main.async {
            self.state = .loadedInfo(userProfile: userProfile, repositories: repositories)
        }
    }
    
    func render(errorMessage: String) {
        DispatchQueue.main.async {
            self.state = .error(message: errorMessage)
        }
    }
}
