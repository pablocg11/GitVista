import Foundation

class RepositoriesStore: ObservableObject {
    enum State {
        case loading
        case initial
        case error(message: String)
        case loaded(repositories: [Repository])
    }
    
    @Published var state: State = .initial
}

extension RepositoriesStore: RepositoriesPresenterDelegate {
    func renderLoading() {
        DispatchQueue.main.async {
            self.state = .loading
        }
    }
    
    func render(repositories: [Repository]) {
        DispatchQueue.main.async {
            self.state = .loaded(repositories: repositories)
        }
    }
    
    func render(errorMessage: String) {
        DispatchQueue.main.async {
            self.state = .error(message: errorMessage)
        }
    }
}
