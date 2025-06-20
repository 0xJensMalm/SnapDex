import SwiftUI

/// Displays a grid of collected cards
struct CardCollectionView: View {
    @EnvironmentObject var appState: AppState
    
    private let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color.black.opacity(0.05)
                    .edgesIgnoringSafeArea(.all)
                
                // Content
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(appState.cards) { card in
                            cardCell(for: card)
                        }
                    }
                    .padding()
                }
                .navigationTitle("Snap-Facts")
                .toolbar {
                    Button(action: { appState.send(.showCameraView) }) {
                        Image(systemName: "camera")
                            .font(.system(size: 20))
                    }
                }
                
                // Empty state
                if appState.cards.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No cards collected yet")
                            .font(.headline)
                        
                        Text("Tap the camera to scan something and create your first card!")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .foregroundColor(.secondary)
                        
                        Button(action: { appState.send(.showCameraView) }) {
                            Text("Take a Picture")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(Color.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .padding(.top)
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $appState.isCameraPresented) {
            // In a real implementation, this would be the CameraView
            Text("Camera View Placeholder")
                .padding()
        }
        // Sheet to display newly created card
        .sheet(isPresented: $appState.isShowingNewCard) {
            if let card = appState.selectedCard {
                NewCardView(card: card)
                    .environmentObject(appState)
            }
        }
    }
    
    private func cardCell(for card: Card) -> some View {
        NavigationLink(destination: CardDetailView(card: card)) {
            VStack {
                RemoteImage(url: card.imageUrl, contentMode: .fill)
                    .frame(height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(alignment: .topTrailing) {
                        ZStack {
                            Circle()
                                .fill(CardTheme.forType(card.type).accentColor)
                                .frame(width: 30, height: 30)
                                .shadow(radius: 2)
                            
                            Text("#\(card.displayId)")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(8)
                    }
                
                Text(card.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .padding(.top, 4)
                
                Spacer()
            }
            .frame(height: 200)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.2), radius: 5, y: 2)
        }
    }
}

/// View to display a newly generated card with options to add or discard
struct NewCardView: View {
    let card: Card
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                CardDetailView(card: card)
                
                HStack(spacing: 30) {
                    Button(action: {
                        dismiss()
                    }) {
                        Label("Discard", systemImage: "trash")
                            .foregroundColor(.red)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.red, lineWidth: 1)
                            )
                    }
                    
                    Button(action: {
                        appState.send(.addCard(card: card))
                        dismiss()
                    }) {
                        Label("Keep", systemImage: "checkmark")
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 32)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.green)
                            )
                    }
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("New Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Discard") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CardCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        let appState = AppState()
        return CardCollectionView()
            .environmentObject(appState)
    }
}
