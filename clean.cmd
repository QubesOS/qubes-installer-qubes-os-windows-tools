:: removes all build artifacts and intermediate files

@echo off

rmdir /s /q "%~dp0\bin"
rmdir /s /q "%~dp0\vs2022\tmp"
rmdir /s /q "%~dp0\vs2022\x64"
rmdir /s /q "%~dp0\vs2022\installer\obj"
rmdir /s /q "%~dp0\vs2022\installer\version.wxi"
rmdir /s /q "%~dp0\vs2022\installer-bundle\obj"
del /q /f "%~dp0\testsign.cer"
del /q /f "%~dp0\qubes-windows-tools*.exe"
del /q /f "%~dp0\qubes-windows-tools*.wixpdb"

pushd "%~dp0\qubes-vmm-xen-windows-pvdrivers\xenbus"
rmdir /s /q xenbus
del /q /f .build_number
del /q /f include\version.h
cd vs2022
del /q /f xenbus.inf
del /q /f version\.revision
rmdir /s /q x64
rmdir /s /q Windows10Debug
rmdir /s /q Windows10Release
rmdir /s /q package\Windows10Debug
rmdir /s /q package\Windows10Release
rmdir /s /q xen\Windows10Debug
rmdir /s /q xen\Windows10Release
rmdir /s /q xenbus\Windows10Debug
rmdir /s /q xenbus\Windows10Release
rmdir /s /q xenbus_monitor\x64
rmdir /s /q xenfilt\Windows10Debug
rmdir /s /q xenfilt\Windows10Release

cd "%~dp0\qubes-vmm-xen-windows-pvdrivers\xeniface"
rmdir /s /q xeniface
del /q /f .build_number
del /q /f include\version.h
del /q /f src\xeniface\wmi.mof
del /q /f src\xeniface\wmi_generated.h
cd vs2022
del /q /f xeniface.inf
del /q /f version\.revision
rmdir /s /q x64
rmdir /s /q Windows10Debug
rmdir /s /q Windows10Release
rmdir /s /q package\Windows10Debug
rmdir /s /q package\Windows10Release
rmdir /s /q xeniface\Windows10Debug
rmdir /s /q xeniface\Windows10Release
rmdir /s /q xenagent\x64
rmdir /s /q xencontrol\x64

cd "%~dp0\qubes-vmm-xen-windows-pvdrivers\xennet"
rmdir /s /q xennet
del /q /f .build_number
del /q /f include\version.h
cd vs2022
del /q /f xennet.inf
del /q /f version\.revision
rmdir /s /q Windows10Debug
rmdir /s /q Windows10Release
rmdir /s /q package\Windows10Debug
rmdir /s /q package\Windows10Release
rmdir /s /q xennet\Windows10Debug
rmdir /s /q xennet\Windows10Release

cd "%~dp0\qubes-vmm-xen-windows-pvdrivers\xenvbd"
rmdir /s /q xenvbd
del /q /f .build_number
del /q /f include\version.h
cd vs2022
del /q /f xenvbd.inf
del /q /f version\.revision
rmdir /s /q Windows10Debug
rmdir /s /q Windows10Release
rmdir /s /q package\Windows10Debug
rmdir /s /q package\Windows10Release
rmdir /s /q xencrsh\Windows10Debug
rmdir /s /q xencrsh\Windows10Release
rmdir /s /q xendisk\Windows10Debug
rmdir /s /q xendisk\Windows10Release
rmdir /s /q xenvbd\Windows10Debug
rmdir /s /q xenvbd\Windows10Release

cd "%~dp0\qubes-vmm-xen-windows-pvdrivers\xenvif"
rmdir /s /q xenvif
del /q /f .build_number
del /q /f include\version.h
cd vs2022
del /q /f xenvif.inf
del /q /f version\.revision
rmdir /s /q Windows10Debug
rmdir /s /q Windows10Release
rmdir /s /q package\Windows10Debug
rmdir /s /q package\Windows10Release
rmdir /s /q xenvif\Windows10Debug
rmdir /s /q xenvif\Windows10Release

popd
