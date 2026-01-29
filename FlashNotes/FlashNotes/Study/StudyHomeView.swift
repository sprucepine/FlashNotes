//
//  FlashcardsHome.swift
//  FlashNotes
//
//  Created by Davis Volpe on 7/12/25.
//

import SwiftUI

struct StudyHomeView: View {
    @Bindable var document: Document
    @Binding var isShowing: Bool
    @Environment(\.dismiss) private var dismiss
    var flashcards: [Flashcard] {
        document.content
            .filter { $0.cardType == .flashcard }
            .compactMap { card -> Flashcard? in
                guard let term = card.flashcardTerm, let definition = card.flashcardDefintion else {
                    return nil
                }
                let termImage = card.flashcardTermPhoto
                let definitionImage = card.flashcardDefinitonPhoto
                return Flashcard(term: term, definition: definition, flashcardTermPhoto: termImage, flashcardDefinitonPhoto: definitionImage)
            }
    }
    @State private var cardIndex = 0
    @State private var textInput = ""
    @State private var showAnswer = false
    @State private var isCorrect = false
    
    var body: some View {
        if !flashcards.isEmpty{
            Form{
                Section{
                    VStack(alignment: .center){
                        HStack {
                            Spacer()
                            VStack{
                                HStack {
                                    IconTableView(outlineColor: Color.accentColor, backgroundColor: AnyShapeStyle(Color.accentColor.opacity(0.2).gradient), icon: "menucard")
                                    IconTableView(outlineColor: Color.accentColor, backgroundColor: AnyShapeStyle(Color.accentColor.opacity(0.2).gradient), icon: "pencil")
                                    
                                    IconTableView(outlineColor: Color.accentColor, backgroundColor: AnyShapeStyle(Color.accentColor.opacity(0.2).gradient), icon: "checkmark")
                                }
                                Text("Practice cards marked as Flashcard in your document.")
                                    .multilineTextAlignment(.center)
                                
                            }
                            Spacer()
                        }
                        
                        
                    }
                }
                Section("Study Modes") {
                    NavigationLink(destination: FlashcardModeView(flashcards: flashcards)){
                        Label("Flashcards Mode", systemImage: "menucard")
                    }
                    NavigationLink(destination: LearnModeView(flashcards: flashcards)) {
                        Label("Spelling Mode", systemImage: "pencil")
                    }
                    
                }
            }
            .navigationTitle("Study")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Done") {
                        dismiss()
                        isShowing = false
                    }
                    .keyboardShortcut(.cancelAction)
                }
            }
        } else {
            VStack(spacing: 16) {
                Image(systemName: "menucard")
                    .font(.system(size: 48, weight: .regular))
                    .foregroundStyle(.secondary)
                Text("No cards to study")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("Mark some items as Flashcard in your document to study them here.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .navigationTitle("Study")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Done") {
                        dismiss()
                        isShowing = false
                    }
                    .keyboardShortcut(.cancelAction)
                }
            }
        }
            


        
    }
    
    
}

#Preview {
    PreviewWrapper()
}

private struct PreviewWrapper: View {
    @State private var isShowing = true
    
    var body: some View {
        NavigationStack{
            Text("Preview Sheet Trigger")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray)
                .sheet(isPresented: $isShowing) {
                    NavigationStack {
                        StudyHomeView(
                            document: Document(id: UUID(), title: "", dateCreated: Date(), dateModified: Date(), content: []),
                            isShowing: $isShowing
                        )
                    }
                }
        }
    }
}

