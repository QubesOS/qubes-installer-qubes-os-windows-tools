@echo off

:: Set the default power scheme to High Performance
powercfg /setactive SCHEME_MIN

:: Disable disk drive idle poweroff
powercfg /setacvalueindex SCHEME_MIN SUB_DISK DISKIDLE 0
powercfg /setdcvalueindex SCHEME_MIN SUB_DISK DISKIDLE 0

:: Disable idle sleep & hibernation
powercfg /setacvalueindex SCHEME_MIN SUB_SLEEP STANDBYIDLE 0
powercfg /setdcvalueindex SCHEME_MIN SUB_SLEEP STANDBYIDLE 0
powercfg /setacvalueindex SCHEME_MIN SUB_SLEEP HIBERNATEIDLE 0
powercfg /setdcvalueindex SCHEME_MIN SUB_SLEEP HIBERNATEIDLE 0

:: Disable idle video poweroff
powercfg /setacvalueindex SCHEME_MIN SUB_VIDEO VIDEOIDLE 0
powercfg /setdcvalueindex SCHEME_MIN SUB_VIDEO VIDEOIDLE 0
