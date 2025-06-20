import SwiftUI

/// A component to display a single card stat
struct StatDisplay: View {
    let stat: Stat
    let theme: CardTheme
    
    var body: some View {
        HStack(spacing: 4) {
            Text(stat.category)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(theme.accentColor)
            
            Spacer()
            
            Text(stat.value.displayString)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(theme.textColor)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(theme.backgroundColor.opacity(0.7))
        )
    }
}

/// A component to display all card stats in a grid
struct StatsGrid: View {
    let stats: [Stat]
    let theme: CardTheme
    let columns: Int
    
    init(stats: [Stat], theme: CardTheme, columns: Int = 2) {
        self.stats = stats
        self.theme = theme
        self.columns = columns
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<rowCount, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(0..<columns, id: \.self) { column in
                        let index = row * columns + column
                        if index < stats.count {
                            StatDisplay(stat: stats[index], theme: theme)
                        } else {
                            // Empty placeholder to maintain grid structure
                            Spacer()
                        }
                    }
                }
            }
        }
    }
    
    private var rowCount: Int {
        (stats.count + columns - 1) / columns // Ceiling division
    }
}

struct StatDisplay_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Single stat
            StatDisplay(
                stat: Stat(category: "Height", value: .string("1.8m")),
                theme: CardTheme.forType(.grass)
            )
            .frame(width: 150)
            
            // Stats grid
            StatsGrid(
                stats: [
                    Stat(category: "Attack", value: .integer(80)),
                    Stat(category: "Defense", value: .integer(60)),
                    Stat(category: "Speed", value: .integer(120)),
                    Stat(category: "Habitat", value: .string("Forest")),
                ],
                theme: CardTheme.forType(.fire)
            )
            .frame(width: 300)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .previewLayout(.sizeThatFits)
    }
}
