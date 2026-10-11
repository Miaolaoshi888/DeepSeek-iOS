import SwiftUI

/// 主内容视图 - 包含登录和主界面
struct ContentView: View {
    @StateObject private var viewModel = ChatViewModel()
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        Group {
            if appViewModel.isAuthenticated {
                MainTabView(viewModel: viewModel)
            } else {
                LoginView()
            }
        }
        .onChange(of: appViewModel.isAuthenticated) { newValue in
            if !newValue {
                // 强制刷新
            }
        }
    }
}

/// 登录视图
struct LoginView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var apiKeyInput = ""
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Logo
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                    .padding(.top, 60)
                
                // 标题
                Text("DeepSeek AI")
                    .font(.system(size: 32, weight: .bold))
                
                Text("您的智能 AI 助手")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Divider()
                    .padding(.vertical)
                
                // API Key 输入
                VStack(alignment: .leading, spacing: 8) {
                    Text("API Key")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    SecureField("请输入您的 API Key", text: $apiKeyInput)
                        .textFieldStyle(.roundedBorder)
                        .font(.title3)
                        .padding(.horizontal)
                    
                    Text("使用 Agnes AI API")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // 登录按钮
                Button(action: login) {
                    if appViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Text("登录")
                            .font(.headline)
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(appViewModel.isLoading)
                .padding(.horizontal)
                
                Spacer()
                
                // 隐私政策链接
                Button(action: {
                    appViewModel.showPrivacyPolicy = true
                }) {
                    Text("查看隐私政策")
                        .font(.caption)
                }
                
                Text("登录即表示您同意我们的服务条款")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.bottom)
            }
            .alert("登录失败", isPresented: $showError) {
                Button("确定") { }
                Button("重试") { login() }
            } message: {
                Text(errorMessage)
            }
            .navigationBarHidden(true)
        }
    }
    
    private func login() {
        guard !apiKeyInput.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "请输入 API Key"
            showError = true
            return
        }
        
        appViewModel.saveApiKey(apiKeyInput.trimmingCharacters(in: .whitespaces))
    }
}
