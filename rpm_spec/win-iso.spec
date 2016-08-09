%define build_number %(cat build)

%{!?version: %define version %(cat version)}

Name:	    qubes-windows-tools
Version:	%{version}
Release:	%{build_number}
Summary:	Qubes Tools for Windows VMs
Group:		Qubes
License:    GPL
Obsoletes:  qubes-core-dom0-pvdrivers
BuildRequires: genisoimage

%define _builddir %(pwd)

%description
PV Drivers and Qubes Tools for Windows AppVMs. Bundled for Windows 7 64bit.

%build

rm -f iso-content/*.msi iso-content/*.exe
cp qubes-tools-*-%{version}.%{build_number}.msi iso-content/
genisoimage -o qubes-windows-tools-%{version}.%{build_number}.iso -m .gitignore -JR iso-content


%install
mkdir -p $RPM_BUILD_ROOT/usr/lib/qubes/
cp qubes-windows-tools-%{version}.%{build_number}.iso $RPM_BUILD_ROOT/usr/lib/qubes/
ln -s qubes-windows-tools-%{version}.%{build_number}.iso $RPM_BUILD_ROOT/usr/lib/qubes/qubes-windows-tools.iso

%files
/usr/lib/qubes/qubes-windows-tools-%{version}.%{build_number}.iso
/usr/lib/qubes/qubes-windows-tools.iso

%changelog

