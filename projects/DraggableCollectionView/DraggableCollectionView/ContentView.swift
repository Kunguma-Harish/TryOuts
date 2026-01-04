//
//  ContentView.swift
//  DraggableCollectionView
//
//  Created by Kunguma Harish P on 25/09/25.
//

import SwiftUI

struct MyDataItem: Identifiable, Codable, Transferable {
    var id = UUID()
    var name: String

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .text) // Or a custom UTType
    }
}

struct ContentView: View {
    @State private var items: [MyDataItem] = [
        MyDataItem(name: "Item A"),
        MyDataItem(name: "Item B"),
        MyDataItem(name: "Item C")
    ]

    var body: some View {
        List {
            ForEach(items) { item in
                Text(item.name)
                    .draggable(item) // Make each item draggable
            }
        }
        ContentView1()
    }
}

struct ContentView1: View {
    @State private var items: [MyDataItem] = [
        MyDataItem(name: "Item A"),
        MyDataItem(name: "Item B")
    ]

    var body: some View {
        List {
            ForEach(items) { item in
                Text(item.name)
                    .draggable(item)
            }
            .onInsert(of: [.text], perform: { index, _items in // For inserting into a List
                // Handle insertion logic here
                items.insert(contentsOf: _items, at: index)
            })
            .onMove(perform: { source, destination in // For reordering within a List
                items.move(fromOffsets: source, toOffset: destination)
            })
        }
        .dropDestination(for: MyDataItem.self) { droppedItems, location in
            // Handle dropped items (e.g., add to the end of the list)
            items.append(contentsOf: droppedItems)
            return true // Indicate successful drop
        } isTargeted: { isTargeted in
            // Change UI appearance based on isTargeted
        }
    }
}

#Preview {
    ContentView()
}
