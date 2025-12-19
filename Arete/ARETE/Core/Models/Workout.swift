import Foundation

struct Workout: Codable, Identifiable {
    let id: UUID
    let trainerId: UUID
    let clientId: UUID
    let title: String
    let scheduledFor: Date
    let notes: String?
    let createdAt: Date
    var exercises: [Exercise]?
    var isCompleted: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, title, notes
        case trainerId = "trainer_id"
        case clientId = "client_id"
        case scheduledFor = "scheduled_for"
        case createdAt = "created_at"
        case exercises
    }
}
