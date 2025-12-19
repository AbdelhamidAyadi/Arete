import Foundation
import SwiftUI
import Supabase

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var messageText = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let chatService = ChatService()
    private let authService = AuthService()
    private var realtimeChannel: RealtimeChannel?
    private var trainerId: UUID?
    
    func loadMessages() async {
        guard let clientId = SupabaseManager.shared.currentUserId else { return }
        
        isLoading = true
        
        do {
            trainerId = try await authService.getTrainerId()
            
            guard let trainerId = trainerId else { return }
            
            messages = try await chatService.fetchMessages(
                trainerId: trainerId,
                clientId: clientId
            )
            
            subscribeToMessages(trainerId: trainerId, clientId: clientId)
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func sendMessage() async {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let clientId = SupabaseManager.shared.currentUserId,
              let trainerId = trainerId else { return }
        
        let text = messageText
        messageText = ""
        
        do {
            try await chatService.sendMessage(
                trainerId: trainerId,
                clientId: clientId,
                senderType: .client,
                text: text
