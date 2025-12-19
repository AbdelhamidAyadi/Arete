import Foundation

struct Exercise: Codable, Identifiable {
    let id: UUID
    let workoutId: UUID
    let name: String
    let sets: Int?
    let reps: String?
    let weight: String?
    let orderIndex: Int
    var isCompleted: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id, name, sets, reps, weight
        case workoutId = "workout_id"
        case orderIndex = "order_index"
    }
}
