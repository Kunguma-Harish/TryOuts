//
//  MessageBubbleView.swift
//  WhatsAppProtoType
//
//  Created by Kunguma Harish P on 23/08/25.
//

import SwiftUI

struct MessageBubbleView: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isFromCurrentUser {
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    messageBubble
                    messageInfo
                }
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    messageBubble
                    messageInfo
                }
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 2)
    }
    
    private var messageBubble: some View {
        Text(message.content)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(message.isFromCurrentUser ? Color.whatsAppGreen : Color.messageBubbleReceived)
            )
            .foregroundColor(message.isFromCurrentUser ? .white : .primary)
            .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: message.isFromCurrentUser ? .trailing : .leading)
    }
    
    private var messageInfo: some View {
        HStack(spacing: 4) {
            Text(timeString)
                .font(.caption2)
                .foregroundColor(.secondary)
            
            if message.isFromCurrentUser {
                deliveryStatusIcon
            }
        }
    }
    
    private var deliveryStatusIcon: some View {
        Group {
            switch message.deliveryStatus {
            case .sending:
                Image(systemName: "clock")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            case .sent:
                Image(systemName: "checkmark")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            case .delivered:
                Image(systemName: "checkmark.circle")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            case .read:
                Image(systemName: "checkmark.circle.fill")
                    .font(.caption2)
                    .foregroundColor(.blue)
            }
        }
    }
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: message.timestamp)
    }
}

#Preview {
    VStack {
        MessageBubbleView(message: Message(content: "Hey! How are you doing?", senderID: UUID(), isFromCurrentUser: false))
        MessageBubbleView(message: Message(content: "I'm good, thanks! How about you?", senderID: UUID(), isFromCurrentUser: true, deliveryStatus: .read))
        MessageBubbleView(message: Message(content: "This is a longer message to test how the bubble looks with more text content that spans multiple lines", senderID: UUID(), isFromCurrentUser: false))
    }
    .padding()
}
