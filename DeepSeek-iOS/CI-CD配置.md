# DeepSeek iOS 应用 - CI/CD 配置

## GitHub Actions 自动构建

### 1. 创建 workflow 文件

在项目根目录创建 `.github/workflows/build-ios.yml`:

```yaml
name: Build iOS App

on:
  push:
    branches: [ main, master ]
  pull_request:
    branches: [ main, master ]
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
    
    - name: Restore Pods cache
      uses: actions/cache@v3
      with:
        path: Pods
        fallback-key: ios-pods-cache
    
    - name: Install Dependencies
      run: pod install --repo-update
      working-directory: ios
    
    - name: Build for Simulator
      run: |
        xcodebuild build \
          -workspace DeepSeek-iOS.xcworkspace \
          -scheme DeepSeek-iOS \
          -destination 'platform=iOS Simulator,name=iPhone 16 Pro Max' \
          -configuration Debug \
          CODE_SIGNING_ALLOWED=NO
      
    - name: Run Tests
      run: |
        xcodebuild test \
          -workspace DeepSeek-iOS.xcworkspace \
          -scheme DeepSeek-iOS \
          -destination 'platform=iOS Simulator,name=iPhone 16 Pro Max' \
          -configuration Debug \
          CODE_SIGNING_ALLOWED=NO \
          ONLY_ACTIVE_ARCH=YES
      
    - name: Archive for Distribution
      run: |
        xcodebuild archive \
          -workspace DeepSeek-iOS.xcworkspace \
          -scheme DeepSeek-iOS \
          -destination 'generic/platform=iOS' \
          -configuration Release \
          -archivePath Build/DeepSeek-iOS.xcarchive \
          CODE_SIGNING_ALLOWED=YES \
          CODE_SIGN_IDENTITY="iPhone Developer" \
          PROVISIONING_PROFILE_SPECIFIER="DeepSeek-iOS"*
      
    - name: Export IPA
      run: |
        xcodebuild -exportArchive \
          -archivePath Build/DeepSeek-iOS.xcarchive \
          -exportPath Build/Exported \
          -exportOptionsPlist ExportOptions.plist
      
    - name: Upload Artifact
      uses: actions/upload-artifact@v3
      with:
        name: DeepSeek-iOS
        path: Build/Exported/DeepSeek-iOS.ipa
    
    - name: Upload to TestFlight
      if: github.ref == 'refs/heads/main'
      run: |
        xcrun altool --upload-app \
          --type ios \
          --file Build/Exported/DeepSeek-iOS.ipa \
          --apiKey YOUR_API_KEY \
          --apiIssuer YOUR_ISSUER_ID
```

### 2. 创建 ExportOptions.plist

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>uploadBitcode</key>
    <false/>
    <key>uploadSymbols</key>
    <true/>
    <key>compileBitcode</key>
    <false/>
</dict>
</plist>
```

## Fastlane 配置

### 1. 创建 Fastfile

```ruby
default_platform(:ios)

platform :ios do
  desc "Build and test iOS app"
  lane :build do
    build_app(
      workspace: "DeepSeek-iOS.xcworkspace",
      scheme: "DeepSeek-iOS",
      configuration: "Debug",
      skip_build_package: true,
      skip_archive: false
    )
  end
  
  desc "Run tests"
  lane :test do
    test(
      workspace: "DeepSeek-iOS.xcworkspace",
      scheme: "DeepSeek-iOS",
      destination: "platform=iOS Simulator,name=iPhone 16 Pro Max",
      skip_build: true
    )
  end
  
  desc "Deploy to TestFlight"
  lane :beta do
    build_app(
      workspace: "DeepSeek-iOS.xcworkspace",
      scheme: "DeepSeek-iOS",
      configuration: "Release",
      export_options: {
        method: "app-store"
      }
    )
    
    upload_to_testflight(
      skip_waiting_for_build_processing: false
    )
  end
  
  desc "Submit to App Store"
  lane :release do
    build_app(
      workspace: "DeepSeek-iOS.xcworkspace",
      scheme: "DeepSeek-iOS",
      configuration: "Release",
      export_options: {
        method: "app-store"
      }
    )
    
    upload_to_app_store(
      skip_metadata: false,
      skip_screenshots: true,
      submit_for_review: true
    )
  end
end
```

### 2. 安装 Fastlane

```bash
# 安装
bundle install

# 或
brew install fastlane
```

## 本地构建命令

### 基础构建
```bash
# 清理
xcodebuild clean -scheme DeepSeek-iOS

# 构建模拟器
xcodebuild build \
  -scheme DeepSeek-iOS \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro Max' \
  -configuration Debug

# 构建真机
xcodebuild build \
  -scheme DeepSeek-iOS \
  -destination 'platform=iOS' \
  -configuration Release
```

### Archive 导出
```bash
# Archive
xcodebuild archive \
  -scheme DeepSeek-iOS \
  -destination 'generic/platform=iOS' \
  -archivePath Build/DeepSeek-iOS.xcarchive

# Export IPA
xcodebuild -exportArchive \
  -archivePath Build/DeepSeek-iOS.xcarchive \
  -exportPath Build/Exported \
  -exportOptionsPlist ExportOptions.plist
```

## 环境变量配置

在 GitHub Actions 中添加以下 Secrets:

- `APPLE_ID`: Apple ID 邮箱
- `APPLE_APP_PASSWORD`: App 专用密码
- `TEAM_ID`: Team ID
- `API_KEY_ID`: API Key ID
- `API_KEY_ISSUER_ID`: API Key Issuer ID

## 常见问题

### 签名问题
确保在 Xcode 中配置正确的 Bundle ID 和签名证书。

### 模拟器 vs 真机
- 模拟器: `-destination 'platform=iOS Simulator,name=iPhone 16 Pro Max'`
- 真机: `-destination 'platform=iOS'`

### 测试分布
使用 TestFlight 邀请测试人员，无需上架 App Store。
