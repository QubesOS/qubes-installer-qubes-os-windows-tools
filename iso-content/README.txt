I. Installing Qubes Windows Tools
---------------------------------

Qubes Windows Tools are currently only supported on Windows 7 x64. In order to
install, one needs to disable driver signature checking policy, as the current
drivers are only self-signed. In order to disable driver signing requirement
do the following (in Windows VM):

1) Start command prompt as Administrator Mode, i.e. right click on the Command
Prompt icon and choose "Run as administrator".

2) In the command prompt type:
   bcdedit /set testsigning on

3) Reboot your Windows VM.

4) Run the .exe file from the virtual CDROM. Installation may require a few
   reboots, especially in case of an upgrade -- make sure the process is
   completed before using the VM (mostly relevant for VM templates).

II. Known issues
----------------

1) The Xen PV disk driver is disabled by default. This is because it causes
   a BSOD after installation in Qubes. However, it seems to work fine after
   that, so you may want to use it (for better performance and the ability
   to use qvm-block). MAKE SURE TO BACK UP YOUR VM FIRST in case something
   goes very wrong.
   
2) Windows shows an exclamation mark on the network icon in the system tray,
   but this is only a cosmetic issue (network configuration is being set
   properly).
