//
//  Extensions.swift
//  WhatsAppProtoType
//
//  Created by Kunguma Harish P on 23/08/25.
//

import SwiftUI

extension Color {
    static let whatsAppGreen = Color(red: 0.18, green: 0.73, blue: 0.25)
    static let whatsAppLightGreen = Color(red: 0.87, green: 0.95, blue: 0.84)
    static let whatsAppGray = Color(red: 0.92, green: 0.92, blue: 0.92)
    static let messageBubbleReceived = Color(.systemGray6)
    static let messageBubbleSent = Color.blue
}

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    func formatted(style: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDate(self, inSameDayAs: Date()) {
            formatter.timeStyle = .short
        } else if calendar.isDate(self, inSameDayAs: calendar.date(byAdding: .day, value: -1, to: Date()) ?? Date()) {
            return "Yesterday"
        } else {
            formatter.dateStyle = style
        }
        return formatter.string(from: self)
    }
}
