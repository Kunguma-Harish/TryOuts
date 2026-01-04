//
//  Models.swift
//  WhatsAppProtoType
//
//  Created by Kunguma Harish P on 23/08/25.
//

import Foundation

// MARK: - User Model
struct User: Identifiable, Codable {
    let id = UUID()
    let name: String
    let phoneNumber: String
    let profileImage: String?
    let isOnline: Bool
    let lastSeen: Date?
    
    init(name: String, phoneNumber: String, profileImage: String? = nil, isOnline: Bool = false, lastSeen: Date? = nil) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.profileImage = profileImage
        self.isOnline = isOnline
        self.lastSeen = lastSeen
    }
}

// MARK: - Message Model
struct Message: Identifiable, Codable {
    let id = UUID()
    let content: String
    let timestamp: Date
    let senderID: UUID
    let isFromCurrentUser: Bool
    let messageType: MessageType
    let deliveryStatus: DeliveryStatus
    
    enum MessageType: String, Codable, CaseIterable {
        case text
        case image
        case voice
        case video
    }
    
    enum DeliveryStatus: String, Codable, CaseIterable {
        case sending
        case sent
        case delivered
        case read
    }
    
    init(content: String, senderID: UUID, isFromCurrentUser: Bool, messageType: MessageType = .text, deliveryStatus: DeliveryStatus = .sent) {
        self.content = content
        self.timestamp = Date()
        self.senderID = senderID
        self.isFromCurrentUser = isFromCurrentUser
        self.messageType = messageType
        self.deliveryStatus = deliveryStatus
    }
    
    init(content: String, timestamp: Date, senderID: UUID, isFromCurrentUser: Bool, messageType: MessageType = .text, deliveryStatus: DeliveryStatus = .sent) {
        self.content = content
        self.timestamp = timestamp
        self.senderID = senderID
        self.isFromCurrentUser = isFromCurrentUser
        self.messageType = messageType
        self.deliveryStatus = deliveryStatus
    }
}

// MARK: - Chat Model
struct Chat: Identifiable, Codable {
    let id = UUID()
    let participants: [User]
    var messages: [Message]
    let isGroupChat: Bool
    let chatName: String?
    let chatImage: String?
    
    var lastMessage: Message? {
        messages.sorted(by: { $0.timestamp > $1.timestamp }).first
    }
    
    var otherParticipant: User? {
        participants.first { !$0.name.contains("You") }
    }
    
    init(participants: [User], messages: [Message] = [], isGroupChat: Bool = false, chatName: String? = nil, chatImage: String? = nil) {
        self.participants = participants
        self.messages = messages
        self.isGroupChat = isGroupChat
        self.chatName = chatName
        self.chatImage = chatImage
    }
}
