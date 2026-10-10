@echo off
chcp 65001 >nul
cd /d "%~dp0"
py -m pip install piper-tts
if errorlevel 1 goto :fail
py voice_tools\generate_voice_pack.py
if errorlevel 1 goto :fail
echo.
echo All voice WAVs generated. Open project in Godot.
pause
exit /b 0
:fail
echo.
echo Voice generation failed. Copy the error text here.
pause
exit /b 1
