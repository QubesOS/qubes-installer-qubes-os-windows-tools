I. Installing Qubes Windows Tools
=================================

Qubes Windows Tools are currently supported on 64-bit Windows (7 or
newer), but gui-agent (auxiliary support for arbitrary screen resolution and seamless
mode) requires exactly Windows 7.

How to prepare for Windows 7 installation
-----------------------------------------
In order to install gui-agent on Windows 7, disable driver
signature checking policy, as the current drivers are only self-signed. In
order to disable driver signing requirement (in the Windows VM):

1) Start command prompt as Administrator Mode, i.e. right click on the Command
Prompt icon and choose "Run as administrator".

2) In the command prompt type:
   bcdedit /set testsigning on

3) Reboot your Windows VM.

Installing Qubes Windows Tools
------------------------------

Run the .exe file from this virtual CDROM. Installation may require a few
reboots, especially in case of an upgrade -- make sure the process is
completed before using the VM (this is especially important for VM templates).

* During the installation, you will be prompted to allow installation of
multiple drivers, signed by The Linux Foundation -- allow that.

* In some situations, you might be prompted to format a "Qubes Private
Image" -- cancel that prompt.

* Some of Xen PV drivers will request a system restart during the
installation -- answer "No" there, and reboot the system only after the
whole installation.


II. Known issues
================

1) The Xen PV disk driver is disabled by default. This is because it causes
   a BSOD after installation in Qubes. However, it seems to work fine after
   that, so you may want to use it (for better performance and the ability
   to use qvm-block). MAKE SURE TO BACK UP YOUR VM FIRST in case something
   goes very wrong.
   
2) Windows shows an exclamation mark on the network icon in the system tray,
   but this is only a cosmetic issue (network configuration is being set
   properly).
