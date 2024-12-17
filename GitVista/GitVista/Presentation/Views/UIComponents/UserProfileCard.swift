import SwiftUI

struct UserProfileCard: View {
    var userProfile: UserProfile

    var body: some View {
        Link(destination: URL(string: userProfile.htmlURL)!) {
            HStack {
                ZStack(alignment: .bottomLeading) {
                    AsyncImage(url: URL(string: userProfile.avatarURL)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 140, height: 140)
                            .clipped()
                            .cornerRadius(20)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 140, height: 140)
                    }
                    
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.8)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .cornerRadius(20)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(userProfile.name ?? userProfile.login)
                            .font(.caption)
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .multilineTextAlignment(.leading)
                        if let company = userProfile.company {
                            Text(company)
                                .font(.caption2)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .padding()
                }
                .frame(width: 140, height: 140)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
            }
            .padding(.horizontal, 10)
                            
            VStack(alignment: .leading, spacing: 8) {
                OptionalText(text: userProfile.bio)
                
                OptionalHStack(icon: "envelope.fill", text: userProfile.email)
                
                OptionalHStack(icon: "mappin.circle.fill", text: userProfile.location)
                
                Spacer()
            }
            .frame(height: 130)
            .foregroundStyle(Color.white)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

struct OptionalText: View {
    var text: String?
    var body: some View {
        if let text = text {
            Text(text)
                .font(.caption)
                .foregroundColor(.white.opacity(0.9))
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
    }
}

struct OptionalHStack: View {
    var icon: String
    var text: String?
    var body: some View {
        if let text = text {
            HStack(alignment: .top) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.gray)
                Text(text)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.9))
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
            }
        }
    }
}
