import SwiftUI
import CoreImage.CIFilterBuiltins

/// Displays a detailed view of a card with a Pokemon-style layout
struct CardDetailView: View {
    let card: Card
    
    @State private var isFlipped = false
    @State private var dragRotation: Double = 0
    @State private var baseRotation: Double = 0
    
    private let flipDuration: Double = 0.8
    private let maxDragRotation: Double = 45
    
    private var theme: CardTheme {
        CardTheme.forType(card.type)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                theme.backgroundColor.opacity(0.2)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Flip button
                    HStack {
                        Spacer()
                        Button(action: flipCard) {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(theme.accentColor)
                                .padding(12)
                                .background(Circle().fill(Color.black.opacity(0.1)))
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 10)
                    }
                    
                    Spacer()
                    
                    // Card
                    cardContent(in: geometry)
                        .frame(
                            width: geometry.size.width * 0.9,
                            height: geometry.size.height * 0.7
                        )
                        .card3DRotation(
                            rotationY: baseRotation + (isFlipped ? 180 : 0),
                            dragRotation: dragRotation
                        )
                        .dynamicShadow(dragRotation: dragRotation)
                        .cardDragRotation(
                            dragRotation: $dragRotation,
                            maxRotation: maxDragRotation,
                            screenWidth: geometry.size.width
                        )
                    
                    Spacer()
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    private func flipCard() {
        withAnimation(.easeInOut(duration: flipDuration)) {
            isFlipped.toggle()
        }
    }
    
    @ViewBuilder
    private func cardContent(in geometry: GeometryProxy) -> some View {
        if isFlipped {
            cardBack(in: geometry)
        } else {
            cardFront(in: geometry)
        }
    }
    
    private func cardFront(in geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            // Top section with title and ID
            topSection
                .frame(height: geometry.size.height * 0.15)
            
            // Main image
            imageSection
                .frame(height: geometry.size.height * 0.35)
            
            // Description and stats
            descriptionSection
                .frame(height: geometry.size.height * 0.3)
            
            // Bottom section with placeholder graphics and QR
            bottomSection
                .frame(height: geometry.size.height * 0.2)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(theme.primaryColor)
                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(theme.accentColor, lineWidth: 3)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func cardBack(in geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            // Top section - mirrored layout
            backTopSection
                .frame(height: geometry.size.height * 0.15)
            
            // Stats section
            VStack(spacing: 12) {
                Text("Stats")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(theme.textColor)
                
                StatsGrid(stats: card.stats, theme: theme)
                    .padding(.horizontal, 20)
            }
            .frame(height: geometry.size.height * 0.5)
            .frame(maxWidth: .infinity)
            .background(theme.backgroundColor.opacity(0.7))
            
            // QR Code section
            VStack(spacing: 8) {
                generateQRCode(from: "SnapDexCard:\(card.id)")
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
                Text("Scan to share")
                    .font(.caption)
                    .foregroundColor(theme.accentColor)
            }
            .frame(height: geometry.size.height * 0.35)
            .frame(maxWidth: .infinity)
            .background(theme.secondaryColor.opacity(0.7))
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(theme.primaryColor)
                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(theme.accentColor, lineWidth: 3)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
    }
    
    private var backTopSection: some View {
        HStack {
            // Type indicator (mirrored position)
            ZStack {
                Circle()
                    .fill(theme.accentColor)
                    .frame(width: 40, height: 40)
                
                Text(String(card.type.displayName.prefix(1)))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            // Title and ID (mirrored position)
            VStack(alignment: .trailing, spacing: 2) {
                Text(card.title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(theme.textColor)
                    .lineLimit(1)
                
                Text(card.formattedId)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(theme.textColor.opacity(0.7))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            Rectangle()
                .fill(theme.secondaryColor)
        )
    }
    
    private var topSection: some View {
        HStack {
            // Title and ID
            VStack(alignment: .leading, spacing: 2) {
                Text(card.title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(theme.textColor)
                    .lineLimit(1)
                
                Text(card.formattedId)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(theme.textColor.opacity(0.7))
            }
            
            Spacer()
            
            // Type indicator
            ZStack {
                Circle()
                    .fill(theme.accentColor)
                    .frame(width: 40, height: 40)
                
                Text(String(card.type.displayName.prefix(1)))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            Rectangle()
                .fill(theme.secondaryColor)
        )
    }
    
    private var imageSection: some View {
        RemoteImage(url: card.imageUrl, contentMode: .fit)
            .background(theme.backgroundColor.opacity(0.7))
            .clipShape(Rectangle())
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(theme.accentColor)
            
            Text(card.description)
                .font(.system(size: 12))
                .foregroundColor(theme.textColor)
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(2)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.secondaryColor.opacity(0.7))
    }
    
    private var bottomSection: some View {
        HStack(alignment: .center) {
            // Left side - placeholder for graphics
            ZStack {
                Circle()
                    .fill(theme.backgroundColor.opacity(0.4))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(theme.accentColor)
            }
            .padding(.leading)
            
            Spacer()
            
            // Right side - QR code (small version)
            generateQRCode(from: "SnapDexCard:\(card.id)")
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .padding(.trailing)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(theme.secondaryColor.opacity(0.5))
    }
    
    private func generateQRCode(from string: String) -> Image {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        filter.message = Data(string.utf8)
        filter.correctionLevel = "H"
        
        if let outputImage = filter.outputImage,
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return Image(uiImage: UIImage(cgImage: cgImage))
        }
        
        return Image(systemName: "xmark.circle")
    }
}

struct CardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CardDetailView(card: Card.sample)
            .previewLayout(.device)
    }
}
