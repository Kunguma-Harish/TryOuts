//
//  swiftUITryOutApp.swift
//  swiftUITryOut
//
//  Created by kunguma-14252 on 06/04/23.
//

import SwiftUI

@main
struct swiftUITryOutApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 1150, maxWidth: 1150, minHeight: 550, maxHeight: 550)
        }
        .windowToolbarStyle(.unified(showsTitle: false))
        .windowResizabilityContentSize()
    }
}

extension Scene {
    func windowResizabilityContentSize() -> some Scene {
        if #available(macOS 13.0, *) {
            return windowResizability(.contentSize)
        } else {
            return self
        }
    }
}
