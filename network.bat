@echo off
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script requires administrative privileges. Please run as administrator.
    pause
    exit /b
)

echo Terminating specified processes...
taskkill /F /IM LauncherPatcher.exe /T
taskkill /F /IM gta5.exe /T
taskkill /F /IM SocialClubHelper.exe /T
taskkill /F /IM RockstarErrorHandler.exe /T
taskkill /F /IM Launcher.exe /T
taskkill /F /IM RockstarService.exe /T
taskkill /F /IM EpicWebHelper.exe /T
taskkill /F /IM EpicGamesLauncher.exe /T
taskkill /F /IM SteamService.exe /T
taskkill /F /IM Steam.exe /T

echo Releasing current IP address...
ipconfig /release

echo Renewing IP address...
ipconfig /renew

echo Flushing DNS cache...
ipconfig /flushdns

echo Registering DNS...
ipconfig /registerdns

echo Resetting Winsock...
netsh winsock reset

echo Resetting IP stack...
netsh int ip reset

echo Disabling and enabling network adapters...
netsh interface set interface "Wi-Fi" admin=disable
netsh interface set interface "Wi-Fi" admin=enable
netsh interface set interface "Ethernet" admin=disable
netsh interface set interface "Ethernet" admin=enable

:repeat
(ping -n 2 socialclub.rockstargames.com | find "TTL=") || goto :repeat
echo Connecting to Social Club was successful.
echo All network settings have been refreshed
pause
exit