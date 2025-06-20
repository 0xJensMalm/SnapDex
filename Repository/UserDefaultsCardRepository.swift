import Foundation
import SwiftUI

/// Repository implementation that stores cards in UserDefaults
class UserDefaultsCardRepository: CardRepository {
    private let userDefaultsKey = "snapDexCards"
    private let cardIdCounterKey = "totalSnapDexCardsMade"
    
    func loadCards() -> [Card] {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Card].self, from: data)
        } catch {
            print("Error loading cards from UserDefaults: \(error)")
            return []
        }
    }
    
    func saveCards(_ cards: [Card]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(cards)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            print("Error saving cards to UserDefaults: \(error)")
        }
    }
    
    func getCard(id: String) -> Card? {
        return loadCards().first { $0.id == id }
    }
    
    func saveCard(_ card: Card) {
        var cards = loadCards()
        if let index = cards.firstIndex(where: { $0.id == card.id }) {
            cards[index] = card
        } else {
            cards.append(card)
        }
        saveCards(cards)
    }
    
    func deleteCard(id: String) {
        var cards = loadCards()
        cards.removeAll { $0.id == id }
        saveCards(cards)
    }
    
    func getNextCardId() -> Int {
        // Using @AppStorage directly would require a SwiftUI View context,
        // so we access UserDefaults directly here
        let currentId = UserDefaults.standard.integer(forKey: cardIdCounterKey)
        let nextId = currentId + 1
        UserDefaults.standard.set(nextId, forKey: cardIdCounterKey)
        return nextId
    }
}
