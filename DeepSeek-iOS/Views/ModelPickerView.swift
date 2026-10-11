import SwiftUI

/// 模型选择器视图
struct ModelPickerView: View {
    let models: [String]
    @Binding var selectedModel: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(models, id: \.self) { model in
                    Button(action: {
                        selectedModel = model
                        dismiss()
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(model)
                                    .font(.headline)
                                Text(modelDescription(model))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            if model == selectedModel {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle("选择模型")
        }
    }
    
    private func modelDescription(_ model: String) -> String {
        switch model {
        case "agnes-2.5-flash":
            return "最快响应，适合日常对话"
        case "agnes-2.0-flash":
            return "稳定版本，平衡性能与质量"
        default:
            return "AI 模型"
        }
    }
}
