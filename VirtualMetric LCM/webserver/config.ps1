# Copyright (C) 2015 VirtualMetric
# This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

# Import required modules
$ImportSetLinuxVM = Import-Module SetLinuxVM

# SetLinuxVM VM hosts config
$VMHostsConfig = "$HomeDirectory\config\vmhosts.config"
$VMHostsConfigContent = Get-Content -Path $VMHostsConfig
if ($VMHostsConfigContent -eq $Null)
{
	Clear-Content -Path $VMHostsConfig
	$VMHostsList = Search-LinuxVMHost
	foreach ($VMHost in $VMHostsList)
	{
		Add-Content -Path $VMHostsConfig -Value $VMHost.VMHost
	}
}

# SetLinuxVM RestAPI config
$RestAPIKeyConfig = "$HomeDirectory\config\restapikey.config"
$RestAPIKeyConfigContent = Get-Content -Path $RestAPIKeyConfig
if ($RestAPIKeyConfigContent -eq $Null)
{
	Clear-Content -Path $RestAPIKeyConfig
	$NewAPIKey = Get-Random
	Add-Content -Path $RestAPIKeyConfig -Value $NewAPIKey
}
