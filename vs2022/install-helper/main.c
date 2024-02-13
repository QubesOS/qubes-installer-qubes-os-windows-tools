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

/*
 * This utility waits for the xenbus_monitor service to become active and stops it.
 * This is to suppress prompts for reboot during pvdrivers installation.
 * It's not possible to schedule an action between installing components in MSI
 * (between installing xenbus and the rest of pvdrivers), so we use this instead.
*/

#include <windows.h>

int WinMain(_In_ HINSTANCE hInstance, _In_opt_ HINSTANCE hPrevInstance, _In_ LPSTR lpCmdLine, _In_ int nShowCmd)
{
	SC_HANDLE scm = OpenSCManager(NULL, NULL, SC_MANAGER_ALL_ACCESS);
	if (!scm)
	{
		return 1;
	}

	int ret = 0;
	while (TRUE)
	{
		SC_HANDLE xm = OpenService(scm, L"xenbus_monitor", SC_MANAGER_ALL_ACCESS);
		if (!xm)
		{
			Sleep(10);
			continue;
		}

		SERVICE_STATUS status;
		if (!QueryServiceStatus(xm, &status))
		{
			CloseServiceHandle(xm);
			Sleep(10);
			continue;
		}

		if (status.dwCurrentState != SERVICE_RUNNING)
		{
			CloseServiceHandle(xm);
			Sleep(10);
			continue;
		}

		// service ready and running, stop it and exit
		if (!ControlService(xm, SERVICE_CONTROL_STOP, &status))
		{
			ret = 1;
		}

		CloseServiceHandle(xm);
		break;
	}

	CloseServiceHandle(scm);
	return ret;
}
