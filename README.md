# Installer for Qubes Windows Tools

All required components are contained as submodules.
Visual Studio solution includes relevant projects from submodules and allows building everything.

- TODO: actual installer
- TODO: integrate with Qubes builder
- TODO: signing pvdrivers
- TODO: cmdline build of VS installer project

## Command-line build

`EWDK_PATH` env variable must be set to the root of MS Enterprise WDK for Windows 10/Visual Studio 2022. 

`build.cmd` script builds the solution from command line using the EWDK (no need for external VS installation).

Usage: `build.cmd Release|Debug`
