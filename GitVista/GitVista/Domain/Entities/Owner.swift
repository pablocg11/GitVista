import Foundation

struct Owner {
    let id: Int
    let userName: String
    let htmlUserUrl: String
    let avatarUrl: String?
    let type: String?
    
    init
    (
        id: Int,
        userName: String,
        htmlUserUrl: String,
        avatarUrl: String?,
        type: String?
    ) {
        self.id = id
        self.userName = userName
        self.htmlUserUrl = htmlUserUrl
        self.avatarUrl = avatarUrl
        self.type = type
    }
    
    init(dto: OwnerDTO) {
        self.id = dto.id
        self.userName = dto.userName
        self.htmlUserUrl = dto.htmlUserUrl
        self.avatarUrl = dto.avatarUrl ?? nil
        self.type = dto.type ?? "unknown"
    }
}
