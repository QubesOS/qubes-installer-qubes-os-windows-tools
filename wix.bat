@ECHO OFF

FOR /F %%V IN (version) DO SET VERSION_BASE=%%V
FOR /F %%V IN (build) DO SET BUILD=%%V
SET VERSION=%VERSION_BASE%.%BUILD%

IF "%_BUILDARCH%"=="x86" (SET DIFXLIB="%WIX%\bin\difxapp_x86.wixlib") ELSE (SET DIFXLIB="%WIX%\bin\difxapp_x64.wixlib")

IF "%_BUILDARCH%"=="x86" (SET MSIARCH=x86) ELSE (SET MSIARCH=x64)

IF "%DDKBUILDENV%"=="chk" (SET MSIBUILD=_debug) ELSE (SET MSIBUILD=)

SET MSIOS=%DDK_TARGET_OS%
IF "%DDK_TARGET_OS%"=="Win2K" (SET MSIOS=2000)
IF "%DDK_TARGET_OS%"=="WinXP" (SET MSIOS=XP)
IF "%DDK_TARGET_OS%"=="WinNET" (SET MSIOS=2003)
IF "%DDK_TARGET_OS%"=="WinLH" (SET MSIOS=Vista2008)
IF "%DDK_TARGET_OS%"=="Win7" (SET MSIOS=Win7)

SET MSINAME=qubes-windows-tools-%MSIOS%%MSIARCH%-%VERSION%%MSIBUILD%.msi

for /F %%x in ('DIR /B %BASEDIR%\redist\wdf\%_BUILDARCH%\WdfCoInstaller?????.dll') do set WDFFILENAME=%%x

"%WIX%\bin\candle" main.wxs -arch %MSIARCH% -ext "%WIX%\bin\WixUIExtension.dll" -ext "%WIX%\bin\WixDifxAppExtension.dll" -ext "%WIX%\bin\WixIIsExtension.dll"
"%WIX%\bin\light.exe" -o %MSINAME% main.wixobj %DIFXLIB% -ext "%WIX%\bin\WixUIExtension.dll" -ext "%WIX%\bin\WixDifxAppExtension.dll" -ext "%WIX%\bin\WixIIsExtension.dll"

IF NOT EXIST SIGN_CONFIG.BAT GOTO DONT_SIGN

%SIGNTOOL% sign /v /f %CERT_FILENAME% %CERT_PASSWORD_FLAG% /t http://timestamp.verisign.com/scripts/timestamp.dll %MSINAME%

:DONT_SIGN
