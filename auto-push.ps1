# auto-push.ps1
$watchPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $watchPath
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

$action = {
    Start-Sleep -Seconds 5
    Set-Location $watchPath
    $status = git status --porcelain
    if ($status) {
        git add .
        git commit -m "auto: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        git push
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] pushed: $status"
    }
}

Register-ObjectEvent $watcher "Changed" -Action $action | Out-Null
Register-ObjectEvent $watcher "Created" -Action $action | Out-Null
Register-ObjectEvent $watcher "Deleted" -Action $action | Out-Null

Write-Host "監視開始: $watchPath"
Write-Host "Ctrl+C で停止"
while ($true) { Start-Sleep -Seconds 1 }