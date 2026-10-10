@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo Installing Piper speech generator...
py -3 -m pip install --upgrade piper-tts
if errorlevel 1 goto fail
echo Generating Oleksa, Mykyta and Tetiana voices. Download ~340 MB once.
py -3 tools\generate_piper_uk.py
if errorlevel 1 goto fail
echo.
echo SUCCESS! Open project.godot in Godot, let assets import, then run the game.
pause
exit /b 0
:fail
echo ERROR: generation failed. Verify Python 3 and internet access.
pause
exit /b 1
