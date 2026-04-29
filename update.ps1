# =====================================================
# HR Skill Hub - 内容更新脚本
# 用途：改完 skills.json 或页面后，一键推送上线
# =====================================================

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir

$msg = Read-Host "📝 本次更新说明（直接回车用默认: 内容更新）"
if ([string]::IsNullOrWhiteSpace($msg)) { $msg = "chore: 内容更新" }

git add .
$status = git status --porcelain
if (-not $status) {
    Write-Host "✅ 工作区干净，无更新可推送" -ForegroundColor Green
    exit 0
}

git commit -m "$msg"
git push origin main

Write-Host "`n🎉 已推送到 GitHub，1-2 分钟后线上更新" -ForegroundColor Green
Write-Host "🌐 https://ttttyu019.github.io/hr-skill-hub/skill-hub.html" -ForegroundColor Cyan
