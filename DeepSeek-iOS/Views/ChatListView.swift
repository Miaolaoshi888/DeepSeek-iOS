import SwiftUI

/// 对话列表视图
struct ChatListView: View {
    @ObservedObject var viewModel: ChatViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        NavigationStack {
            List {
                // 新建对话按钮
                Section {
                    Button(action: {
                        viewModel.createNewChat()
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                            Text("新建对话")
                                .font(.headline)
                            Spacer()
                        }
                    }
                }
                
                // 快捷预设
                Section(header: Text("快捷预设")) {
                    ForEach(PresetManager.presets) { preset in
                        Button(action: {
                            viewModel.startWithPreset(preset)
                        }) {
                            HStack {
                                Image(systemName: preset.icon)
                                    .foregroundColor(.blue)
                                VStack(alignment: .leading) {
                                    Text(preset.name)
                                        .font(.headline)
                                    Text(preset.description)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                // 对话历史
                Section(header: Text("最近对话")) {
                    ForEach(viewModel.chats) { chat in
                        NavigationLink(destination: ChatDetailView(chat: chat, viewModel: viewModel)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(chat.title.isEmpty ? "新对话" : chat.title)
                                    .font(.headline)
                                Text(chat.lastMessage ?? "暂无消息")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                viewModel.deleteChat(chat.id)
                            } label: {
                                Label("删除", systemImage: "trash")
                            }
                            
                            Button {
                                viewModel.duplicateChat(chat)
                            } label: {
                                Label("复制", systemImage: "doc.on.doc")
                            }
                            .tint(.blue)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("DeepSeek AI")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("清除所有对话", action: viewModel.clearAllChats)
                        Button("查看隐私政策", action: { appViewModel.showPrivacyPolicy = true })
                        Button("退出登录", role: .destructive, action: appViewModel.logout)
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $appViewModel.showPrivacyPolicy) {
                PrivacyPolicyView()
            }
        }
    }
}

/// 预设管理器
class PresetManager {
    static let presets: [Preset] = [
        Preset(name: "翻译", icon: "translate", description: "多语言翻译助手"),
        Preset(name: "总结", icon: "doc.text", description: "内容摘要和提炼"),
        Preset(name: "编程", icon: "curlybraces", description: "代码编写和调试"),
        Preset(name: "问答", icon: "questionmark.circle", description: "知识问答专家"),
        Preset(name: "写作", icon: "pencil", description: "创意写作助手"),
        Preset(name: "数学", icon: "function", description: "数学问题求解")
    ]
}

struct Preset: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let description: String
}
