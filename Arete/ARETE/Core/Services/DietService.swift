import Foundation
import Supabase

class DietService {
    private let client = SupabaseManager.shared.client
    
    func fetchDietPlan(forClientId clientId: UUID) async throws -> DietPlan? {
        let plans: [DietPlan] = try await client.database
            .from("diet_plans")
            .select()
            .eq("client_id", value: clientId.uuidString)
            .execute()
            .value
        
        return plans.first
    }
}
