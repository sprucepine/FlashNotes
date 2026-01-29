//
//  FlashcardModeView.swift
//  FlashNotes
//
//  Created by Davis Volpe on 7/14/25.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

struct FlashcardModeView: View {
    var flashcards: [Flashcard]
    @State private var cardIndex = 0
    @State private var textInput = ""
    @State private var showAnswer = false
    @State private var isCorrect = false
    
    private func image(from data: Data?) -> Image? {
        guard let data, let uiImage = {
            #if canImport(UIKit)
            return UIImage(data: data)
            #elseif canImport(AppKit)
            return NSImage(data: data)
            #else
            return nil
            #endif
        }() else { return nil }
        #if canImport(UIKit)
        return Image(uiImage: uiImage)
        #elseif canImport(AppKit)
        return Image(nsImage: uiImage)
        #else
        return nil
        #endif
    }

    var body: some View {
        NavigationStack{
            if flashcards.isEmpty {

            } else {
                Form{
                    Section("Term"){
                        if flashcards[cardIndex].flashcardTermPhoto != nil {                    Text(flashcards[cardIndex].term)
                        }
                        if flashcards[cardIndex].flashcardTermPhoto != nil {
                            if let img = image(from: flashcards[cardIndex].flashcardTermPhoto) {
                                img
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 500, alignment: .center)
                                    .clipped()
                                    .cornerRadius(12)
                            }
                        }
                    }
                    Section("Answer"){
                        Button("Show Answer"){
                            showAnswer = true
                        }
                        .buttonStyle(.borderedProminent)
                        if showAnswer {
                            if let img = image(from: flashcards[cardIndex].flashcardDefinitonPhoto) {
                                img
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 500, alignment: .center)
                                    .clipped()
                                    .cornerRadius(12)
                            }
                            Text(flashcards[cardIndex].definition)
                        }
                    }
                    Section{
                        HStack{
                            Button("Previous"){
                                cardIndex = max(0, cardIndex - 1)
                            }
                            .disabled(cardIndex <= 0)
                            .buttonStyle(.borderless)
                            Spacer()
                            Text("\(cardIndex+1)/\(flashcards.count)")
                            Spacer()
                            Button("Next") {
                                cardIndex = min(flashcards.count - 1, cardIndex + 1)
                            }
                            .disabled(cardIndex >= flashcards.count - 1)
                            .buttonStyle(.borderless)
                        }
                    }
                }
                .navigationTitle("Flashcard Mode")
    #if os(iOS) || os(iPadOS)

                .navigationBarTitleDisplayMode(.inline)
                #endif

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
                    FlashcardModeView(flashcards: [Flashcard(term: "Hello", definition: "Truck")])
                }
        }
    }
}

