import Foundation

struct Message: Codable, Identifiable {
    let id: UUID
    let trainerId: UUID
    let clientId: UUID
    let senderType: SenderType
    let text: String
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, text
        case trainerId = "trainer_id"
        case clientId = "client_id"
        case senderType = "sender_type"
        case createdAt = "created_at"
    }
}

enum SenderType: String, Codable {
    case trainer
    case client
}
