import SwiftUI

/// A view modifier that applies a 3D rotation effect with perspective
struct Card3DRotation: ViewModifier {
    let rotationY: Double
    let dragRotation: Double
    let perspective: Double
    
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(rotationY + dragRotation),
                axis: (x: 0.0, y: 1.0, z: 0.0),
                perspective: perspective
            )
    }
}

/// A view modifier that applies dynamic shadow based on rotation
struct DynamicShadow: ViewModifier {
    let dragRotation: Double
    let baseShadowRadius: Double
    
    func body(content: Content) -> some View {
        content
            .shadow(
                color: .black.opacity(0.3),
                radius: abs(dragRotation) * 0.2 + baseShadowRadius,
                x: dragRotation * 0.1,
                y: 5
            )
    }
}

/// Drag gesture handler for 3D card rotation
struct CardDragRotation: ViewModifier {
    @Binding var dragRotation: Double
    let maxRotation: Double
    let screenWidth: Double
    
    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let rotationFactor = value.translation.x / screenWidth
                        let newRotation = rotationFactor * maxRotation * 2
                        dragRotation = max(-maxRotation, min(maxRotation, newRotation))
                    }
                    .onEnded { _ in
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            dragRotation = 0
                        }
                    }
            )
    }
}

/// View extensions for 3D card effects
extension View {
    func card3DRotation(
        rotationY: Double,
        dragRotation: Double = 0,
        perspective: Double = 0.5
    ) -> some View {
        self.modifier(Card3DRotation(
            rotationY: rotationY,
            dragRotation: dragRotation,
            perspective: perspective
        ))
    }
    
    func dynamicShadow(
        dragRotation: Double,
        baseShadowRadius: Double = 10
    ) -> some View {
        self.modifier(DynamicShadow(
            dragRotation: dragRotation,
            baseShadowRadius: baseShadowRadius
        ))
    }
    
    func cardDragRotation(
        dragRotation: Binding<Double>,
        maxRotation: Double = 45,
        screenWidth: Double
    ) -> some View {
        self.modifier(CardDragRotation(
            dragRotation: dragRotation,
            maxRotation: maxRotation,
            screenWidth: screenWidth
        ))
    }
}

struct Card3DRotation_Previews: PreviewProvider {
    struct PreviewView: View {
        @State private var dragRotation: Double = 0
        @State private var isFlipped = false
        
        var body: some View {
            GeometryReader { geometry in
                VStack {
                    Rectangle()
                        .fill(isFlipped ? Color.red : Color.blue)
                        .frame(width: 200, height: 300)
                        .overlay(
                            Text(isFlipped ? "Back" : "Front")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        )
                        .card3DRotation(
                            rotationY: isFlipped ? 180 : 0,
                            dragRotation: dragRotation
                        )
                        .dynamicShadow(dragRotation: dragRotation)
                        .cardDragRotation(
                            dragRotation: $dragRotation,
                            screenWidth: geometry.size.width
                        )
                    
                    Button("Flip") {
                        withAnimation(.easeInOut(duration: 0.8)) {
                            isFlipped.toggle()
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.top, 20)
                }
            }
        }
    }
    
    static var previews: some View {
        PreviewView()
    }
}
