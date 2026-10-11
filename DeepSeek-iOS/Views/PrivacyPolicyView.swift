import SwiftUI

/// 隐私政策视图
struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("隐私政策")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    SectionContent(title: "1. 数据收集", content: """
                        本应用会收集以下信息：
                        - API Key（存储在设备本地 Keychain）
                        - 对话历史（存储在设备本地）
                        - 使用的模型名称
                        
                        我们不会收集您的个人信息或将其发送给第三方。
                        """)
                    
                    SectionContent(title: "2. 数据使用", content: """
                        - API Key 仅用于与 Agnes AI 服务通信
                        - 对话历史仅在本地存储，不会上传到服务器
                        - 所有数据传输均通过 HTTPS 加密
                        """)
                    
                    SectionContent(title: "3. 数据存储", content: """
                        - API Key 使用 iOS Keychain 安全存储
                        - 对话数据存储在设备本地 SQLite 数据库
                        - 您可以随时在应用中清除所有数据
                        """)
                    
                    SectionContent(title: "4. 第三方服务", content: """
                        本应用使用以下第三方服务：
                        - Agnes AI API：处理您的对话请求
                        - Apple Services：用于应用商店分发
                        
                        我们不会与任何第三方分享您的数据。
                        """)
                    
                    SectionContent(title: "5. 用户权利", content: """
                        - 查看和导出您的对话历史
                        - 删除所有对话记录
                        - 退出登录并清除 API Key
                        - 卸载应用以清除所有本地数据
                        """)
                    
                    SectionContent(title: "6. 联系我们", content: """
                        如有疑问，请联系：
                        - 邮箱：support@agents.com
                        - 网站：https://agents.com
                        
                        最后更新：2026年1月9日
                        """)
                }
                .padding()
            }
            .navigationTitle("隐私政策")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") { dismiss() }
                }
            }
        }
    }
}

struct SectionContent: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}
