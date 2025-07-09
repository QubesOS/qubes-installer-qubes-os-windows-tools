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

#define UMDF_USING_NTSTATUS
#include <windows.h>
#include <NTSecAPI.h>
#include <ntstatus.h>
#include <strsafe.h>

#define LINK_ERRMSG L"Failed to adjust account rights to allow symbolic link creation:\n"
#define SERVICE_ERRMSG L"Failed to stop the xenbus_monitor service:\n"

DWORD ReportError(const WCHAR* msg, DWORD status)
{
    const WCHAR* title = L"Qubes Tools Installer";
    WCHAR buffer[1024];
    if (FAILED(StringCchPrintf(buffer, ARRAYSIZE(buffer), L"%s (error 0x%x)", msg, status)))
    {
        MessageBox(NULL, msg, title, MB_ICONERROR);
    }
    else
    {
        MessageBox(NULL, buffer, title, MB_ICONERROR);
    }

    return status;
}

// Add SeCreateSymbolicLinkPrivilege to the "Users" group.
// Needed for file-receiver to create symlinks.
DWORD AddSymlinkRightToUsers()
{
    LSA_OBJECT_ATTRIBUTES oa;
    LSA_HANDLE lsa;

    ZeroMemory(&oa, sizeof(oa)); // not used by the call but required

    NTSTATUS status = LsaOpenPolicy(NULL, &oa, POLICY_ALL_ACCESS, &lsa);
    if (status != STATUS_SUCCESS)
        return ReportError(LINK_ERRMSG L"Failed to open LSA policy", status);

    DWORD sid_size = 256;
    PSID sid = malloc(sid_size);
    if (!sid)
        return ReportError(LINK_ERRMSG L"Out of memory", ERROR_OUTOFMEMORY);

    if (!CreateWellKnownSid(WinBuiltinUsersSid, NULL, sid, &sid_size))
        return ReportError(LINK_ERRMSG L"CreateWellKnownSid(users) failed", GetLastError());

    LSA_UNICODE_STRING right;
    right.Buffer = SE_CREATE_SYMBOLIC_LINK_NAME;
    right.Length = (USHORT)wcslen(right.Buffer) * sizeof(WCHAR);
    right.MaximumLength = (USHORT)(wcslen(right.Buffer) + 1) * sizeof(WCHAR);

    status = LsaAddAccountRights(lsa, sid, &right, 1);
    if (status != STATUS_SUCCESS)
        ReportError(LINK_ERRMSG L"LsaAddAccountRights(users, SeCreateSymbolicLinkPrivilege) failed", status);

    return status;
}

/*
 * This function waits for the xenbus_monitor service to become active and stops it.
 * This is to suppress prompts for reboot during pvdrivers installation.
 * It's not possible to schedule an action between installing components in MSI
 * (between installing xenbus and the rest of pvdrivers), so we use this instead.
*/

DWORD StopXenbusMonitor()
{
    DWORD status = ERROR_SUCCESS;
    SC_HANDLE scm = OpenSCManager(NULL, NULL, SC_MANAGER_ALL_ACCESS);
    if (!scm)
        return ReportError(SERVICE_ERRMSG L"Failed to open service manager", status = GetLastError());

    while (TRUE)
    {
        SC_HANDLE xm = OpenService(scm, L"xenbus_monitor", SC_MANAGER_ALL_ACCESS);
        if (!xm)
        {
            Sleep(10);
            continue;
        }

        SERVICE_STATUS svc_status;
        if (!QueryServiceStatus(xm, &svc_status))
        {
            CloseServiceHandle(xm);
            Sleep(10);
            continue;
        }

        if (svc_status.dwCurrentState != SERVICE_RUNNING)
        {
            CloseServiceHandle(xm);
            Sleep(10);
            continue;
        }

        // service ready and running, stop it and exit
        if (!ControlService(xm, SERVICE_CONTROL_STOP, &svc_status))
            return ReportError(SERVICE_ERRMSG L"Failed to stop service", status = GetLastError());

        CloseServiceHandle(xm);
        break;
    }

    CloseServiceHandle(scm);
    return status;
}

/*
 * Automatically accept the prompt for installing test-signed drivers.
 */
DWORD ApproveTestSign(void* param)
{
    while (TRUE)
    {
        HWND window = FindWindow(NULL, L"Windows Security");
        if (window)
        {
            DWORD fg_tid = GetWindowThreadProcessId(GetForegroundWindow(), NULL);
            DWORD tid = GetCurrentThreadId();
            // Without this, focus-stealing mitigations can prevent activating the target window.
            if (tid != fg_tid)
                AttachThreadInput(fg_tid, tid, TRUE);

            BringWindowToTop(window);
            ShowWindow(window, SW_SHOW);

            while (GetForegroundWindow() != window)
                Sleep(100);

            INPUT inputs[2];
            inputs[0].type = INPUT_KEYBOARD;
            inputs[0].ki.wVk = 'i';
            inputs[1].type = INPUT_KEYBOARD;
            inputs[1].ki.dwFlags = KEYEVENTF_KEYUP;
            inputs[1].ki.wVk = 'i';
            SendInput(ARRAYSIZE(inputs), inputs, sizeof(INPUT));
            break;
        }
        else
        {
            Sleep(100);
        }
    }
    return 0;
}

int WinMain(_In_ HINSTANCE hInstance, _In_opt_ HINSTANCE hPrevInstance, _In_ LPSTR lpCmdLine, _In_ int nShowCmd)
{
    (void)AddSymlinkRightToUsers();
    HANDLE thread = CreateThread(NULL, 0, ApproveTestSign, NULL, 0, NULL);
    if (WaitForSingleObject(thread, 1800000) == WAIT_TIMEOUT)
        TerminateThread(thread, 0);
    return (int)StopXenbusMonitor();
}
