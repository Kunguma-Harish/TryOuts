//
//  Models.swift
//  TabBarFullScreen
//
//  Created by AI Assistant
//

import Foundation
import SwiftUI

// MARK: - Chat Model
struct Chat: Identifiable, Hashable {
    let id: String
    let name: String
    let lastMessage: String
    let timestamp: Date
    let profileImage: String
    let unreadCount: Int
    
    init(id: String = UUID().uuidString, name: String, lastMessage: String, timestamp: Date, profileImage: String, unreadCount: Int = 0) {
        self.id = id
        self.name = name
        self.lastMessage = lastMessage
        self.timestamp = timestamp
        self.profileImage = profileImage
        self.unreadCount = unreadCount
    }
}

// MARK: - Message Model
struct Message: Identifiable, Hashable {
    let id: String
    let text: String
    let timestamp: Date
    let isFromUser: Bool
    let chatId: String
    
    init(id: String = UUID().uuidString, text: String, timestamp: Date, isFromUser: Bool, chatId: String) {
        self.id = id
        self.text = text
        self.timestamp = timestamp
        self.isFromUser = isFromUser
        self.chatId = chatId
    }
}

// MARK: - Status Model
struct Status: Identifiable, Hashable {
    let id: String
    let userName: String
    let timestamp: Date
    let content: String
    let profileImage: String
    let viewCount: Int
    
    init(id: String = UUID().uuidString, userName: String, timestamp: Date, content: String, profileImage: String, viewCount: Int = 0) {
        self.id = id
        self.userName = userName
        self.timestamp = timestamp
        self.content = content
        self.profileImage = profileImage
        self.viewCount = viewCount
    }
}

// MARK: - Data Manager
class DataManager: ObservableObject {
    static let shared = DataManager()
    
    private init() {}
    
    // Sample data
    @Published var chats: [Chat] = [
        Chat(name: "John Doe", lastMessage: "Hey, how are you doing?", timestamp: Date().addingTimeInterval(-3600), profileImage: "person.circle.fill", unreadCount: 2),
        Chat(name: "Jane Smith", lastMessage: "Let's meet tomorrow", timestamp: Date().addingTimeInterval(-7200), profileImage: "person.circle.fill", unreadCount: 1),
        Chat(name: "Mike Johnson", lastMessage: "Thanks for the help!", timestamp: Date().addingTimeInterval(-86400), profileImage: "person.circle.fill", unreadCount: 0),
        Chat(name: "Sarah Wilson", lastMessage: "Great job on the project", timestamp: Date().addingTimeInterval(-172800), profileImage: "person.circle.fill", unreadCount: 3),
        Chat(name: "Team Group", lastMessage: "Meeting at 3 PM", timestamp: Date().addingTimeInterval(-259200), profileImage: "person.3.fill", unreadCount: 5)
    ]
    
    @Published var messages: [String: [Message]] = [:]
    
    @Published var statuses: [Status] = [
        Status(userName: "John Doe", timestamp: Date().addingTimeInterval(-1800), content: "Having a great day! 🌟", profileImage: "person.circle.fill", viewCount: 15),
        Status(userName: "Jane Smith", timestamp: Date().addingTimeInterval(-3600), content: "Beautiful sunset today 🌅", profileImage: "person.circle.fill", viewCount: 23),
        Status(userName: "Mike Johnson", timestamp: Date().addingTimeInterval(-7200), content: "Just finished my workout 💪", profileImage: "person.circle.fill", viewCount: 8),
        Status(userName: "Sarah Wilson", timestamp: Date().addingTimeInterval(-10800), content: "Coffee time ☕", profileImage: "person.circle.fill", viewCount: 12)
    ]
    
    // Initialize sample messages for each chat
    func initializeSampleMessages() {
        for chat in chats {
            messages[chat.id] = generateSampleMessages(for: chat.id)
        }
    }
    
    private func generateSampleMessages(for chatId: String) -> [Message] {
        let sampleTexts = [
            "Hey there! How's it going?",
            "I'm doing great, thanks for asking!",
            "What are you up to today?",
            "Just working on some projects",
            "That sounds interesting!",
            "Would you like to grab coffee sometime?",
            "Sure, that would be nice!",
            "How about tomorrow afternoon?",
            "Perfect! Let's meet at 3 PM"
        ]
        
        var chatMessages: [Message] = []
        for (index, text) in sampleTexts.enumerated() {
            let message = Message(
                text: text,
                timestamp: Date().addingTimeInterval(TimeInterval(-3600 * (sampleTexts.count - index))),
                isFromUser: index % 2 == 0,
                chatId: chatId
            )
            chatMessages.append(message)
        }
        return chatMessages
    }
    
    // Add new message
    func addMessage(to chatId: String, text: String, isFromUser: Bool = true) {
        let newMessage = Message(text: text, timestamp: Date(), isFromUser: isFromUser, chatId: chatId)
        
        if messages[chatId] == nil {
            messages[chatId] = []
        }
        messages[chatId]?.append(newMessage)
        
        // Update the last message in chat
        if let chatIndex = chats.firstIndex(where: { $0.id == chatId }) {
            let updatedChat = Chat(
                id: chats[chatIndex].id,
                name: chats[chatIndex].name,
                lastMessage: text,
                timestamp: Date(),
                profileImage: chats[chatIndex].profileImage,
                unreadCount: chats[chatIndex].unreadCount
            )
            chats[chatIndex] = updatedChat
        }
    }
    
    // Get messages for chat
    func getMessages(for chatId: String) -> [Message] {
        return messages[chatId] ?? []
    }
}
