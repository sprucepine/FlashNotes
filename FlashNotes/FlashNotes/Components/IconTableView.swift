//
//  IconTableView.swift
//  TimeTables
//
//  Created by Davis Volpe on 2/5/25.
//

import SwiftUI

struct IconTableView: View {
    var outlineColor: Color
    var backgroundColor: AnyShapeStyle
    var icon: String
    var iconSize: CGFloat?
    
    var body: some View {
        Image(systemName: icon)
            .resizable()
            .scaledToFit()
            .frame(width: iconSize ?? 25, height: iconSize ?? 25)
            .foregroundColor(outlineColor) // Icon color
        
            .padding(8)
            .background(backgroundColor)
            .clipShape(.rect(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(outlineColor, lineWidth: 1)
            )
    }
}

#Preview {
    IconTableView(outlineColor: Color.green, backgroundColor: AnyShapeStyle(Color.green.opacity(0.2).gradient), icon: "text.document")
}
