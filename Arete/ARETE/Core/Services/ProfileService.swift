import Foundation
import Supabase

class ProfileService {
    private let client = SupabaseManager.shared.client
    
    func fetchProfile(userId: UUID) async throws -> User {
        let user: User = try await client.database
            .from("users")
            .select()
            .eq("id", value: userId.uuidString)
            .single()
            .execute()
            .value
        
        return user
    }
    
    func updateProfile(userId: UUID, fullName: String?, goal: String?, avatarUrl: String?) async throws {
        var updates: [String: Any] = [:]
        
        if let fullName = fullName {
            updates["full_name"] = fullName
        }
        if let goal = goal {
            updates["goal"] = goal
        }
        if let avatarUrl = avatarUrl {
            updates["avatar_url"] = avatarUrl
        }
        
        try await client.database
            .from("users")
            .update(updates)
            .eq("id", value: userId.uuidString)
            .execute()
    }
}
