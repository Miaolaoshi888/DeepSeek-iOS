import SwiftUI
import Combine

/// 聊天视图模型 - 管理所有聊天状态
class ChatViewModel: ObservableObject {
    @Published var chats: [Chat] = []
    @Published var currentChat: Chat?
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var showSettings = false
    @Published var showModelPicker = false
    @Published var showFilePicker = false
    @Published var defaultModel: String = "agnes-2.5-flash"
    
    /// 可选模型列表
    let models: [String] = [
        "agnes-2.5-flash",
        "agnes-2.0-flash",
        "agnes-2.0-pro"
    ]
    
    private let apiService = APIService.shared
    private let storageService = StorageService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadChats()
    }
    
    // MARK: - 数据加载
    func loadChats() {
        chats = storageService.loadChats()
        currentChat = chats.first
    }
    
    // MARK: - 聊天操作
    func createNewChat() {
        let chat = Chat(title: "")
        chats.insert(chat, at: 0)
        currentChat = chat
        storageService.addChat(chat)
    }
    
    func startWithPreset(_ preset: Preset) {
        createNewChat()
        if let chat = currentChat {
            let message = ChatMessage(
                role: .user,
                content: "[\(preset.name)] ",
                timestamp: Date()
            )
            sendMessage(chat.id, message: message, model: "agnes-2.5-flash") { _ in
                // 追加预设内容
            }
        }
    }
    
    func sendMessage(_ chatId: UUID, message: ChatMessage, model: String, completion: @escaping (ChatMessage) -> Void) {
        guard let chatIndex = chats.firstIndex(where: { $0.id == chatId }) else { return }
        
        var chat = chats[chatIndex]
        chat.messages.append(message)
        chat.updatedAt = Date()
        
        // 更新标题
        if chat.title.isEmpty {
            chat.title = extractTitle(from: message.content)
        }
        
        chats[chatIndex] = chat
        storageService.updateChat(chat)
        currentChat = chat
        
        isLoading = true
        
        Task {
            do {
                let response = try await apiService.chat(
                    messages: chat.messages,
                    model: model
                )
                
                let assistantMessage = ChatMessage(
                    role: .assistant,
                    content: response,
                    model: model
                )
                
                chat.messages.append(assistantMessage)
                chat.updatedAt = Date()
                chats[chatIndex] = chat
                storageService.updateChat(chat)
                
                completion(assistantMessage)
                
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
    }
    
    func deleteChat(_ id: UUID) {
        if let index = chats.firstIndex(where: { $0.id == id }) {
            chats.remove(at: index)
            storageService.deleteChat(id)
            
            if currentChat?.id == id {
                currentChat = chats.first
            }
        }
    }
    
    func duplicateChat(_ chat: Chat) {
        let newChat = Chat(
            title: chat.title + " (副本)",
            messages: chat.messages,
            createdAt: Date(),
            updatedAt: Date()
        )
        chats.insert(newChat, at: 0)
        storageService.addChat(newChat)
        currentChat = newChat
    }
    
    func clearAllChats() {
        chats.removeAll()
        currentChat = nil
        storageService.clearAll()
    }
    
    func exportData() {
        // 实现导出功能
    }
    
    func testConnection() {
        isLoading = true
        Task {
            do {
                try await apiService.testConnection()
                errorMessage = "连接成功"
            } catch {
                errorMessage = "连接失败: \(error.localizedDescription)"
            }
            isLoading = false
        }
    }
    
    // MARK: - 辅助方法
    private func extractTitle(from content: String) -> String {
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.count <= 30 {
            return trimmed
        }
        return String(trimmed.prefix(30)) + "..."
    }
}
