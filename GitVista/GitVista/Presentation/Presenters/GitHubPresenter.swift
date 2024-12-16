import Foundation

final class GitHubPresenter {
    private weak var delegate: GitHubPresenterDelegate?
    private var username: String = ""
    private let repositoriesRepository: GitHubRepositoriesRepositoryProtocol
    private let profileRepository: GitHubUserProfileRepositoryProtocol

    private var cachedUserProfile: UserProfile?
    private var cachedRepositories: [Repository] = [] 

    init(delegate: GitHubPresenterDelegate,
         repositoriesRepository: GitHubRepositoriesRepositoryProtocol,
         profileRepository: GitHubUserProfileRepositoryProtocol
    ) {
        self.delegate = delegate
        self.repositoriesRepository = repositoriesRepository
        self.profileRepository = profileRepository
    }

    func updateUsername(_ username: String) {
        self.username = username
    }

    var currentUsername: String {
        return username
    }

    func fetchUserInfo() {
        guard !username.isEmpty else {
            delegate?.render(errorMessage: "Please enter a username.")
            return
        }

        delegate?.renderLoading()

        Task {
            do {
                try await withThrowingTaskGroup(of: Void.self) { group in
                    group.addTask {
                        let result = try await self.profileRepository.getUserProfileInfo(self.username)
                        switch result {
                        case .success(let profile):
                            self.cachedUserProfile = profile
                        case .failure:
                            throw DomainError.userNotFound
                        }
                    }

                    group.addTask {
                        let result = try await self.repositoriesRepository.getRepositoriesByUser(self.username)
                        switch result {
                        case .success(let repositories):
                            self.cachedRepositories = repositories
                        case .failure:
                            throw DomainError.noRepositories
                        }
                    }

                    try await group.waitForAll()
                }

                if let profile = cachedUserProfile {
                    delegate?.renderUserInfo(profile, repositories: cachedRepositories)
                } else {
                    delegate?.render(errorMessage: "Failed to fetch user profile.")
                }
            } catch {
                delegate?.render(errorMessage: "Failed to fetch data: \(error.localizedDescription)")
            }
        }
    }

    func sortByStars() {
        guard let profile = cachedUserProfile, !cachedRepositories.isEmpty else {
            delegate?.render(errorMessage: "No data available to sort.")
            return
        }

        let sortedRepositories = cachedRepositories.sorted { $0.starsCount > $1.starsCount }
        delegate?.renderUserInfo(profile, repositories: sortedRepositories)
    }

    func sortAlphabetically() {
        guard let profile = cachedUserProfile, !cachedRepositories.isEmpty else {
            delegate?.render(errorMessage: "No data available to sort.")
            return
        }

        let sortedRepositories = cachedRepositories.sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
        delegate?.renderUserInfo(profile, repositories: sortedRepositories)
    }

    func sortByWatchers() {
        guard let profile = cachedUserProfile, !cachedRepositories.isEmpty else {
            delegate?.render(errorMessage: "No data available to sort.")
            return
        }

        let sortedRepositories = cachedRepositories.sorted { $0.watchers > $1.watchers }
        delegate?.renderUserInfo(profile, repositories: sortedRepositories)
    }
}
