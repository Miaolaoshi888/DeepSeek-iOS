# GitHub 快速配置脚本 (PowerShell 版本)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  DeepSeek iOS - GitHub 快速配置" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查 git
try {
    $gitVersion = git --version
    Write-Host "[✓] Git 已安装: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "[!] Git 未安装" -ForegroundColor Red
    Write-Host "请访问 https://git-scm.com/download/win 下载安装" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# 检查项目目录
if (-not (Test-Path "DeepSeek-iOS")) {
    Write-Host "[!] 未找到 DeepSeek-iOS 目录" -ForegroundColor Red
    Write-Host "请确保在正确的项目目录下运行此脚本" -ForegroundColor Yellow
    exit 1
}

Write-Host "[✓] 项目目录存在" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  配置步骤" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 询问 GitHub 用户名
$githubUser = Read-Host "请输入您的 GitHub 用户名"
if ([string]::IsNullOrEmpty($githubUser)) {
    Write-Host "[!] GitHub 用户名不能为空" -ForegroundColor Red
    exit 1
}

# 询问邮箱
$githubEmail = Read-Host "请输入您的 GitHub 邮箱"
if ([string]::IsNullOrEmpty($githubEmail)) {
    Write-Host "[!] 邮箱不能为空" -ForegroundColor Red
    exit 1
}

# 配置 Git
Write-Host ""
Write-Host "[1/4] 配置 Git..." -ForegroundColor Yellow
git config --global user.name $githubUser
git config --global user.email $githubEmail
git config --global credential.helper manager
Write-Host "      ✓ Git 配置完成" -ForegroundColor Green

# 初始化仓库
Write-Host ""
Write-Host "[2/4] 初始化 Git 仓库..." -ForegroundColor Yellow
git init
git add .
git commit -m "Initial commit: DeepSeek iOS app"
Write-Host "      ✓ 仓库初始化完成" -ForegroundColor Green

# 提示创建 GitHub 仓库
Write-Host ""
Write-Host "[3/4] 创建 GitHub 仓库" -ForegroundColor Yellow
Write-Host "      请访问: https://github.com/new"
Write-Host "      填写:"
Write-Host "        - Repository name: DeepSeek-iOS"
Write-Host "        - Description: DeepSeek AI iOS Application"
Write-Host "        - 选择 Public 或 Private"
Write-Host "        - 不要勾选 Initialize this repository with a README"
Write-Host ""

$createRepo = Read-Host "      是否已创建仓库? (y/n)"
if ($createRepo -ne 'y' -and $createRepo -ne 'Y') {
    Write-Host "      请先创建仓库，然后重新运行此脚本" -ForegroundColor Yellow
    exit 0
}

# 提示输入 PAT
Write-Host ""
Write-Host "[4/4] 配置 GitHub 认证" -ForegroundColor Yellow
Write-Host "      请访问: https://github.com/settings/tokens"
Write-Host "      创建新的 Personal Access Token (PAT)"
Write-Host "      权限要求: repo, workflow"
Write-Host ""

# 安全输入 PAT
$pat = Read-Host "      请输入您的 PAT" -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pat)
$patPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

Write-Host ""
Write-Host "正在推送代码到 GitHub..." -ForegroundColor Yellow

# 推送代码
git remote add origin "https://${githubUser}:${patPlain}@github.com/${githubUser}/DeepSeek-iOS.git"
git branch -M main
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  ✓ 推送成功！" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "下一步：" -ForegroundColor Cyan
    Write-Host "1. 访问: https://github.com/${githubUser}/DeepSeek-iOS/actions"
    Write-Host "2. 点击 'Run workflow' 触发构建"
    Write-Host "3. 等待 10-15 分钟后下载 IPA"
    Write-Host "4. 使用 AltStore 或 iMazing 安装到 iPhone"
    Write-Host ""
    Write-Host "GitHub 仓库: https://github.com/${githubUser}/DeepSeek-iOS" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "[!] 推送失败，请检查：" -ForegroundColor Red
    Write-Host "    - GitHub 用户名是否正确" -ForegroundColor Yellow
    Write-Host "    - PAT 是否有正确权限" -ForegroundColor Yellow
    Write-Host "    - 网络连接是否正常" -ForegroundColor Yellow
    Write-Host ""
}
