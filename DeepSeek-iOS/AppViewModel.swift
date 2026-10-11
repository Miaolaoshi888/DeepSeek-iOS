import SwiftUI
import Combine

/// DeepSeek iOS 应用 - 主入口点
@main
struct DeepSeekApp: App {
    @StateObject private var viewModel = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .onAppear {
                    viewModel.checkAPIKey()
                }
        }
    }
}

/// 应用级视图模型
class AppViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var apiKey: String = ""
    @Published var defaultModel: String = "agnes-2.5-flash"
    @Published var showPrivacyPolicy = false
    
    private let apiKeyStorage = UserDefaults.standard
    
    init() {
        loadSettings()
    }
    
    func loadSettings() {
        // 从环境变量或 Keychain 获取 API Key
        if let envKey = ProcessInfo.processInfo.environment["AGNES_API_KEY"] {
            saveApiKey(envKey)
        } else {
            // 尝试从 Keychain 读取
            if let storedKey = readFromKeychain("AGNES_API_KEY") {
                saveApiKey(storedKey)
            }
        }
        
        defaultModel = apiKeyStorage.string(forKey: "default_model") ?? "agnes-2.5-flash"
        isAuthenticated = !apiKey.isEmpty
    }
    
    func checkAPIKey() {
        isAuthenticated = !apiKey.isEmpty
    }
    
    func saveApiKey(_ key: String) {
        apiKey = key
        saveToKeychain(key, forKey: "AGNES_API_KEY")
        isAuthenticated = true
    }
    
    func logout() {
        apiKey = ""
        removeFromKeychain("AGNES_API_KEY")
        isAuthenticated = false
    }
    
    func setDefaultModel(_ model: String) {
        defaultModel = model
        apiKeyStorage.set(model, forKey: "default_model")
    }
    
    // MARK: - Keychain Helper
    private func saveToKeychain(_ value: String, forKey key: String) {
        let data = value.data(using: .utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data as Any
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func readFromKeychain(_ key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess,
              let data = item as? Data,
              let string = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return string
    }
    
    private func removeFromKeychain(_ key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
