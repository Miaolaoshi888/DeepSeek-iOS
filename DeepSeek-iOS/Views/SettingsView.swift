import SwiftUI

/// 设置视图
struct SettingsView: View {
    @ObservedObject var viewModel: ChatViewModel
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("apiBaseURL") private var apiBaseURL = "https://api.agnes-ai.cn/v1"
    @AppStorage("apiKeyName") private var apiKeyName = "AGNES_API_KEY"
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("API 配置")) {
                    TextField("API Base URL", text: $apiBaseURL)
                        .autocapitalization(.none)
                    
                    TextField("API Key 环境变量名", text: $apiKeyName)
                        .autocapitalization(.none)
                    
                    Button(action: {
                        viewModel.testConnection()
                    }) {
                        Text("测试连接")
                            .foregroundColor(.blue)
                    }
                }
                
                Section(header: Text("默认模型")) {
                    Picker("默认模型", selection: $viewModel.defaultModel) {
                        ForEach(viewModel.models, id: \.self) { model in
                            Text(model).tag(model)
                        }
                    }
                    .pickerStyle(.wheel)
                }
                
                Section(header: Text("关于")) {
                    LabeledContent("应用版本", value: "1.0.0")
                    LabeledContent("支持模型", value: "\(viewModel.models.count) 个")
                }
                
                Section {
                    Button("清除所有对话", role: .destructive) {
                        viewModel.clearAllChats()
                    }
                }
            }
            .navigationTitle("设置")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") { dismiss() }
                }
            }
        }
    }
}
