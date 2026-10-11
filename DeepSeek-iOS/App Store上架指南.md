# 🍎 DeepSeek iOS - App Store 上架完整指南

## 📋 上架前准备清单

### 必需材料
- [ ] Apple Developer 账号（$99/年）
- [ ] App Store Connect 应用信息
- [ ] 应用图标（1024x1024）
- [ ] 截图（多种尺寸）
- [ ] 应用描述文案
- [ ] 隐私政策 URL
- [ ] 分类和标签
- [ ] 年龄分级
- [ ] 构建版本（.ipa）

---

## 第一步：创建 Apple Developer 账号

### 1. 注册账号
访问：https://developer.apple.com/accounts/

**个人账号 vs 组织账号：**

| 类型 | 费用 | 适用场景 | 备注 |
|------|------|----------|------|
| **个人** | $99/年 | 个人开发者、小团队 | 使用个人姓名发布 |
| **组织** | $99/年 | 公司、机构 | 使用公司名称发布 |

**建议：选择个人账号（简单快速）**

### 2. 注册流程
```
1. 访问 https://developer.apple.com
2. 点击 "Member Center" → "Enroll Now"
3. 选择 "Individual" 或 "Organization"
4. 填写个人信息：
   - 姓名（必须与身份证件一致）
   - 邮箱
   - 电话号码
   - 居住地址
5. 验证身份：
   - 个人：上传护照/身份证
   - 组织：上传商业注册文件
6. 支付 $99 年费
7. 等待审核（通常 1-3 工作日）
```

### 3. 加入后需要的信息
- **Team ID**：在 Member Center → Membership 查看
- **Apple ID**：您的开发者邮箱
- **密码**：用于 App Store Connect 登录

---

## 第二步：创建 App Store Connect 应用

### 1. 登录 App Store Connect
访问：https://developer.apple.com/account/resources/apps/list

### 2. 创建新应用
```
1. 点击 "+" 按钮 → "New App"
2. 填写应用信息：
```

### 3. 填写应用元数据

#### 基础信息
```
平台：iOS
名称：DeepSeek AI
主语言：Chinese (Simplified)
Bundle ID：com.agents.dsh.deepseek
SKU：DSH-iOS-001
```

#### 信息
```
描述：DeepSeek AI - 您的随身智能助手

简短描述（170字符内）：
使用 DeepSeek AI 进行智能对话、代码编写和问题解答。支持语音输入、图片分析，让 AI 成为您的得力助手。

完整描述（4000字符内）：
DeepSeek AI 是一款强大的 AI 助手应用，基于先进的 DeepSeek 大语言模型，为您提供智能对话、代码编写、问题解答等全方位服务。

主要功能：
• 智能对话：支持多轮对话，理解上下文，提供精准回答
• 代码执行：内置代码解释器，支持 Python、JavaScript、Bash
• 文件分析：上传图片、PDF、文档，AI 自动分析内容
• 语音输入：实时语音转文字，解放双手
• 多模态交互：文字+图片混合输入，表达能力更强
• 离线使用：本地保存对话历史，随时查阅
• 角色预设：翻译、总结、编程等快捷模板

适用场景：
• 日常问答：知识查询、概念解释、建议推荐
• 学习辅助：题目解答、学习笔记、论文辅导
• 编程开发：代码编写、调试帮助、技术文档
• 内容创作：文案写作、翻译润色、创意构思
• 办公效率：文档摘要、邮件撰写、数据分析

隐私保护：
• API Key 本地加密存储
• 对话数据仅保存在您的设备
• 不收集任何个人信息
• 支持随时清除所有数据

DeepSeek AI - 让智能触手可及！
```

---

## 第三步：准备应用截图

### 所需截图尺寸

