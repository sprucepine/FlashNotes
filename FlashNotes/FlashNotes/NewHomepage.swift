//
//  ContentView.swift
//  FlashNotes
//
//  Created by Davis Volpe on 4/2/25.
//

import SwiftData
import SwiftUI

struct NewHomepage: View {
    @Environment(\.modelContext) var modelContext
    @Query var documents: [Document]
    @State private var sortOrder = [
        SortDescriptor(\Document.dateCreated, order: .reverse),
        SortDescriptor(\Document.title)
    ]
    @State private var path = NavigationPath()

    
    var body: some View {
        NavigationStack{
                NewHomepageView(path: $path)
            .toolbar{
                Button("Create New", systemImage: "square.and.pencil"){
                    let newDocument = Document(id: UUID(), title: "Untitled Document", dateCreated: Date.now, dateModified: Date.now, content: [Card]())

                    modelContext.insert(newDocument)
                    path.append(newDocument)
                }
            }
            .navigationDestination(for: Document.self) { document in
                Text("Editing: \(document.title)")
            }
            .navigationTitle("FlashNotes")
        }
    }
}

#Preview {
    NewHomepage()
}
