import Foundation
import Supabase

class WorkoutService {
    private let client = SupabaseManager.shared.client
    
    func fetchWorkouts(forClientId clientId: UUID) async throws -> [Workout] {
        let workouts: [Workout] = try await client.database
            .from("workouts")
            .select()
            .eq("client_id", value: clientId.uuidString)
            .order("scheduled_for", ascending: false)
            .execute()
            .value
        
        var workoutsWithExercises: [Workout] = []
        for var workout in workouts {
            let exercises = try await fetchExercises(forWorkoutId: workout.id)
            workout.exercises = exercises
            
            let isCompleted = try await isWorkoutCompleted(workoutId: workout.id)
            workout.isCompleted = isCompleted
            
            workoutsWithExercises.append(workout)
        }
        
        return workoutsWithExercises
    }
    
    func fetchTodayWorkout(forClientId clientId: UUID) async throws -> Workout? {
        let today = Calendar.current.startOfDay(for: Date())
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate]
        let todayString = dateFormatter.string(from: today)
        
        let workouts: [Workout] = try await client.database
            .from("workouts")
            .select()
            .eq("client_id", value: clientId.uuidString)
            .eq("scheduled_for", value: todayString)
            .execute()
            .value
        
        guard var workout = workouts.first else { return nil }
        
        let exercises = try await fetchExercises(forWorkoutId: workout.id)
        workout.exercises = exercises
        
        let isCompleted = try await isWorkoutCompleted(workoutId: workout.id)
        workout.isCompleted = isCompleted
        
        return workout
    }
    
    func fetchExercises(forWorkoutId workoutId: UUID) async throws -> [Exercise] {
        let exercises: [Exercise] = try await client.database
            .from("workout_exercises")
            .select()
            .eq("workout_id", value: workoutId.uuidString)
            .order("order_index", ascending: true)
            .execute()
            .value
        
        return exercises
    }
    
    func completeWorkout(workoutId: UUID, clientId: UUID, comment: String?) async throws {
        let log: [String: Any] = [
            "workout_id": workoutId.uuidString,
            "client_id": clientId.uuidString,
            "comment": comment as Any
        ]
        
        try await client.database
            .from("workout_logs")
            .insert(log)
            .execute()
    }
    
    private func isWorkoutCompleted(workoutId: UUID) async throws -> Bool {
        struct LogCount: Codable {
            let count: Int
        }
        
        let response: [LogCount] = try await client.database
            .from("workout_logs")
            .select("count")
            .eq("workout_id", value: workoutId.uuidString)
            .execute()
            .value
        
        return (response.first?.count ?? 0) > 0
    }
    
    func fetchWorkoutStats(forClientId clientId: UUID) async throws -> ProfileStats {
        struct WorkoutCount: Codable {
            let count: Int
        }
        
        let totalResponse: [WorkoutCount] = try await client.database
            .from("workouts")
            .select("count")
            .eq("client_id", value: clientId.uuidString)
            .execute()
            .value
        
        let total = totalResponse.first?.count ?? 0
        
        let completedResponse: [WorkoutCount] = try await client.database
            .from("workout_logs")
            .select("count")
            .eq("client_id", value: clientId.uuidString)
            .execute()
            .value
        
        let completed = completedResponse.first?.count ?? 0
        
        let adherence = total > 0 ? Int((Double(completed) / Double(total)) * 100) : 0
        
        return ProfileStats(
            totalWorkouts: total,
            completedWorkouts: completed,
            adherencePercentage: adherence,
            currentStreak: 0
        )
    }
}
