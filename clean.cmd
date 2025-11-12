@echo off

rd /s /q %~dp0\vs2022\tmp
rd /s /q %~dp0\vs2022\x64
rd /s /q %~dp0\vs2022\installer\obj
del /q /a /f %~dp0\vs2022\installer\version.wxi
rd /s /q %~dp0\vs2022\installer-bundle\obj
del /q /a /f %~dp0\qubes-windows-tools*.wixpdb
del /q /a /f %~dp0\qubes-windows-tools*.exe
