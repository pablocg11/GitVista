import SwiftUI

struct RepositoriesView: View {
    @ObservedObject private var store: RepositoriesStore
    private var presenter: RepositoriesPresenter?

    init(store: RepositoriesStore, presenter: RepositoriesPresenter) {
        self.store = store
        self.presenter = presenter
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter GitHub username", text: Binding(
                    get: { presenter?.currentUsername ?? "" },
                    set: { presenter?.updateUsername($0) }
                ))
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    presenter?.fetchRepositories()
                }, label: {
                    Text("Search")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                })
                .padding(.horizontal)
                
                switch store.state {
                case .initial:
                    Text("Search GitHub repositories")
                case .loading:
                    ProgressView("Loading...")
                        .padding()
                case .error(let message):
                    Text(message)
                        .foregroundColor(.red)
                        .padding()
                case .loaded(let repositories):
                    List(repositories, id: \.id) { repo in
                        VStack(alignment: .leading) {
                            Text(repo.name).bold()
                            Text(repo.description ?? "No description")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("GitHub Repos")
        }
    }
}
