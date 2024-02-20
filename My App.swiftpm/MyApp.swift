import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .accentColor(Color(hex: "#227033"))
                .preferredColorScheme(.light)
                .onAppear {
                    SoundManager.instance.initPlayers()
                }
        }
    }
}
