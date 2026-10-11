# 🖥️ Windows 用户专属：免费安装 DeepSeek iOS 应用

> 无需 Mac，无需付费，直接运行在 iPhone 上

---

## 🎯 推荐方案对比

| 方案 | 费用 | 难度 | 稳定性 | 推荐度 |
|------|------|------|--------|--------|
| **方案一：云 Mac 租赁** | 免费试用/低价 | ⭐⭐ 简单 | ⭐⭐⭐⭐ 稳定 | ⭐⭐⭐⭐⭐ |
| **方案二：GitHub Actions 构建** | 免费 | ⭐⭐ 简单 | ⭐⭐⭐ 稳定 | ⭐⭐⭐⭐⭐ |
| **方案三：AltStore + Windows** | 免费 | ⭐⭐⭐ 中等 | ⭐⭐⭐ 稳定 | ⭐⭐⭐⭐ |
| **方案四：借用他人 Mac** | 免费 | ⭐ 极简 | ⭐⭐⭐⭐⭐ 最稳定 | ⭐⭐⭐⭐⭐ |

---

## 🏆 方案一：云 Mac 租赁（推荐新手）

### 优点
- ✅ 完全在线，无需本地安装
- ✅ 有免费试用（通常 1-2 小时）
- ✅ 像使用自己的 Mac 一样操作

### 推荐服务

#### 1. MacinCloud（最推荐）
```
网址：https://www.macincloud.com/
免费试用：30 分钟
付费价格：约 $6-15/月
优势：
- 操作简单，有详细教程
- 永久云存储
- 支持远程连接
```

#### 2. AWS EC2 Mac（专业用户）
```
网址：https://aws.amazon.com/ec2/instance-types/mac/
价格：按小时计费（约 $0.5-1/小时）
优势：
- 按实际使用时间付费
- 性能强大
- 适合长期开发
```

### 详细步骤

#### 第 1 步：注册云 Mac 服务
```
1. 访问 https://www.macincloud.com/
2. 点击"Get Started"或"Free Trial"
3. 注册账号（需要邮箱）
4. 选择免费试用套餐
```

#### 第 2 步：连接到云 Mac
```
1. 登录后进入控制台
2. 点击"Launch Mac"启动虚拟机
3. 等待几分钟启动完成
4. 使用浏览器或专用客户端连接桌面
```

#### 第 3 步：安装 Xcode
```
1. 打开云 Mac 上的 App Store
2. 搜索"Xcode"
3. 点击获取，下载安装（约 10GB，需要等待）
4. 安装完成后打开 Xcode，同意许可协议
```

#### 第 4 步：传输项目文件
```
方法 A：Git 推送（推荐）
在 Windows 上执行：
cd "H:\桌面存储\deepseek harness\苹果手机端开发"
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/你的用户名/DeepSeek-iOS.git
git push -u origin main

在云 Mac 上执行：
git clone https://github.com/你的用户名/DeepSeek-iOS.git
```

```
方法 B：网盘传输
1. 在 Windows 上压缩项目文件夹为 .zip
2. 上传到百度网盘/Google Drive
3. 在云 Mac 上下载并解压
```

#### 第 5 步：编译和运行
```
1. 打开云 Mac 上的 Xcode
2. File → Open → 选择 DeepSeek-iOS.xcodeproj
3. 用 USB 连接您的 iPhone 到云 Mac（需要 USB 中继）
   或者通过 Wi-Fi 调试
4. 选择您的 iPhone 设备
5. 点击 Run ▶️
6. 应用自动安装到 iPhone
```

#### 第 6 步：配置 API Key
```
方法 A：在应用内输入
1. 打开 iPhone 上的 DeepSeek AI
2. 输入 API Key: sk-6wtCS9tQu8tmzyz9kDdTmQlV0wg7FQJBzOIE8seOOc2DeqTs

方法 B：配置环境变量（推荐）
在 Xcode 中：
Product → Scheme → Edit Scheme
Run → Arguments → Environment Variables
添加: AGNES_API_KEY = sk-6wtCS9tQu8tmzyz9kDdTmQlV0wg7FQJBzOIE8seOOc2DeqTs
```

---

## 🥈 方案二：GitHub Actions 云构建（完全免费）

### 优点
- ✅ 完全免费，无需购买任何东西
- ✅ 自动构建，无需手动操作
- ✅ 构建完成后直接下载 IPA

### 详细步骤

#### 第 1 步：创建 GitHub 仓库
```bash
# 在 Windows 上打开 PowerShell
cd "H:\桌面存储\deepseek harness\苹果手机端开发"

# 初始化 Git
git init
git add .
git commit -m "Initial commit"

# 创建 GitHub 仓库（访问 https://github.com 新建）
git remote add origin https://github.com/你的用户名/DeepSeek-iOS.git
git push -u origin main
```

#### 第 2 步：创建 CI/CD 配置文件
在项目根目录创建 `.github/workflows/build.yml`：

```yaml
name: Build iOS App

on:
  push:
    branches: [ main ]
  workflow_dispatch:  # 允许手动触发

jobs:
  build:
    runs-on: macos-latest
    
    steps:
    - name: Checkout
      uses: actions/checkout@v4
    
    - name: Set up Xcode
      run: sudo xcode-select -switch /Applications/Xcode_15.0.app
    
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
    
    - name: Upload Artifact
      uses: actions/upload-artifact@v3
      with:
        name: DeepSeek-iOS-Archive
        path: Build/DeepSeek-iOS.xcarchive
```

