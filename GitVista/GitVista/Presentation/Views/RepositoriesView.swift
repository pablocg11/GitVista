import SwiftUI

struct RepositoriesView: View {
    @ObservedObject private var store: GitHubStore
    private var presenter: GitHubPresenter?

    init(store: GitHubStore, presenter: GitHubPresenter) {
        self.store = store
        self.presenter = presenter
    }

    var body: some View {
        NavigationView {
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
                        searchAction: { presenter?.fetchUserInfo() }
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
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .foregroundColor(.white)
                            .scaleEffect(1.5)
                            .padding()
                    case .error(let message):
                        Text(message)
                            .foregroundColor(.red)
                            .padding()
                    case .loadedInfo(let userProfileInfo, let repositories):
                        if repositories.isEmpty {
                            Text("No repositories found")
                                .foregroundColor(.white)
                        } else {
                            VStack(alignment: .leading, spacing: 10) {
                                UserProfileCard(userProfile: userProfileInfo)
                                
                                HStack(alignment: .center) {
                                    Text("Repositories")
                                        .font(.callout)
                                        .foregroundColor(.white)
                                        .padding(.bottom, 2)
                                    Spacer()
                                    Menu {
                                        Button("Sort by Stars") {
                                            presenter?.sortByStars()
                                        }
                                        Button("Sort Alphabetically") {
                                            presenter?.sortAlphabetically()
                                        }
                                        Button("Sort by Watchers") {
                                            presenter?.sortByWatchers()
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

                                ScrollView {
                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                                        ForEach(repositories, id: \.id) { repository in
                                            GitHubRepositoryCard(repository: repository)
                                        }
                                    }
                                }
                                .scrollIndicators(.hidden)
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
}
