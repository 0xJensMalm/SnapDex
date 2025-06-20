import SwiftUI

/// A component that loads and displays a remote image with a placeholder and error state
struct RemoteImage: View {
    let url: URL?
    let contentMode: ContentMode
    
    @State private var image: UIImage? = nil
    @State private var isLoading: Bool = false
    @State private var loadError: Error? = nil
    
    init(url: URL?, contentMode: ContentMode = .fill) {
        self.url = url
        self.contentMode = contentMode
    }
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            } else if loadError != nil {
                Image(systemName: "exclamationmark.triangle")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.red)
                    .frame(width: 40, height: 40)
            } else {
                // Placeholder
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                            .frame(width: 40, height: 40)
                    )
            }
        }
        .onAppear(perform: loadImage)
    }
    
    private func loadImage() {
        guard let url = url else { return }
        isLoading = true
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    self.loadError = error
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    self.loadError = NSError(domain: "RemoteImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to load image"])
                    return
                }
                
                self.image = image
            }
        }.resume()
    }
}

struct RemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Valid URL
            RemoteImage(url: URL(string: "https://picsum.photos/200"))
                .frame(width: 200, height: 200)
            
            // Invalid URL
            RemoteImage(url: URL(string: "https://invalid-url.example"))
                .frame(width: 200, height: 200)
            
            // Nil URL
            RemoteImage(url: nil)
                .frame(width: 200, height: 200)
        }
        .padding()
    }
}
