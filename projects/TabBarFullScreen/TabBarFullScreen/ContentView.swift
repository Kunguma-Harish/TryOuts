//
//  ContentView.swift
//  TabBarFullScreen
//
//  Created by AI Assistant
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        TabView {
            ChatsView()
                .tabItem {
                    Image(systemName: "message")
                    Text("Chats")
                }
            
            StatusView()
                .tabItem {
                    Image(systemName: "circle.dashed")
                    Text("Status")
                }
        }
        .accentColor(.green)
    }
}

#Preview {
    ContentView()
        .environmentObject(DataManager.shared)
}

