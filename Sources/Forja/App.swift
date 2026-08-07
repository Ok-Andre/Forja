import SwiftUI

@main
struct ForjaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 420, idealWidth: 480, minHeight: 700, idealHeight: 800)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}
