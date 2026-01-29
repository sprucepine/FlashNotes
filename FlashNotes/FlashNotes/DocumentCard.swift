//
//  DocumentCard.swift
//  FlashNotes
//
//  Created by Davis Volpe on 8/18/25.
//
import SwiftUI

struct DocumentCard: View {
    let document: Document
    @Environment(\.modelContext) private var modelContext
    @State private var isPressed = false
    @State private var isRenaming = false
    @State private var pendingTitle: String = ""
    
    var body: some View {
        ZStack {
            NavigationLink(value: document) {
                HomepageCardView(
                    text: document.title, label: document.dateModified.formatted(date: .abbreviated, time: .omitted), labelIcon: "pencil"
                )
            }
            .contextMenu {
                Button {
                    pendingTitle = document.title
                    isRenaming = true
                } label: {
                    Label("Rename", systemImage: "pencil")
                }
                Button(role: .destructive) {
                    withAnimation {
                        modelContext.delete(document)
                    }
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                Text("Date Created: \(document.dateCreated.formatted(date: .abbreviated, time: .omitted))")
            }
            .buttonStyle(.plain)
            .alert("Rename Document", isPresented: $isRenaming) {
                TextField("Title", text: $pendingTitle)
                Button("Cancel", role: .cancel) {}
                Button("Save") {
                    let trimmed = pendingTitle.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else { return }
                    document.title = trimmed
                    try? modelContext.save()
                }
            } message: {
                Text("Enter a new name for this document.")
            }
        }
    }
}
