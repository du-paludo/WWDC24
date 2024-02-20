import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false

    var body: some View {
        NavigationStack {
            GameView()
                .overlay {
                    if !hasSeenOnboarding {
                        IntroductionView()
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
