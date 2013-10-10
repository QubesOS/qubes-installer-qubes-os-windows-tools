%define iso_build_timestamp %(date -u +%Y%m%d%H%M)

%{!?version: %define version %(cat version)}

Name:	    qubes-windows-tools
Version:	%{version}
Release:	%{iso_build_timestamp}
Summary:	PV Drivers for Windows VMs
Group:		Qubes
License:    GPL/Proprietary
Obsoletes:  qubes-core-dom0-pvdrivers
BuildRequires: genisoimage

%define _builddir %(pwd)

%description
PV Drivers (GPL) and Qubes Windows agent code (proprietary) Windows AppVMs. Bundled for XP, Vista, 2003, 7, both 32bit and 64bit.

%build

rm -f iso-content/*.msi iso-content/*.exe
cp qubes-windows-tools-*-%{version}*.msi iso-content/
genisoimage -o qubes-windows-tools-%{iso_build_timestamp}.iso -m .gitignore -JR iso-content

%install
mkdir -p $RPM_BUILD_ROOT/usr/lib/qubes/
cp qubes-windows-tools-%{iso_build_timestamp}.iso $RPM_BUILD_ROOT/usr/lib/qubes/

%files
/usr/lib/qubes/qubes-windows-tools-%{iso_build_timestamp}.iso

%changelog

