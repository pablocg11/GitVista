import Foundation

struct RepositoryDTO: Codable {
    let id: Int
    let name: String
    let createdAt: String
    let isPrivate: Bool
    let owner: OwnerDTO
    let htmlUrl: String
    let description: String?
    let language: String?
    let visibility: String?
    let fork: Bool
    let watchers: Int
    let starsCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, owner, description, language, visibility, fork, watchers
        case createdAt = "created_at"
        case isPrivate = "private"
        case htmlUrl = "html_url"
        case starsCount = "stargazers_count"
    }
}
