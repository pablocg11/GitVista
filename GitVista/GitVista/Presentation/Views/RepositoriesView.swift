import SwiftUI
import Lottie

struct RepositoriesView: View {
    @ObservedObject private var store: GitHubStore
    @State private var isInitialVisible = false
    @State private var isLoadedVisible = false
    private var presenter: GitHubPresenter?

    init(store: GitHubStore, presenter: GitHubPresenter) {
        self.store = store
        self.presenter = presenter
    }

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                let screenWidth = geometry.size.width
                let columnCount = max(Int(screenWidth / 160), 2)
                let columns = Array(repeating: GridItem(.flexible()), count: columnCount)
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black, Color.black.opacity(0.8)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                    
                    VStack {
                        SearchBar(
                            searchText: Binding(
                                get: { presenter?.currentUsername ?? "" },
                                set: { presenter?.updateUsername($0) }
                            ),
                            searchAction: {
                                presenter?.fetchUserInfo()
                            }
                        )
                        .padding(.bottom)
                        
                        Spacer()
                        
                        switch store.state {
                        case .initial:
                            VStack(spacing: 50) {
                                LottieView(animation: .named("githubAnimation"))
                                    .configure(\.contentMode, to: .scaleAspectFit)
                                    .playing(loopMode: .loop)
                                    .animationSpeed(0.8)
                                    .frame(maxWidth: 400, maxHeight: 300)
                                    .opacity(isInitialVisible ? 1 : 0)
                                    .animation(.easeOut(duration: 0.9).delay(0.1), value: isInitialVisible)
                                VStack(spacing: 5) {
                                    Text("Welcome to GitVista")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .opacity(isInitialVisible ? 1 : 0)
                                        .animation(.easeOut(duration: 0.9).delay(0.3), value: isInitialVisible)
                                    
                                    Text("Sign in to discover repositories, users, and more!")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.8))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                        .opacity(isInitialVisible ? 1 : 0)
                                        .animation(.easeOut(duration: 0.9).delay(0.5), value: isInitialVisible)
                                }
                            }
                            .onAppear {
                                isInitialVisible = true
                            }
                        case .loading:
                            LoadingView(bigSize: true)
                        case .error(let message):
                            ErrorView(errorMessage: message)
                        case .loadedInfo(let userProfileInfo, let repositories):
                            if repositories.isEmpty {
                                Text("No repositories found")
                                    .foregroundColor(.white)
                            } else {
                                VStack(alignment: .leading, spacing: 10) {
                                    UserProfileCard(userProfile: userProfileInfo)
                                        .padding(.bottom)
                                        .opacity(isLoadedVisible ? 1 : 0)
                                        .animation(.easeOut(duration: 0.9).delay(0.2), value: isLoadedVisible)
                                    
                                    HStack(alignment: .center) {
                                        Text("Repositories")
                                            .font(.callout)
                                            .foregroundColor(.white)
                                            .padding(.bottom, 2)
                                        Spacer()
                                        Menu {
                                            Button("Sort by stars") {
                                                presenter?.sortByStars()
                                            }
                                            Button("Sort alphabetically") {
                                                presenter?.sortAlphabetically()
                                            }
                                            Button("Sort by updated date") {
                                                presenter?.sortByDate()
                                            }
                                        } label: {
                                            Image(systemName: "arrow.up.arrow.down")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .padding(.bottom, 8)
                                    .opacity(isLoadedVisible ? 1 : 0)
                                    .animation(.easeOut(duration: 0.9).delay(0.4), value: isLoadedVisible)
                                    
                                    ScrollView {
                                        LazyVGrid(columns: columns) {
                                            ForEach(repositories, id: \.id) { repository in
                                                GitHubRepositoryCard(repository: repository)
                                                    .onAppear {
                                                        if repository.id == repositories.last?.id {
                                                            presenter?.fetchMoreRepositories()
                                                        }
                                                    }
                                            }
                                        }
                                        if store.isLoadingMore {
                                            Spacer()
                                            LoadingView(bigSize: false)
                                        }
                                    }
                                    .padding(.bottom, 10)
                                    .opacity(isLoadedVisible ? 1 : 0)
                                    .animation(.easeOut(duration: 0.9).delay(0.4), value: isLoadedVisible)
                                    .scrollIndicators(.hidden)
                                }
                                .onAppear {
                                    isLoadedVisible = true
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    .foregroundStyle(Color.white)
                    .padding()
                    .ignoresSafeArea(edges: .bottom)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
