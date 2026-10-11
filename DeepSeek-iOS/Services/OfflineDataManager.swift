import Foundation
import CoreData

/// 离线数据管理器 - 实现离线缓存和同步
///
/// 说明：使用代码内构建的 NSManagedObjectModel（见 CoreDataModel.swift），
/// 不依赖 .xcdatamodeld 文件，避免因模型未编译导致的运行时崩溃。
class OfflineDataManager: ObservableObject {
    static let shared = OfflineDataManager()

    @Published var isSyncing = false
    @Published var syncProgress: Double = 0
    @Published var lastSyncDate: Date?

    /// CoreData 容器。若首次初始化失败会回退为内存存储，保证不会崩溃。
    private let container: NSPersistentContainer

    private init() {
        let model = CoreDataModel.make()
        container = NSPersistentContainer(name: "DeepSeekData", managedObjectModel: model)

        // 把 SQLite 落到 Application Support 下的独立目录，避免与其他数据混在一起
        let storeDirectory: URL
        if let appSupport = FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first {
            storeDirectory = appSupport.appendingPathComponent("DeepSeekData", isDirectory: true)
        } else {
            storeDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
        }

        try? FileManager.default.createDirectory(
            at: storeDirectory,
            withIntermediateDirectories: true
        )

        let storeURL = storeDirectory.appendingPathComponent("DeepSeekData.sqlite")
        let description = NSPersistentStoreDescription(url: storeURL)
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions = [description]

        var loadError: Error?
        container.loadPersistentStores { _, error in
            loadError = error
        }

        // 磁盘存储打不开时（磁盘满 / 权限 / 版本不兼容），降级到内存存储，
        // 保证 App 不崩溃，功能可用（只是不持久化）。
        if let error = loadError {
            print("CoreData 磁盘存储加载失败，降级为内存存储: \(error)")
            let fallback = NSPersistentStoreDescription()
            fallback.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [fallback]
            container.loadPersistentStores { _, fallbackError in
                if let fallbackError = fallbackError {
                    print("CoreData 内存存储也失败（将禁用离线缓存）: \(fallbackError)")
                }
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    // MARK: - 保存

    /// 保存离线对话
    func saveOfflineChat(_ chat: Chat) {
        let context = container.newBackgroundContext()
        context.perform { [weak self] in
            guard self != nil else { return }

            let entity = NSEntityDescription.insertNewObject(
                forEntityName: CoreDataModel.Entity.chat,
                into: context
            )
            entity.setValue(chat.id, forKey: "id")
            entity.setValue(chat.title, forKey: "title")
            entity.setValue(chat.createdAt, forKey: "createdAt")
            entity.setValue(chat.updatedAt, forKey: "updatedAt")

            // 保存消息
            for message in chat.messages {
                let msgEntity = NSEntityDescription.insertNewObject(
                    forEntityName: CoreDataModel.Entity.message,
                    into: context
                )
                msgEntity.setValue(message.id, forKey: "id")
                msgEntity.setValue(message.role.rawValue, forKey: "role")
                msgEntity.setValue(message.content, forKey: "content")
                msgEntity.setValue(message.timestamp, forKey: "timestamp")
                msgEntity.setValue(chat.id, forKey: "chatId")
            }

            do {
                try context.save()
            } catch {
                print("Error saving chat: \(error)")
            }
        }
    }

    // MARK: - 读取

    /// 加载离线对话
    func loadOfflineChats() -> [Chat] {
        let context = container.newBackgroundContext()
        var chats: [Chat] = []

        context.performAndWait {
            let fetchRequest = NSFetchRequest<NSManagedObject>(
                entityName: CoreDataModel.Entity.chat
            )
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "updatedAt", ascending: false)
            ]

            do {
                let results = try context.fetch(fetchRequest)
                for result in results {
                    let chat = Chat(
                        id: (result.value(forKey: "id") as? UUID) ?? UUID(),
                        title: (result.value(forKey: "title") as? String) ?? "",
                        createdAt: (result.value(forKey: "createdAt") as? Date) ?? Date(),
                        updatedAt: (result.value(forKey: "updatedAt") as? Date) ?? Date()
                    )
                    chats.append(chat)
                }
            } catch {
                print("Error loading chats: \(error)")
            }
        }

        return chats
    }

    /// 加载指定对话的全部消息
    func loadMessages(forChatId chatId: UUID) -> [ChatMessage] {
        let context = container.newBackgroundContext()
        var messages: [ChatMessage] = []

        context.performAndWait {
            let fetchRequest = NSFetchRequest<NSManagedObject>(
                entityName: CoreDataModel.Entity.message
            )
            fetchRequest.predicate = NSPredicate(format: "chatId == %@", chatId as CVarArg)
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "timestamp", ascending: true)
            ]

            do {
                let results = try context.fetch(fetchRequest)
                for result in results {
                    let roleRaw = (result.value(forKey: "role") as? String) ?? "user"
                    let message = ChatMessage(
                        id: (result.value(forKey: "id") as? UUID) ?? UUID(),
                        role: MessageRole(rawValue: roleRaw) ?? .user,
                        content: (result.value(forKey: "content") as? String) ?? "",
                        timestamp: (result.value(forKey: "timestamp") as? Date) ?? Date()
                    )
                    messages.append(message)
                }
            } catch {
                print("Error loading messages: \(error)")
            }
        }

        return messages
    }

    // MARK: - 同步（占位实现）

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

    // MARK: - 清理

    /// 清除离线数据
    func clearOfflineData() {
        let context = container.newBackgroundContext()
        context.perform { [weak self] in
            guard self != nil else { return }

            let messageFetch = NSFetchRequest<NSFetchRequestResult>(
                entityName: CoreDataModel.Entity.message
            )
            try? context.execute(NSBatchDeleteRequest(fetchRequest: messageFetch))

            let chatFetch = NSFetchRequest<NSFetchRequestResult>(
                entityName: CoreDataModel.Entity.chat
            )
            try? context.execute(NSBatchDeleteRequest(fetchRequest: chatFetch))

            do {
                try context.save()
            } catch {
                print("Error clearing data: \(error)")
            }
        }
    }
}
