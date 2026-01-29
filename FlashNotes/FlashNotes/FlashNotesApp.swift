//
//  FlashNotesApp.swift
//  FlashNotes
//
//  Created by Davis Volpe on 4/2/25.
//

import SwiftData
import SwiftUI

@main
struct FlashNotesApp: App {
    var body: some Scene {
        WindowGroup {
            NewHomepage()
                .modelContainer(for: Document.self)
        }
    }
}
