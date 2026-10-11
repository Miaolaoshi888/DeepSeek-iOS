import SwiftUI

/// 代码执行视图
struct CodeExecutionView: View {
    @State private var code = ""
    @State private var output = ""
    @State private var isRunning = false
    @State private var language = "python"
    @State private var history: [(language: String, code: String, output: String, timestamp: Date)] = []
    
    let languages = ["python", "javascript", "bash"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 语言选择
                Picker("语言", selection: $language) {
                    ForEach(languages, id: \.self) { lang in
                        Text(lang.capitalized).tag(lang)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                Divider()
                
                // 代码编辑器
                CodeEditorView(text: $code, language: language)
                    .frame(height: 200)
                
                Divider()
                
                // 运行按钮
                Button(action: runCode) {
                    if isRunning {
                        ProgressView()
                    } else {
                        Label("运行代码", systemImage: "play.fill")
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding()
                
                Divider()
                
                // 输出区域
                ScrollView {
                    Text(output.isEmpty ? "输出将显示在这里..." : output)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                }
                .frame(minHeight: 150)
                
                Divider()
                
                // 历史记录
                List {
                    ForEach(history.indices, id: \.self) { index in
                        HistoryRow(history: history[index])
                            .onTapGesture {
                                code = history[index].code
                                output = history[index].output
                            }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("代码执行")
            .toolbar {
                Button("清空") {
                    code = ""
                    output = ""
                    history.removeAll()
                }
            }
        }
    }
    
    private func runCode() {
        guard !code.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        isRunning = true
        output = "正在执行..."
        
        // 模拟代码执行（实际应该调用后端服务）
        Task {
            do {
                let result = try await executeCode(code, language: language)
                output = result
                history.insert((language: language, code: code, output: result, timestamp: Date()), at: 0)
            } catch {
                output = "执行失败: \(error.localizedDescription)"
            }
            isRunning = false
        }
    }
    
    private func executeCode(_ code: String, language: String) async throws -> String {
        // 这里应该调用实际的代码执行服务
        // 模拟一个简单的响应
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return "// 代码执行结果\nprint('Hello, DeepSeek!')"
    }
}

/// 代码编辑器视图
struct CodeEditorView: View {
    @Binding var text: String
    let language: String
    
    var body: some View {
        ScrollView {
            TextEditor(text: $text)
                .font(.system(.body, design: .monospaced))
                .padding()
        }
        .background(Color(.systemBackground))
    }
}

/// 历史记录行
struct HistoryRow: View {
    let history: (language: String, code: String, output: String, timestamp: Date)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(history.language.capitalized)
                    .font(.caption)
                    .foregroundColor(.blue)
                Spacer()
                Text(formatTime(history.timestamp))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            Text(history.code.prefix(50) + (history.code.count > 50 ? "..." : ""))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
