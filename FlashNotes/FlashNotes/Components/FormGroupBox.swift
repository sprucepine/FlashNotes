//
//  FormGroupBox.swift
//  FlashNotes
//
//  Created by Davis Volpe on 4/6/25.
//

import SwiftUI

struct FormGroupBox: View {
    var icon: String?
    var title: String
    var description: String
    @Binding var isClosed: Bool
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                if icon != nil {
                    Label(title, systemImage:
                            icon!)
                    .fontWeight(.medium)
                    .labelStyle(.titleAndIcon)
                } else {
                    Text(title)
                    .fontWeight(.medium)
                    .labelStyle(.titleAndIcon)
                }
                
                Spacer()
                Button("Close", systemImage: "xmark"){
                    isClosed = true
                    print("isClosed pressed")
                }
                .labelStyle(.iconOnly)
                .buttonStyle(.bordered)
                .foregroundStyle(.primary)
                .buttonBorderShape(.circle)
            }
            Divider()
            HStack{
                VStack{
                    Text("Welcome to FlashNotes")
                        .multilineTextAlignment(.leading)
                }
            }

            
        }

    }
}

#Preview {
    Form{
        FormGroupBox(title: "Welcome to FlashNotes", description: "Welcome to FlashNotes!", isClosed: .constant(false))
    }
}
