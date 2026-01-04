//
//  SampleData.swift
//  WhatsAppProtoType
//
//  Created by Kunguma Harish P on 23/08/25.
//

import Foundation

class SampleData: ObservableObject {
    @Published var chats: [Chat] = []
    
    let currentUser = User(name: "You", phoneNumber: "+1234567890", isOnline: true)
    
    init() {
        loadSampleData()
    }
    
    private func loadSampleData() {
        let users = [
            User(name: "Demilade😎", phoneNumber: "+2347000000000", profileImage: "person.circle.fill", isOnline: false, lastSeen: Calendar.current.date(byAdding: .minute, value: -2, to: Date())),
            User(name: "+234 700 000 0000", phoneNumber: "+2347000000000", profileImage: "person.circle.fill", isOnline: false, lastSeen: Calendar.current.date(byAdding: .minute, value: -17, to: Date())),
            User(name: "Cubbie", phoneNumber: "+2348000000000", profileImage: "person.circle.fill", isOnline: false, lastSeen: Calendar.current.date(byAdding: .hour, value: -1, to: Date())),
            User(name: "Bossman Dami", phoneNumber: "+2349000000000", profileImage: "person.circle.fill", isOnline: true),
            User(name: "Edey Shake", phoneNumber: "+2347111111111", profileImage: "person.circle.fill", isOnline: false, lastSeen: Calendar.current.date(byAdding: .minute, value: -33, to: Date())),
            User(name: "Edon Appen", phoneNumber: "+2347222222222", profileImage: "person.circle.fill", isOnline: false, lastSeen: Calendar.current.date(byAdding: .hour, value: -1, to: Date())),
            User(name: "Yiu Agay", phoneNumber: "+2347333333333", profileImage: "person.circle.fill", isOnline: false, lastSeen: Calendar.current.date(byAdding: .hour, value: -2, to: Date())),
            User(name: "Kaywise", phoneNumber: "+2347444444444", profileImage: "person.circle.fill", isOnline: false, lastSeen: Calendar.current.date(byAdding: .hour, value: -6, to: Date()))
        ]
        
        // Create sample chats with messages
        var sampleChats: [Chat] = []
        
        // Create messages with specific timestamps to match the template
        let now = Date()
        let calendar = Calendar.current
        
        // Chat 1: Demilade😎 (23:48)
        let demiMessage = Message(content: "Yes, 2pm is awesome", timestamp: calendar.date(byAdding: .minute, value: -2, to: now) ?? now, senderID: currentUser.id, isFromCurrentUser: true, deliveryStatus: .read)
        sampleChats.append(Chat(participants: [currentUser, users[0]], messages: [demiMessage]))
        
        // Chat 2: +234 700 000 0000 (23:03)
        let phoneMessage = Message(content: "May i know you?", timestamp: calendar.date(byAdding: .minute, value: -47, to: now) ?? now, senderID: users[1].id, isFromCurrentUser: false, deliveryStatus: .sent)
        sampleChats.append(Chat(participants: [currentUser, users[1]], messages: [phoneMessage]))
        
        // Chat 3: Cubbie - Voice message (22:45)
        let cubbieMessage = Message(content: "Voice message", timestamp: calendar.date(byAdding: .minute, value: -65, to: now) ?? now, senderID: users[2].id, isFromCurrentUser: false, messageType: .voice, deliveryStatus: .sent)
        sampleChats.append(Chat(participants: [currentUser, users[2]], messages: [cubbieMessage]))
        
        // Chat 4: Bossman Dami (22:30)
        let bossmanMessage = Message(content: "Bro, how far that level?", timestamp: calendar.date(byAdding: .minute, value: -80, to: now) ?? now, senderID: currentUser.id, isFromCurrentUser: true, deliveryStatus: .read)
        sampleChats.append(Chat(participants: [currentUser, users[3]], messages: [bossmanMessage]))
        
        // Chat 5: Edey Shake - Photo (22:27)
        let edeyMessage = Message(content: "Photo", timestamp: calendar.date(byAdding: .minute, value: -83, to: now) ?? now, senderID: users[4].id, isFromCurrentUser: false, messageType: .image, deliveryStatus: .read)
        sampleChats.append(Chat(participants: [currentUser, users[4]], messages: [edeyMessage]))
        
        // Chat 6: Edon Appen (22:13)
        let edonMessage = Message(content: "Lmao, Akin lemme", timestamp: calendar.date(byAdding: .minute, value: -97, to: now) ?? now, senderID: users[5].id, isFromCurrentUser: false, deliveryStatus: .read)
        sampleChats.append(Chat(participants: [currentUser, users[5]], messages: [edonMessage]))
        
        // Chat 7: Yiu Agay (21:30)
        let yiuMessage = Message(content: "Sweetness", timestamp: calendar.date(byAdding: .minute, value: -140, to: now) ?? now, senderID: currentUser.id, isFromCurrentUser: true, deliveryStatus: .read)
        sampleChats.append(Chat(participants: [currentUser, users[6]], messages: [yiuMessage]))
        
        // Chat 8: Kaywise (18:00)
        let kaywiseMessage = Message(content: "Bye", timestamp: calendar.date(byAdding: .hour, value: -6, to: now) ?? now, senderID: currentUser.id, isFromCurrentUser: true, deliveryStatus: .read)
        sampleChats.append(Chat(participants: [currentUser, users[7]], messages: [kaywiseMessage]))
        
        // Sort chats by last message timestamp
        self.chats = sampleChats.sorted { chat1, chat2 in
            guard let lastMessage1 = chat1.lastMessage,
                  let lastMessage2 = chat2.lastMessage else {
                return false
            }
            return lastMessage1.timestamp > lastMessage2.timestamp
        }
    }
    
    func addMessage(to chatID: UUID, content: String) {
        if let index = chats.firstIndex(where: { $0.id == chatID }) {
            let newMessage = Message(content: content, senderID: currentUser.id, isFromCurrentUser: true)
            chats[index].messages.append(newMessage)
            
            // Move chat to top
            let updatedChat = chats.remove(at: index)
            chats.insert(updatedChat, at: 0)
        }
    }
}
