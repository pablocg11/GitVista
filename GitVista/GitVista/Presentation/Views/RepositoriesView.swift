import SwiftUI

struct RepositoriesView: View {
    @ObservedObject private var store: GitHubStore
    @State private var isVisible = false
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
                                isVisible = false
                                presenter?.fetchUserInfo()
                            }
                        )
                        .padding(.bottom)
                        
                        Spacer()
                        
                        switch store.state {
                        case .initial:
                            VStack(spacing: 10) {
                                Image(systemName: "magnifyingglass")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                                Text("Search GitHub repositories")
                                    .foregroundColor(.gray)
                                    .font(.headline)
                            }
                        case .loading:
                            LoadingView()
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
                                        .opacity(isVisible ? 1 : 0)
                                        .animation(.easeOut(duration: 0.9).delay(0.2), value: isVisible)
                                    
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
                                            Button("Sort by date") {
                                                presenter?.sortByDate()
                                            }
                                        } label: {
                                            Image(systemName: "arrow.up.arrow.down")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 15, height: 15)
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .padding(.bottom, 8)
                                    .opacity(isVisible ? 1 : 0)
                                    .animation(.easeOut(duration: 0.9).delay(0.4), value: isVisible)
                                    
                                    ScrollView {
                                        LazyVGrid(columns: columns) {
                                            ForEach(repositories, id: \.id) { repository in
                                                GitHubRepositoryCard(repository: repository)
                                            }
                                        }
                                    }
                                    .padding(.bottom, 10)
                                    .opacity(isVisible ? 1 : 0)
                                    .animation(.easeOut(duration: 0.9).delay(0.4), value: isVisible)
                                    .scrollIndicators(.hidden)
                                }
                                .onAppear {
                                    isVisible = true
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
