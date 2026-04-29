# =====================================================
# HR Skill Hub - GitHub 一键部署脚本
# 仓库：hr-skill-hub (Public)
# 部署后访问：https://ttttyu019.github.io/hr-skill-hub/
# =====================================================

$ErrorActionPreference = "Stop"
$RepoName = "hr-skill-hub"
$GhUser   = "ttttyu019"

Write-Host "`n🚀 HR Skill Hub 一键部署脚本" -ForegroundColor Cyan
Write-Host "================================`n" -ForegroundColor Cyan

# Step 0: 切到 skill-hub 目录
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir
Write-Host "📂 工作目录: $ScriptDir" -ForegroundColor Gray

# Step 1: 检查 gh 登录状态
Write-Host "`n[1/6] 检查 GitHub CLI 登录状态..." -ForegroundColor Yellow
$authStatus = gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ 未登录 GitHub CLI，请先运行：" -ForegroundColor Red
    Write-Host "   gh auth login" -ForegroundColor White
    Write-Host "`n选择 GitHub.com → HTTPS → Login with a web browser，跟着提示走完即可" -ForegroundColor Gray
    exit 1
}
Write-Host "✅ 已登录" -ForegroundColor Green

# Step 2: 初始化 git 仓库（如未初始化）
Write-Host "`n[2/6] 初始化本地 git 仓库..." -ForegroundColor Yellow
if (-not (Test-Path ".git")) {
    git init -b main | Out-Null
    Write-Host "✅ 已初始化" -ForegroundColor Green
} else {
    Write-Host "✅ 已存在 .git，跳过" -ForegroundColor Green
}

# Step 3: 添加并提交文件
Write-Host "`n[3/6] 添加并提交文件..." -ForegroundColor Yellow
git add .
$status = git status --porcelain
if ($status) {
    git commit -m "feat: HR Skill Hub v1.1 - with local memory" | Out-Null
    Write-Host "✅ 已提交" -ForegroundColor Green
} else {
    Write-Host "✅ 工作区干净，无需提交" -ForegroundColor Green
}

# Step 4: 创建 GitHub 仓库（若不存在）
Write-Host "`n[4/6] 创建/连接 GitHub 仓库 $GhUser/$RepoName ..." -ForegroundColor Yellow
$repoExists = gh repo view "$GhUser/$RepoName" 2>$null
if ($LASTEXITCODE -ne 0) {
    gh repo create "$RepoName" --public --source=. --remote=origin --description "HR 团队专属 AI 能力索引中心 by 章老师" --push
    Write-Host "✅ 仓库已创建并推送" -ForegroundColor Green
} else {
    Write-Host "✅ 仓库已存在，配置 remote 并推送" -ForegroundColor Green
    $remoteExists = git remote 2>$null | Select-String -Pattern "^origin$"
    if (-not $remoteExists) {
        git remote add origin "https://github.com/$GhUser/$RepoName.git"
    }
    git push -u origin main
}

# Step 5: 开启 GitHub Pages
Write-Host "`n[5/6] 开启 GitHub Pages..." -ForegroundColor Yellow
gh api -X POST "repos/$GhUser/$RepoName/pages" -f "source[branch]=main" -f "source[path]=/" 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Pages 已开启" -ForegroundColor Green
} else {
    # 可能已开启，尝试更新
    gh api -X PUT "repos/$GhUser/$RepoName/pages" -f "source[branch]=main" -f "source[path]=/" 2>$null | Out-Null
    Write-Host "✅ Pages 配置已更新（或已存在）" -ForegroundColor Green
}

# Step 6: 输出访问链接
Write-Host "`n[6/6] 完成！" -ForegroundColor Green
Write-Host "`n=====================================================" -ForegroundColor Cyan
Write-Host "🎉 部署成功！" -ForegroundColor Green
Write-Host "`n📍 仓库地址：" -ForegroundColor White
Write-Host "   https://github.com/$GhUser/$RepoName" -ForegroundColor Cyan
Write-Host "`n🌐 Hub 访问地址（约 1-2 分钟后可访问）：" -ForegroundColor White
Write-Host "   https://$GhUser.github.io/$RepoName/skill-hub.html" -ForegroundColor Cyan
Write-Host "`n💡 后续更新：改完文件后双击 update.ps1 即可" -ForegroundColor Gray
Write-Host "=====================================================`n" -ForegroundColor Cyan
