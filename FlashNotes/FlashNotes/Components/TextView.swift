//
//  TextView.swift
//  FlashNotes
//
//  Created by Davis Volpe on 4/13/25.
//

import SwiftUI

struct TextView: View {
    @Binding var text: AttributedString
    @Binding var isActive: Bool
    
    var isFocused: FocusState<Bool>.Binding
    @State private var calculatedHeight: CGFloat = 44

    // Bridge AttributedString <-> String for platforms where TextEditor/TextField require String
    private var plainTextBinding: Binding<String> {
        Binding<String>(
            get: { String(text.characters) },
            set: { text = AttributedString($0) }
        )
    }

    var body: some View {
        VStack {
            if isActive {
                HStack {
                    Label("Text", systemImage: "textformat")
                        .labelStyle(CustomLabel(spacing: 5))
                    Spacer()
                }
            }

            if #available(iOS 26.0, macOS 26.0, tvOS 20.0, watchOS 11.0, *) {

                // iOS 26+ supports AttributedString in TextEditor
                ZStack(alignment: .topLeading) {
                    // Mirror content for sizing
                    Text(text)
                        .font(.body)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 8)
                        .background(
                            GeometryReader { proxy in
                                Color.clear
                                    .onChange(of: proxy.size.height) { newValue in
                                        calculatedHeight = max(newValue, 44)
                                    }
                            }
                        )
                        .hidden()

                    TextEditor(text: $text)
                        .focused(isFocused)
                        .font(.body)
                        .frame(height: calculatedHeight)
                        .scrollDisabled(true)
                }
            } else {
                // Prior to iOS 26, use a String binding and mirror text sizing
                ZStack(alignment: .topLeading) {
                    Text(String(text.characters))
                        .font(.body)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 8)
                        .background(
                            GeometryReader { proxy in
                                Color.clear
                                    .onChange(of: proxy.size.height) { newValue in
                                        calculatedHeight = max(newValue, 44)
                                    }
                            }
                        )
                        .hidden()

                    TextEditor(text: plainTextBinding)
                        .focused(isFocused)
                        .font(.body)
                        .frame(height: calculatedHeight)
                        .scrollDisabled(true)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var sampleText: AttributedString = "t"
    @FocusState var sampleFocus: Bool

    TextView(text: $sampleText, isActive: .constant(false), isFocused: $sampleFocus)
}
