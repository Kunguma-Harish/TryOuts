//
//  ChatDetailView.swift
//  WhatsAppProtoType
//
//  Created by Kunguma Harish P on 23/08/25.
//

import SwiftUI

struct ChatDetailView: View {
    let chat: Chat
    @ObservedObject var sampleData: SampleData
    @State private var newMessageText = ""
    // Scroll view proxy is handled directly in the ScrollViewReader closure
    
    var body: some View {
        VStack(spacing: 0) {
            // Messages List
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(currentChat.messages) { message in
                            MessageBubbleView(message: message)
                                .id(message.id)
                        }
                    }
                    .padding(.top, 8)
                }
                .onAppear {
                    if let lastMessage = currentChat.messages.last {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
                .onChange(of: currentChat.messages.count) { _ in
                    if let lastMessage = currentChat.messages.last {
                        withAnimation(.easeOut(duration: 0.3)) {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            // Message Input
            messageInputView
        }
        .navigationTitle(chatTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button(action: {
                        // Video call action
                    }) {
                        Image(systemName: "video")
                    }
                    
                    Button(action: {
                        // Voice call action
                    }) {
                        Image(systemName: "phone")
                    }
                }
            }
        }
    }
    
    private var currentChat: Chat {
        sampleData.chats.first { $0.id == chat.id } ?? chat
    }
    
    private var chatTitle: String {
        if chat.isGroupChat {
            return chat.chatName ?? "Group Chat"
        } else {
            return chat.otherParticipant?.name ?? "Unknown"
        }
    }
    
    private var messageInputView: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 12) {
                // Attachment button
                Button(action: {
                    // Attachment action
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                
                // Text input
                HStack {
                    TextField("Message", text: $newMessageText, axis: .vertical)
                        .lineLimit(1...5)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                    
                    if !newMessageText.isEmpty {
                        Button(action: {
                            // Emoji picker
                        }) {
                            Image(systemName: "face.smiling")
                                .foregroundColor(.secondary)
                        }
                        .padding(.trailing, 8)
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemGray6))
                )
                
                // Send/Voice button
                Button(action: {
                    if newMessageText.isEmpty {
                        // Voice message action
                    } else {
                        sendMessage()
                    }
                }) {
                    Image(systemName: newMessageText.isEmpty ? "mic" : "arrow.up.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color(.systemBackground))
    }
    
    private func sendMessage() {
        guard !newMessageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        sampleData.addMessage(to: chat.id, content: newMessageText)
        newMessageText = ""
        
        // Scroll will be handled automatically by onChange
    }

}

#Preview {
    NavigationView {
        ChatDetailView(
            chat: Chat(
                participants: [
                    User(name: "You", phoneNumber: "+1234567890"),
                    User(name: "John Doe", phoneNumber: "+1987654321", isOnline: true)
                ],
                messages: [
                    Message(content: "Hey! How are you?", senderID: UUID(), isFromCurrentUser: false),
                    Message(content: "I'm good, thanks!", senderID: UUID(), isFromCurrentUser: true),
                    Message(content: "Want to grab coffee later?", senderID: UUID(), isFromCurrentUser: false)
                ]
            ),
            sampleData: SampleData()
        )
    }
}
