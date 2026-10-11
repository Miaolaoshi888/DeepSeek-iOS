import SwiftUI

/// DeepSeek iOS 应用 - 入口点
@main
struct DeepSeekApp: App {
    @StateObject private var appViewModel = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appViewModel)
                .onAppear {
                    appViewModel.checkAPIKey()
                }
        }
    }
}
