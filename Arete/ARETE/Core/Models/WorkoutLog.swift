import Foundation

struct WorkoutLog: Codable, Identifiable {
    let id: UUID
    let workoutId: UUID
    let clientId: UUID
    let completedAt: Date
    let comment: String?
    
    enum CodingKeys: String, CodingKey {
        case id, comment
        case workoutId = "workout_id"
        case clientId = "client_id"
        case completedAt = "completed_at"
    }
}

struct ProfileStats {
    let totalWorkouts: Int
    let completedWorkouts: Int
    let adherencePercentage: Int
    let currentStreak: Int
    
    var adherenceDisplay: String {
        "\(adherencePercentage)%"
    }
}
