$defaultPath = "C:\IDEMIA\MFACE_MGMT\central_config\root\MFace\conf\CBP\tvs-config.json"

function Get-ValidPath {
    param ($path)

    if (Test-Path $path) {
        return $path
    }

    Write-Host "Default file not found:" -ForegroundColor Yellow
    Write-Host $path
    Write-Host ""
    $userInput = Read-Host "Paste the full path to tvs-config.json OR the directory containing it"

    if (Test-Path $userInput -PathType Container) {
        $userInput = Join-Path $userInput "tvs-config.json"
    }

    if (!(Test-Path $userInput)) {
        Write-Host "File still not found. Exiting." -ForegroundColor Red
        exit 1
    }

    return $userInput
}

$path = Get-ValidPath $defaultPath
$newHash = Read-Host "Enter the new password hash"

if ([string]::IsNullOrWhiteSpace($newHash)) {
    Write-Host "Password hash cannot be empty." -ForegroundColor Red
    exit 1
}

# Load file raw json
$jsonText = Get-Content $path -Raw

# Match: "password" : "new hash val"
$jsonText = [regex]::Replace($jsonText, '("password"\s*:\s*")[^"]*(")', "`$1$newHash`$2")

# avoiding extra new line at end of file
[System.IO.File]::WriteAllText($path, $jsonText)

Write-Host ""
Write-Host "Password updated successfully at:" -ForegroundColor Green
Write-Host $path

# Ask about Git push
$pushGit = Read-Host "Push changes to git? (y/n)"

if ($pushGit -match '^[Yy]$') {

    # Move from CBP -> conf
    $confDir = Split-Path (Split-Path $path -Parent) -Parent
    Set-Location $confDir

    Write-Host "Working directory set to:" $confDir
    Write-Host ""

    $commitMsg = Read-Host "Enter commit message (default: TVS password change)"

    if ([string]::IsNullOrWhiteSpace($commitMsg)) {
        $commitMsg = "TVS password change"
    }

    git add -A
    git commit -m "$commitMsg"
    git push

    Write-Host ""
    Write-Host "Git push completed." -ForegroundColor Green
}
else {
    Write-Host "Git push skipped."
}

Write-Host ""
Write-Host "Press any key to exit..."
$x = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")