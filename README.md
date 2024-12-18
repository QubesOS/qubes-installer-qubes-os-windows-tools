# Installer for Qubes Windows Tools

## Local command-line build on Windows

### Prerequisites

- Microsoft EWDK iso mounted as a drive
- `qubes-builderv2`
- `powershell-yaml` PowerShell package (run `powershell -command Install-Package powershell-yaml` as admin)
  (TODO: provide offline installer for this)
- `vmm-xen-windows-pvdrivers`, `core-vchan-xen`, `windows-utils`, `core-qubesdb`,
  `core-agent-windows`, `gui-common` and `gui-agent-windows` sources in the same directory as the installer
  (without the `qubes-` prefix)

### Build

- Run `powershell qubes-builderv2\qubesbuilder\plugins\build_windows\scripts\local\build-qwt.ps1 src_dir Release|Debug`
- All output will be copied to `repository` in the current directory.

### Development

Open `vs2022\qwt.sln` in Visual Studio (see Prerequisites for how to prepare component sources).
Includes/libs should be set up automatically and everything except the installer should build.
If VS insists that it doesn't see component includes, try changing solution configuration to/from
debug/release -- this seems to fix the issue.
