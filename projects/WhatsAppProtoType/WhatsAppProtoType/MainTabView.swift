//
//  MainTabView.swift
//  WhatsAppProtoType
//
//  Created by Kunguma Harish P on 23/08/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ChatListView()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Chats")
                }
                .badge(3) // Unread chats count
            
            StatusView()
                .tabItem {
                    Image(systemName: "circle.dashed")
                    Text("Status")
                }
            
            CallsView()
                .tabItem {
                    Image(systemName: "phone")
                    Text("Calls")
                }
            
            VStack {
                // Groups tab with badge
                Text("Groups")
                    .font(.title2)
                    .fontWeight(.medium)
                Text("Coming Soon")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .tabItem {
                Image(systemName: "person.3")
                Text("Groups")
            }
            .badge(4) // Unread groups count
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .accentColor(.blue)
    }
}

struct StatusView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "circle.dashed")
                    .font(.largeTitle)
                    .foregroundColor(.green)
                    .padding()
                
                Text("Status")
                    .font(.title2)
                    .fontWeight(.medium)
                
                Text("Coming Soon")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Status")
        }
    }
}

struct CallsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "phone")
                    .font(.largeTitle)
                    .foregroundColor(.green)
                    .padding()
                
                Text("Calls")
                    .font(.title2)
                    .fontWeight(.medium)
                
                Text("Coming Soon")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Calls")
        }
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        
                        VStack(alignment: .leading) {
                            Text("You")
                                .font(.headline)
                            Text("+1 234 567 890")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "qrcode")
                            .foregroundColor(.green)
                    }
                    .padding(.vertical, 8)
                }
                
                Section {
                    SettingsRow(icon: "key", title: "Account", subtitle: "Security notifications, change number")
                    SettingsRow(icon: "lock", title: "Privacy", subtitle: "Block contacts, disappearing messages")
                    SettingsRow(icon: "person.circle", title: "Avatar", subtitle: "Create, edit, profile photo")
                    SettingsRow(icon: "bubble.left.and.bubble.right", title: "Chats", subtitle: "Theme, wallpapers, chat history")
                    SettingsRow(icon: "bell", title: "Notifications", subtitle: "Message, group & call tones")
                    SettingsRow(icon: "wifi", title: "Storage and Data", subtitle: "Network usage, auto-download")
                }
                
                Section {
                    SettingsRow(icon: "questionmark.circle", title: "Help", subtitle: "Help center, contact us, privacy policy")
                    SettingsRow(icon: "heart", title: "Tell a Friend", subtitle: "Share WhatsApp with friends")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.primary)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    MainTabView()
}