| 设备 | 尺寸 | 数量 |
|------|------|------|
| iPhone 6.7" (iPhone 16 Pro Max) | 1290 x 2796 | 至少 1 张 |
| iPhone 6.5" (iPhone 15/14 Pro) | 1290 x 2796 | 建议 1 张 |
| iPhone 6.1" (iPhone 15/14) | 1170 x 2532 | 至少 1 张 |
| iPhone SE (4.7") | 750 x 1334 | 可选 |
| iPad Pro 12.9" | 2048 x 2732 | 可选 |
| iPad Pro 11" | 1668 x 2388 | 可选 |

### 截图要求
- ✅ 格式：PNG 或 JPEG
- ✅ 分辨率：最低 730px 宽，最高 8px 误差
- ✅ 文件大小：每个不超过 6MB
- ✅ 不要包含外部 UI 元素（状态栏、按钮等）
- ✅ 展示核心功能

### 推荐截图内容
1. **登录界面** - 显示品牌和专业感
2. **对话界面** - 展示聊天体验
3. **代码执行** - 展示代码功能
4. **文件分析** - 展示多模态能力
5. **语音输入** - 展示语音功能
6. **设置页面** - 展示个性化选项

### 快速生成截图工具
```bash
# 使用 Xcode 模拟器截图
1. 运行应用到模拟器
2. 使用快捷键：Cmd + S 截图
3. 选择尺寸：Window → Size → 选择设备尺寸

# 或使用第三方工具
- ScreenFlow（Mac）
- SnapIt（Mac）
- ApowerMirror（Windows/Mac）
```

---

## 第四步：准备应用图标

### 图标规格
```
尺寸：1024 x 1024 像素
格式：PNG（带透明通道）
颜色模式：sRGB
文件类型：.png 或 .icns
```

### 设计要点
- ✅ 不要加圆角（Apple 自动处理）
- ✅ 保持简洁，避免过多细节
- ✅ 使用高对比度颜色
- ✅ 测试在不同背景下的可见性

### 图标生成工具
```bash
# 使用 iOS App Icon Generator
https://appicon.co/

# 或使用在线工具
- https://makeappicon.com/
- https://icon.kitchen/
```

### 自动生成脚本
```bash
# 从 1024x1024 源图生成所有尺寸
mkdir -p AppIcon.appiconset
sips -z 120 120 icon.png --out AppIcon/app-icon@2x.png
# ... 更多尺寸
```

---

## 第五步：构建上传版本

### 方法一：Xcode 直接上传（推荐）

```bash
# 1. Archive 构建
xcodebuild archive \
  -workspace DeepSeek-iOS.xcworkspace \
  -scheme DeepSeek-iOS \
  -destination 'generic/platform=iOS' \
  -configuration Release \
  -archivePath Build/DeepSeek-iOS.xcarchive

# 2. 导出 IPA
xcodebuild -exportArchive \
  -archivePath Build/DeepSeek-iOS.xcarchive \
  -exportPath Build/Exported \
  -exportOptionsPlist ExportOptions.plist

# 3. 上传到 App Store
xcrun altool --upload-app \
  --type ios \
  --file Build/Exported/DeepSeek-iOS.ipa \
  --apiKey $API_KEY \
  --apiIssuer $ISSUER_ID
```

### 方法二：Xcode Organizer（最简单）

```
1. 连接 iPhone 或通过 Wi-Fi
2. Product → Archive
3. 等待构建完成
4. Organizer 窗口打开
5. 点击 "Distribute App"
6. 选择 "App Store Connect"
7. 选择 "Upload"
8. 等待上传完成
```

### 方法三：Fastlane（自动化）

```bash
# 安装 Fastlane
brew install fastlane

# 初始化
cd ios && fastlane init

# 上传
fastlane beta  # TestFlight
fastlane release  # App Store
```

---

## 第六步：填写 App Store Connect 详细信息

### 1. 价格与可用性
```
价格表：Free（免费）
地区：全球（或选择特定地区）
```

### 2. 分类
```
主分类：Reference（参考）
副分类：Education（教育）
```

### 3. 年龄分级
```
问卷评估（需逐一回答）

常见问题：
- 是否包含/鼓励赌博？否
- 是否包含不当语言？否
- 是否包含恐怖/威胁内容？否
- 是否包含酒精/毒品？否
- 是否包含成人内容？否

预期评级：4+（所有年龄）
```

### 4. 版权信息
```
版权：© 2026 Agnes AI. All rights reserved.
```

### 5. 支持 URL
```
https://your-website.com/support  # 填写您的支持页面
```

### 6. 营销 URL
```
https://your-website.com  # 可选，填写官网
```

### 7. 隐私政策 URL
```
https://your-website.com/privacy  # 必须提供
```

---

## 第七步：准备审核材料

### 1. 审核备注（重要！）
```
尊敬的审核团队：

本应用是一个 AI 助手应用，用户通过输入自己的 API Key 来使用 Agnes AI 的 API 服务。

注意事项：
1. 应用需要网络连接才能使用
2. 用户必须提供有效的 API Key 才能登录
3. 应用不存储任何用户数据，所有数据仅保存在用户设备本地
4. 应用不会收集任何个人信息

测试账号：无需测试账号，用户需提供自己的 API Key
特殊功能：无

如有任何问题，请随时联系。
```

### 2. 截图标注
```
为每张截图添加简短说明，突出核心功能
```

### 3. 演示视频（可选但推荐）
```
录制 30-60 秒的应用演示视频
展示主要功能和使用流程
上传到 App Store Connect
```

---

## 第八步：提交审核

### 提交前检查清单
```
□ Bundle ID 正确
□ 版本号正确（首次提交用 1.0.0）
□ 构建版本已上传
□ 截图已添加（至少 5 张）
□ 描述文案已完成
□ 隐私政策 URL 已填写
□ 年龄分级问卷已完成
□ 价格与可用性已设置
□ 支持 URL 已填写
□ 内部测试人员已添加（可选）
```

### 提交流程
```
1. 登录 App Store Connect
2. 选择您的应用
3. 左侧菜单：App Review Information
4. 填写所有必填字段
5. 上传截图
6. 填写审核备注
7. 点击 "Add for Review"
8. 选择测试组（可选）
9. 点击 "Submit to Apple Review"
```

---

## 第九步：等待审核

### 审核时间
```
首次提交：1-7 天（通常 2-3 天）
更新版本：1-3 天
```

### 审核状态
```
Waiting for Review（等待审核）
In Review（审核中）
Rejected（被拒绝）→ 查看原因，修改后重新提交
Approved（已批准）→ 准备上线
```

### 常见被拒原因
```
1. 功能问题：应用崩溃、卡顿、功能缺失
2. 内容问题：不当内容、误导性描述
3. 隐私问题：缺少隐私政策、权限使用不当
4. 性能问题：耗电、内存泄漏、启动慢
5. 法律问题：侵犯版权、商标

解决方法：
- 仔细阅读拒审原因
- 逐项修改
- 重新提交并添加解释
```

---

## 第十步：上线发布

### 发布方式
```
1. 自动发布：审核通过后立即上线
2. 手动发布：审核通过后，在 App Store Connect 手动发布
3. 定时发布：设置特定日期和时间上线
```

### 发布后操作
```
1. 监控用户反馈和评分
2. 收集崩溃报告
3. 规划版本更新
4. 推广应用
```

---

## 📱 应用元数据模板

### App Store 标题
```
DeepSeek AI - 智能助手
```

### 关键词（100字符）
```
AI,人工智能,聊天,对话,代码,编程,翻译,助手,问答,写作
```

### 开发者名称
```
Agnes AI
```

### 类别
```
Reference / Education
```

---

## 📝 隐私政策模板

访问您的应用内隐私政策页面，或创建独立网页：

```markdown
# DeepSeek AI 隐私政策

**最后更新日期：2026年1月9日**

## 1. 我们收集的信息

### 1.1 您主动提供的信息
- API Key（存储在设备本地 Keychain）
- 对话内容和历史记录
- 上传的图片和文件

### 1.2 自动收集的信息
- 设备类型和操作系统版本
- 应用使用统计（匿名）
- 错误日志（用于改进应用）

## 2. 信息的使用

- API Key 仅用于连接 Agnes AI 服务
- 对话数据存储在您的设备本地
- 我们不收集、存储或共享您的个人信息

## 3. 信息的存储

- API Key：使用 iOS Keychain 加密存储
- 对话数据：存储在设备本地 SQLite 数据库
- 所有数据不会上传到我们的服务器

## 4. 数据的共享

我们不会与任何第三方共享您的数据。

## 5. 您的权利

- 查看和导出您的对话历史
- 删除所有对话记录
- 退出登录并清除 API Key
- 卸载应用以清除所有本地数据

## 6. 数据安全

- 所有数据传输使用 HTTPS 加密
- API Key 使用 iOS Keychain 安全存储
- 我们采用行业标准的安全措施

## 7. 儿童隐私

本应用不适合 13 岁以下儿童使用。

## 8. 政策的变更

我们将及时更新隐私政策，并在应用内通知您。

## 9. 联系我们

如有任何问题，请联系：
- 邮箱：support@agents.com
- 网站：https://agents.com
```

---

## 🔧 技术配置检查清单

### Xcode 配置
```xml
<!-- Info.plist -->
<key>CFBundleIdentifier</key>
<string>com.agents.dsh.deepseek</string>

<key>CFBundleShortVersionString</key>
<string>1.0.0</string>

<key>CFBundleVersion</key>
<string>1</string>

<key>LSApplicationQueriesSchemes</key>
<array>
    <string>https</string>
    <string>http</string>
</array>
```

### 权限声明
```xml
<!-- 必须在 Info.plist 中添加 -->
<key>NSCameraUsageDescription</key>
<string>此应用需要访问相机以拍摄照片用于 AI 分析</string>

<key>NSMicrophoneUsageDescription</key>
<string>此应用需要访问麦克风以进行语音输入</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>此应用需要访问相册以选择图片</string>
```

### 后台模式
```xml
<!-- 如需要后台下载 -->
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

---

## 📊 审核通过后的操作

### 1. 监控指标
```
- 下载量
- 用户评分
- 崩溃率
- 用户留存
- 评论反馈
```

### 2. 及时响应用户反馈
```
- 回复评论
- 修复 bug
- 收集新功能需求
```

### 3. 规划版本更新
```
- v1.0.1：Bug 修复
- v1.1.0：新功能
- v2.0.0：重大更新
```

---

## 💡 成功上架的关键要点

### 1. 合规性
```
✅ 遵守 Apple 审核指南
✅ 提供完整的隐私政策
✅ 正确使用 API 密钥
✅ 不收集不必要的权限
```

### 2. 用户体验
```
✅ 应用稳定无崩溃
✅ 界面美观易用
✅ 响应速度快
✅ 提供清晰的错误提示
```

### 3. 文档完整性
```
✅ 完整的应用描述
✅ 高质量的截图
✅ 清晰的关键词
✅ 准确的分类和标签
```

---

## 🆘 常见问题解答

### Q: 审核被拒怎么办？
A: 仔细阅读拒审原因，修改后重新提交，并在备注中说明修改内容。

### Q: 如何加快审核速度？
A: 
- 确保应用稳定无 bug
- 提供详细的审核备注
- 添加内部测试人员
- 选择工作日提交

### Q: 审核期间能修改应用吗？
A: 可以，但需要重新构建和上传新版本。

### Q: 如何查看审核进度？
A: 登录 App Store Connect → 您的应用 → 版本信息。

### Q: 审核通过后多久上线？
A: 如果选择自动发布，通常几小时内上线；手动发布则需您手动操作。

---

## 📞 需要帮助？

如果您在审核过程中遇到问题，请告诉我：
1. 具体的拒审原因
2. 应用截图
3. 您的问题描述

我可以帮您：
- ✅ 分析拒审原因
- ✅ 提供修改建议
- ✅ 优化应用描述
- ✅ 重新构建版本
- ✅ 准备申诉材料

---

**祝您审核顺利通过！** 🎉

*如需我帮您生成具体的截图、优化文案或修改代码，请随时告诉我！*
