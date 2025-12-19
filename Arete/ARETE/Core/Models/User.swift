import Foundation

struct User: Codable, Identifiable {
    let id: UUID
    let email: String
    let fullName: String
    let role: UserRole
    let avatarUrl: String?
    let goal: String?
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, email, role, goal
        case fullName = "full_name"
        case avatarUrl = "avatar_url"
        case createdAt = "created_at"
    }
}

enum UserRole: String, Codable {
    case trainer
    case client
}
