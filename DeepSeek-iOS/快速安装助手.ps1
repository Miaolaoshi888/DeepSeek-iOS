# PowerShell 快速安装脚本 (Windows)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  DeepSeek iOS 免费安装助手 (Windows)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[提示] 在 Windows 上编译 iOS 应用需要 Mac 环境" -ForegroundColor Yellow
Write-Host ""
Write-Host "请选择方案：" -ForegroundColor Green
Write-Host "1. 使用云 Mac 服务（推荐）" -ForegroundColor White
Write-Host "2. 借用朋友的 Mac" -ForegroundColor White
Write-Host "3. 使用 GitHub Actions 云构建" -ForegroundColor White
Write-Host "4. 查看详细文档" -ForegroundColor White
Write-Host "0. 退出" -ForegroundColor White
Write-Host ""

$choice = Read-Host "请输入选项 (0-4)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "推荐云 Mac 服务：" -ForegroundColor Green
        Write-Host "- MacinCloud: https://www.macincloud.com/ (约 $15/月)" -ForegroundColor White
        Write-Host "- AWS EC2 Mac: https://aws.amazon.com/ec2/instance-types/mac/" -ForegroundColor White
        Write-Host ""
        $open = Read-Host "是否打开 MacinCloud? (y/n)"
        if ($open -eq "y") {
            Start-Process "https://www.macincloud.com/"
        }
    }
    "2" {
        Write-Host ""
        Write-Host "借用 Mac 的步骤：" -ForegroundColor Green
        Write-Host "1. 将项目文件夹复制到 Mac" -ForegroundColor White
        Write-Host "2. 用 Xcode 打开项目" -ForegroundColor White
        Write-Host "3. 连接 iPhone 并运行" -ForegroundColor White
        Write-Host ""
    }
    "3" {
        Write-Host ""
        Write-Host "GitHub Actions 云构建：" -ForegroundColor Green
        Write-Host "1. 将代码推送到 GitHub" -ForegroundColor White
        Write-Host "2. Actions 会自动构建" -ForegroundColor White
        Write-Host "3. 下载构建产物" -ForegroundColor White
        Write-Host ""
        $push = Read-Host "是否现在推送代码? (y/n)"
        if ($push -eq "y") {
            Set-Location "H:\桌面存储\deepseek harness\苹果手机端开发"
            git init
            git add .
            git commit -m "Initial commit"
            Write-Host "请将代码推送到 GitHub 仓库" -ForegroundColor Cyan
        }
    }
    "4" {
        Write-Host ""
        Write-Host "打开详细文档..." -ForegroundColor Cyan
        Start-Process "H:\桌面存储\deepseek harness\苹果手机端开发\DeepSeek-iOS\免费安装方案.md"
    }
    "0" {
        Write-Host "退出程序" -ForegroundColor Gray
        exit 0
    }
    default {
        Write-Host "无效选项" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "按任意键退出..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
