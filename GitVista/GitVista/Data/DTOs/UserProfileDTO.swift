import Foundation

struct UserProfileDTO: Codable {
    let id: Int
    let login: String
    let avatarURL: String
    let htmlURL: String
    let userViewType: String
    let name: String?
    let company: String?
    let blog: String?
    let location: String?
    let email: String?
    let bio: String?

    enum CodingKeys: String, CodingKey {
        case id, name, company, blog, location, email, bio
        case login
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
        case userViewType = "user_view_type"
    }
}
