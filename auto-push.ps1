# auto-push.ps1 - ポーリング方式
$watchPath = "C:\Users\nonma\Documents\infodashborad"

Set-Location $watchPath
Write-Host "監視開始: $watchPath"
Write-Host "Ctrl+C で停止"

$lastHash = ""

while ($true) {
    Start-Sleep -Seconds 5
    $status = git status --porcelain
    $currentHash = ($status | Out-String).Trim()
    
    if ($currentHash -ne "" -and $currentHash -ne $lastHash) {
        $lastHash = $currentHash
        git add .
        git commit -m "auto: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        git push
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] pushed"
    }
}