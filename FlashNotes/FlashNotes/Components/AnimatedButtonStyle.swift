//
//  AnimatedButtonStyle.swift
//  FlashNotes
//
//  Created by Davis Volpe on 7/17/25.
//

import SwiftUI

struct AnimatedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            .contentShape(Rectangle()) // ensure full tappable area
    }
}
