import Foundation
import SwiftUI

/// Card type that affects theming
enum CardType: String, Codable, CaseIterable {
    case normal
    case fire
    case water
    case electric
    case grass
    case ice
    case fighting
    case poison
    case ground
    case flying
    case psychic
    case bug
    case rock
    case ghost
    case dragon
    case dark
    case steel
    case fairy
    
    var displayName: String {
        rawValue.capitalized
    }
}

/// Represents a collectible card
struct Card: Identifiable, Codable, Equatable {
    let id: String
    let displayId: Int
    let title: String
    let description: String
    let imageUrl: URL?
    let stats: [Stat]
    let type: CardType
    let createdAt: Date
    
    var formattedId: String {
        String(format: "#%03d", displayId)
    }
    
    init(
        id: String = UUID().uuidString,
        displayId: Int,
        title: String,
        description: String,
        imageUrl: URL?,
        stats: [Stat],
        type: CardType = .normal,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.displayId = displayId
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.stats = stats
        self.type = type
        self.createdAt = createdAt
    }
    
    // Sample card for previews
    static var sample: Card {
        Card(
            displayId: 42,
            title: "Majestic Oak",
            description: "An ancient oak tree with sprawling branches that has stood for centuries, providing shelter for woodland creatures.",
            imageUrl: URL(string: "https://placekitten.com/300/300"),
            stats: [
                Stat(category: "Age", value: .integer(250)),
                Stat(category: "Height", value: .string("18m")),
                Stat(category: "Habitat", value: .string("Forest")),
                Stat(category: "Rarity", value: .string("Uncommon"))
            ],
            type: .grass
        )
    }
}
