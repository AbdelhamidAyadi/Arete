import Foundation
import Supabase

class AuthService {
    private let client = SupabaseManager.shared.client
    
    func signUp(email: String, password: String, fullName: String, role: UserRole) async throws -> User {
        let authResponse = try await client.auth.signUp(
            email: email,
            password: password
        )
        
        guard let userId = authResponse.user.id else {
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create user"])
        }
        
        let userProfile = [
            "id": userId.uuidString,
            "email": email,
            "full_name": fullName,
            "role": role.rawValue
        ] as [String: Any]
        
        try await client.database
            .from("users")
            .insert(userProfile)
            .execute()
        
        return try await getCurrentUser()
    }
    
    func signIn(email: String, password: String) async throws -> User {
        try await client.auth.signIn(
            email: email,
            password: password
        )
        
        return try await getCurrentUser()
    }
    
    func signOut() async throws {
        try await client.auth.signOut()
    }
    
    func getCurrentUser() async throws -> User {
        guard let userId = client.auth.currentUser?.id else {
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"])
        }
        
        let response: User = try await client.database
            .from("users")
            .select()
            .eq("id", value: userId.uuidString)
            .single()
            .execute()
            .value
        
        return response
    }
    
    func getTrainerId() async throws -> UUID {
        guard let userId = client.auth.currentUser?.id else {
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"])
        }
        
        struct TrainerClient: Codable {
            let trainerId: UUID
            
            enum CodingKeys: String, CodingKey {
                case trainerId = "trainer_id"
            }
        }
        
        let response: TrainerClient = try await client.database
            .from("trainer_clients")
            .select("trainer_id")
            .eq("client_id", value: userId.uuidString)
            .single()
            .execute()
            .value
        
        return response.trainerId
    }
}
