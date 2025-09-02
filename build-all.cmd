@echo off

for %%p in ("%~dp0\..") do set QUBES_REPO=%%~fp\artifacts
set BUILD_CFG=%1
if "%BUILD_CFG%" == "" set BUILD_CFG=Release

setlocal EnableDelayedExpansion
for %%i in (vmm-xen-windows-pvdrivers core-vchan-xen windows-utils core-qubesdb core-agent-windows gui-agent-windows) do (
  set CDIR=%~dp0\..\%%i
  set CSUB=
  if exist "!CDIR!\windows\build.cmd" set CSUB=windows\
  call "!CDIR!\!CSUB!build.cmd"
)

powershell %QUBES_BUILDER%\qubesbuilder\plugins\build_windows\scripts\local\build.ps1 %~dp0 %QUBES_REPO% %BUILD_CFG%
