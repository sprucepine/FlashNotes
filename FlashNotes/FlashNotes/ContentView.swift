//
//  ContentView.swift
//  FlashNotes
//
//  Created by Davis Volpe on 4/2/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var documents: [Document]
    @State private var sortOrder = [
        SortDescriptor(\Document.dateCreated, order: .reverse),
        SortDescriptor(\Document.title)
    ]
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ContentViewListView(path: $path)
                .toolbar {
                    Button("Create New", systemImage: "square.and.pencil") {
                        let newDocument = Document(id: UUID(), title: "Untitled Document", dateCreated: Date.now, dateModified: Date.now, content: [Card]())
                        modelContext.insert(newDocument)
                        path.append(newDocument)
                    }
                }
                .navigationTitle("FlashNotes")
        }
    }
}

#Preview {
    ContentView()
}
