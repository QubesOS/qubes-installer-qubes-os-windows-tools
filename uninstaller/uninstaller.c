/*
 * The Qubes OS Project, http://www.qubes-os.org
 *
 * Copyright (c) Invisible Things Lab
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 *
 */

#include <Windows.h>

/* 
 * This utility performs post-uninstallation cleanup of Qubes Windows Tools.
 * It's needed because MSI can't revert some changes done by the PV drivers co-installers
 * (like inserting device stack filters for example).
 * We should not depend on QWT libraries because they are already uninstalled at this point.
 */

PWSTR serviceNames[] = { L"qvideo", L"xen", L"xenagent", L"xenbus", L"xenfilt", L"xeniface", L"xennet", L"xenvif", L"xendisk", L"xenvbd" };

int wmain(int argc, WCHAR *argv[])
{
    LONG status;
    HKEY key;

    // delete QWT keys
    status = RegOpenKeyEx(HKEY_LOCAL_MACHINE, L"Software", 0, KEY_ALL_ACCESS, &key);
    if (status != ERROR_SUCCESS)
        return status;

    RegDeleteTree(key, L"Invisible Things Lab"); // ignore failures in case it's already deleted

    status = RegCloseKey(key);
    if (status != ERROR_SUCCESS)
        return status;

    // delete device stack filter entries created by Xen pvdrivers
    status = RegOpenKeyEx(HKEY_LOCAL_MACHINE,
        L"SYSTEM\\CurrentControlSet\\Control\\Class\\{4d36e96a-e325-11ce-bfc1-08002be10318}",
        0, KEY_ALL_ACCESS, &key);

    if (status != ERROR_SUCCESS)
        return status;

    // FIXME: don't delete the whole value, there might be some other filters besides Xen (XENFILT).
    RegDeleteValue(key, L"UpperFilters");

    status = RegCloseKey(key);
    if (status != ERROR_SUCCESS)
        return status;

    status = RegOpenKeyEx(HKEY_LOCAL_MACHINE,
        L"SYSTEM\\CurrentControlSet\\Control\\Class\\{4d36e97d-e325-11ce-bfc1-08002be10318}",
        0, KEY_ALL_ACCESS, &key);

    if (status != ERROR_SUCCESS)
        return status;

    RegDeleteValue(key, L"UpperFilters");

    status = RegCloseKey(key);
    if (status != ERROR_SUCCESS)
        return status;

    // delete driver services, SC manager can't do it
    status = RegOpenKeyEx(HKEY_LOCAL_MACHINE,
        L"SYSTEM\\CurrentControlSet\\Services",
        0, KEY_ALL_ACCESS, &key);

    if (status != ERROR_SUCCESS)
        return status;

    for (int i = 0; i < ARRAYSIZE(serviceNames); i++)
        RegDeleteTree(key, serviceNames[i]);

    status = RegCloseKey(key);
    if (status != ERROR_SUCCESS)
        return status;

    return 0;
}
