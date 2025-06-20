import SwiftUI

/// Manages card theming based on card type
struct CardTheme {
    let primaryColor: Color
    let secondaryColor: Color
    let backgroundColor: Color
    let textColor: Color
    let accentColor: Color
    
    // Returns the appropriate theme for a given card type
    static func forType(_ type: CardType) -> CardTheme {
        switch type {
        case .normal:
            return CardTheme(
                primaryColor: Color(hex: "#A8A77A"),
                secondaryColor: Color(hex: "#C6C6A7"),
                backgroundColor: Color(hex: "#E8E8D0"),
                textColor: .black,
                accentColor: Color(hex: "#6D6D4E")
            )
        case .fire:
            return CardTheme(
                primaryColor: Color(hex: "#EE8130"),
                secondaryColor: Color(hex: "#F5AC78"),
                backgroundColor: Color(hex: "#F8D030"),
                textColor: .black,
                accentColor: Color(hex: "#9C531F")
            )
        case .water:
            return CardTheme(
                primaryColor: Color(hex: "#6390F0"),
                secondaryColor: Color(hex: "#9DB7F5"),
                backgroundColor: Color(hex: "#98D8D8"),
                textColor: .black,
                accentColor: Color(hex: "#445E9C")
            )
        case .electric:
            return CardTheme(
                primaryColor: Color(hex: "#F7D02C"),
                secondaryColor: Color(hex: "#FADF78"),
                backgroundColor: Color(hex: "#FAE078"),
                textColor: .black,
                accentColor: Color(hex: "#A1871F")
            )
        case .grass:
            return CardTheme(
                primaryColor: Color(hex: "#7AC74C"),
                secondaryColor: Color(hex: "#A7DB8D"),
                backgroundColor: Color(hex: "#C3F0A8"),
                textColor: .black,
                accentColor: Color(hex: "#4E8234")
            )
        default:
            // Default theme for other types
            return CardTheme(
                primaryColor: Color(hex: "#A8A878"),
                secondaryColor: Color(hex: "#C6C6A7"),
                backgroundColor: Color(hex: "#E8E8D0"),
                textColor: .black,
                accentColor: Color(hex: "#6D6D4E")
            )
        }
    }
}

// Helper extension for hex color initialization
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
