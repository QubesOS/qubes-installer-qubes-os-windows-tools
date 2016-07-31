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

int wmain(int argc, WCHAR *argv[])
{
	return 0;
}
