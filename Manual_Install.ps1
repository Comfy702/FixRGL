
# Check for administrative privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    # Relaunch the script with elevated permissions
    $newProcess = New-Object System.Diagnostics.ProcessStartInfo "powershell"
    $newProcess.Arguments = "& '" + $script:MyInvocation.MyCommand.Definition + "'"
    $newProcess.Verb = "runas"
    [System.Diagnostics.Process]::Start($newProcess)
    exit
}

# Define the name of the zip file
$zipFileName = "Launcher.zip"

# Get the directory of the current script
$scriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

# Define the full path to the zip file
$zipFilePath = Join-Path -Path $scriptDirectory -ChildPath $zipFileName

# Define the extraction path
$extractPath = "C:\Program Files\Rockstar Games"

# Check if the zip file exists
if (-Not (Test-Path -Path $zipFilePath)) {
    Write-Error "The zip file 'Launcher.zip' was not found in the script's directory."
    Read-Host -Prompt "Press Enter to exit"
    exit
}

# Remove the extraction path if it already exists to avoid conflicts
if (Test-Path -Path $extractPath) {
    Remove-Item -Recurse -Force -Path $extractPath
}

# Create the extraction path
New-Item -ItemType Directory -Path $extractPath

# Extract the zip file
Add-Type -AssemblyName System.IO.Compression.FileSystem
try {
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipFilePath, $extractPath)
} catch {
    Write-Error "An error occurred while extracting the zip file: $_"
    Read-Host -Prompt "Press Enter to exit"
    exit
}

# Define the path to LauncherPatcher.exe
$launcherPath = Join-Path $extractPath "Launcher\LauncherPatcher.exe"

# Check if Launcher.exe exists
if (-Not (Test-Path -Path $launcherPath)) {
    Write-Error "LauncherPatcher.exe was not found in the extracted files."
    Read-Host -Prompt "Press Enter to exit"
    exit
}

# Run Launcher.exe
Start-Process -FilePath $launcherPath