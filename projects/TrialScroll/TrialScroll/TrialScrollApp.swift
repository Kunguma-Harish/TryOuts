//
//  TrialScrollApp.swift
//  TrialScroll
//
//  Created by kunguma.hp-14252 on 07/08/25.
//

import SwiftUI

struct Dummy: Hashable, Codable, Identifiable {
    let id: String
}

@main
struct TrialScrollApp: App {
    var body: some Scene {
//        WindowGroup {
//            NavStackWithPath()
//            NavStackWithLink()
//            NavViewWithLink()
//            NewView()
//        }
//        .windowStyle(.titleBar)
//        .windowToolbarStyle(.unified)
//        .defaultSize(width: 1200, height: 800)
        
        WindowGroup("Editor", id: "editor", for: Dummy.self) { data in
            NewView()
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified)
        .defaultSize(width: 1200, height: 800)
    }
}

struct NewView: View {
    var body: some View {
        VStack {
            NewView2()
                .overlay {
                    NavStackWithLink()
                        .frame(width: 100)
                }
            
        }
    }
}

struct NewView2: View {
    var body: some View {
        VStack {
            Rectangle().fill(.yellow)
        }
    }
}

struct NavViewWithLink: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: DocumentGridView(model: SampleViewModel())) {
                    Text("Click Here to enter")
                }
                
                NavigationLink(destination: Rectangle().fill(.yellow)) {
                    Text("Click Here 2")
                }
                
                NavigationLink(destination: Rectangle().fill(.red)) {
                    Text("Click Here 3")
                }
            }
        }
    }
}

struct NavStackWithPath: View {
    let dummyData = Dummy(id: "aa")
    @State private var navPath: NavigationPath = .init()

    var body: some View {
        NavigationStack(path: $navPath) {
            Button(action: {
                self.navPath.append(self.dummyData)
            }) {
                Text("Click Here")
            }
        }.navigationDestination(for: Dummy.self) { _ in
            DocumentGridView(model: SampleViewModel())
                .id(self.dummyData)
        }
    }
}

struct NavStackWithLink: View {
    var body: some View {
        NavigationStack {
            NavigationLink(destination: Rectangle().fill(.red)) {
//            NavigationLink(destination: DocumentGridView(model: SampleViewModel())) {
                Text("Click Here to enter")
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}
