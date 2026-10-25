import SwiftUI

@main
struct SipAndSeeApp: App {
    init() {
        if ProcessInfo.processInfo.arguments.contains("-resetState") {
            UserDefaults.standard.removeObject(forKey: "savedDrinks")
        }
        #if DEBUG
        let arguments = ProcessInfo.processInfo.arguments
        if let index = arguments.firstIndex(of: "-seedFavorites"), arguments.indices.contains(index + 1) {
            UserDefaults.standard.set(arguments[index + 1], forKey: "savedDrinks")
        }
        #endif
    }

    var body: some Scene {
        WindowGroup { ContentView().preferredColorScheme(.light) }
    }
}
