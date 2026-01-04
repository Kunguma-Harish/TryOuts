//
//  ContentView.swift
//  ScrollPrefKeySwiftUI
//
//  Created by Kunguma Harish on 22/08/25.
//
import SwiftUI

// PreferenceKey: child sections report their Y-offset
struct VisibleSectionPreferenceKey: PreferenceKey {
    static var defaultValue: [String: CGFloat] = [:]
    static func reduce(value: inout [String: CGFloat], nextValue: () -> [String: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

// A simple "section" view
struct SectionView: View {
    let id: String
    let color: Color
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: 300)
            .overlay(Text("Section \(id)").font(.largeTitle).foregroundColor(.white))
            .background(
                GeometryReader { geo in
                    Color.clear.preference(
                        key: VisibleSectionPreferenceKey.self,
                        value: [id: geo.frame(in: .named("scroll")).minY]
                    )
                }
            )
    }
}

struct ContentView: View {
    let sections: [(id: String, color: Color)] = [
        ("A", .red), ("B", .green), ("C", .blue), ("D", .orange)
    ]
    
    @State private var selectedId: String = "A"
    @State private var isUpdatingFromScroll = false
    
    var body: some View {
        VStack {
            // Tabs at top
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(sections, id: \.id) { section in
                        Button(action: {
                            selectedId = section.id
                        }) {
                            Text(section.id)
                                .padding()
                                .background(selectedId == section.id ? Color.gray.opacity(0.3) : Color.clear)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
            }
            
            // Vertical scrollable sections
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(sections, id: \.id) { section in
                            SectionView(id: section.id, color: section.color)
                                .id(section.id)
                        }
                    }
                }
                .coordinateSpace(name: "scroll")
                
                // When tab selection changes, scroll to it
                .onChange(of: selectedId) { _, newValue in
                    if !isUpdatingFromScroll {
                        withAnimation(.easeInOut) {
                            proxy.scrollTo(newValue, anchor: .top)
                        }
                    }
                }
                
                // Listen to visible section updates
                .onPreferenceChange(VisibleSectionPreferenceKey.self) { values in
                    guard !values.isEmpty else { return }
                    
                    let threshold: CGFloat = 0
                    if let current = values
                        .filter({ $0.value <= threshold })
                        .max(by: { $0.value < $1.value }) {
                        
                        if selectedId != current.key {
                            isUpdatingFromScroll = true
                            selectedId = current.key
                            DispatchQueue.main.async {
                                isUpdatingFromScroll = false
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
