//
//  TableHomepageCard.swift
//  TimeTables
//
//  Created by Davis Volpe on 2/15/25.
//

import SwiftUI

struct TableHomepageCard: View {
    var title: String
    var dateEdited: Date
    var color: String
    
    var body: some View {
        HStack(spacing: 12){
            IconTableView(outlineColor: .blue, backgroundColor: AnyShapeStyle(Color.blue.opacity(0.2).gradient), icon: "document")

            VStack(alignment: .leading){
                Text(title)
                    .font(.headline)
                Label("Last Edited: \(dateEdited.formatted())", systemImage: "clock")
                    .labelStyle(CustomLabel(spacing: 4))
                    .font(.caption)
                    .imageScale(.small)
            }
        }
    }
}

#Preview {
    Form{
        TableHomepageCard(title: "My Card", dateEdited: Date(), color: "Yellow")
    }
}
