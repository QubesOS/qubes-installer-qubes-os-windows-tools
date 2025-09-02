@echo off

rd /s /q %~dp0\.artifacts
rd /s /q %~dp0\vs2022\tmp
rd /s /q %~dp0\vs2022\x64
rd /s /q %~dp0\vs2022\installer\obj
rd /s /q %~dp0\vs2022\installer-bundle\obj
del /s /q /f %~dp0\qubes-windows-tools*.wixpdb
del /s /q /f %~dp0\qubes-windows-tools*.exe
