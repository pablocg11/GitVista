import SwiftUI
import Firebase

@main
struct GitVistaApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(gitHubRepositoriesFactory: GitHubRepositoriesFactory())
        }
    }
}
