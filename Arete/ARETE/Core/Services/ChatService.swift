import Foundation
import Supabase

class ChatService {
    private let client = SupabaseManager.shared.client
    
    func fetchMessages(trainerId: UUID, clientId: UUID) async throws -> [Message] {
        let messages: [Message] = try await client.database
            .from("messages")
            .select()
            .or("trainer_id.eq.\(trainerId.uuidString),client_id.eq.\(clientId.uuidString)")
            .order("created_at", ascending: true)
            .execute()
            .value
        
        return messages
    }
    
    func sendMessage(trainerId: UUID, clientId: UUID, senderType: SenderType, text: String) async throws {
        let message: [String: Any] = [
            "trainer_id": trainerId.uuidString,
            "client_id": clientId.uuidString,
            "sender_type": senderType.rawValue,
            "text": text
        ]
        
        try await client.database
            .from("messages")
            .insert(message)
            .execute()
    }
    
    func subscribeToMessages(trainerId: UUID, clientId: UUID, onMessage: @escaping (Message) -> Void) -> RealtimeChannel {
        let channel = client.realtime.channel("messages")
        
        channel
            .on("postgres_changes", filter: ChannelFilter(
                event: "INSERT",
                schema: "public",
                table: "messages",
                filter: "trainer_id=eq.\(trainerId.uuidString)"
            )) { message in
                if let payload = message.payload["record"] as? [String: Any],
                   let jsonData = try? JSONSerialization.data(withJSONObject: payload),
                   let newMessage = try? JSONDecoder().decode(Message.self, from: jsonData) {
                    onMessage(newMessage)
                }
            }
        
        channel.subscribe()
        
        return channel
    }
}
