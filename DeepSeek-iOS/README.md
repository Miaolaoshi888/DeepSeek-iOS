# DeepSeek iOS 应用

一个基于 DeepSeek/Agnes AI 的 iOS 聊天应用，支持 iPhone 16 Pro Max 原生体验。

## 📱 功能特性

- ✅ **AI 聊天对话** - 支持多轮对话，流式响应
- ✅ **代码执行** - 支持 Python/Node.js 代码解释
- ✅ **多模态输入** - 支持图片、PDF 等文件上传
- ✅ **对话历史** - 本地持久化保存历史记录
- ✅ **角色预设** - 内置多种助手角色模板
- ✅ **导出分享** - 支持导出对话记录

## 🛠️ 技术栈

- **Swift 5.9**
- **SwiftUI** - 声明式 UI
- **Combine** - 响应式编程
- **iOS 16.0+**

## 🚀 快速开始

### 环境要求

- Xcode 15.0+
- iOS 16.0+ 部署目标
- Apple Developer 账号（用于签名和发布）

### 构建步骤

```bash
# 1. 进入项目目录
cd 苹果手机端开发/DeepSeek-iOS

# 2. 使用 Xcode 打开
open DeepSeek-iOS.xcodeproj

# 3. 配置签名信息
# - 选择你的 Team
# - 修改 Bundle ID

# 4. 运行应用
# 连接 iPhone 16 Pro Max，选择设备运行
```

### 配置 API Key

应用启动时会自动读取环境变量 `AGNES_API_KEY`。

**方式一：Xcode Scheme 环境变量**
```
Product → Scheme → Edit Scheme → Run → Arguments → Environment Variables
添加: AGNES_API_KEY = sk-xxxxx
```

**方式二：修改代码中的默认值**
```swift
// Services/APIService.swift
private var apiKey = "sk-xxxxx" // 替换为你的 API Key
```

## 📁 项目结构

```
DeepSeek-iOS/
├── DeepSeekApp.swift       # 应用入口
├── Views/                  # UI 视图
│   ├── ContentView.swift
│   ├── ChatListView.swift
│   ├── ChatDetailView.swift
│   ├── InputBar.swift
│   ├── Pickers.swift
│   └── SettingsView.swift
├── Models/                 # 数据模型
│   ├── Chat.swift
│   └── APIResponse.swift
├── Services/               # 服务层
│   ├── APIService.swift    # API 通信
│   └── StorageService.swift # 本地存储
└── ViewModels/             # 视图模型
    └── ChatViewModel.swift
```

## 🔧 自定义配置

编辑 `project-config.json` 修改：
- API 端点
- 支持的模型列表
- 功能开关

## 📦 发布到 App Store

```bash
# 1. archive 构建
xcodebuild archive \
  -scheme DeepSeek \
  -destination 'generic/platform=iOS' \
  -archivePath Build/DeepSeek.xcarchive

# 2. 导出 IPA
xcodebuild -exportArchive \
  -archivePath Build/DeepSeek.xcarchive \
  -exportPath Build/Exported \
  -exportOptionsPlist ExportOptions.plist
```

## 🧪 测试

```bash
# 单元测试
xcodebuild test -scheme DeepSeek -destination 'platform=iOS Simulator,name=iPhone 16 Pro Max'
```

## 📄 License

MIT License

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

**作者**: Agnes AI  
**版本**: 1.0.0  
**创建时间**: 2026-01-09
