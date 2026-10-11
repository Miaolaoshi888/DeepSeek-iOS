#!/bin/bash

echo "========================================"
echo "  DeepSeek Harness 远程访问 - Cloudflare"
echo "========================================"
echo ""

# 检查 cloudflared
if ! command -v cloudflared &> /dev/null; then
    echo "[!] cloudflared 未安装"
    echo "请访问 https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/downloads/"
    exit 1
fi

echo "[i] 启动 Cloudflare Tunnel..."
echo ""
echo "  首次使用需要:"
echo "  1. cloudflared tunnel login"
echo "  2. cloudflared tunnel create dsh-tunnel"
echo "  3. cloudflared tunnel route dns dsh-tunnel your-domain.com"
echo ""
echo "  然后运行:"
echo "  cloudflared tunnel run dsh-tunnel --url http://localhost:3080"
echo ""

# 可选：自动启动
read -p "是否现在启动 Tunnel? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    cloudflared tunnel run dsh-tunnel --url http://localhost:3080
fi
