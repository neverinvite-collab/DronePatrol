@echo off
setlocal
cd /d "%~dp0"
echo WARNING: this will remove local Godot cache and the app_userdata folders for this project.
choice /m "Continue"
if errorlevel 2 goto :eof
if exist ".godot" rmdir /s /q ".godot"
for %%D in ("%APPDATA%\Godot\app_userdata\*Дрон-Патруль*" "%APPDATA%\Godot\app_userdata\*DronePatrol*" "%LOCALAPPDATA%\Godot\app_userdata\*Дрон-Патруль*" "%LOCALAPPDATA%\Godot\app_userdata\*DronePatrol*") do (
  if exist "%%~D" rmdir /s /q "%%~D"
)
echo Reset complete.
pause
