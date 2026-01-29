//
//  ContentViewListView.swift
//  FlashNotes
//
//  Created by Davis Volpe on 4/2/25.
//

import SwiftData
import SwiftUI

struct ContentViewListView: View {
    @Environment(\.modelContext) var modelContext
    @Query var documents: [Document]
    @Binding var path: NavigationPath
    @State private var isClosed = false
    
    var body: some View {
        Form{
//            VStack(alignment: .leading){
//                HStack{
//                    Label("Welcome to FlashNotes", systemImage:
//                            "hand.wave")
//                    .fontWeight(.medium)
//                    .labelStyle(.titleAndIcon)
//                    Spacer()
//                    Button("Close", systemImage: "xmark"){
//                        
//                    }
//                    .labelStyle(.iconOnly)
//                    .buttonStyle(.bordered)
//                    .foregroundStyle(.primary)
//                    .buttonBorderShape(.circle)
//                }
//                Divider()
//                HStack{
//                    VStack{
//                        Text("Welcome to FlashNotes")
//                            .multilineTextAlignment(.leading)
//                    }
//                }
//
//                
//            }
            if isClosed == false {
                FormGroupBox(icon: "hand.wave", title: "Welcome to FlashNotes", description: "Welcome to FlashNotes", isClosed: $isClosed)
            }
            Section("All Files"){
                if documents.isEmpty {
                    ContentUnavailableView("No Files", systemImage: "filemenu.and.cursorarrow", description: Text("You haven't created any files. To create your first file click on the upper right hand corner."))
                }
                ForEach(documents, id: \.id) {document in
                    NavigationLink(value: document){
                        TableHomepageCard(title: document.title, dateEdited: document.dateModified, color: "")
                    }
                }
            }

        }
        .navigationDestination(for: Document.self) { document in
            DocumentView(path: $path, document: document)
        }
    }
}

#Preview {
    ContentViewListView(path: .constant(NavigationPath()))
}
