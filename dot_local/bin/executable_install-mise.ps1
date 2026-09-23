# install-mise.ps1

# Suppress default web request info
$ProgressPreference = "SilentlyContinue"

# Progress outputs
function Step($msg) { Write-Host "==> $msg" -ForegroundColor Cyan }
function Done($msg) { Write-Host "  [OK] $msg" -ForegroundColor Green }

# Get the latest mise release info from GitHub's API
Step "Fetching latest release info"
$releastUrl = "https://api.github.com/repos/jdx/mise/releases/latest"
$release = Invoke-RestMethod -Uri $releastUrl
Done "Found version $($release.tag_name)"

# Find the Windows x64 asset
$asset = $release.assets | Where-Object { $_.name -like "mise-*-windows-x64.zip" }
if (-not $asset) { throw "Could not find a Windows x64 asset in this release." }

# Download asset
Step "Downloading $($asset.name)"
$tempZipPath = Join-Path "$env:TEMP" "$($asset.name)"
Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $tempZipPath
Done "Download complete"

# Extract asset to install path
$localappdataPath = "$env:LOCALAPPDATA"
$installPath = Join-Path "$localappdataPath" "mise"
Step "Extracting files to $installPath"
Expand-Archive -Path $tempZipPath -DestinationPath $localappdataPath -Force
Remove-Item $tempZipPath -Recurse -Force
Done "Saved to $installPath"

# Add install dir to USER PATH
Step "Updating PATH"
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
$binPath = Join-Path "$installPath" "bin"
if ($userPath -notlike "*$binPath*") {
    [Environment]::SetEnvironmentVariable("Path", "$userPath;$binPath", "User")
    Done "Added $binPath to your user PATH"
} else {
  Done "$binPath already on PATH"
}

Write-Host "`nmise installed successfully! Restart your terminal, then run 'mise --version'." -ForegroundColor Yellow
