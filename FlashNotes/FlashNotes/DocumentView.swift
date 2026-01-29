//
//  DocumentView.swift
//  FlashNotes
//
//  Created by Davis Volpe on 4/2/25.
//

import SwiftUI
import SwiftData

struct DocumentView: View {
    @Binding var path: NavigationPath
    @Environment(\.modelContext) var modelContext
    @Bindable var document: Document
    @State private var showingRenameSheet = false
    @State private var showingFlashcards = false
    @State private var editActive = false
    @FocusState private var isFocused: Bool
    
    var sortedContent: [Binding<Card>] {
        $document.content.sorted { $0.wrappedValue.cardIndex < $1.wrappedValue.cardIndex }
    }
 
    var body: some View {
        contentList
            .animation(.spring(response: 0.35, dampingFraction: 0.85), value: document.content.map { $0.cardIndex })
            .animation(.spring(response: 0.35, dampingFraction: 0.85), value: document.content.count)
            .scrollContentBackground(.hidden)
            .background(Color.blueGradient)
            .alert("Rename Table", isPresented: $showingRenameSheet){
                TextField("Rename Table", text: $document.title)
            }
            .onChange(of: document.content) { oldValue, newValue in
                for (index, card) in newValue.enumerated() {
                    card.cardIndex = index
                }
                try? modelContext.save()
            }
            .sheet(isPresented: $showingFlashcards){
                NavigationStack {
                    StudyHomeView(document: document, isShowing: $showingFlashcards)
                }
            }
            .toolbar { documentToolbar() }
#if !os(macOS)
            .environment(\.editMode, .constant(editActive ? EditMode.active : EditMode.inactive))
#endif
            .navigationTitle(document.title)
    }
    
    @ViewBuilder
    private var contentList: some View {
        List {
            // Render in stable order using cardIndex
            ForEach(sortedContent, id: \.id) { $card in
                CardRow(
                    card: $card, editActive: $editActive,
                    isFocused: $isFocused,
                    number: Binding<Int?>(
                        get: {
                            let flashcards = document.content
                                .filter { $0.cardType == .flashcard }
                                .sorted { $0.cardIndex < $1.cardIndex }
                            guard let idx = flashcards.firstIndex(where: { $0.id == card.id }) else { return nil }
                            return idx + 1
                        },
                        set: { _ in }
                    ),
                    moveUp: { moveCardUp(cardID: card.id) },
                    moveDown: { moveCardDown(cardID: card.id) },
                    canMoveUp: card.cardIndex > 0,
                    canMoveDown: card.cardIndex < max(0, document.content.count - 1)
                )
            }
            .onDelete(perform: removeItems)
            .onMove(perform: moveItems)
        }
    }
    
    @ToolbarContentBuilder
    private func documentToolbar() -> some ToolbarContent {
        if !showingFlashcards {
            ToolbarItemGroup {
                Button(editActive ? "Done" : "Edit", systemImage: (editActive ? "checkmark" : "pencil")) {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                        editActive.toggle()
                    }
                }

                Menu("Create New", systemImage: "plus") {
                    Button("Text Item", systemImage: "textformat"){
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            let newIndex = document.content.count
                            let item = Card(id: UUID(), cardType: .text, dateCreated: Date.now, dateModified: Date.now, text: "", flashcardDefintion: nil, flashcardTerm: nil, cardIndex: newIndex)
                            document.content.append(item)
                        }
                        try? modelContext.save()
                    }
                    Button("Photo Item", systemImage: "photo"){
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            let newIndex = document.content.count
                            let item = Card(id: UUID(), cardType: .image, dateCreated: Date.now, dateModified: Date.now, text: nil, flashcardDefintion: nil, flashcardTerm: nil, cardIndex: newIndex)
                            document.content.append(item)
                        }
                        try? modelContext.save()
                    }
                    Button("Flashcard", systemImage: "menucard"){
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            let newIndex = document.content.count
                            let item = Card(id: UUID(), cardType: .flashcard, dateCreated: Date.now, dateModified: Date.now, text: nil, flashcardDefintion: "", flashcardTerm: "", cardIndex: newIndex)
                            document.content.append(item)
                        }
                        try? modelContext.save()
                    }
                }
                Button("Practice with Flashcards", systemImage: "paperplane.fill"){
                    showingFlashcards = true
                }
                Menu("More Options", systemImage: "ellipsis.circle"){
                    Button("Rename Document", systemImage: "pencil"){
                        showingRenameSheet = true
                    }

                }
            }
