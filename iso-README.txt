I. Installing Qubes Windows Tools
=================================

Qubes Windows Tools are currently supported on 64-bit Windows (10 or
newer).

How to prepare for Windows 10/11 installation
-----------------------------------------
In order to install gui-agent on Windows 10/11, disable driver
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
multiple drivers, signed by Qubes Windows Tools -- allow that.

* In some situations, you might be prompted to format a "Qubes Private
Image" -- cancel that prompt.


II. Known issues
================

Check qubes issues with "C: windows-tools" label:
https://github.com/QubesOS/qubes-issues/issues?q=state%3Aopen%20label%3A%22C%3A%20windows-tools%22%20
