# Check for administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # Relaunch the script with elevated permissions
    $newProcess = New-Object System.Diagnostics.ProcessStartInfo "powershell"
    $newProcess.Arguments = "& '" + $script:MyInvocation.MyCommand.Definition + "'"
    $newProcess.Verb = "runas"
    [System.Diagnostics.Process]::Start($newProcess)
    exit
}

# Kill all processes
taskkill /f /im steam.exe /T
taskkill /f /im SteamService.exe /T
taskkill /f /im SteamWebHelper.exe /T
taskkill /f /im steamclientbootstrapper.exe /T
taskkill /f /im EpicGamesLauncher.exe /T
taskkill /f /im EpicWebHelper.exe /T
taskkill /f /im gta5.exe /T
taskkill /f /im LauncherPatcher.exe /T
taskkill /f /im Launcher.exe /T
taskkill /f /im SocialClubHelper.exe /T
taskkill /f /im RockstarErrorHandler.exe /T
taskkill /f /im RockstarService.exe /T

# Rename Rockstar Games folder in OneDrive
$OneDrivePath = [Environment]::GetFolderPath("MyDocuments")
$OneDrivePath += "\OneDrive"

if (Test-Path "$OneDrivePath\Rockstar Games") {
    Rename-Item "$OneDrivePath\Rockstar Games" -NewName "RockstarBackup"
    $oneDriveRootRenamed = $true
} else {
    $oneDriveRootRenamed = $false
}

if (Test-Path "$OneDrivePath\Documents\Rockstar Games") {
    Rename-Item "$OneDrivePath\Documents\Rockstar Games" -NewName "RockstarBackup"
    $oneDriveDocumentsRenamed = $true
} else {
    $oneDriveDocumentsRenamed = $false
}

# Output the result
Write-Output "Documents backup disabled for all OneDrive accounts."

# Get the installation path from the registry
$registryPath = "HKLM:\Software\WOW6432Node\Rockstar Games\Launcher"
$installFolder = (Get-ItemProperty -Path $registryPath -Name "InstallFolder").InstallFolder

if ($installFolder) {
    $launcherPath = Join-Path $installFolder "LauncherPatcher.exe"
    if (Test-Path -Path $launcherPath) {
        # Run LauncherPatcher.exe
        Start-Process -FilePath $launcherPath
    } else {
        $launcherPatcherFound = $false
    }
} else {
    $installFolderFound = $false
}

# Logging information at the end
if ($oneDriveRootRenamed) {
    Write-Host "Folder in OneDrive root renamed to RockstarBackup."
} else {
    Write-Host "Rockstar Games folder not found in OneDrive root."
}

if ($oneDriveDocumentsRenamed) {
    Write-Host "Folder in OneDrive Documents renamed to RockstarBackup."
} else {
    Write-Host "Rockstar Games folder not found in OneDrive Documents."
    }
    exit