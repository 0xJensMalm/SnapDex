import Foundation

/// Represents a value that can be either an integer or string
enum StatValue: Equatable, Codable {
    case integer(Int)
    case string(String)
    
    var displayString: String {
        switch self {
        case .integer(let value):
            return String(value)
        case .string(let value):
            return value
        }
    }
}

/// Represents a stat item on a card
struct Stat: Identifiable, Codable, Equatable {
    let id: UUID
    let category: String
    let value: StatValue
    
    init(id: UUID = UUID(), category: String, value: StatValue) {
        self.id = id
        self.category = category
        self.value = value
    }
}
