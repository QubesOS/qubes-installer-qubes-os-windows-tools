# Installer for Qubes Windows Tools

All required components are contained as submodules.
Visual Studio solution includes relevant projects from submodules and allows building everything.

`EWDK_PATH` env variable must be set to the root of MS Enterprise WDK for Windows 10/Visual Studio 2022.

- TODO: automatically install prerequisites for installer
- TODO: integrate with Qubes builder
- TODO: support release signing

## Prerequisites
- .NET SDK: https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/sdk-8.0.101-windows-x64-installer
- WiX as a .NET tool: `dotnet tool install --global wix --version 4.0.5`
- WiX extensions:
  - `wix extension add --global WixToolset.Bal.wixext/4.0.5`
  - `wix extension add --global WixToolset.DifxApp.wixext/4.0.5`
  - `wix extension add --global WixToolset.Iis.wixext/4.0.5`
  - `wix extension add --global WixToolset.UI.wixext/4.0.5`
  - `wix extension add --global WixToolset.util.wixext/4.0.5`

Don't install WiX 5.0: one of the extensions (Bal) seems broken and can't be correctly installed. Another extension (DifxApp for driver installation) is unavailable for 5.0 and will need to be replaced in the future.

## Command-line build

`build.cmd` script builds the solution from command line using the EWDK (no need for external VS installation).
A selfsigned test certificate (`testsign.cer`) is generated and used to sign all executables, DLLs and drivers.

Usage: `build.cmd Release|Debug`
