import Foundation

struct Constants {
    // MARK: - Supabase Configuration
    // TODO: Replace with your actual Supabase credentials
    static let supabaseURL = "https://YOUR_PROJECT_ID.supabase.co"
    static let supabaseAnonKey = "YOUR_SUPABASE_ANON_KEY"
    
    // MARK: - App Configuration
    struct App {
        static let name = "ARETE"
        static let tagline = "Excellence Begins With You"
    }
    
    // MARK: - User Defaults Keys
    struct UserDefaultsKeys {
        static let userId = "userId"
        static let userRole = "userRole"
        static let isLoggedIn = "isLoggedIn"
    }
    
    // MARK: - Date Formats
    struct DateFormats {
        static let displayDate = "EEEE, MMM d"
        static let shortDate = "MMM d, yyyy"
        static let workoutDate = "yyyy-MM-dd"
    }
}
