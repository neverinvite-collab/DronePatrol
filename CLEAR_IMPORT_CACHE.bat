@echo off
setlocal
cd /d "%~dp0"
echo Removing local Godot import cache (.godot)...
if exist ".godot" rmdir /s /q ".godot"
echo Done. Re-open the project in Godot so assets will be re-imported.
pause
