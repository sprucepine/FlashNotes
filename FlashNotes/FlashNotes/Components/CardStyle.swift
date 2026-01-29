//
//  CardStyle.swift
//  FlashNotes
//
//  Created by Davis Volpe on 4/6/25.
//

import SwiftUI

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(radius: 1)
                    .scrollClipDisabled(true)
            )
    }
}

extension View {
    func cardStyle() -> some View {
        self.modifier(CardStyle())
    }
}