#### 第 3 步：触发构建
```
1. 推送到 GitHub 后，Actions 自动运行
2. 或手动触发：Actions 标签 → Build iOS App → Run workflow
3. 等待约 10-15 分钟
4. 构建完成后，下载 Artifact
```

#### 第 4 步：安装到 iPhone
```
下载后的文件是 .xcarchive，需要转换为 .ipa：

方法 A：使用 Xcode（需要 Mac）
方法 B：使用第三方工具（见下方）
方法 C：使用在线转换服务
```

**转换 IPA 的工具：**
```
1. iMazing（免费）
   https://www.imazing.cn/
   
2. Apple Configurator 2
   https://apps.apple.com/app/apple-configurator-2/id1037126344

3. 命令行工具
   xcodebuild -exportArchive \
     -archivePath Build/DeepSeek-iOS.xcarchive \
     -exportPath Build/Exported \
     -exportOptionsPlist ExportOptions.plist
```

---

## 🥉 方案三：AltStore + Windows（技术爱好者）

### 前提条件
```
- 一台始终开机的电脑（可以是你的 Windows PC）
- 免费的 Apple ID（不需要付费账号）
- AltServer 软件
```

### 详细步骤

#### 第 1 步：安装 AltServer
```
1. 访问 https://altstore.io/
2. 下载 AltServer for Windows
3. 安装并运行
4. 登录您的免费 Apple ID
```

#### 第 2 步：安装 AltStore 到 iPhone
```
1. 用 USB 连接 iPhone 到电脑
2. AltServer 会自动提示安装 AltStore 到 iPhone
3. 在 iPhone 上信任开发者证书
4. 打开 iPhone 上的 AltStore
```

#### 第 3 步：在 Windows 上编译（需要特殊环境）
```
由于 Windows 无法直接编译 iOS 应用，您需要：

方案 A：使用 Docker（需要 Linux 环境）
方案 B：使用在线构建服务
方案 C：使用云 Mac（推荐）

或者，您可以：
1. 让有 Mac 的朋友帮您编译一次
2. 将编译好的 .ipa 文件传输到您的电脑
3. 使用 AltStore 安装到 iPhone
```

---

## 🏅 方案四：借用他人 Mac（最简单）

### 优点
- ✅ 完全免费
- ✅ 最稳定的方案
- ✅ 无需额外软件

### 步骤
```
1. 找一个有 Mac 的朋友
2. 将整个项目文件夹复制给他
3. 让他用 Xcode 打开并运行到您的 iPhone
4. 完成！
```

---

## 🎯 我的建议

### 如果您是新手
```
推荐：方案一（云 Mac 租赁）
原因：
- 有免费试用，可以先体验
- 操作简单，有详细教程
- 像使用自己的电脑一样
```

### 如果您懂一些技术
```
推荐：方案二（GitHub Actions）
原因：
- 完全免费
- 自动化程度高
- 适合长期维护
```

### 如果您有朋友有 Mac
```
推荐：方案四（借用 Mac）
原因：
- 最简单
- 最稳定
- 完全免费
```

---

## 📋 完整操作流程（以云 Mac 为例）

### Day 1：准备工作
```
□ 注册 MacinCloud 账号
□ 领取免费试用
□ 连接到云 Mac
□ 安装 Xcode（约 1-2 小时下载）
□ 将项目上传到 GitHub
```

### Day 2：编译应用
```
□ 在云 Mac 上 clone 项目
□ 用 Xcode 打开项目
□ 配置签名（使用免费 Apple ID）
□ 连接 iPhone 并运行
□ 应用自动安装到 iPhone
```

### Day 3：开始使用
```
□ 打开 iPhone 上的 DeepSeek AI
□ 输入 API Key
□ 开始使用！
```

---

## 💡 常见问题

### Q: 云 Mac 免费试用够吗？
A: 够的！安装 Xcode 需要一些时间，但试用时间足够完成编译。

### Q: 如何保持应用签名有效？
A: 
- 方法 1：定期（7天内）重新编译安装
- 方法 2：使用 AltStore 自动续签
- 方法 3：保持云 Mac 在线，定期触发重新构建

### Q: 没有 Mac 真的能编译 iOS 应用吗？
A: 可以！通过云 Mac 或 GitHub Actions，都在云端 Mac 上编译。

### Q: 编译失败怎么办？
A: 
- 检查 Xcode 版本（需要 15.0+）
- 检查 iOS SDK 是否安装
- 查看错误日志，逐项解决

---

## 🚀 立即开始

### 最快的路径（30分钟）
```
1. 访问 https://www.macincloud.com/ 注册
2. 领取免费试用
3. 连接到云 Mac
4. 安装 Xcode
5. 编译并运行
6. 在 iPhone 上使用
```

### 免费的持续方案
```
1. 推送代码到 GitHub
2. 配置 GitHub Actions
3. 自动构建
4. 下载 IPA
5. 安装到 iPhone
```

---

## 📞 需要帮助？

请告诉我：
1. 您选择哪个方案？
2. 卡在哪一步？
3. 遇到了什么错误？

我可以：
- ✅ 提供详细图文教程
- ✅ 远程指导操作
- ✅ 帮您分析错误
- ✅ 提供替代方案

---

**没有 Mac 也能用！让我们开始吧！** 🎉
