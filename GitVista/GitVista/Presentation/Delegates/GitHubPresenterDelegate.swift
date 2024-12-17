import Foundation

protocol GitHubPresenterDelegate: AnyObject {
    func renderLoading()
    func renderLoadingMore() 
    func renderUserInfo(_ userProfile: UserProfile, repositories: [Repository])
    func render(errorMessage: String)
}
