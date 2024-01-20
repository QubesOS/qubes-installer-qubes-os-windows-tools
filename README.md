# Installer for Qubes Windows Tools

All required components are contained as submodules.
Visual Studio solution includes relevant projects from submodules and allows building everything.

`EWDK_PATH` env variable must be set to the root of MS Enterprise WDK for Windows 10/Visual Studio 2022.

- TODO: clean build fails on pvdrivers, retry succeeds - investigate
- TODO: actual installer
- TODO: integrate with Qubes builder
- TODO: support release signing

## Command-line build

`build.cmd` script builds the solution from command line using the EWDK (no need for external VS installation).
A selfsigned test certificate (`testsign.cer`) is generated and used to sign all executables, DLLs and drivers.

Usage: `build.cmd Release|Debug`
