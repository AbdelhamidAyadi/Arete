import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        client = SupabaseClient(
            supabaseURL: URL(string: Constants.supabaseURL)!,
            supabaseKey: Constants.supabaseAnonKey
        )
    }
    
    var currentUserId: UUID? {
        client.auth.currentUser?.id
    }
    
    var currentUserEmail: String? {
        client.auth.currentUser?.email
    }
    
    var isAuthenticated: Bool {
        client.auth.currentSession != nil
    }
}
