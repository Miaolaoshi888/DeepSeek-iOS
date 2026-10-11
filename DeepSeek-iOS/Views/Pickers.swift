import SwiftUI

/// 预设选择器视图
struct PresetPickerView: View {
    let onSelect: (Preset) -> Void
    @Environment(\.dismiss) private var dismiss
    
    private let presets = PresetManager.presets
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(presets) { preset in
                    Button(action: {
                        onSelect(preset)
                        dismiss()
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
                        }
                    }
                }
            }
            .navigationTitle("选择预设")
        }
    }
}
