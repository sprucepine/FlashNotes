//
//  IconBackground.swift
//  FlashNotes
//
//  Created by Davis Volpe on 4/8/25.
//

import SwiftUI
struct IconBackground: ViewModifier {
    var color: Color
    var foreColor: Color
    
    func body(content: Content) -> some View {
        content
            .padding(1.5)
            .rotationEffect(/*@START_MENU_TOKEN@*/.zero/*@END_MENU_TOKEN@*/)
            .foregroundColor(foreColor)
            .background(
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: min(geometry.size.width, geometry.size.height) * 0.2)
                        .fill(color)
                }
            )
    }
}

extension View {
    func iconColor(color: Color, foreColor: Color) -> some View {
        self.modifier(IconBackground(color: color, foreColor: .white))
    }
}
