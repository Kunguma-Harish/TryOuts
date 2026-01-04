
import SwiftUI

// MARK: - Data Model

struct Document: Identifiable {
    let id: Int
    let title: String
    let category: String
}

// MARK: - Protocol

protocol ListingModelProtocol {
    var documents: [Document] { get }
}

// MARK: - Sample ViewModel

class SampleViewModel: ObservableObject, ListingModelProtocol {
    @Published var documents: [Document] = {
        let categories = ["Category A", "Category B", "Category C", "Category D"]
        var docs: [Document] = []
        var id = 1
        for category in categories {
            for i in 1...10 {
                docs.append(Document(id: id, title: "\(category) - Document \(i)", category: category))
                id += 1
            }
        }
        return docs
    }()
}

// MARK: - Preference

struct VisibleDocInfo: Equatable, Identifiable {
    let id: Int
    let minY: CGFloat
    var identifier: String { "\(id)" }
    var identity: String { return "\(id)" }
    var _id: String { identity }
}

struct TopVisibleDocKey: PreferenceKey {
    static var defaultValue: [VisibleDocInfo] = []

    static func reduce(value: inout [VisibleDocInfo], nextValue: () -> [VisibleDocInfo]) {
        value.append(contentsOf: nextValue())
    }
}

// MARK: - View

struct DocumentGridView<T: ListingModelProtocol & ObservableObject>: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var model: T
    @State private var currentCategory: String?
    
    let markerOffset: CGFloat = 0 // Top offset in global space where marker is

    var body: some View {
        ZStack(alignment: .top) {
            // 🔴 Marker line
            Color.red
                .frame(height: 2)
                .padding(.top, markerOffset)
                .zIndex(1)

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(model.documents) { doc in
                        documentView(for: doc)
                    }
                }
            }
            .coordinateSpace(name: "scroll")
        }
        .onPreferenceChange(TopVisibleDocKey.self) { values in
            updateCurrentCategory(with: values)
        }
    }

    // MARK: - Document Cell

    private func documentView(for doc: Document) -> some View {
        HStack {
            Text(doc.title)
                .padding()
                .foregroundStyle(.black)
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 1)
                .border(.red, width: 2)
                .background(
                    GeometryReader { proxy in
                        let minY = proxy.frame(in: .global).minY // global space!
                        Color.clear.preference(
                            key: TopVisibleDocKey.self,
                            value: [VisibleDocInfo(id: doc.id, minY: minY)]
                        )
                    }
                )
                .padding(.horizontal)
            Button("Close") {
                dismiss()
            }
        }
    }

    // MARK: - Category Update Logic

    private func updateCurrentCategory(with values: [VisibleDocInfo]) {
        // Find item closest to marker (at global Y = markerOffset)
        let closest = values.min(by: {
            abs($0.minY - markerOffset) < abs($1.minY - markerOffset)
        })

        guard let topID = closest?.id,
              let doc = model.documents.first(where: { $0.id == topID }) else {
            return
        }

//        if doc.category != currentCategory {
            currentCategory = doc.category
            print("🟢 Now viewing category: \(doc.category) \(doc.id)")
//        }
    }
}
