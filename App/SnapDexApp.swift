import SwiftUI

@main
struct SnapDexApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        CardCollectionView()
            .environmentObject(appState)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let appState = AppState()
        return ContentView()
            .environmentObject(appState)
    }
}
