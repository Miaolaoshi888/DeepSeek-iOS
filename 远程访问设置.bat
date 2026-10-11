@echo off
chcp 65001 >nul
echo ========================================
echo   DeepSeek Harness 远程访问设置向导
echo ========================================
echo.

:: 检查是否已安装 Tailscale
tailscale status >nul 2>&1
if %errorlevel% equ 0 (
    echo [✓] Tailscale 已安装
    tailscale status
) else (
    echo [!] Tailscale 未安装
    echo.
    echo 请访问 https://tailscale.com/download/windows
    echo 下载并安装 Tailscale
    pause
)

echo.
echo ========================================
echo   Cloudflare Tunnel 配置
echo ========================================
echo.

:: 检查 cloudflared
where cloudflared >nul 2>&1
if %errorlevel% equ 0 (
    echo [✓] cloudflared 已安装
) else (
    echo [!] cloudflared 未安装
    echo 请访问 https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/downloads/
    pause
)

echo.
echo ========================================
echo   ngrok 配置
echo ========================================
echo.

:: 检查 ngrok
where ngrok >nul 2>&1
if %errorlevel% equ 0 (
    echo [✓] ngrok 已安装
    ngrok config list
) else (
    echo [!] ngrok 未安装
    echo 请访问 https://ngrok.com/download
    pause
)

echo.
echo ========================================
echo   快速启动脚本
echo ========================================
echo.
echo 1. 使用 Tailscale（推荐）
echo    - 在 iPhone 和电脑安装 Tailscale
echo    - 使用相同账号登录
echo    - 访问 http://100.x.x.x:3080
echo.
echo 2. 使用 Cloudflare Tunnel
echo    - 运行: cloudflared tunnel run dsh-tunnel --url http://localhost:3080
echo    - 复制生成的 URL 到 iPhone
echo.
echo 3. 使用 ngrok
echo    - 运行: ngrok http 3080
echo    - 复制生成的 URL 到 iPhone
echo.
pause
