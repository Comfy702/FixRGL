@echo off
setlocal

set "dirs=%UserProfile%\Documents\Rockstar Games"
set "onedrive=%OneDrive%"

if not "%onedrive%"=="" (
    set "dirs=%dirs%;%onedrive%"
)

if exist "%onedrive%\Documents" (
    set "dirs=%dirs%;%onedrive%\Documents"
)

set "files=settings.xml pc_settings.bin"

for %%d in (%dirs%) do (
    for %%f in (%files%) do (
        if exist "%%d\%%f" (
            echo Deleting %%d\%%f
            del /q "%%d\%%f"
        )
    )
)

echo Done.
endlocal
pause