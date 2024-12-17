import SwiftUI

struct GitHubRepositoryCard: View {
    var repository: Repository
    var body: some View {
        Link(destination: URL(string: repository.htmlUrl)!) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(repository.name)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    Text(repository.visibility?.uppercased() ?? "")
                        .font(.system(size: 8))
                        .padding(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.white, lineWidth: 0.5)
                        )
                }
                
                Text(repository.description ?? "No description.")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .truncationMode(.tail)
                
                Spacer()
                
                if let language = repository.language {
                    Spacer(minLength: 0)
                    HStack {
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(LanguageColorService.colorForLanguage(language))
                        Text(language)
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
            
                HStack {
                    Image(systemName: "star")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 10, height: 10)
                    
                    Text(String(repository.starsCount))
                        .font(.caption)
                    
                    Image(systemName: "eye")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 10, height: 10)
                    
                    Text(String(repository.watchers))
                        .font(.caption)
                }
                .foregroundStyle(Color.gray)
                
            }
            .multilineTextAlignment(.leading)
            .padding(10)
            .frame(width: 170, height: 150)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .shadow(color: Color.white.opacity(0.2), radius: 5, x: 0, y: 3)
            .foregroundStyle(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
    }
}
