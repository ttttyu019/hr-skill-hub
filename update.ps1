# =====================================================
# HR Skill Hub - Daily Update Script
# Usage: Double-click this file after editing files
# =====================================================

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir

Write-Host ""
Write-Host "[Skill Hub] Update & Push" -ForegroundColor Cyan
Write-Host "===========================" -ForegroundColor Cyan

git add .
$status = git status --porcelain
if (-not $status) {
    Write-Host "[OK] Working tree clean. Nothing to push." -ForegroundColor Green
    Read-Host "Press Enter to exit"
    exit 0
}

Write-Host ""
Write-Host "[Changes detected]" -ForegroundColor Yellow
git status --short

$msg = Read-Host "`nCommit message (Enter for default)"
if (-not $msg) {
    $msg = "chore: content update " + (Get-Date -Format "yyyy-MM-dd HH:mm")
}

git commit -m "$msg"
git push

Write-Host ""
Write-Host "[Done] Pushed to GitHub. Pages will rebuild in ~1 min." -ForegroundColor Green
Write-Host "URL: https://ttttyu019.github.io/hr-skill-hub/skill-hub.html" -ForegroundColor Cyan
Write-Host ""
Read-Host "Press Enter to exit"
