# auto-push.ps1 - ポーリング方式
$watchPath = "C:\Users\nonma\Documents\infodashborad"
Set-Location $watchPath
Write-Host "check start: $watchPath"
Write-Host "Ctrl+C stop commund"
$lastHash = ""
while ($true) {
    Start-Sleep -Seconds 5
    $status = git status --porcelain
    $currentHash = ($status | Out-String).Trim()
    
    if ($currentHash -ne "" -and $currentHash -ne $lastHash) {
        $lastHash = $currentHash
        git add .
        git commit -m "auto: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        git pull --no-edit origin main
        git push
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] pushed"
    }
}