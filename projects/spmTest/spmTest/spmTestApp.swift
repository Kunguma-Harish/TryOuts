//
//  spmTestApp.swift
//  spmTest
//
//  Created by kunguma-14252 on 04/06/24.
//

import SwiftUI

@main
struct spmTestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
