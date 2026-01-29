//
//  FlashcardView.swift
//  FlashNotes
//
//  Created by Davis Volpe on 7/11/25.
//

import SwiftUI

struct LearnModeView: View {
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
            Form{
                    Section("Term"){
                        Text(flashcards[cardIndex].term)
                        if let img = image(from: flashcards[cardIndex].flashcardTermPhoto) {
                            img
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 500, alignment: .center)
                                .clipped()
                                .cornerRadius(12)
                        }
                    }
                    Section("Answer"){
                        //                VStack(alignment: .center){
                        //                    Image(systemName: "menucard")
                        //                    Text("Study with Flashcards")
                        //
                        //                }
                       
                        TextField("Answer", text: $textInput)
                        VStack(alignment: .leading){
                            HStack{
                                Button("Check"){
                                    print("Clicked!")
                                    if textInput.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                                        == flashcards[cardIndex].definition.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
                                            showAnswer = true
                                    
                                        isCorrect = true
                                    } else {
                                        withAnimation{
                                            showAnswer = true
                                        }
                                        isCorrect = false
                                    }
                                }
                                .disabled(textInput.isEmpty)
                                .buttonStyle(.borderedProminent)
                                
                                    if showAnswer {
                                        if isCorrect {
                                            Label("Correct!", systemImage: "checkmark")
                                        } else {
                                            Label("Incorrect!", systemImage: "xmark")
                                        
                                    }
                                }
                            }
                            if showAnswer {
                                Text("The correct answer was: \(flashcards[cardIndex].definition)")
                                if let img = image(from: flashcards[cardIndex].flashcardDefinitonPhoto) {
                                    img
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 500, alignment: .center)
                                        .clipped()
                                        .cornerRadius(12)
                                }
                            }

                        }
                    }
                    Section{
                        HStack{
                            Button("Previous"){
                                cardIndex -= 1
                            }
                            .disabled(cardIndex <= 0)
                            .buttonStyle(.borderless)
                            Spacer()
                            Text("\(cardIndex+1)/\(flashcards.count)")
                            Spacer()
                            Button("Next") {
                                cardIndex += 1
                            }
                            .disabled(cardIndex >= flashcards.count - 1)
                            .buttonStyle(.borderless)
                            
                            
                        }
                    }
                }

            .navigationTitle("Learn Mode")
#if os(iOS) || os(iPadOS)

            .navigationBarTitleDisplayMode(.inline)
            #endif
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
                    LearnModeView(flashcards: [Flashcard(term: "Hello", definition: "Truck")])
                }
        }
    }
}
