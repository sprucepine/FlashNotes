//
//  CustomLabel.swift
//  FlashNotes
//
//  Created by Davis Volpe on 4/6/25.
//

import SwiftUI

struct CustomLabel: LabelStyle {
    var spacing: Double = 0.0
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: spacing) {
            configuration.icon
            configuration.title
        }
    }
}
