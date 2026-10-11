import SwiftUI

/// 输入栏视图 - 支持语音、附件、文本输入
struct InputBar: View {
    @Binding var text: String
    let isGenerating: Bool
    let selectedModel: String
    let attachments: [Attachment]
    let onSend: () -> Void
    let onAttach: () -> Void
    let onVoice: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            // 附件区域（已有）
            if !attachments.isEmpty {
                HStack {
                    ForEach(attachments) { attachment in
                        Image(systemName: attachment.icon)
                            .foregroundColor(.blue)
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            HStack {
                // 模型选择
                Text(selectedModel)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(4)
                
                Spacer()
                
                // 语音按钮
                Button(action: onVoice) {
                    Image(systemName: "mic.fill")
                        .foregroundColor(.blue)
                }
                .disabled(isGenerating)
                
                // 附件按钮
                Button(action: onAttach) {
                    Image(systemName: "paperclip")
                        .foregroundColor(.blue)
                }
                .disabled(isGenerating)
            }
            .padding(.horizontal)
            
            HStack(spacing: 12) {
                TextEditor(text: $text)
                    .font(.body)
                    .lineLimit(1...8)
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                
                Button(action: onSend) {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 44, height: 44)
                        
                        if isGenerating {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                }
                .disabled(text.trimmingCharacters(in: .whitespaces).isEmpty && !isGenerating)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
    }
}
