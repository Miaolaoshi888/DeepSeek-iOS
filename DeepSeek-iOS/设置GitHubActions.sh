#!/bin/bash

echo "========================================"
echo "  DeepSeek iOS - GitHub Actions 设置"
echo "========================================"
echo ""

# 检查 git
if ! command -v git &> /dev/null; then
    echo "[!] Git 未安装"
    echo "请访问 https://git-scm.com/download/win 下载安装"
    exit 1
fi

echo "[✓] Git 已安装"

# 检查项目目录
if [ ! -d "DeepSeek-iOS" ]; then
    echo "[!] 未找到 DeepSeek-iOS 目录"
    echo "请确保在正确的项目目录下运行此脚本"
    exit 1
fi

echo "[✓] 项目目录存在"
echo ""

echo "========================================"
echo "  设置步骤"
echo "========================================"
echo ""

echo "1. 初始化 Git 仓库"
git init
git add .
git commit -m "Initial commit: DeepSeek iOS app"

echo ""
echo "2. 创建 GitHub 仓库"
echo "   请访问 https://github.com/new"
echo "   填写仓库信息并创建"
echo ""

read -p "是否已创建 GitHub 仓库? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    read -p "请输入您的 GitHub 用户名: " github_user
    read -p "请输入仓库名称 (默认: DeepSeek-iOS): " repo_name
    repo_name=${repo_name:-DeepSeek-iOS}
    
    echo ""
    echo "3. 推送代码到 GitHub"
    git remote add origin "https://github.com/${github_user}/${repo_name}.git"
    git branch -M main
    git push -u origin main
    
    echo ""
    echo "✓ 代码已推送！"
    echo ""
    echo "4. 配置 GitHub Actions"
    echo "   访问: https://github.com/${github_user}/${repo_name}/actions"
    echo "   点击 'Run workflow' 触发首次构建"
    echo ""
    echo "5. 下载构建产物"
    echo "   构建完成后，在 Actions 页面下载 .ipa 文件"
    echo ""
    echo "6. 安装到 iPhone"
    echo "   使用 AltStore 或 iMazing 安装 IPA"
    echo ""
else
    echo "请先创建 GitHub 仓库，然后重新运行此脚本"
fi

echo ""
echo "========================================"
echo "  完成！"
echo "========================================"
echo ""
