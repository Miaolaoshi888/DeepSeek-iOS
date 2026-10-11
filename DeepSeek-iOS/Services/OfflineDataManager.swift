import Foundation
import CoreData

/// 离线数据管理器 - 实现离线缓存和同步
class OfflineDataManager: ObservableObject {
    static let shared = OfflineDataManager()
    
    @Published var isSyncing = false
    @Published var syncProgress: Double = 0
    @Published var lastSyncDate: Date?
    
    private let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "DeepSeekData")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("CoreData load error: \(error)")
            }
        }
    }
    
    /// 保存离线对话
    func saveOfflineChat(_ chat: Chat) {
        let context = container.newBackgroundContext()
        context.perform {
            let entity = NSEntityDescription.insertNewObject(forEntityName: "Chat", into: context)
            entity.setValue(chat.id.uuidString, forKey: "id")
            entity.setValue(chat.title, forKey: "title")
            entity.setValue(chat.createdAt, forKey: "createdAt")
            entity.setValue(chat.updatedAt, forKey: "updatedAt")
            
            // 保存消息
            for message in chat.messages {
                let msgEntity = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context)
                msgEntity.setValue(message.id.uuidString, forKey: "id")
                msgEntity.setValue(message.role.rawValue, forKey: "role")
                msgEntity.setValue(message.content, forKey: "content")
                msgEntity.setValue(message.timestamp, forKey: "timestamp")
                msgEntity.setValue(chat.id.uuidString, forKey: "chatId")
            }
            
            do {
                try context.save()
            } catch {
                print("Error saving chat: \(error)")
            }
        }
    }
    
    /// 加载离线对话
    func loadOfflineChats() -> [Chat] {
        let context = container.newBackgroundContext()
        var chats: [Chat] = []
        
        context.performAndWait {
            let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Chat")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
            
            do {
                let results = try context.fetch(fetchRequest)
                for result in results {
                    let chat = Chat(
                        id: UUID(uuidString: result.value(forKey: "id") as? String ?? "") ?? UUID(),
                        title: result.value(forKey: "title") as? String ?? "",
                        createdAt: result.value(forKey: "createdAt") as? Date ?? Date(),
                        updatedAt: result.value(forKey: "updatedAt") as? Date ?? Date()
                    )
                    chats.append(chat)
                }
            } catch {
                print("Error loading chats: \(error)")
            }
        }
        
        return chats
    }
    
    /// 同步数据到云端
    func syncWithCloud() async {
        isSyncing = true
        
        defer {
            isSyncing = false
            lastSyncDate = Date()
        }
        
        // 模拟同步过程
        for i in stride(from: 0, to: 100, by: 10) {
            syncProgress = Double(i)
            try? await Task.sleep(nanoseconds: 100_000_000)
        }
        
        syncProgress = 100
    }
    
    /// 清除离线数据
    func clearOfflineData() {
        let context = container.newBackgroundContext()
        context.perform {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Message")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try? context.execute(deleteRequest)
            
            let chatFetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Chat")
            let chatDeleteRequest = NSBatchDeleteRequest(fetchRequest: chatFetchRequest)
            try? context.execute(chatDeleteRequest)
            
            do {
                try context.save()
            } catch {
                print("Error clearing data: \(error)")
            }
        }
    }
}
