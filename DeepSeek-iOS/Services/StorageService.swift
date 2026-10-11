import Foundation
import UIKit

/// 本地存储管理 - 保存对话历史
class StorageService {
    static let shared = StorageService()
    
    private let chatsKey = "saved_chats"
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    /// 保存对话列表
    func saveChats(_ chats: [Chat]) {
        if let encoded = try? JSONEncoder().encode(chats) {
            userDefaults.set(encoded, forKey: chatsKey)
        }
    }
    
    /// 加载对话列表
    func loadChats() -> [Chat] {
        guard let data = userDefaults.data(forKey: chatsKey),
              let chats = try? JSONDecoder().decode([Chat].self, from: data) else {
            return []
        }
        return chats.sorted { $0.updatedAt > $1.updatedAt }
    }
    
    /// 添加对话
    func addChat(_ chat: Chat) {
        var chats = loadChats()
        chats.insert(chat, at: 0)
        saveChats(chats)
    }
    
    /// 更新对话
    func updateChat(_ chat: Chat) {
        var chats = loadChats()
        if let index = chats.firstIndex(where: { $0.id == chat.id }) {
            chats[index] = chat
            saveChats(chats)
        }
    }
    
    /// 删除对话
    func deleteChat(_ id: UUID) {
        var chats = loadChats()
        chats.removeAll { $0.id == id }
        saveChats(chats)
    }
    
    /// 清除所有对话
    func clearAll() {
        userDefaults.removeObject(forKey: chatsKey)
    }
    
    /// 导出数据
    func exportData() -> Data? {
        let chats = loadChats()
        return try? JSONEncoder().encode(chats)
    }
}
