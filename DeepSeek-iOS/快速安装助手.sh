#!/bin/bash

echo "========================================"
echo "  DeepSeek iOS 免费安装助手"
echo "========================================"
echo ""

# 检查系统
echo "[检查] 系统环境..."

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "[✓] macOS 系统"
    
    # 检查 Xcode
    if command -v xcodebuild &> /dev/null; then
        echo "[✓] Xcode 已安装"
        xcodebuild -version
    else
        echo "[!] Xcode 未安装"
        echo "    请从 App Store 免费下载 Xcode"
        read -p "    是否打开 App Store? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            open https://apps.apple.com/cn/app/xcode/id497799835
        fi
        exit 1
    fi
    
    # 检查 iOS SDK
    echo "[✓] iOS SDK 已安装"
    
else
    echo "[!] 检测到 Windows 系统"
    echo ""
    echo "    免费安装需要 Mac 环境"
    echo "    可选方案："
    echo "    1. 使用云 Mac 服务（如 MacinCloud）"
    echo "    2. 借用朋友的 Mac"
    echo "    3. 使用 GitHub Actions 云构建"
    echo ""
    read -p "    是否查看云 Mac 推荐? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        open https://www.macincloud.com/
    fi
    exit 1
fi

echo ""
echo "========================================"
echo "  准备工作完成"
echo "========================================"
echo ""
echo "下一步："
echo "1. 用 Xcode 打开项目"
echo "   open \"H:/桌面存储/deepseek harness/苹果手机端开发/DeepSeek-iOS.xcodeproj\""
echo ""
echo "2. 连接 iPhone 并信任此电脑"
echo ""
echo "3. 在 Xcode 中选择您的设备并运行"
echo ""
