//
//  ChatListView.swift
//  WhatsAppProtoType
//
//  Created by Kunguma Harish P on 23/08/25.
//

import SwiftUI

struct ChatListView: View {
    @StateObject private var sampleData = SampleData()
    @State private var searchText = ""
    
    var filteredChats: [Chat] {
        if searchText.isEmpty {
            return sampleData.chats
        } else {
            return sampleData.chats.filter { chat in
                chat.otherParticipant?.name.localizedCaseInsensitiveContains(searchText) ?? false ||
                chat.lastMessage?.content.localizedCaseInsensitiveContains(searchText) ?? false
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom Navigation Header
                HStack {
                    Text("Edit")
                        .foregroundColor(.blue)
                        .font(.body)
                    
                    Spacer()
                    
                    Text("Chats")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button(action: {
                        // New chat action
                    }) {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.blue)
                            .font(.title2)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                
                // Search Bar
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                        
                        TextField("Search", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
                
                // Chat List
                List {
                    ForEach(filteredChats) { chat in
                        NavigationLink(destination: ChatDetailView(chat: chat, sampleData: sampleData)) {
                            ChatRowView(chat: chat)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationBarHidden(true)
        }
    }
}

struct ChatRowView: View {
    let chat: Chat
    
    var body: some View {
        HStack(spacing: 12) {
            // Profile Image
            ZStack {
                profileImage
                
                // Online status indicator
                if let otherUser = chat.otherParticipant, otherUser.isOnline {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 12, height: 12)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .offset(x: 17, y: 17)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    // Chat name
                    Text(chatName)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    // Timestamp
                    Text(timestampString)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    // Last message preview with enhanced formatting
                    HStack(spacing: 4) {
                        lastMessageContent
                    }
                    
                    Spacer()
                    
                    // Unread badge or delivery status
                    if hasUnreadMessages {
                        unreadBadge
                    } else if let lastMessage = chat.lastMessage, lastMessage.isFromCurrentUser {
                        deliveryStatusIcon(for: lastMessage.deliveryStatus)
                    }
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
    
    private var profileImage: some View {
        // Create a realistic profile image using the first letter of the name
        let initials = String(chatName.prefix(1)).uppercased()
        let colors: [Color] = [.blue, .green, .orange, .purple, .pink, .red, .yellow, .indigo]
        let colorIndex = abs(chatName.hashValue) % colors.count
        
        return Circle()
            .fill(colors[colorIndex])
            .frame(width: 50, height: 50)
            .overlay(
                Text(initials)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
            )
    }
    
    private var chatName: String {
        if chat.isGroupChat {
            return chat.chatName ?? "Group Chat"
        } else {
            return chat.otherParticipant?.name ?? "Unknown"
        }
    }
    
    @ViewBuilder
    private var lastMessageContent: some View {
        if let lastMessage = chat.lastMessage {
            HStack(spacing: 4) {
                // Add delivery status for sent messages
                if lastMessage.isFromCurrentUser {
                    deliveryStatusIcon(for: lastMessage.deliveryStatus)
                }
                
                // Message content with special formatting
                if lastMessage.messageType == .voice {
                    Image(systemName: "mic.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                    Text("1:55") // Voice message duration
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                } else if lastMessage.content.lowercased().contains("photo") {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                    Text("Photo")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                } else {
                    Text(lastMessage.content)
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
        } else {
            Text("No messages")
                .font(.system(size: 15))
                .foregroundColor(.secondary)
        }
    }
    
    private var hasUnreadMessages: Bool {
        // Simulate unread messages for some chats
        guard let lastMessage = chat.lastMessage else { return false }
        return !lastMessage.isFromCurrentUser && 
               lastMessage.deliveryStatus != .read &&
               (chatName.contains("Cubbie") || chatName.contains("+234"))
    }
    
    private var unreadBadge: some View {
        let unreadCount = hasUnreadMessages ? (chatName.contains("Cubbie") ? 1 : 2) : 0
        
        return Circle()
            .fill(Color.blue)
            .frame(width: 20, height: 20)
            .overlay(
                Text("\(unreadCount)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
            )
    }
    
    private var timestampString: String {
        guard let lastMessage = chat.lastMessage else {
            return ""
        }
        
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDate(lastMessage.timestamp, inSameDayAs: Date()) {
            formatter.timeStyle = .short
        } else if calendar.isDate(lastMessage.timestamp, inSameDayAs: calendar.date(byAdding: .day, value: -1, to: Date()) ?? Date()) {
            return "Yesterday"
        } else {
            formatter.dateStyle = .short
        }
        
        return formatter.string(from: lastMessage.timestamp)
    }
    
    private func deliveryStatusIcon(for status: Message.DeliveryStatus) -> some View {
        Group {
            switch status {
            case .sending:
                Image(systemName: "clock")
                    .font(.caption)
                    .foregroundColor(.secondary)
            case .sent:
                Image(systemName: "checkmark")
                    .font(.caption)
                    .foregroundColor(.secondary)
            case .delivered:
                Image(systemName: "checkmark.circle")
                    .font(.caption)
                    .foregroundColor(.secondary)
            case .read:
                Image(systemName: "checkmark.circle.fill")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
    }
    

}

#Preview {
    ChatListView()
}
