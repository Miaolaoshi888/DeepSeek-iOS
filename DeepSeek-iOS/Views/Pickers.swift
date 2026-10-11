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
                            Text(model)
                            if model == selectedModel {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                    }
                }
            }
            .navigationTitle("选择模型")
        }
    }
}

/// 预设选择器视图
struct PresetPickerView: View {
    let onSelect: (Preset) -> Void
    @Environment(\.dismiss) private var dismiss
    
    let presets = [
        Preset(name: "翻译", prompt: "请将以下内容翻译成中文："),
        Preset(name: "总结", prompt: "请总结以下内容："),
        Preset(name: "代码", prompt: "请帮我编写代码实现："),
        Preset(name: "问答", prompt: "请回答以下问题："),
        Preset(name: "创意写作", prompt: "请帮我创作：")
    ]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(presets, id: \.name) { preset in
                    Button(action: {
                        onSelect(preset)
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: preset.icon)
                                .foregroundColor(.blue)
                            Text(preset.name)
                        }
                    }
                }
            }
            .navigationTitle("选择预设")
        }
    }
}

struct Preset: Identifiable {
    let id = UUID()
    let name: String
    let prompt: String
    let icon: String
    
    init(name: String, prompt: String) {
        self.name = name
        self.prompt = prompt
        self.icon = name == "翻译" ? "translate" :
                    name == "总结" ? "doc.text" :
                    name == "代码" ? "curlybraces" :
                    name == "问答" ? "questionmark.circle" : "pencil"
    }
}
