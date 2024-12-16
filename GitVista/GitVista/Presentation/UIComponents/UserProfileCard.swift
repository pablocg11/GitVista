import SwiftUI

struct UserProfileCard: View {
    var userProfile: UserProfile

    var body: some View {
        Link(destination: URL(string: userProfile.htmlURL)!) {
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: URL(string: userProfile.avatarURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipped()
                        .cornerRadius(20)
                } placeholder: {
                    ProgressView()
                        .frame(width: 200, height: 200)
                }
                
                LinearGradient(
                    gradient: Gradient(colors: [Color.clear, Color.black]),
                    startPoint: .center,
                    endPoint: .bottom
                )
                .cornerRadius(20)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(userProfile.name ?? userProfile.login)
                        .font(.callout)
                        .foregroundColor(.white)
                    if let company = userProfile.company {
                        Text(company)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    if let location = userProfile.location {
                        Text(location)
                            .font(.caption)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding()
            }
            .frame(width: 200, height: 200)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    UserProfileCard(userProfile: UserProfile(
        id: 1,
        login: "octocat",
        avatarURL: "https://avatars.githubusercontent.com/u/1?v=4",
        htmlURL: "https://github.com/octocat",
        userViewType: "User",
        name: "The Octocat",
        company: "GitHub",
        blog: "https://github.blog",
        location: "San Francisco",
        email: "octocat@github.com",
        bio: "GitHub mascot and friendly developer assistant!"
    ))
}
