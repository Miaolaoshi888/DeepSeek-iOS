import SwiftUI
import Combine

/// 对话详情视图
struct ChatDetailView: View {
    var chat: Chat
    @ObservedObject var viewModel: ChatViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var messageText = ""
    @State private var isGenerating = false
    @State private var selectedModel = "agnes-2.5-flash"
    @State private var showPresets = false
    @State private var showVoiceInput = false
    @State private var showModelPicker = false
    @State private var attachments: [Attachment] = []
    
    init(chat: Chat, viewModel: ChatViewModel) {
        self.chat = chat
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            // 消息列表
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(chat.messages) { message in
                            MessageBubble(message: message, isUser: message.role == .user)
                                .id(message.id)
                        }
                        
                        if isGenerating {
                            LoadingBubble()
                                .id("loading")
                        }
                    }
                    .padding()
                }
                .onChange(of: chat.messages.count) { _ in
                    if let lastId = chat.messages.last?.id {
                        withAnimation {
                            proxy.scrollTo(lastId, anchor: .bottom)
                        }
                    }
                }
            }
            
            Divider()
            
            // 附件预览
            if !attachments.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(attachments) { attachment in
                            AttachmentView(attachment: attachment)
                                .onTapGesture {
                                    attachments.removeAll { $0.id == attachment.id }
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 80)
            }
            
            // 输入栏
            InputBar(
                text: $messageText,
                isGenerating: isGenerating,
                selectedModel: selectedModel,
                attachments: attachments,
                onSend: sendMessage,
                onAttach: showPicker,
                onVoice: { showVoiceInput = true }
            )
        }
        .navigationTitle(chat.title.isEmpty ? "新对话" : chat.title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: { showModelPicker = true }) {
                        Label("切换模型", systemImage: "cpu")
                    }
                    Button(action: { exportChat() }) {
                        Label("导出对话", systemImage: "square.and.arrow.up")
                    }
                    Button(role: .destructive, action: { viewModel.deleteChat(chat.id) }) {
                        Label("删除对话", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showModelPicker) {
            ModelPickerView(models: appViewModel.models, selectedModel: $selectedModel)
        }
        .sheet(isPresented: $showVoiceInput) {
            VoiceInputView()
                .environmentObject(appViewModel)
                .onDisappear {
                    // 将语音结果添加到消息
                    if !messageText.isEmpty {
                        // 处理语音转文字结果
                    }
                }
        }
    }
    
    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let userMessage = ChatMessage(
            id: UUID(),
            role: .user,
            content: messageText,
            timestamp: Date(),
            attachments: attachments.map { $0.toAPIFormat() }
        )
        
        viewModel.sendMessage(chat.id, message: userMessage, model: selectedModel) { assistantMessage in
            messageText = ""
            attachments.removeAll()
            isGenerating = false
        }
        
        isGenerating = true
    }
    
    private func showPicker() {
        // 显示文件选择器
    }
    
    private func exportChat() {
        // 导出对话为文本或 PDF
    }
}

/// 消息气泡视图
struct MessageBubble: View {
    let message: ChatMessage
    let isUser: Bool
    
    var body: some View {
        HStack {
            if isUser {
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    if !message.attachments.isEmpty {
                        attachmentPreview
                    }
                    Text(message.content)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(16)
                    Text(formatTime(message.timestamp))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    if !message.attachments.isEmpty {
                        attachmentPreview
                    }
                    Text(message.content)
                        .foregroundColor(.primary)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(16)
                    HStack {
                        Text(formatTime(message.timestamp))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        if let model = message.model {
                            Text(model)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 4)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(4)
                        }
                    }
                }
                .padding(.horizontal)
                Spacer()
            }
        }
    }
    
    private var attachmentPreview: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(message.attachments, id: \.self) { att in
                    Image(systemName: attachmentIcon(for: att))
                        .font(.caption)
                        .foregroundColor(.blue)
                        .padding(4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(4)
                }
            }
        }
    }
    
    private func attachmentIcon(for type: String) -> String {
        switch type {
        case "image": return "photo.fill"
        case "pdf": return "pdf.fill"
        case "text": return "doc.text.fill"
        default: return "paperclip.fill"
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

/// 加载动画气泡
struct LoadingBubble: View {
    @State private var dots = 0
    
    var body: some View {
        HStack {
            Text("AI 正在思考\(String(repeating: ".", count: dots))")
                .foregroundColor(.secondary)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(16)
            Spacer()
        }
        .padding(.horizontal)
        .onAppear {
            Timer.publish(every: 0.5, on: .main, in: .common)
                .autoconnect()
                .sink { _ in
                    withAnimation {
                        dots = (dots + 1) % 4
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
}

/// 附件视图
struct AttachmentView: View {
    let attachment: Attachment
    
    var body: some View {
        Image(systemName: attachment.icon)
            .font(.title2)
            .foregroundColor(.blue)
            .padding(8)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
            .overlay(
                Text(attachment.name)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 4)
            )
    }
}

struct Attachment: Identifiable {
    let id: UUID
    let name: String
    let type: String
    let icon: String
    
    func toAPIFormat() -> String {
        return "\(type):\(name)"
    }
}
