import SwiftUI

/// 应用主题管理 - 适配 iPhone 16 Pro Max
class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var isDarkMode: Bool = false
    @Published var useDynamicType: Bool = true
    
    private init() {
        updateAppearance()
    }
    
    func updateAppearance() {
        isDarkMode = UITraitCollection.current.userInterfaceStyle == .dark
    }
    
    func toggleTheme() {
        isDarkMode.toggle()
    }
}

/// iPhone 16 Pro Max 优化组件
struct iPhone16ProMaxOptimizations: ViewModifier {
    func body(content: Content) -> some View {
        content
            .dynamicTypeSize(.xSmall ... .xLarge)
            .preference(key: SizeCategoryPreferenceKey.self, value: .medium)
    }
}

extension View {
    func optimizeForiPhone16ProMax() -> some View {
        modifier(iPhone16ProMaxOptimizations())
    }
}

/// 动态类型偏好键
struct SizeCategoryPreferenceKey: PreferenceKey {
    static var defaultValue: DynamicTypeSize = .medium
    static func reduce(value: inout DynamicTypeSize, nextValue: () -> DynamicTypeSize) {
        value = nextValue()
    }
}

/// 安全区域优化
struct SafeAreaOptimizer: ViewModifier {
    let edges: Edge.Set
    @Binding var size: CGFloat
    
    func body(content: Content) -> some View {
        content
            .readSize(onChange: { size = $0.height }, edges: edges)
    }
}

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void, edges: Edge.Set = .all) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .preference(
                        key: ViewSizePreferenceKey.self,
                        value: proxy.size
                    )
            }
        )
        .onPreferenceChange(ViewSizePreferenceKey.self, perform: onChange)
    }
}

struct ViewSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
