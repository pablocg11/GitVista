import Foundation

struct OwnerDTO: Codable {
    let id: Int
    let userName: String
    let htmlUserUrl: String
    let avatarUrl: String?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case id, type
        case userName = "login"
        case htmlUserUrl = "html_url"
        case avatarUrl = "avatar_url"
    }
}
