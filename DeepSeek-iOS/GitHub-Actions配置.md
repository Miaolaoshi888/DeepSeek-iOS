# GitHub Actions 自动构建配置

## 创建 workflow 文件

在项目根目录创建：`.github/workflows/build-ios.yml`

```yaml
name: Build iOS App

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  workflow_dispatch:  # 允许手动触发

jobs:
  build:
    runs-on: macos-14
    
    steps:
    - name: Checkout
      uses: actions/checkout@v4
    
    - name: Select Xcode Version
      run: sudo xcode-select -switch /Applications/Xcode_15.0.app
    
    - name: Set up Swift
      uses: swift-actions/setup-swift@v1
      with:
        swift-version: '5.9'
    
    - name: Install Dependencies
      run: |
        echo "No dependencies needed for this project"
    
    - name: Build for iOS
      run: |
        xcodebuild build \
          -scheme DeepSeek-iOS \
          -destination 'generic/platform=iOS' \
          -configuration Release \
          CODE_SIGNING_ALLOWED=NO \
          | xcpretty
    
    - name: Archive
      run: |
        xcodebuild archive \
          -scheme DeepSeek-iOS \
          -destination 'generic/platform=iOS' \
          -configuration Release \
          -archivePath Build/DeepSeek-iOS.xcarchive \
          CODE_SIGNING_ALLOWED=NO \
          | xcpretty
    
    - name: Export IPA
      run: |
        # 创建 ExportOptions.plist
        cat > ExportOptions.plist << 'EOF'
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>method</key>
            <string>development</string>
            <key>uploadBitcode</key>
            <false/>
            <key>uploadSymbols</key>
            <true/>
        </dict>
        </plist>
        EOF
        
        xcodebuild -exportArchive \
          -archivePath Build/DeepSeek-iOS.xcarchive \
          -exportPath Build/Exported \
          -exportOptionsPlist ExportOptions.plist
    
    - name: Upload IPA
      uses: actions/upload-artifact@v3
      with:
        name: DeepSeek-iOS
        path: Build/Exported/DeepSeek-iOS.ipa
    
    - name: Upload Archive
      uses: actions/upload-artifact@v3
      with:
        name: DeepSeek-iOS-Archive
        path: Build/DeepSeek-iOS.xcarchive
```

## 使用方法

### 1. 推送代码到 GitHub
```bash
cd "H:\桌面存储\deepseek harness\苹果手机端开发"
git init
git add .
git commit -m "Add iOS app"
git remote add origin https://github.com/你的用户名/DeepSeek-iOS.git
git push -u origin main
```

### 2. 触发构建
```
访问 https://github.com/你的用户名/DeepSeek-iOS/actions
点击 "Build iOS App" → "Run workflow"
```

### 3. 下载构建产物
```
等待约 10-15 分钟
在 Actions 页面下载 Artifact（.ipa 文件）
```

### 4. 安装到 iPhone
```
方法 A：使用 TestFlight
- 需要在 App Store Connect 创建应用
- 上传 IPA 并邀请测试人员

方法 B：使用 AltStore
- 将 IPA 发送到电脑
- 使用 AltServer 安装到 iPhone

方法 C：使用 iMazing
- 将 IPA 传输到电脑
- 使用 iMazing 安装到 iPhone
```

## 注意事项

- GitHub Actions 免费额度：每月 2000 分钟
- 构建超时：60 分钟
- 文件大小限制：2GB
- 首次构建需要安装 Xcode，可能需要较长时间
