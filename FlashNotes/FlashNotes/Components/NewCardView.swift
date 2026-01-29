//
//  NewCardView.swift
//  FlashNotes
//
//  Created by Davis Volpe on 4/6/25.
//

import SwiftUI

struct NewCardView: View {
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        NavigationStack{
            LazyVGrid(columns: columns){
                VStack{
                    Image(systemName: "photo")
                        .padding(4)
                    Text("Photo Object")
                }
                    .padding()
                    .cardStyle()
                    Text("Hello")
            }
            .navigationTitle(Text("Select New Card Type"))
#if os(iOS) || os(iPadOS)

            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
    }
}

#Preview {
    NewCardView()
}
