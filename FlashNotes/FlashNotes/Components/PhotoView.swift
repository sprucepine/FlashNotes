//
//  PhotoView.swift
//  FlashNotes
//
//  Created by Davis Volpe on 5/26/25.
//

import SwiftData
import SwiftUI
import PhotosUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

struct PhotoView: View {
    @State private var selectedItem: PhotosPickerItem?
    @Bindable var card: Card
    @Binding var isActive: Bool
    
    var processedImage: Image? {
        guard let photoData = card.photo else { return nil }
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
        VStack{
            if isActive {
                HStack{
                    Label("Photo", systemImage: "photo")
                        .labelStyle(CustomLabel(spacing: 5))
                    Spacer()
                }
            }
            PhotosPicker(selection: $selectedItem){
                
                if let processedImage = processedImage {
                    processedImage
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .clipped() // Prevents overflow
                        .cornerRadius(12)
                        .frame(maxWidth: .infinity) // Ensure it takes the full horizontal width
                } else {
                    ContentUnavailableView("No picture", systemImage: "hand.tap.fill", description: Text("Tap to import a photo"))
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .buttonStyle(PlainButtonStyle())
            .task(id: selectedItem) {
                if let data = try? await selectedItem? .loadTransferable(type: Data.self){
                    card.photo = data
                }
            }
        }
    }
}

#Preview {
    PhotoView(
        card: Card(
            id: UUID(),
            cardType: .image,
            dateCreated: Date.now,
            dateModified: Date.now,
            text: nil,
            flashcardDefintion: nil,
            flashcardTerm: nil,
            cardIndex: 0
        ),
        isActive: .constant(true)
    )
}
