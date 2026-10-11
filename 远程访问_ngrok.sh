#!/bin/bash

echo "========================================"
echo "  DeepSeek Harness 远程访问 - ngrok"
echo "========================================"
echo ""

# 检查 ngrok
if ! command -v ngrok &> /dev/null; then
    echo "[!] ngrok 未安装"
    echo "请访问 https://ngrok.com/download"
    exit 1
fi

# 检查配置
if [ ! -f "$HOME/.ngrok2/ngrok.yml" ]; then
    echo "[!] ngrok 未配置"
    echo ""
    echo "  1. 注册账号: https://ngrok.com/register"
    echo "  2. 获取 Authtoken: https://dashboard.ngrok.com/get-started/your-authtoken"
    echo "  3. 配置: ngrok config add-authtoken YOUR_TOKEN"
    echo ""
    read -p "是否现在配置? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ngrok config add-authtoken
    fi
fi

echo ""
echo "[i] 启动 ngrok..."
echo ""
echo "  访问地址将在终端中显示"
echo "  格式: https://xxxxx.ngrok.io → http://localhost:3080"
echo ""

# 启动 ngrok
ngrok http 3080
