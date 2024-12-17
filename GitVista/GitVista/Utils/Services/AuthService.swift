import FirebaseAuth

func signInWithGitHub() {
    let provider = OAuthProvider(providerID: "github.com")
    provider.getCredentialWith(nil) { credential, error in
        if let error = error {
            print("Error during GitHub Sign-In: \(error.localizedDescription)")
            return
        }
        
        if let credential = credential {
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Error signing in: \(error.localizedDescription)")
                } else {
                    print("Signed in successfully! User: \(authResult?.user.displayName ?? "No Name")")
                }
            }
        }
    }
}
