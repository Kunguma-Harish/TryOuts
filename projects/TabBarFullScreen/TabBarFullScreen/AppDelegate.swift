//
//  TabBarFullScreenApp.swift
//  TabBarFullScreen
//
//  Created by kunguma-14252 on 16/07/24.
//

import SwiftUI

@main
struct TabBarFullScreenApp: App {
    @StateObject private var dataManager = DataManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager)
                .onAppear {
                    dataManager.initializeSampleMessages()
                }
        }
    }
}

