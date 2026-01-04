//
//  ContentView.swift
//  Experiment
//
//  Created by kunguma-14252 on 23/07/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showSheet = false
    @State private var showSheet1 = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var isFloatingFruitListViewVisible: Bool = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            GestureView()
                .background(Color.blue)
            
            Text("")
                .popover(isPresented: Binding(
                    get: { horizontalSizeClass == .compact && showSheet },
                    set: { newValue in
                        print("Sheet presented: \(newValue)")
                        if horizontalSizeClass == .compact && !isFloatingFruitListViewVisible {
                            showSheet = newValue
                        }
                    }
                )) {
                    FruitListView()
                    .presentationDetents([.height(200), .medium, .large])
                    .interactiveDismissDisabled(false)
                    .presentationBackgroundInteraction(.enabled)
                    .presentationContentInteraction(.scrolls)
                    .frame(width: horizontalSizeClass == .regular ? 0 : .infinity, height: horizontalSizeClass == .regular ? 0 : .infinity)
                }
                .position(x: -1000, y: -1000)
            
            VStack {
                Spacer()
                
                Button(action: {
                    showSheet = true
                }) {
                    Text("Show Fruit List")
                        .font(.headline)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(12)
                        .shadow(radius: 4)
                }
                .padding(.bottom, 40)
            }
            // Show as floating view in regular size class
            if horizontalSizeClass == .regular && showSheet {
                FloatingFruitListView(isPresented: $showSheet)
                    .transition(.move(edge: .top))
                    .zIndex(1)
                    .onAppear() {
                        self.isFloatingFruitListViewVisible = true
                    }
                    .onDisappear() {
                        self.isFloatingFruitListViewVisible = false
                    }
            }
        }
        .onChange(of: horizontalSizeClass) { newSizeClass in
            if newSizeClass == .compact {
                print("Size class is compact")
            }
        }
//         Show as sheet in compact size class
//        .sheet(isPresented: Binding(
//            get: { horizontalSizeClass == .compact && showSheet },
//            set: { newValue in
//                print("Sheet presented: \(newValue)")
//                if horizontalSizeClass == .compact && !isFloatingFruitListViewVisible {
//                    showSheet = newValue
//                }
//            }
//        )) {
//            FruitListView()
//            .presentationDetents([.height(200), .medium, .large])
//            .interactiveDismissDisabled(false)
//            .presentationBackgroundInteraction(.enabled)
//            .presentationContentInteraction(.scrolls)
//        }
    }
}

struct FloatingFruitListView: View {
    @Binding var isPresented: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Fruits")
                    .font(.headline)
                Spacer()
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                }
            }
            .padding()
            Divider()
            FruitListView()
            .frame(width: 320, height: 400)
        }
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(radius: 8)
        .padding(.top, 40)
        .padding(.leading, 20)
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

struct GestureView: View {
    @State private var lastEvent: String = ""
    @State private var scale: CGFloat = 1.0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    Text("GestureView")
                        .font(.largeTitle)
                        .padding()
                    Text("Last event: \(lastEvent)")
                        .padding()
                    Spacer()
                }
                .scaleEffect(scale)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .gesture(
                    TapGesture()
                        .onEnded {
                            lastEvent = "Tap detected"
                            print("Tap detected")
                        }
                )
                .simultaneousGesture(
                    MagnificationGesture()
                        .onChanged { value in
                            scale = value
                            lastEvent = "Pinch (scale: \(String(format: "%.2f", value)))"
                            print("Pinch detected, scale: \(value)")
                        }
                        .onEnded { _ in
                            lastEvent = "Pinch ended"
                            print("Pinch ended")
                        }
                )
                .simultaneousGesture(
                    DragGesture(minimumDistance: 30, coordinateSpace: .local)
                        .onEnded { value in
                            let horizontal = value.translation.width
                            let vertical = value.translation.height
                            if abs(horizontal) > abs(vertical) {
                                if horizontal > 0 {
                                    lastEvent = "Swipe right"
                                    print("Swipe right")
                                } else {
                                    lastEvent = "Swipe left"
                                    print("Swipe left")
                                }
                            } else {
                                if vertical > 0 {
                                    lastEvent = "Swipe down"
                                    print("Swipe down")
                                } else {
                                    lastEvent = "Swipe up"
                                    print("Swipe up")
                                }
                            }
                        }
                )
            }
        }
    }
}

struct FruitListView: View {
    let fruits = [
        "Apple", "Banana", "Cherry", "Date", "Elderberry",
        "Fig", "Grape", "Honeydew", "Kiwi", "Lemon",
        "Mango", "Nectarine", "Orange", "Papaya", "Quince",
        "Raspberry", "Strawberry", "Tangerine", "Ugli Fruit", "Watermelon",
        "Pineapple", "Blueberry", "Cantaloupe", "Dragonfruit", "Guava",
        "Jackfruit", "Lychee", "Mulberry", "Olive", "Peach"
    ]
    
    var body: some View {
        List(fruits, id: \.self) { fruit in
            HStack {
                Circle()
                    .fill(LinearGradient(gradient: Gradient(colors: [.orange, .pink]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 30, height: 30)
                    .overlay(
                        Text(String(fruit.prefix(1)))
                            .font(.headline)
                            .foregroundColor(.white)
                    )
                Text(fruit)
                    .font(.title3)
                    .padding(.leading, 8)
            }
            .padding(.vertical, 6)
        }
        .navigationTitle("Fruits")
        .listStyle(InsetGroupedListStyle())
        .scrollContentBackground(.hidden)
        .background(
            LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.1), .green.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
    }
}


struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
