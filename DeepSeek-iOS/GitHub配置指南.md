# 🚀 GitHub 配置 + iOS 应用构建指南

> 帮您在 Windows 上配置 GitHub 并构建 DeepSeek iOS 应用

---

## 📋 所需材料

- ✅ GitHub 账号（如果没有，先注册：https://github.com/signup）
- ✅ 您的 GitHub 用户名
- ✅ GitHub 个人访问令牌（PAT）

---

## 第一步：创建 GitHub 个人访问令牌（PAT）

### 为什么要用 PAT？
- 比密码更安全
- 可以设置权限范围
- 可以随时撤销

### 创建步骤：

1. **访问 GitHub 设置**
   ```
   打开：https://github.com/settings/tokens
   ```

2. **生成新令牌**
   - 点击 "Generate new token" → "Generate new token (classic)"
   - 填写：
     - **Note**: `DeepSeek-iOS`（或其他描述）
     - **Expiration**: 选择过期时间（建议 90 天）
     - **Select scopes**: 勾选以下权限：
       - ✅ `repo`（仓库访问）
       - ✅ `workflow`（GitHub Actions）
       - ✅ `read:org`（可选）

3. **保存令牌**
   - 点击 "Generate token"
   - **立即复制令牌**（格式：`ghp_xxxxxxxxxxxx`）
   - ⚠️ 令牌只显示一次，务必保存好！

---

## 第二步：安装 GitHub CLI（可选但推荐）

### 安装方法

#### 方法 A：使用 winget（推荐）
```powershell
# 在 PowerShell 中执行
winget install GitHub.cli
```

#### 方法 B：下载安装包
```
访问：https://github.com/cli/cli/releases
下载 Windows 版本并安装
```

#### 方法 C：使用 Chocolatey
```powershell
choco install github-cli
```

### 登录 GitHub
```powershell
# 安装完成后执行
gh auth login

# 按提示操作：
# 1. 选择 HTTPS
# 2. 选择 Login with a web browser
# 3. 在浏览器中登录 GitHub
# 4. 输入验证码
```

---

## 第三步：配置 Git

### 设置用户名和邮箱
```powershell
# 打开 PowerShell，执行：
git config --global user.name "您的GitHub用户名"
git config --global user.email "您的邮箱@example.com"

# 验证配置
git config --global --list
```

### 配置 Git 凭证存储（避免每次输入密码）
```powershell
# 使用凭据管理器（Windows 推荐）
git config --global credential.helper manager

# 或使用缓存（1小时）
git config --global credential.helper 'cache --timeout=3600'
```

---

## 第四步：推送项目到 GitHub

### 1. 进入项目目录
```powershell
cd "H:\桌面存储\deepseek harness\苹果手机端开发"
```

### 2. 初始化 Git 仓库
```powershell
git init
```

### 3. 添加所有文件
```powershell
git add .
```

### 4. 提交更改
```powershell
git commit -m "Initial commit: DeepSeek iOS app with full features"
```

### 5. 创建 GitHub 仓库
```
1. 访问 https://github.com/new
2. 填写：
   - Repository name: DeepSeek-iOS
   - Description: DeepSeek AI iOS Application
   - 选择 Public 或 Private
   - 不要勾选"Initialize this repository with a README"
3. 点击"Create repository"
```

### 6. 推送代码
```powershell
# 替换 YOUR_USERNAME 为您的 GitHub 用户名
git remote add origin https://github.com/YOUR_USERNAME/DeepSeek-iOS.git
git branch -M main
git push -u origin main
```

**如果提示输入用户名和密码：**
- 用户名：您的 GitHub 用户名
- 密码：刚才创建的 PAT 令牌（不是 GitHub 密码！）

---

## 第五步：触发 GitHub Actions 构建

### 1. 查看 Actions
```
访问：https://github.com/YOUR_USERNAME/DeepSeek-iOS/actions
```

### 2. 手动触发构建
```
1. 点击 "Build iOS App"
2. 点击 "Run workflow"
3. 等待 10-15 分钟
```

### 3. 下载构建产物
```
1. 在 Actions 页面找到最新的运行
2. 滚动到 "Artifacts" 部分
3. 下载 "DeepSeek-iOS" 压缩包
4. 解压后得到 .ipa 文件
```

---

## 第六步：安装到 iPhone

### 方法 A：使用 AltStore（推荐）

#### 1. 安装 AltServer 到电脑
```
访问：https://altstore.io/
下载 AltServer for Windows
安装并运行
```

