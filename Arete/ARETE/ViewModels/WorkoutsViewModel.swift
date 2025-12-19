import Foundation
import SwiftUI

@MainActor
class WorkoutsViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var selectedWorkout: Workout?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showCompletionSheet = false
    
    private let workoutService = WorkoutService()
    
    func loadWorkouts() async {
        guard let clientId = SupabaseManager.shared.currentUserId else { return }
        
        isLoading = true
        
        do {
            workouts = try await workoutService.fetchWorkouts(forClientId: clientId)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func completeWorkout(workout: Workout, comment: String?) async {
        guard let clientId = SupabaseManager.shared.currentUserId else { return }
        
        do {
            try await workoutService.completeWorkout(
                workoutId: workout.id,
                clientId: clientId,
                comment: comment
            )
            
            await loadWorkouts()
            showCompletionSheet = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
