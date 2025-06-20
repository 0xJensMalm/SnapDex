import Foundation

/// Protocol for card data persistence operations
protocol CardRepository {
    /// Loads all cards from storage
    func loadCards() -> [Card]
    
    /// Saves cards to storage
    func saveCards(_ cards: [Card])
    
    /// Retrieves a single card by ID
    func getCard(id: String) -> Card?
    
    /// Adds or updates a single card
    func saveCard(_ card: Card)
    
    /// Deletes a card by ID
    func deleteCard(id: String)
    
    /// Gets the next available card display ID
    func getNextCardId() -> Int
}
