#!/bin/bash

echo "========================================"
echo "  DeepSeek iOS - GitHub 快速配置"
echo "========================================"
echo ""

# 检查 git
if ! command -v git &> /dev/null; then
    echo "[!] Git 未安装"
    echo "请访问 https://git-scm.com/download/win 下载安装"
    exit 1
fi

echo "[✓] Git 已安装"
echo ""

# 检查项目目录
if [ ! -d "DeepSeek-iOS" ]; then
    echo "[!] 未找到 DeepSeek-iOS 目录"
    echo "请确保在正确的项目目录下运行此脚本"
    exit 1
fi

echo "[✓] 项目目录存在"
echo ""

echo "========================================"
echo "  配置步骤"
echo "========================================"
echo ""

# 询问 GitHub 用户名
read -p "请输入您的 GitHub 用户名: " github_user
if [ -z "$github_user" ]; then
    echo "[!] GitHub 用户名不能为空"
    exit 1
fi

# 询问邮箱
read -p "请输入您的 GitHub 邮箱: " github_email
if [ -z "$github_email" ]; then
    echo "[!] 邮箱不能为空"
    exit 1
fi

# 配置 Git
echo ""
echo "[1/4] 配置 Git..."
git config --global user.name "$github_user"
git config --global user.email "$github_email"
git config --global credential.helper manager
echo "      ✓ Git 配置完成"

# 初始化仓库
echo ""
echo "[2/4] 初始化 Git 仓库..."
git init
git add .
git commit -m "Initial commit: DeepSeek iOS app"
echo "      ✓ 仓库初始化完成"

# 提示创建 GitHub 仓库
echo ""
echo "[3/4] 创建 GitHub 仓库"
echo "      请访问: https://github.com/new"
echo "      填写:"
echo "        - Repository name: DeepSeek-iOS"
echo "        - Description: DeepSeek AI iOS Application"
echo "        - 选择 Public 或 Private"
echo "        - 不要勾选 README"
echo ""
read -p "      是否已创建仓库? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "      请先创建仓库，然后重新运行此脚本"
    exit 0
fi

# 提示输入 PAT
echo ""
echo "[4/4] 配置 GitHub 认证"
echo "      请访问: https://github.com/settings/tokens"
echo "      创建新的 Personal Access Token (PAT)"
echo "      权限要求: repo, workflow"
echo ""
read -p "      请输入您的 PAT (会隐藏显示): " pat
echo ""

if [ -z "$pat" ]; then
    echo "[!] PAT 不能为空"
    exit 1
fi

# 推送代码
echo ""
echo "正在推送代码到 GitHub..."
git remote add origin "https://${github_user}:${pat}@github.com/${github_user}/DeepSeek-iOS.git"
git branch -M main
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "========================================"
    echo "  ✓ 推送成功！"
    echo "========================================"
    echo ""
    echo "下一步："
    echo "1. 访问: https://github.com/${github_user}/DeepSeek-iOS/actions"
    echo "2. 点击 'Run workflow' 触发构建"
    echo "3. 等待 10-15 分钟后下载 IPA"
    echo "4. 使用 AltStore 或 iMazing 安装到 iPhone"
    echo ""
    echo "GitHub 仓库: https://github.com/${github_user}/DeepSeek-iOS"
    echo ""
else
    echo ""
    echo "[!] 推送失败，请检查："
    echo "    - GitHub 用户名是否正确"
    echo "    - PAT 是否有正确权限"
    echo "    - 网络连接是否正常"
    echo ""
fi
