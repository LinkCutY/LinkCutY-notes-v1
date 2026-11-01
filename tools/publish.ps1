# 一键发布：构建自检 -> commit -> push
# 由 发布.bat 或 VS Code 任务调用
# 注意：这里不能用 ErrorActionPreference = Stop，npm 往 stderr 打字会被当成致命错误
$ErrorActionPreference = 'Continue'
[Console]::OutputEncoding = [Text.Encoding]::UTF8

$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

Write-Host ''
Write-Host '  笔记站 · 发布' -ForegroundColor Cyan
Write-Host '  -------------------------------' -ForegroundColor DarkGray

$changes = git -c core.quotepath=false status --porcelain
if (-not $changes) {
    Write-Host '  没有改动，线上已经是最新的。' -ForegroundColor Yellow
    Write-Host ''
    exit 0
}

Write-Host '  改动：' -ForegroundColor DarkGray
$changes | ForEach-Object { Write-Host ('    ' + $_) -ForegroundColor Gray }
Write-Host ''

Write-Host '  [1/3] 构建自检 ...' -ForegroundColor Cyan
$build = npm run build 2>&1 | Out-String
$code = $LASTEXITCODE
if ($code -ne 0) {
    Write-Host '  构建失败，没有推送。修好再试，错误如下：' -ForegroundColor Red
    Write-Host $build -ForegroundColor DarkRed
    exit 1
}
Write-Host '        OK' -ForegroundColor Green

Write-Host '  [2/3] 提交 ...' -ForegroundColor Cyan
git add -A
$msg = '更新笔记 ' + (Get-Date -Format 'yyyy-MM-dd HH:mm')
$out = git commit -q -m $msg 2>&1 | Out-String
if ($LASTEXITCODE -ne 0) {
    Write-Host '  提交失败：' -ForegroundColor Red
    Write-Host $out -ForegroundColor DarkRed
    exit 1
}
Write-Host ('        ' + $msg) -ForegroundColor Green

Write-Host '  [3/3] 推送到 GitHub ...' -ForegroundColor Cyan
$push = git push 2>&1 | Out-String
if ($LASTEXITCODE -ne 0) {
    Write-Host '  推送失败，检查网络或 GitHub 登录（gh auth status）：' -ForegroundColor Red
    Write-Host $push -ForegroundColor DarkRed
    exit 1
}
Write-Host '        OK' -ForegroundColor Green

Write-Host ''
Write-Host '  约 1 分钟后上线：https://linkcuty.github.io/' -ForegroundColor Cyan
Write-Host '  部署进度：https://github.com/LinkCutY/LinkCutY.github.io/actions' -ForegroundColor DarkGray
Write-Host ''
exit 0
