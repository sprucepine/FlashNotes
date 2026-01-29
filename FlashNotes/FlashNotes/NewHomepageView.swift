//
//  ContentViewListView.swift
//  FlashNotes
//
//  Created by Davis Volpe on 4/2/25.
//

import SwiftData
import SwiftUI
#if os(iOS) || os(iPadOS)
import UIKit
#endif

struct NewHomepageView: View {
    @Environment(\.modelContext) var modelContext
    @Query var documents: [Document]
    @Binding var path: NavigationPath
    @State private var isClosed = false
    @State private var searchText = ""
    let columns = [
        GridItem(.adaptive(minimum: 220), spacing: 12)
    ]
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color.blueGradient], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {
                    if isClosed == false {
                        FormGroupBox(icon: "hand.wave", title: "Welcome to FlashNotes", description: "Welcome to FlashNotes", isClosed: $isClosed)
                            .padding()
                            .cardStyle()
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    HStack{
                        Text("Recent")
                            .font(.title2)
                        Spacer()
                    }
                    .padding(.top)
                    if documents.isEmpty {
                        ContentUnavailableView("No Files", systemImage: "filemenu.and.cursorarrow", description: Text("You haven't created any files. To create your first file click on the upper right hand corner."))
                    }
                    

                    LazyVGrid(columns: columns, spacing: 12) {
                        
                        ForEach(documents
                            .filter { searchText.isEmpty || $0.title.localizedCaseInsensitiveContains(searchText) }
                                .sorted { $0.dateModified > $1.dateModified }, id: \.id) { document in
                                DocumentCard(document: document)

                        }
                    }
                    .padding(.top)
                    .animation(.easeInOut, value: documents)
                }
                .padding(.top)
                .searchable(text: $searchText)
                
                
                .navigationDestination(for: Document.self) { document in
                    DocumentView(path: $path, document: document)
                }
            }
            .padding(.horizontal)
        }
    }
}

#if os(iOS) || os(iPadOS)
private extension UIScrollView {
    open override var clipsToBounds: Bool {
        get { false }
        set {}
    }
}
#endif

#Preview {
    NewHomepageView(path: .constant(NavigationPath()))
}

