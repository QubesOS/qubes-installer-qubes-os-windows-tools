# Installer for Qubes Windows Tools

## Local command-line build on Windows

### Prerequisites

- Microsoft EWDK iso mounted as a drive
- `qubes-builderv2`
- `powershell-yaml` PowerShell package (run `powershell -command Install-Package powershell-yaml` as admin)
  (TODO: provide offline installer for this)
- `vmm-xen-windows-pvdrivers`, `core-vchan-xen`, `windows-utils`, `core-qubesdb`,
  `core-agent-windows`, `gui-common` and `gui-agent-windows` sources in the same directory as the installer

### Build

- Run `powershell qubes-builderv2\qubesbuilder\plugins\build_windows\scripts\local\build-qwt.ps1 src_dir Release|Debug`
- All output will be copied to `repository` in the current directory.