#### 2. 安装 AltStore 到 iPhone
```
1. 用 USB 连接 iPhone 到电脑
2. AltServer 会自动提示安装 AltStore 到 iPhone
3. 在 iPhone 上信任开发者证书
   - 设置 → 通用 → VPN与设备管理 → 信任您的 Apple ID
```

#### 3. 安装 DeepSeek-iOS
```
1. 将下载的 .ipa 文件发送到电脑
2. 在 AltServer 中选择 "Install .ipa"
3. 选择 DeepSeek-iOS.ipa
4. 输入您的免费 Apple ID
5. 等待安装完成
```

### 方法 B：使用 iMazing

#### 1. 下载 iMazing
```
访问：https://www.imazing.cn/
下载并安装
```

#### 2. 安装应用
```
1. 用 USB 连接 iPhone
2. 打开 iMazing
3. 点击 "安装应用"
4. 选择 DeepSeek-iOS.ipa
5. 等待安装完成
```

### 方法 C：使用 TestFlight（需要 App Store Connect）

如果您有 Apple Developer 账号（$99/年）：
```
1. 登录 https://developer.apple.com/account
2. 创建应用
3. 上传 IPA
4. 添加到 TestFlight 测试组
5. 在 iPhone 上安装 TestFlight App
6. 接受邀请并安装
```

---

## 第七步：配置 API Key

### 方法 1：在应用内输入
```
1. 打开 DeepSeek AI
2. 输入 API Key: sk-6wtCS9tQu8tmzyz9kDdTmQlV0wg7FQJBzOIE8seOOc2DeqTs
3. 开始使用！
```

### 方法 2：通过 Xcode 配置环境变量（可选）
```
如果您之后想用 Xcode 重新编译：
1. 打开项目
2. Product → Scheme → Edit Scheme
3. Run → Arguments → Environment Variables
4. 添加: AGNES_API_KEY = sk-6wtCS9tQu8tmzyz9kDdTmQlV0wg7FQJBzOIE8seOOc2DeqTs
```

---

## 🔑 重要信息汇总

### 您需要准备的信息：
```
GitHub 用户名: _________________
GitHub 邮箱: _________________
GitHub PAT:   ghp_xxxxxxxxxxxx（创建后复制保存）
Apple ID:     _________________（用于签名，免费账号即可）
```

### 已为您配置好的信息：
```
API Base URL: https://api.agnes-ai.cn/v1
Model: agnes-2.5-flash
API Key: sk-6wtCS9tQu8tmzyz9kDdTmQlV0wg7FQJBzOIE8seOOc2DeqTs
Bundle ID: com.agents.dsh.deepseek
```

---

## ⚠️ 常见问题解决

### Q1: git push 失败，提示认证错误
```
解决方案：
1. 确保使用 PAT 而不是 GitHub 密码
2. 检查 PAT 是否过期
3. 重新配置凭证：
   git config --global credential.helper manager
   git credential approve
   输入: https://YOUR_USERNAME:YOUR_PAT@github.com
```

### Q2: GitHub Actions 构建失败
```
解决方案：
1. 查看 Actions 页面的错误日志
2. 常见原因：
   - Swift 代码语法错误
   - 缺少依赖
   - Xcode 版本问题
3. 修复后重新推送代码触发构建
```

### Q3: IPA 安装失败
```
解决方案：
1. 确保 iPhone 已信任开发者证书
2. 检查 Apple ID 是否正确
3. 尝试使用不同的安装工具（AltStore/iMazing）
```

### Q4: 应用闪退
```
解决方案：
1. 检查 API Key 是否正确
2. 确认网络连接正常
3. 重新编译并安装
```

---

## 🎯 快速命令清单

```powershell
# 1. 安装 Git（如果还没有）
winget install Git.Git

# 2. 配置 Git
git config --global user.name "YourName"
git config --global user.email "your@email.com"
git config --global credential.helper manager

# 3. 进入项目目录
cd "H:\桌面存储\deepseek harness\苹果手机端开发"

# 4. 初始化并推送
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/DeepSeek-iOS.git
git branch -M main
git push -u origin main

# 5. 等待 GitHub Actions 构建完成
# 6. 下载 IPA 并安装到 iPhone
```

---

## 📞 需要帮助？

请告诉我：
1. 您的 GitHub 用户名是什么？
2. 您在哪个步骤遇到问题？
3. 有什么错误信息？

我可以帮您：
- ✅ 创建 GitHub 仓库
- ✅ 配置 Git
- ✅ 解决构建错误
- ✅ 优化应用代码

---

**现在开始吧！** 🚀
