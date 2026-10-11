import Foundation

/// 网络状态管理器
class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    
    @Published var isConnected = true
    @Published var connectionType: ConnectionType = .unknown
    
    enum ConnectionType: String {
        case unknown, none, wifi, cellular2G, cellular3G, cellular4G, cellular5G
    }
    
    private let reachability: Reachability
    
    private init() {
        reachability = Reachability()!
        startMonitoring()
    }
    
    func startMonitoring() {
        try? reachability.startNotifier()
        
        NotificationCenter.default.addObserver(
            forName: .ReachabilityChanged,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.updateConnectionStatus(notification)
        }
    }
    
    func stopMonitoring() {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self)
    }
    
    private func updateConnectionStatus(_ notification: Notification) {
        guard let reachability = notification.object as? Reachability else { return }
        
        isConnected = reachability.connection != .none
        connectionType = reachability.currentConnectionType
    }
    
    var isOnline: Bool {
        return isConnected && connectionType != .none
    }
}

/// 简化的网络检测（替代 Reachability）
class Reachability {
    static let shared = Reachability()
    
    var isConnected: Bool {
        return true // 简化实现，实际应该使用 SystemConfiguration
    }
    
    var connection: NetworkType {
        return .wifi
    }
    
    var currentConnectionType: NetworkMonitor.ConnectionType {
        return .wifi
    }
}

enum NetworkType {
    case none, wifi, cellular
}
