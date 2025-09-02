@echo off

rd /s /q %~dp0\.artifacts
rd /s /q %~dp0\vs2022\tmp
rd /s /q %~dp0\vs2022\x64
rd /s /q %~dp0\vs2022\installer\obj
rd /s /q %~dp0\vs2022\installer-bundle\obj
del /s /q /f %~dp0\qubes-windows-tools*.wixpdb
del /s /q /f %~dp0\qubes-windows-tools*.exe

setlocal EnableDelayedExpansion
for %%i in (vmm-xen-windows-pvdrivers core-vchan-xen windows-utils core-qubesdb core-agent-windows gui-agent-windows) do (
  set CDIR=%~dp0\..\%%i
  set CSUB=
  if exist "!CDIR!\windows\clean.cmd" set CSUB=windows\
  call "!CDIR!\!CSUB!clean.cmd"
)
