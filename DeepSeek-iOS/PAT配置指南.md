# GitHub PAT 配置指南

## 📋 快速步骤（2分钟）

### 第一步：生成 PAT 令牌
1. 打开浏览器，访问：https://github.com/settings/tokens
2. 点击 "Generate new token" → "Generate new token (classic)"
3. 填写：
   - **Note**: `DeepSeek-iOS`
   - **Expiration**: `90 days`
4. 勾选权限（Scopes）：
   - ✅ `repo`（完整仓库权限）
   - ✅ `workflow`（GitHub Actions 权限）
5. 点击 "Generate token"
6. **立即复制令牌**（格式：`ghp_xxxxxxxxxxxx`）
   ⚠️ 令牌只显示一次！

### 第二步：告诉我令牌
把复制的令牌发给我，格式如：
```
ghp_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdef12
```

### 第三步：我帮您完成
我会：
- ✅ 配置 Git
- ✅ 推送代码到 GitHub
- ✅ 触发构建
- ✅ 指导安装到 iPhone

---

## 🔐 为什么用 PAT 而不是密码？

| 对比项 | PAT 令牌 | 密码 |
|--------|----------|------|
| 安全性 | ✅ 高（可设置权限和过期时间） | ❌ 低（全盘访问） |
| 可撤销 | ✅ 随时可撤销 | ❌ 需改密码 |
| 权限控制 | ✅ 精确控制 | ❌ 全部权限 |
| 推荐度 | ⭐⭐⭐⭐⭐ | ⭐⭐ |

---

## ⏱️ 预计时间

- 生成 PAT：1 分钟
- 告诉我令牌：30 秒
- 我帮您配置：2 分钟
- **总计：约 3 分钟**

---

## 🆘 需要帮助？

如果在生成 PAT 时遇到问题，请告诉我：
- 卡在哪一步？
- 看到什么错误信息？

我会帮您解决！😊
