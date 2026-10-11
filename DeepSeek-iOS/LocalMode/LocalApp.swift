import SwiftUI
import UIKit

/// 本地模式资源（辅助类型，不提供 App 入口）

/// 本地聊天视图模型
class LocalChatViewModel: ObservableObject {
    @Published var chats: [Chat] = []
    @Published var currentChat: Chat?
    @Published var isLocalMode = true
    
    private let storage = LocalStorageService.shared
    
    init() {
        loadChats()
    }
    
    func loadFromLocal() {
        loadChats()
    }
    
    func loadChats() {
        chats = storage.loadChats()
        currentChat = chats.first
    }
    
    func createNewChat() {
        let chat = Chat(title: "新对话")
        chats.insert(chat, at: 0)
        currentChat = chat
        storage.saveChats(chats)
    }
    
    func saveChat(_ chat: Chat) {
        if let index = chats.firstIndex(where: { $0.id == chat.id }) {
            chats[index] = chat
        } else {
            chats.insert(chat, at: 0)
        }
        storage.saveChats(chats)
        currentChat = chat
    }
}

/// 本地存储服务
class LocalStorageService {
    static let shared = LocalStorageService()
    
    private let key = "local_chats"
    
    func saveChats(_ chats: [Chat]) {
        if let data = try? JSONEncoder().encode(chats) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func loadChats() -> [Chat] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let chats = try? JSONDecoder().decode([Chat].self, from: data) else {
            return []
        }
        return chats.sorted { $0.updatedAt > $1.updatedAt }
    }
}
