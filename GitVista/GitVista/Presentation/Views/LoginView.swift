import SwiftUI
import Lottie
import FirebaseAuth

struct LoginView: View {
    var gitHubRepositoriesFactory: GitHubRepositoriesFactory
    @State private var isVisible = false
    @State private var navigateToHome = false
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.black, Color.black.opacity(0.8)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 50) {
                    
                    LottieView(animation: .named("githubAnimation"))
                        .configure(\.contentMode, to: .scaleAspectFit)
                        .playing(loopMode: .loop)
                        .animationSpeed(0.8)
                        .frame(maxWidth: 400, maxHeight: 300)
                    
                    VStack(spacing: 5) {
                        Text("Welcome to GitVista")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .opacity(isVisible ? 1 : 0)
                            .animation(.easeOut(duration: 0.9).delay(0.2), value: isVisible)
                        
                        Text("Sign in to discover repositories, users, and more!")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .opacity(isVisible ? 1 : 0)
                            .animation(.easeOut(duration: 0.9).delay(0.4), value: isVisible)
                    }
                    
                    Button(action: {
                        signInWithGitHub()
                    }, label: {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Sign in with GitHub")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .white.opacity(0.2), radius: 5, x: 0, y: 3)
                    })
                    .padding(.horizontal, 40)
                    .opacity(isVisible ? 1 : 0)
                    .scaleEffect(isVisible ? 1 : 0.9)
                    .animation(.easeOut(duration: 0.9).delay(0.6), value: isVisible)
                }
            }
            .onAppear {
                isVisible = true
            }
            .navigationDestination(isPresented: $navigateToHome) {
                gitHubRepositoriesFactory.createView()
            }
        }
    }
    
    func signInWithGitHub() {
        navigateToHome = true
        let provider = OAuthProvider(providerID: "github.com")
        provider.customParameters = ["allow_signup": "false"]

        provider.getCredentialWith(nil) { credential, error in
            if let error = error {
                print("Error al obtener credenciales de GitHub: \(error.localizedDescription)")
                return
            }

            print("Credenciales recibidas exitosamente")
            if let credential = credential {
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        print("Error al iniciar sesión con Firebase Auth: \(error.localizedDescription)")
                    } else {
                        print("Autenticación exitosa, usuario: \(String(describing: authResult?.user.email))")
                    }
                }
            }
        }
    }
}
