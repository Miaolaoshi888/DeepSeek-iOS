import SwiftUI
import XCTest

/// 单元测试 - ChatViewModel
class ChatViewModelTests: XCTestCase {
    var viewModel: ChatViewModel!
    
    override func setUp() async throws {
        try await super.setUp()
        viewModel = ChatViewModel()
    }
    
    override func tearDown() async throws {
        viewModel = nil
        try await super.tearDown()
    }
    
    func testCreateNewChat() {
        let initialCount = viewModel.chats.count
        viewModel.createNewChat()
        XCTAssertEqual(viewModel.chats.count, initialCount + 1)
        XCTAssertNotNil(viewModel.currentChat)
    }
    
    func testDeleteChat() {
        viewModel.createNewChat()
        let chatId = viewModel.chats.first?.id
        XCTAssertNotNil(chatId)
        
        if let id = chatId {
            viewModel.deleteChat(id)
            XCTAssertFalse(viewModel.chats.contains { $0.id == id })
        }
    }
    
    func testClearAllChats() {
        viewModel.createNewChat()
        viewModel.createNewChat()
        viewModel.clearAllChats()
        XCTAssertTrue(viewModel.chats.isEmpty)
    }
}

/// 单元测试 - StorageService
class StorageServiceTests: XCTestCase {
    func testSaveAndLoadChats() {
        let storage = StorageService.shared
        let chat = Chat(title: "测试对话", messages: [
            ChatMessage(role: .user, content: "你好")
        ])
        
        // 先清空
        storage.clearAll()
        
        // 保存
        storage.addChat(chat)
        
        // 加载
        let loaded = storage.loadChats()
        XCTAssertEqual(loaded.count, 1)
        XCTAssertEqual(loaded.first?.title, "测试对话")
        
        // 清理
        storage.clearAll()
    }
}
