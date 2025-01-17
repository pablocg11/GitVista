import Foundation

final class GitHubPresenter {
    private weak var delegate: GitHubPresenterDelegate?
    @Published private var username: String = ""
    private let fetchRepositoriesUseCase: FetchRepositoriesUseCaseProtocol
    private let getUserProfileInfoUseCase: GetUserProfileInfoUseCaseProtocol
    private let presentationErrorMapper: PresentationErrorMapper

    private var cachedUserProfile: UserProfile?
    private var cachedRepositories: [Repository] = []
    private var currentPage = 1
    private let pageSize = 14
    private var isLoadingMore = false
    private var canLoadMore = true

    init(delegate: GitHubPresenterDelegate,
         fetchRepositoriesUseCase: FetchRepositoriesUseCaseProtocol,
         getUserProfileInfoUseCase: GetUserProfileInfoUseCaseProtocol,
         presentationErrorMapper: PresentationErrorMapper
    ) {
        self.delegate = delegate
        self.fetchRepositoriesUseCase = fetchRepositoriesUseCase
        self.getUserProfileInfoUseCase = getUserProfileInfoUseCase
        self.presentationErrorMapper = presentationErrorMapper
    }

    func updateUsername(_ username: String) {
        self.username = username
    }

    var currentUsername: String {
        return username
    }

    func fetchUserInfo() {
        guard !username.isEmpty else {
            handleError(.validationError(message: "Please enter a username."))
            return
        }

        currentPage = 1
        cachedRepositories.removeAll()
        canLoadMore = true

        delegate?.renderLoading()

        Task {
            do {
                try await loadUserProfileAndRepositories()
                if cachedRepositories.count < pageSize {
                    canLoadMore = false
                }
            } catch let error as DomainError {
                handleError(error)
            } catch {
                handleError(.unknownError)
            }
        }
    }

    func fetchMoreRepositories() {
        guard !isLoadingMore, canLoadMore else { return }
        isLoadingMore = true
        delegate?.renderLoadingMore()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            Task {
                do {
                    let result = try await self.fetchRepositoriesUseCase.execute(self.username, page: self.currentPage, pageSize: self.pageSize)
                    switch result {
                    case .success(let newRepositories):
                        if newRepositories.count < self.pageSize {
                            self.canLoadMore = false
                        }
                        self.cachedRepositories.append(contentsOf: newRepositories)
                        self.currentPage += 1
                        if let profile = self.cachedUserProfile {
                            self.delegate?.renderUserInfo(profile, repositories: self.cachedRepositories)
                        }
                    case .failure(let error):
                        self.handleError(error)
                    }
                } catch let error as DomainError {
                    self.handleError(error)
                } catch {
                    self.handleError(.unknownError)
                }
                self.isLoadingMore = false
            }
        }
    }

    private func loadUserProfileAndRepositories() async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask {
                let result = try await self.getUserProfileInfoUseCase.execute(self.username)
                switch result {
                case .success(let profile):
                    self.cachedUserProfile = profile
                case .failure(let error):
                    self.handleError(error)
                }
            }

            group.addTask {
                let result = try await self.fetchRepositoriesUseCase.execute(self.username, page: self.currentPage, pageSize: self.pageSize)
                switch result {
                case .success(let repositories):
                    self.cachedRepositories = repositories
                    self.currentPage += 1
                case .failure(let error):
                    self.handleError(error)
                }
            }

            try await group.waitForAll()
            if let profile = cachedUserProfile {
                delegate?.renderUserInfo(profile, repositories: cachedRepositories)
            }
        }
    }

    func sortByStars() {
        guard let profile = cachedUserProfile, !cachedRepositories.isEmpty else {
            handleError(.noDataAvailable)
            return
        }

        let sortedRepositories = cachedRepositories.sorted { $0.starsCount > $1.starsCount }
        delegate?.renderUserInfo(profile, repositories: sortedRepositories)
    }

    func sortAlphabetically() {
        guard let profile = cachedUserProfile, !cachedRepositories.isEmpty else {
            handleError(.noDataAvailable)
            return
        }

        let sortedRepositories = cachedRepositories.sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
        delegate?.renderUserInfo(profile, repositories: sortedRepositories)
    }
    
    func sortByDate() {
        guard let profile = cachedUserProfile, !cachedRepositories.isEmpty else {
            handleError(.noDataAvailable)
            return
        }

        let sortedRepositories = cachedRepositories.sorted { $0.updatedAt > $1.updatedAt }
        delegate?.renderUserInfo(profile, repositories: sortedRepositories)
    }

    private func handleError(_ error: DomainError) {
        let errorMessage = presentationErrorMapper.map(error: error)
        delegate?.render(errorMessage: errorMessage)
    }
}
