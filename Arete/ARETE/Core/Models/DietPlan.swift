import Foundation

struct DietPlan: Codable, Identifiable {
    let id: UUID
    let trainerId: UUID
    let clientId: UUID
    let calories: Int?
    let protein: Int?
    let carbs: Int?
    let fats: Int?
    let breakfastNotes: String?
    let lunchNotes: String?
    let dinnerNotes: String?
    let snacksNotes: String?
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, calories, protein, carbs, fats
        case trainerId = "trainer_id"
        case clientId = "client_id"
        case breakfastNotes = "breakfast_notes"
        case lunchNotes = "lunch_notes"
        case dinnerNotes = "dinner_notes"
        case snacksNotes = "snacks_notes"
        case updatedAt = "updated_at"
    }
}
