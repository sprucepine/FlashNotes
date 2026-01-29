//
//  FlashcardView.swift
//  FlashNotes
//
//  Created by Davis Volpe on 7/6/25.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct FlashcardView: View {
    @Binding var card: Card
    @Binding var number: Int?
    @FocusState.Binding var isFocused: Bool
    
    @State private var termImageSelected: PhotosPickerItem?
    @State private var definitionImageSelected: PhotosPickerItem?

    var processedTermImage: Image? {
        guard let photoData = card.flashcardTermPhoto else { return nil }
        #if canImport(UIKit)
        if let uiImage = UIImage(data: photoData) {
            return Image(uiImage: uiImage)
        }
        #elseif canImport(AppKit)
        if let nsImage = NSImage(data: photoData) {
            return Image(nsImage: nsImage)
        }
        #endif
        return nil
    }
    
    var processedDefinitionImage: Image? {
        guard let photoData = card.flashcardDefinitonPhoto else { return nil }
        #if canImport(UIKit)
        if let uiImage = UIImage(data: photoData) {
            return Image(uiImage: uiImage)
        }
        #elseif canImport(AppKit)
        if let nsImage = NSImage(data: photoData) {
            return Image(nsImage: nsImage)
        }
        #endif
        return nil
    }
    
    var body: some View {
        VStack(alignment: .leading){
//        Label("Flashcard", systemImage: "menucard")
//            .labelStyle(CustomLabel(spacing: 5))
            HStack{
                Label("Flashcard", systemImage: "menucard")
                    .labelStyle(CustomLabel(spacing: 5))
                Spacer()
                Text(String(number ?? 1))
                    .fontWeight(.medium)
                    .padding(5)
                    .padding(.horizontal, 5)
                   
            }

            TextField("Term", text: Binding<String>(
                get: { card.flashcardTerm ?? "" },
                set: { card.flashcardTerm = $0.isEmpty ? nil : $0 }
            ), axis: .vertical)
                .textBoxStyle()
            if let processedImage = processedTermImage {
                processedImage
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: 240)
                    .cornerRadius(12)
                    .frame(maxWidth: .infinity)
                    .allowsHitTesting(false)
                    .transition(.asymmetric(insertion: .scale.combined(with: .opacity), removal: .opacity))
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: processedTermImage != nil)
            }
            
            HStack{
                PhotosPicker(selection: $termImageSelected, matching: .images) {
                    Label((processedTermImage != nil) ? "photo.badge.plus" : "photo.badge.checkmark", systemImage: (processedTermImage == nil) ? "photo.badge.plus" : "photo.badge.checkmark")
                }
                .labelStyle(.iconOnly)
                    .buttonStyle(.plain)

                if (processedTermImage != nil) {
                    Divider()
                        .frame(height: 20)
                        .foregroundStyle(.ultraThinMaterial)

                    Button("Remove Image", systemImage: "trash", role: .destructive) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            card.flashcardTermPhoto = nil
                        }
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(.plain)
                }

            }
            .textBoxStyle()

            .onChange(of: termImageSelected) { newItem in
                guard let newItem else { return }
                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            card.flashcardTermPhoto = data
                        }
                    }
                }
            }
            Text("Term")
                .font(.caption)
                .padding(.bottom, 5)

            TextField("Definition", text: Binding<String>(
                get: { card.flashcardDefintion ?? "" },
                set: { card.flashcardDefintion = $0.isEmpty ? nil : $0 }
            ), axis: .vertical)
                .textBoxStyle()
            
            if let processedImage = processedDefinitionImage {
                processedImage
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: 240)
                    .cornerRadius(12)
                    .frame(maxWidth: .infinity)
                    .allowsHitTesting(false)
                    .transition(.asymmetric(insertion: .scale.combined(with: .opacity), removal: .opacity))
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: processedDefinitionImage != nil)
                    .contextMenu {
                        Button("Change Image") {
                            // Implement image change action if needed
                        }
                    }
            }
            
            HStack{
                HStack{
                    PhotosPicker(selection: $definitionImageSelected, matching: .images) {
                        Label((processedDefinitionImage != nil) ? "photo.badge.plus" : "photo.badge.checkmark", systemImage: (processedDefinitionImage == nil) ? "photo.badge.plus" : "photo.badge.checkmark")
                    }
                    .labelStyle(.iconOnly)
                        .buttonStyle(.plain)
                    
                    if (processedDefinitionImage != nil) {
                        Divider()
                            .frame(height: 20)
                            .foregroundStyle(.ultraThinMaterial)

                        Button("Remove Image", systemImage: "trash", role: .destructive) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                card.flashcardDefinitonPhoto = nil
                            }
                        }
                        .labelStyle(.iconOnly)
                        .buttonStyle(.plain)
                    }


                    


                }
                .textBoxStyle()


            }
            .onChange(of: definitionImageSelected) { newItem in
                guard let newItem else { return }
                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            card.flashcardDefinitonPhoto = data
                        }
                    }
                }
            }
            
            Text("Definition")
                .font(.caption)
                .padding(.bottom, 5)
        }
    }
}

#Preview {
    @Previewable @State var term = "t"
    @Previewable @State var definition = "t"
    @Previewable @State var number: Int? = nil
    @FocusState var sampleFocus: Bool

    Form{
        FlashcardView(card: .constant(Card(id: UUID(), cardType: .flashcard, dateCreated: Date.now, dateModified: Date.now, cardIndex: 1)), number: $number, isFocused: $sampleFocus)
    }
}

