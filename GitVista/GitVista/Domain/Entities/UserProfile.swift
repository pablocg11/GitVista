import Foundation

struct UserProfile: Equatable {
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
    
    init(id: Int, login: String, avatarURL: String, htmlURL: String, userViewType: String, name: String?, company: String?, blog: String?, location: String?, email: String?, bio: String?) {
        self.id = id
        self.login = login
        self.avatarURL = avatarURL
        self.htmlURL = htmlURL
        self.userViewType = userViewType
        self.name = name
        self.company = company
        self.blog = blog
        self.location = location
        self.email = email
        self.bio = bio
    }
    
    init(dto: UserProfileDTO) {
        self.id = dto.id
        self.login = dto.login
        self.avatarURL = dto.avatarURL
        self.htmlURL = dto.htmlURL
        self.userViewType = dto.userViewType
        self.name = dto.name
        self.company = dto.company
        self.blog = dto.blog
        self.location = dto.location
        self.email = dto.email
        self.bio = dto.bio
    }
}
