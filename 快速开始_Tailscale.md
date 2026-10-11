# 🚀 5分钟快速开始 - Tailscale 方案

> 最适合您的方案：简单、安全、免费、随时随地访问

---

## 第 1 步：电脑安装 Tailscale（2分钟）

### 下载
1. 打开浏览器访问：**https://tailscale.com/download/windows**
2. 点击 **"Download for Windows"**
3. 运行下载的 `.exe` 文件

### 登录
1. 点击 **"Login"**
2. 选择登录方式：
   - Google 账号（推荐）
   - Microsoft 账号
   - GitHub 账号
   - 企业 SSO
3. 按提示完成登录

### 确认状态
```powershell
tailscale status
```

应该看到类似输出：
```
Connected to tailscale-mail.tailscale.com via tailnet (udp)
Local IP: 100.x.x.x
```

**记录这个 IP 地址！**（如 `100.64.0.1`）

---

## 第 2 步：iPhone 安装 Tailscale（1分钟）

1. 打开 **App Store**
2. 搜索 **"Tailscale"**
3. 点击下载（开发者：Tailscale Inc.）
4. 打开 App，使用**同一个账号**登录
5. 等待几秒，显示 "Connected"

---

## 第 3 步：测试连接（1分钟）

### 确认 DSH 运行中
在电脑浏览器打开：http://localhost:3080
确保能看到 DeepSeek Harness 界面

### iPhone 访问
1. 打开 **Safari**
2. 输入：**http://100.x.x.x:3080**（替换为您电脑的 Tailscale IP）
3. 按回车

✅ 如果看到 DeepSeek Harness 界面，说明成功！

---

## 第 4 步：添加到主屏幕（1分钟）

1. 在 Safari 中保持 DSH 页面打开
2. 点击底部中间的 **分享按钮** ⬆️
3. 向下滑动，找到并点击 **"添加到主屏幕"**
4. 输入名称：`DSH远程` 或 `DeepSeek`
5. 点击右上角 **"添加"**

现在您的主屏幕上有了 DSH 图标！

---

## 完成！🎉

现在您可以：
- ✅ 在任何地方访问家中的 DSH
- ✅ 像原生应用一样使用
- ✅ 完全免费
- ✅ 端到端加密，非常安全

---

## 常见问题

### Q: 电脑休眠后还能访问吗？
A: 不能。需要电脑保持开机。建议：
- 系统设置 → 电源 → 永不休眠
- 或设置合盖不休眠（笔记本）

### Q: 手机耗电吗？
A: Tailscale 后台运行很省电，iPhone 16 Pro Max 影响可忽略。

### Q: 可以同时多人使用吗？
A: 可以！同一账号可以在多台设备登录。

### Q: 别人能访问我的 DSH 吗？
A: 不能。只有登录了您账号的设备才能连接。

### Q: 更换网络后还能访问吗？
A: 可以！Tailscale 会自动切换网络（WiFi ↔ 4G/5G）。

---

## 可选：设置开机自启

1. 打开 Tailscale App
2. 点击设置 ⚙️
3. 开启 **"开机自动启动"**

这样电脑重启后自动连接，您随时可用。

---

## 备用方案：ngrok（应急用）

如果 Tailscale 暂时不可用：

```powershell
# 安装
winget install ngrok.ngrok

# 配置（首次）
ngrok config add-authtoken YOUR_TOKEN

# 启动
ngrok http 3080
```

复制生成的 URL 到 iPhone 即可临时使用。

---

**祝您使用愉快！** 🚀

如有问题，欢迎随时询问。
