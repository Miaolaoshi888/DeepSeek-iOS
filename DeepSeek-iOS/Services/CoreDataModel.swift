import Foundation
import CoreData

/// 编程式定义 CoreData 模型，替代 .xcdatamodeld 文件。
///
/// 为什么不用 .xcdatamodeld：
/// 1. 模型文件需要被 Xcode 的「Compile Sources」阶段处理成 .momd，
///    在 xcodegen / CI 环境下极易漏编译，导致运行时 NSPersistentContainer 直接崩溃。
/// 2. 编程式模型不依赖任何工程文件配置，编译即生效，行为完全确定。
enum CoreDataModel {

    /// 实体名（顺序与下面保持一致）
    enum Entity {
        static let chat = "Chat"
        static let message = "Message"
    }

    /// 构建 NSManagedObjectModel
    static func make() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        // MARK: - Chat 实体
        let chat = NSEntityDescription()
        chat.name = Entity.chat
        chat.managedObjectClassName = "NSManagedObject"
        chat.properties = [
            attribute("id", .UUIDAttributeType, optional: false),
            attribute("title", .stringAttributeType, optional: false, defaultValue: ""),
            attribute("createdAt", .dateAttributeType, optional: false),
            attribute("updatedAt", .dateAttributeType, optional: false)
        ]

        // MARK: - Message 实体
        let message = NSEntityDescription()
        message.name = Entity.message
        message.managedObjectClassName = "NSManagedObject"
        message.properties = [
            attribute("id", .UUIDAttributeType, optional: false),
            attribute("role", .stringAttributeType, optional: false, defaultValue: "user"),
            attribute("content", .stringAttributeType, optional: false, defaultValue: ""),
            attribute("timestamp", .dateAttributeType, optional: false),
            attribute("chatId", .UUIDAttributeType, optional: false)
        ]

        model.entities = [chat, message]
        return model
    }

    // MARK: - Helper

    private static func attribute(
        _ name: String,
        _ type: NSAttributeType,
        optional: Bool,
        defaultValue: Any? = nil
    ) -> NSAttributeDescription {
        let attr = NSAttributeDescription()
        attr.name = name
        attr.attributeType = type
        attr.isOptional = optional
        if let defaultValue = defaultValue {
            attr.defaultValue = defaultValue
        }
        return attr
    }
}
