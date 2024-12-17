import Foundation

struct Repository: Equatable {
    let id: Int
    let name: String
    let createdAt: Date
    let updatedAt: Date
    let isPrivate: Bool
    let owner: Owner
    let htmlUrl: String
    let description: String?
    let language: String?
    let visibility: String?
    let fork: Bool
    let watchers: Int
    let starsCount: Int
    
    init
    (
        id: Int,
        name: String,
        createdAt: Date,
        updateAt: Date,
        isPrivate: Bool,
        owner: Owner,
        htmlUrl: String,
        description: String?,
        language: String?,
        visibility: String?,
        fork: Bool,
        watchers: Int,
        starsCount: Int
    ) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.updatedAt = updateAt
        self.isPrivate = isPrivate
        self.owner = owner
        self.htmlUrl = htmlUrl
        self.description = description
        self.language = language
        self.visibility = visibility
        self.fork = fork
        self.watchers = watchers
        self.starsCount = starsCount
    }
    
    init(dto: RepositoryDTO) {
        self.id = dto.id
        self.name = dto.name
        self.createdAt = ISO8601DateFormatter().date(from: dto.createdAt) ?? Date()
        self.updatedAt = ISO8601DateFormatter().date(from: dto.updatedAt) ?? Date()
        self.isPrivate = dto.isPrivate
        self.owner = Owner(dto: dto.owner)
        self.htmlUrl = dto.htmlUrl
        self.description = dto.description
        self.language = dto.language
        self.visibility = dto.visibility
        self.fork = dto.fork
        self.watchers = dto.watchers
        self.starsCount = dto.starsCount
    }
}
