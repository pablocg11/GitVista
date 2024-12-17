import SwiftUI

struct ContentView: View {
    var gitHubRepositoriesFactory: GitHubRepositoriesFactory
    var body: some View {
        LoginView(gitHubRepositoriesFactory: gitHubRepositoriesFactory)
    }
}
