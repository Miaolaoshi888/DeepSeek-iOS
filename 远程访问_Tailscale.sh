#!/bin/bash

echo "========================================"
echo "  DeepSeek Harness 远程访问 - Tailscale"
echo "========================================"
echo ""

# 检查 Tailscale
if ! command -v tailscale &> /dev/null; then
    echo "[!] Tailscale 未安装"
    echo "请访问 https://tailscale.com/download"
    exit 1
fi

# 检查状态
echo "[i] Tailscale 状态:"
tailscale status

# 获取 IP
TAILSCALE_IP=$(tailscale ip -4 | head -1)
if [ -z "$TAILSCALE_IP" ]; then
    echo "[!] 无法获取 Tailscale IP"
    echo "请确保已登录: tailscale login"
    exit 1
fi

echo ""
echo "========================================"
echo "  访问地址"
echo "========================================"
echo ""
echo "  http://${TAILSCALE_IP}:3080"
echo ""
echo "  在任何网络下，使用 iPhone Safari 访问此地址"
echo ""
echo "  提示: 添加到主屏幕获得原生体验"
echo ""
echo "========================================"
