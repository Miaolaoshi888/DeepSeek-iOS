import SwiftUI

/// 主标签页视图
struct MainTabView: View {
    @ObservedObject var viewModel: ChatViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // 聊天标签
            ChatListView(viewModel: viewModel)
                .tabItem {
                    Label("聊天", systemImage: "message.fill")
                }
                .tag(0)
            
            // 代码执行标签
            CodeExecutionView()
                .tabItem {
                    Label("代码", systemImage: "curlybraces")
                }
                .tag(1)
            
            // 文件上传标签
            FileUploadView()
                .tabItem {
                    Label("文件", systemImage: "doc.fill")
                }
                .tag(2)
            
            // 设置标签
            SettingsTabView()
                .tabItem {
                    Label("设置", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
        .accentColor(.blue)
    }
}

/// 设置标签页
struct SettingsTabView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var defaultModel: String = "agnes-2.5-flash"
    
    let models = ["agnes-2.5-flash", "agnes-2.0-flash"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("API 配置")) {
                    LabeledContent("API 端点", value: "https://api.agnes-ai.cn/v1")
                    LabeledContent("状态", value: appViewModel.isAuthenticated ? "已连接" : "未连接")
                        .foregroundColor(appViewModel.isAuthenticated ? .green : .red)
                }
                
                Section(header: Text("默认模型")) {
                    Picker("模型", selection: $defaultModel) {
                        ForEach(models, id: \.self) { model in
                            Text(model).tag(model)
                        }
                    }
                    .pickerStyle(.wheel)
                }
                
                Section(header: Text("数据管理")) {
                    Button("清除所有对话", role: .destructive) {
                        viewModel.clearAllChats()
                    }
                    
                    Button("导出数据") {
                        viewModel.exportData()
                    }
                }
                
                Section(header: Text("关于")) {
                    LabeledContent("版本", value: "1.0.0")
                    LabeledContent("开发者", value: "Agnes AI")
                }
                
                Section {
                    Button("查看隐私政策") {
                        appViewModel.showPrivacyPolicy = true
                    }
                    
                    Button("退出登录", role: .destructive) {
                        appViewModel.logout()
                    }
                }
            }
            .navigationTitle("设置")
            .onChange(of: defaultModel) { newValue in
                appViewModel.setDefaultModel(newValue)
            }
        }
    }
}
