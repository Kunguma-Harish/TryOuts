//
//  ChatDetailView.swift
//  TabBarFullScreen
//
//  Created by AI Assistant
//

import SwiftUI

struct ChatDetailView: View {
    let chat: Chat
    @EnvironmentObject var dataManager: DataManager
    @State private var newMessage = ""
    @State private var messages: [Message] = []
    
    var body: some View {
        VStack(spacing: 0) {
            // Messages List
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(messages) { message in
                            MessageBubbleView(message: message)
                                .id(message.id)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }
                .onAppear {
                    loadMessages()
                    scrollToBottom(proxy: proxy)
                }
                .onChange(of: messages.count) { _ in
                    scrollToBottom(proxy: proxy)
                }
            }
            
            // Message Input
            MessageInputView(
                newMessage: $newMessage,
                onSend: sendMessage
            )
        }
        .navigationTitle(chat.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func loadMessages() {
        messages = dataManager.getMessages(for: chat.id)
    }
    
    private func sendMessage() {
        guard !newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let messageText = newMessage
        newMessage = ""
        
        dataManager.addMessage(to: chat.id, text: messageText, isFromUser: true)
        loadMessages()
        
        // Simulate response after 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let responses = ["Got it!", "Thanks!", "Sure thing!", "Sounds good!", "I'll get back to you", "👍"]
            let randomResponse = responses.randomElement() ?? "👍"
            dataManager.addMessage(to: chat.id, text: randomResponse, isFromUser: false)
            loadMessages()
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewReader) {
        if let lastMessage = messages.last {
            withAnimation(.easeOut(duration: 0.3)) {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
}

struct MessageBubbleView: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer()
            }
            
            VStack(alignment: message.isFromUser ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(message.isFromUser ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(message.isFromUser ? .white : .primary)
                    .cornerRadius(16)
                
                Text(formatTime(message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: message.isFromUser ? .trailing : .leading)
            
            if !message.isFromUser {
                Spacer()
            }
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

struct MessageInputView: View {
    @Binding var newMessage: String
    let onSend: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            TextField("Type a message...", text: $newMessage)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onSubmit {
                    onSend()
                }
            
            Button(action: onSend) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundColor(newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : .blue)
            }
            .disabled(newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
}

#Preview {
    NavigationView {
        ChatDetailView(chat: Chat(
            name: "John Doe",
            lastMessage: "Hey there!",
            timestamp: Date(),
            profileImage: "person.circle.fill"
        ))
        .environmentObject(DataManager.shared)
    }
}
