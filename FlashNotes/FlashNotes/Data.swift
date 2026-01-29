//
//  Data.swift
//  FlashNotes
//
//  Created by Davis Volpe on 4/2/25.
//

import SwiftUI
import SwiftData

@Model
class Document {
    var id: UUID
    
    var title: String
    var dateCreated: Date
    var dateModified: Date
    
    var isPinned: Bool = false
    
    var content: [Card]
    
    
    init(id: UUID, title: String, dateCreated: Date, dateModified: Date, content: [Card]) {
        self.id = id
        self.title = title
        self.dateCreated = dateCreated
        self.dateModified = dateModified
        self.content = content
    }
}

@Model
class Card: Identifiable, Equatable  {
    var id: UUID
    var cardType: CardType
    var dateCreated: Date
    var dateModified: Date
    @Attribute(.externalStorage) var text: AttributedString?
    @Attribute(.externalStorage) var photo: Data?
    var flashcardDefintion: String?
    @Attribute(.externalStorage) var flashcardDefinitonPhoto: Data?
    var flashcardTerm: String?
    @Attribute(.externalStorage) var flashcardTermPhoto: Data?
    var cardIndex: Int
    
    static func == (lhs: Card, rhs: Card) -> Bool {
            lhs.id == rhs.id
        }

    init(id: UUID, cardType: CardType, dateCreated: Date, dateModified: Date, text: AttributedString? = nil, photo: Data? = nil, flashcardDefintion: String? = nil, flashcardDefinitonPhoto: Data? = nil, flashcardTerm: String? = nil, flashcardTermPhoto: Data? = nil, cardIndex: Int) {
        self.id = id
        self.cardType = cardType
        self.dateCreated = dateCreated
        self.dateModified = dateModified
        self.text = text
        self.photo = photo
        self.flashcardDefintion = flashcardDefintion
        self.flashcardDefinitonPhoto = flashcardDefinitonPhoto
        self.flashcardTerm = flashcardTerm
        self.flashcardTermPhoto = flashcardTermPhoto
        self.cardIndex = cardIndex
    }
}

enum CardType: String, Codable {
    case text
    case image
    case flashcard
}

struct Flashcard: Hashable {
    var term: String
    var definition: String
    var flashcardTermPhoto: Data?
    var flashcardDefinitonPhoto: Data?
}
