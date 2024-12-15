import Foundation

protocol RepositoriesPresenterDelegate: AnyObject {
    func renderLoading()
    func render(repositories: [Repository])
    func render(errorMessage: String)
}
