# 🎯 Windows 用户 - 30 分钟快速上手

> 没有 Mac？没问题！30 分钟内在 iPhone 上运行 DeepSeek AI

---

## ⚡ 最快方案（推荐）

### 选择方案一：GitHub Actions（完全免费）

#### 第 1 步：创建 GitHub 账号（5分钟）
```
1. 访问 https://github.com/signup
2. 填写邮箱、密码
3. 验证邮箱
4. 完成注册（免费）
```

#### 第 2 步：推送代码到 GitHub（5分钟）
```powershell
# 在 Windows PowerShell 中执行
cd "H:\桌面存储\deepseek harness\苹果手机端开发"

# 初始化 Git
git init
git add .
git commit -m "Initial commit"

# 创建远程仓库（在 GitHub 网站上操作）
# 访问 https://github.com/new
# 创建新仓库，名称：DeepSeek-iOS

# 推送代码
git remote add origin https://github.com/你的用户名/DeepSeek-iOS.git
git branch -M main
git push -u origin main
```

#### 第 3 步：触发自动构建（2分钟）
```
1. 访问 https://github.com/你的用户名/DeepSeek-iOS/actions
2. 点击 "Build iOS App"
3. 点击 "Run workflow"
4. 等待 10-15 分钟
```

#### 第 4 步：下载 IPA 文件（2分钟）
```
1. 在 Actions 页面，点击最新的运行
2. 向下滚动到 "Artifacts" 部分
3. 下载 "DeepSeek-iOS" 压缩包
4. 解压后得到 .ipa 文件
```

#### 第 5 步：安装到 iPhone（5分钟）

**方法 A：使用 AltStore（推荐）**
```
1. 下载 AltServer：https://altstore.io/
2. 安装到电脑并运行
3. 用 USB 连接 iPhone
4. AltServer 会自动安装 AltStore 到 iPhone
5. 打开 iPhone 上的 AltStore
6. 将 .ipa 文件发送到电脑
7. 在 AltServer 中选择 "Install .ipa"
8. 输入您的免费 Apple ID
9. 等待安装完成
```

**方法 B：使用 iMazing**
```
1. 下载 iMazing：https://www.imazing.cn/
2. 安装并运行
3. 连接 iPhone
4. 点击"安装应用"
5. 选择 .ipa 文件
6. 等待安装完成
```

**方法 C：使用 TestFlight（需要 Apple ID）**
```
1. 在 App Store 下载 TestFlight
2. 需要将 IPA 上传到 App Store Connect
3. 创建测试组并邀请
4. 在 TestFlight 中接受邀请并安装
```

#### 第 6 步：信任开发者证书（1分钟）
```
1. 打开 iPhone"设置"
2. 进入"通用" → "VPN与设备管理"
3. 找到您的 Apple ID
4. 点击"信任"
5. 完成！
```

#### 第 7 步：开始使用（1分钟）
```
1. 打开 DeepSeek AI
2. 输入 API Key: sk-6wtCS9tQu8tmzyz9kDdTmQlV0wg7FQJBzOIE8seOOc2DeqTs
3. 开始对话！
```

---

## ⏱️ 时间统计

| 步骤 | 时间 |
|------|------|
| 创建 GitHub 账号 | 5 分钟 |
| 推送代码 | 5 分钟 |
| 触发构建 | 2 分钟（等待 10-15 分钟） |
| 下载 IPA | 2 分钟 |
| 安装到 iPhone | 5 分钟 |
| 信任证书 | 1 分钟 |
| **总计** | **约 30 分钟** |

---

## 🔄 如何更新应用

### 修改代码后
```
1. 修改代码
2. git add .
3. git commit -m "Update: xxx"
4. git push
5. 在 GitHub Actions 触发新的构建
6. 下载新的 IPA
7. 重新安装到 iPhone
```

---

## 💡 重要提示

### 免费 Apple ID 限制
```
✅ 可以在自己的设备上运行
✅ 最多 3 台设备
✅ 每 7 天需要重新签名（重新安装即可）
❌ 无法上架 App Store
```

### 如何避免 7 天过期
```
方法 1：每次更新代码后重新安装
方法 2：使用 AltStore 自动续签（需要电脑保持开机）
方法 3：每周手动重新安装一次
```

---

## 🆘 常见问题

### Q: GitHub Actions 构建失败？
A: 
- 检查代码是否有语法错误
- 查看 Actions 页面的错误日志
- 确保所有 Swift 文件都在项目中

### Q: 无法下载 IPA？
A: 
- 确认构建成功（绿色对勾）
- 刷新页面重新下载
- 清除浏览器缓存

### Q: 安装后闪退？
A: 
- 检查 API Key 是否正确
- 确认网络连接正常
- 重新安装应用

### Q: 签名过期怎么办？
A: 
- 重新运行 GitHub Actions
- 下载新的 IPA
- 重新安装到 iPhone

---

## 🎉 完成！

现在您已经在 iPhone 上运行了 DeepSeek AI！

**随时可以：**
- 发送消息给 AI
- 上传文件进行分析
- 执行代码
- 使用语音输入

---

## 📞 遇到问题？

告诉我：
1. 卡在哪个步骤？
2. 有什么错误信息？
3. 您选择哪个方案？

我会帮您解决！ 😊
