//
//  TextBoxStyle.swift
//  FlashNotes
//
//  Created by Davis Volpe on 11/16/25.
//


import SwiftUI

struct TextBoxStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(.quaternary, lineWidth: 0.5)
            )
    }
}

extension View {
    func textBoxStyle() -> some View {
        self.modifier(TextBoxStyle())
    }
}

