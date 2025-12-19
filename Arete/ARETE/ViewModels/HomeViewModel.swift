import Foundation
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var todayWorkout: Workout?
    @Published var dietPlan: DietPlan?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let workoutService = WorkoutService()
    private let dietService = DietService()
    
    func loadTodayData() async {
        guard let clientId = SupabaseManager.shared.currentUserId else { return }
        
        isLoading = true
        
        async let workout = workoutService.fetchTodayWorkout(forClientId: clientId)
        async let diet = dietService.fetchDietPlan(forClientId: clientId)
        
        do {
            todayWorkout = try await workout
            dietPlan = try await diet
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