//            ToolbarItemGroup(placement: .bottomBar) {
//                Button("Practice Flashcards"){
//                    showingFlashcards = true
//                }
//            }
        }
        ToolbarItemGroup(placement: .keyboard) {
            if isFocused {
                Button("Done"){
                    isFocused = false
                    print("Button pressed")
                }
                Spacer()
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            for index in offsets {
                document.content.remove(at: index)
            }
            // Reindex remaining items to keep indices contiguous
            for (index, card) in document.content.enumerated() {
                card.cardIndex = index
            }
        }
        try? modelContext.save()
    }
    
    func moveItems(from source: IndexSet, to destination: Int) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            document.content.move(fromOffsets: source, toOffset: destination)
            // After moving in the backing array, normalize cardIndex to match visual order
            for (index, card) in document.content.enumerated() {
                card.cardIndex = index
            }
        }
        try? modelContext.save()
    }

    // MARK: - Manual reordering helpers using cardIndex
    private func moveCardUp(cardID: UUID) {
        guard let currentIndex = document.content.firstIndex(where: { $0.id == cardID }) else { return }
        let currentCard = document.content[currentIndex]
        let currentOrder = currentCard.cardIndex
        guard currentOrder > 0 else { return }

        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            // Find the card that currently occupies the previous order slot
            if let swapIndex = document.content.firstIndex(where: { $0.cardIndex == currentOrder - 1 }) {
                document.content[swapIndex].cardIndex += 1
                document.content[currentIndex].cardIndex -= 1
            }

            // Normalize indices to be contiguous starting at 0
            reindexCards()
        }
        try? modelContext.save()
    }

    private func moveCardDown(cardID: UUID) {
        guard let currentIndex = document.content.firstIndex(where: { $0.id == cardID }) else { return }
        let currentCard = document.content[currentIndex]
        let currentOrder = currentCard.cardIndex
        guard currentOrder < document.content.count - 1 else { return }

        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            // Find the card that currently occupies the next order slot
            if let swapIndex = document.content.firstIndex(where: { $0.cardIndex == currentOrder + 1 }) {
                document.content[swapIndex].cardIndex -= 1
                document.content[currentIndex].cardIndex += 1
            }

            // Normalize indices to be contiguous starting at 0
            reindexCards()
        }
        try? modelContext.save()
    }

    private func reindexCards() {
        // Ensure stable contiguous order by cardIndex
        let sorted = document.content.sorted { $0.cardIndex < $1.cardIndex }
        for (index, card) in sorted.enumerated() {
            card.cardIndex = index
        }
    }
}

private struct CardRow: View {
    @Binding var card: Card
    @Binding var editActive: Bool
    var isFocused: FocusState<Bool>.Binding
    var number: Binding<Int?>
    let moveUp: () -> Void
    let moveDown: () -> Void
    let canMoveUp: Bool
    let canMoveDown: Bool

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            CardContentView(card: $card, editActive: $editActive, number: number, isFocused: isFocused)
            
            Spacer()
            if ($editActive).wrappedValue {
                HStack(spacing: 4) {
                    Button(action: moveUp) {
                        Image(systemName: "arrow.up")
                    }
                    .buttonStyle(.borderless)
                    .disabled(!canMoveUp)
                    
                    Button(action: moveDown) {
                        Image(systemName: "arrow.down")
                    }
                    .buttonStyle(.borderless)
                    .disabled(!canMoveDown)
                }
            }
        }
    }
}

private struct CardContentView: View {
    @Binding var card: Card
    @Binding var editActive: Bool
    var number: Binding<Int?>
    var isFocused: FocusState<Bool>.Binding

    var body: some View {
        Group {
            switch card.cardType {
            case .text:
                TextView(text: Binding(
                    get: { card.text ?? "" },
                    set: { card.text = $0 }
                ), isActive: $editActive, isFocused: isFocused)
            case .image:
                PhotoView(card: card, isActive: $editActive)
            case .flashcard:
                FlashcardView(card: $card, number: number, isFocused: isFocused)
            default:
                EmptyView()
            }
        }
    }
}

#Preview {
    DocumentView(path: .constant(NavigationPath()), document: Document(id: UUID(), title: "Untitled Table", dateCreated: Date.now, dateModified: Date.now, content: [Card]()))
}
