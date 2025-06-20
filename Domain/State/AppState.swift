import SwiftUI
import Combine

/// Central app state that serves as the single source of truth
class AppState: ObservableObject {
    // Card collection
    @Published var cards: [Card] = []
    @Published var selectedCard: Card? = nil
    
    // UI state
    @Published var isCameraPresented: Bool = false
    @Published var isGeneratingCard: Bool = false
    @Published var isShowingNewCard: Bool = false
    
    // Error handling
    @Published var error: Error? = nil
    
    // Keep track of next card ID
    @AppStorage("totalSnapDexCardsMade") private var totalCards: Int = 0
    
    // Card repository for persistence
    private let cardRepository: CardRepository
    
    // Services
    private let aiService: AIService
    
    init(
        cardRepository: CardRepository = UserDefaultsCardRepository(),
        aiService: AIService? = nil
    ) {
        self.cardRepository = cardRepository
        self.aiService = aiService ?? MockAIService()
        
        loadCards()
        
        // For preview and testing, add sample cards if empty
        #if DEBUG
        if cards.isEmpty {
            cards = [
                Card.sample,
                Card(
                    displayId: 7,
                    title: "Ruby Crystal",
                    description: "A vibrant red crystal that glows with inner fire, said to embody the essence of passion and energy.",
                    imageUrl: URL(string: "https://images.unsplash.com/photo-1566398476332-118d3ba299ad?q=80&w=300"),
                    stats: [
                        Stat(category: "Power", value: .integer(65)),
                        Stat(category: "Hardness", value: .integer(8)),
                        Stat(category: "Element", value: .string("Fire")),
                        Stat(category: "Origin", value: .string("Mountains"))
                    ],
                    type: .fire
                ),
                Card(
                    displayId: 23,
                    title: "Aqua Serpent",
                    description: "A mystical water creature that flows like liquid between dimensions, able to control currents and tides.",
                    imageUrl: URL(string: "https://images.unsplash.com/photo-1580394629311-9a29113a5166?q=80&w=300"),
                    stats: [
                        Stat(category: "Speed", value: .integer(90)),
                        Stat(category: "Fluidity", value: .integer(100)),
                        Stat(category: "Element", value: .string("Water")),
                        Stat(category: "Rarity", value: .string("Very Rare"))
                    ],
                    type: .water
                )
            ]
        }
        #endif
    }
    
    // MARK: - Public Methods
    
    /// Handles actions from the UI
    func send(_ action: AppAction) {
        switch action {
        case .selectCard(let card):
            selectedCard = card
            
        case .deselectCard:
            selectedCard = nil
            
        case .showCameraView:
            isCameraPresented = true
            
        case .dismissCameraView:
            isCameraPresented = false
            
        case .generateCard(let image):
            generateCard(from: image)
            
        case .showNewCard(let card):
            selectedCard = card
            isShowingNewCard = true
            
        case .addCard(let card):
            addCard(card)
            
        case .removeCard(let card):
            removeCard(card)
            
        case .dismissError:
            error = nil
        }
    }
    
    // MARK: - Private Methods
    
    private func loadCards() {
        cards = cardRepository.loadCards()
    }
    
    private func addCard(_ card: Card) {
        if !cards.contains(where: { $0.id == card.id }) {
            cards.append(card)
            cardRepository.saveCards(cards)
        }
    }
    
    private func removeCard(_ card: Card) {
        cards.removeAll { $0.id == card.id }
        cardRepository.saveCards(cards)
    }
    
    private func generateCard(from image: UIImage) {
        // This would normally call the AI service to generate a card
        // For now, we'll just create a sample card with the next sequential ID
        isGeneratingCard = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            
            self.totalCards += 1
            
            let newCard = Card(
                displayId: self.totalCards,
                title: "Generated Card #\(self.totalCards)",
                description: "This is a newly generated card from an image capture.",
                imageUrl: nil, // In a real app, this would be a local file URL for the captured image
                stats: [
                    Stat(category: "Power", value: .integer(Int.random(in: 50...100))),
                    Stat(category: "Defense", value: .integer(Int.random(in: 30...80))),
                    Stat(category: "Special", value: .integer(Int.random(in: 40...90))),
                    Stat(category: "Type", value: .string(CardType.allCases.randomElement()!.displayName))
                ],
                type: CardType.allCases.randomElement()!
            )
            
            self.isGeneratingCard = false
            self.send(.showNewCard(card: newCard))
        }
    }
}

// MARK: - Actions

/// Actions that can be dispatched to the AppState
enum AppAction {
    case selectCard(card: Card)
    case deselectCard
    case showCameraView
    case dismissCameraView
    case generateCard(image: UIImage)
    case showNewCard(card: Card)
    case addCard(card: Card)
    case removeCard(card: Card)
    case dismissError
}

// MARK: - Mock AI Service for previews and testing

class MockAIService: AIService {
    func analyzeImage(_ image: UIImage) async throws -> InitialAnalysisData {
        // This is a stub implementation
        return InitialAnalysisData(subject: "Mock Subject", visualTraits: "Mock visual traits", type: "normal", stats: [])
    }
    
    func generateCardData(from analysisData: InitialAnalysisData) async throws -> CardGenerationData {
        // This is a stub implementation
        return CardGenerationData(title: "Mock Card", description: "Mock description", stats: [], artPrompt: "Mock art prompt")
    }
    
    func generateImage(from prompt: String) async throws -> URL {
        // This is a stub implementation
        return URL(string: "https://placekitten.com/300/300")!
    }
}

// MARK: - Supporting Data Structures

struct InitialAnalysisData {
    let subject: String
    let visualTraits: String
    let type: String
    let stats: [String: String]
}

struct CardGenerationData {
    let title: String
    let description: String
    let stats: [Stat]
    let artPrompt: String
}

protocol AIService {
    func analyzeImage(_ image: UIImage) async throws -> InitialAnalysisData
    func generateCardData(from analysisData: InitialAnalysisData) async throws -> CardGenerationData
    func generateImage(from prompt: String) async throws -> URL
}
