# Copyright (C) 2015 VirtualMetric
# This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

function Connect-LinuxVM {

<#
    .SYNOPSIS
     
        Function to login Linux virtual machine

    .EXAMPLE
     
        Connect-LinuxVM -VMName "CentOS" -Username "root" -Password "123456"
		
#>

param (
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the virtual machine. Example: CentOS01')]
    [string]$VMName,
	
	[Parameter(
        Mandatory = $true,
        HelpMessage = 'Username of the Linux VM. Example: root')]
    [string]$Username,
	
    [Parameter(
        Mandatory = $true,
        HelpMessage = 'Password of the Linux VM. Example: password')]
    [string]$Password,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the Hyper-V host. Example: hyperv01.virtualmetric.com')]
    [string]$VMHost,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the Hyper-V Cluster. Example: hyperv.virtualmetric.com')]
    [string]$VMCluster,
	
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the SCVMM server. Example: scvmm01.virtualmetric.com')]
    [string]$VMMServer = 'localhost',
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'VM manager name.')]
    [string]$VMManager,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Wmi hostname')]
    [string]$WmiHost,

	[Parameter(
        Mandatory = $false,
        HelpMessage = 'VM Console')]
    $VMConsole,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'XML output')]
    [switch]$OutXML = $false,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Debug Mode')]
    [switch]$DebugMode = $false
)

	# Enable Debug Mode
	if ($DebugMode)
	{
		$DebugPreference = "Continue"
	}
	else
	{
		$ErrorActionPreference = "silentlycontinue"
	}

	# Connect to VM Console
	if (!$VMConsole)
	{
		if (!$VMName) 
		{
			$ResultCode = "0"
			$ResultMessage = "You should provide a virtual machine name."
		}
		else
		{
			if (!$WmiHost)
			{
				$TestVMConsole = Connect-VMConsole -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer
				$VMConsole = $TestVMConsole.VSMKB
				$ResultCode = $TestVMConsole.ResultCode
				$ResultMessage = $TestVMConsole.ResultMessage
			}
			else
			{
				$TestVMConsole = Connect-VMConsole -VMName $VMName -VMManager $VMManager -WmiHost $WmiHost
				$VMConsole = $TestVMConsole.VSMKB
				$ResultCode = $TestVMConsole.ResultCode
				$ResultMessage = $TestVMConsole.ResultMessage
			}
		}
	}
	else
	{
		$ResultCode = "1"
		$ResultMessage = "Connected to VM console."
	}
	
	if ($ResultCode -eq "1")
	{
		# Login to Linux VM
		$SendCommand = $VMConsole.TypeText("$Username");
		$SendCommand = $VMConsole.Typekey(0x0D)
		Start-Sleep 3
		$SendCommand = $VMConsole.TypeText("$Password");
		$SendCommand = $VMConsole.Typekey(0x0D)
		Start-Sleep 5
		if ($Username -ne "root")
		{
			$SendCommand = $VMConsole.TypeText("sudo su");
			$SendCommand = $VMConsole.Typekey(0x0D)
			Start-Sleep 3
			$SendCommand = $VMConsole.TypeText("$Password");
			$SendCommand = $VMConsole.Typekey(0x0D)
			Start-Sleep 5
		}
		
		# Test virtual machine login
		$VMLoginStatus = Test-VMLogin -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost
		
		if ($VMLoginStatus.ResultCode -ne "1")
		{
			# Wait virtual machine reboot
			Wait-VMReboot -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost | Out-Null
			
			# Login to Linux VM
			$SendCommand = $VMConsole.TypeText("$Username");
			$SendCommand = $VMConsole.Typekey(0x0D)
			Start-Sleep 3
			$SendCommand = $VMConsole.TypeText("$Password");
			$SendCommand = $VMConsole.Typekey(0x0D)
			Start-Sleep 5
			if ($Username -ne "root")
			{
				$SendCommand = $VMConsole.TypeText("sudo su");
				$SendCommand = $VMConsole.Typekey(0x0D)
				Start-Sleep 3
				$SendCommand = $VMConsole.TypeText("$Password");
				$SendCommand = $VMConsole.Typekey(0x0D)
				Start-Sleep 5
			}			
			
			# Test virtual machine login
			$VMReLoginStatus = Test-VMLogin -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost
			
			if ($VMReLoginStatus.ResultCode -ne "1")
			{
				$ResultCode = "0"
				$ResultMessage = "Can not login to virtual machine. Please check username/password and virtual machine status."
			}
			else
			{
				$ResultCode = "1"
				$ResultMessage = "Username and password is correct."
			}
		}
		else
		{
			$ResultCode = "1"
			$ResultMessage = "Username and password is correct."
		}
	}
	
	if ($OutXML)
	{
		New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
	}
	else
	{
		$Properties = New-Object Psobject
		$Properties | Add-Member Noteproperty ResultCode $ResultCode
		$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
		Write-Output $Properties
	}
}

function Set-LinuxVMKeyboard {

<#
    .SYNOPSIS
     
        Function to set Linux virtual machine keyboard

    .EXAMPLE
     
        Set-LinuxVMKeyboard -VMName "CentOS" -VMKeyboard "us"
		
#>

param (
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the virtual machine. Example: CentOS01')]
    [string]$VMName,
	
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Language of the virtual machine console keyboard. Example: us')]
    [string]$VMKeyboard,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the Hyper-V host. Example: hyperv01.virtualmetric.com')]
    [string]$VMHost,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the Hyper-V Cluster. Example: hyperv.virtualmetric.com')]
    [string]$VMCluster,
	
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the SCVMM server. Example: scvmm01.virtualmetric.com')]
    [string]$VMMServer = 'localhost',
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'VM manager name.')]
    [string]$VMManager,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Wmi hostname')]
    [string]$WmiHost,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'VM Console')]
    $VMConsole,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'XML output')]
    [switch]$OutXML = $false,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Debug Mode')]
    [switch]$DebugMode = $false
)

	# Enable Debug Mode
	if ($DebugMode)
	{
		$DebugPreference = "Continue"
	}
	else
	{
		$ErrorActionPreference = "silentlycontinue"
	}

	# Connect to VM Console
	if (!$VMConsole)
	{
		if (!$VMName) 
		{
			$ResultCode = "0"
			$ResultMessage = "You should provide a virtual machine name."
		}
		else
		{
			if (!$WmiHost)
			{
				$TestVMConsole = Connect-VMConsole -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer
				$VMConsole = $TestVMConsole.VSMKB
				$ResultCode = $TestVMConsole.ResultCode
				$ResultMessage = $TestVMConsole.ResultMessage
			}
			else
			{
				$TestVMConsole = Connect-VMConsole -VMName $VMName -VMManager $VMManager -WmiHost $WmiHost
				$VMConsole = $TestVMConsole.VSMKB
				$ResultCode = $TestVMConsole.ResultCode
				$ResultMessage = $TestVMConsole.ResultMessage
			}
		}
	}
	else
	{
		$ResultCode = "1"
		$ResultMessage = "Connected to VM console."
	}
	
	if ($ResultCode -eq "1")
	{
		if ($VMKeyboard)
		{
			# Change console keyboard for current session
			$SendCommand = $VMConsole.TypeText("loadkeys $VMKeyboard");
			$SendCommand = $VMConsole.Typekey(0x0D)
			Start-Sleep 1
		}
		else
		{
			# Change console keyboard to English for current session
			$SendCommand = $VMConsole.TypeText("loadkeys us");
			$SendCommand = $VMConsole.Typekey(0x0D)
			Start-Sleep 1
		}
		$ResultCode = "1"
		$ResultMessage = "The operation completed."
	}
	
	if ($OutXML)
	{
		New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
	}
	else
	{
		$Properties = New-Object Psobject
		$Properties | Add-Member Noteproperty ResultCode $ResultCode
		$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
		Write-Output $Properties
	}
}

function Update-LinuxVM {

<#
    .SYNOPSIS
     
        Function to update Linux virtual machine

    .EXAMPLE
     
        Update-LinuxVM -VMName CentOS -TimeStamp $TimeStamp -ScriptPrefix $ScriptPrefix -UnattendedScriptPath $UnattendedScriptPath
		
#>

param (
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the virtual machine. Example: CentOS01')]
    [string]$VMName,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the Hyper-V host. Example: hyperv01.virtualmetric.com')]
    [string]$VMHost,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the Hyper-V Cluster. Example: hyperv.virtualmetric.com')]
    [string]$VMCluster,
	
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the SCVMM server. Example: scvmm01.virtualmetric.com')]
    [string]$VMMServer = 'localhost',
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Time Stamp for Operations')]
    [string]$TimeStamp,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Prefix for unattended answer file')]
    [string]$ScriptPrefix,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Script path for unattended answer file')]
    [string]$UnattendedScriptPath,
	
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Extend Logical Volume. NewPartition - ResizeFS')]
    [string]$ExtendLVM,

    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Install Linux integration components')]
    [switch]$InstallLIC = $false,
	
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Mount Linux answer image')]
    [switch]$MountAnswerISO = $false,
	
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Linux virtual machine customization')]
    [switch]$Customization = $false,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Transfer custom files? Please provide path.')]
    [string]$TransferFile,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Only transfer custom files?')]
    [string]$FileTransferOnly,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'VM Console')]
    $VMConsole,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'VM manager name.')]
    [string]$VMManager,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Wmi hostname')]
    [string]$WmiHost,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'XML output')]
    [switch]$OutXML = $false,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Debug Mode')]
    [switch]$DebugMode = $false
)

	# Enable Debug Mode
	if ($DebugMode)
	{
		$DebugPreference = "Continue"
	}
	else
	{
		$ErrorActionPreference = "silentlycontinue"
	}

	# Check VM Console
	if (!$VMConsole)
	{
		if (!$VMName) 
		{
			$ResultCode = "0"
			$ResultMessage = "You should provide a virtual machine name."
		}
		else
		{
			if (!$WmiHost)
			{
				$TestVMConsole = Connect-VMConsole -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager
				$VMConsole = $TestVMConsole.VSMKB
				$ResultCode = $TestVMConsole.ResultCode
				$ResultMessage = $TestVMConsole.ResultMessage
			}
			else
			{
				$TestVMConsole = Connect-VMConsole -VMName $VMName -VMManager $VMManager -WmiHost $WmiHost
				$VMConsole = $TestVMConsole.VSMKB
				$ResultCode = $TestVMConsole.ResultCode
				$ResultMessage = $TestVMConsole.ResultMessage
			}
		}
	}
	else
	{
		$ResultCode = "1"
		$ResultMessage = "Connected to VM console."
	}
	
	if ($ResultCode -eq "1")
	{	
		# Create Timestamp
		if (!$TimeStamp)
		{
			$TimeStamp = New-TimeStamp
		}

		# Mount Answer Image File
		if ($MountAnswerISO)
		{
			$SendCommand = $VMConsole.TypeText('insmod /lib/modules/$(uname -r)/kernel/drivers/ata/ata_piix.ko;');
			$SendCommand = $VMConsole.Typekey(0x0D)
			Start-Sleep 3
			$SendCommand = $VMConsole.TypeText("mount /dev/cdrom /media;");
			$SendCommand = $VMConsole.Typekey(0x0D)
			Start-Sleep 3
			$SendCommand = $VMConsole.TypeText("timestamp=$TimeStamp");
			$SendCommand = $VMConsole.Typekey(0x0D)
			Start-Sleep 3
			$SendCommand = $VMConsole.TypeText('mkdir /home/backup-$timestamp;');
			$SendCommand = $VMConsole.Typekey(0x0D)
			Start-Sleep 3
			$SendCommand = $VMConsole.TypeText("cp -R /media/$ScriptPrefix/* ");
			$SendCommand = $VMConsole.TypeText('/home/backup-$timestamp;');
			$SendCommand = $VMConsole.Typekey(0x0D)
			Start-Sleep 3
			
			# Wait for File Transfers
			if ($TransferFile)
			{
				Wait-VMProcess -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost
				
				# Debug Output
				Write-Debug "Waiting for file transfers.."
			}
			
			$SendCommand = $VMConsole.TypeText("umount /dev/cdrom;");
			$SendCommand = $VMConsole.Typekey(0x0D)
			Start-Sleep 3
			$SendCommand = $VMConsole.TypeText("eject;");
			$SendCommand = $VMConsole.Typekey(0x0D)
			Start-Sleep 3
			
			# File Transfer Check
			if (!$FileTransferOnly)
			{
				$SendCommand = $VMConsole.TypeText('cd /home/backup-$timestamp/;');
				$SendCommand = $VMConsole.Typekey(0x0D)
				Start-Sleep 3
				$SendCommand = $VMConsole.TypeText(". $ScriptPrefix-Unattended.sh");
				$SendCommand = $VMConsole.Typekey(0x0D)
				Start-Sleep 3
			}
			else
			{
				# Debug Output
				Write-Debug "File transfer only mode. Skipping custom scripts.."
			}
		}
		
		# Install Linux Integration Services
		if ($InstallLIC)
		{
			$SendCommand = $VMConsole.TypeText("SetLinuxVM-InstallLIC");
			$SendCommand = $VMConsole.Typekey(0x0D)
			Wait-VMProcess -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost
		}
		
		# Extend Logical Volume - NewPartition
		if ($ExtendLVM -eq "NewPartition")
		{
			$SendCommand = $VMConsole.TypeText("SetLinuxVM-NewPartition");
			$SendCommand = $VMConsole.Typekey(0x0D)
			Wait-VMProcess -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost
		}
		
		# Extend Logical Volume - ResizeFS
		if ($ExtendLVM -eq "ResizeFS")
		{
			$SendCommand = $VMConsole.TypeText("SetLinuxVM-ResizeFS");
			$SendCommand = $VMConsole.Typekey(0x0D)
			Wait-VMProcess -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost
		}
		
		# Virtual Machine Customization
		if ($Customization)
		{
			$SendCommand = $VMConsole.TypeText("SetLinuxVM-Customization");
			$SendCommand = $VMConsole.Typekey(0x0D)
			Wait-VMProcess -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost
		}
		
		$ResultCode = "1"
		$ResultMessage = "The operation completed."
	}
	
	if ($OutXML)
	{
		New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
	}
	else
	{
		$Properties = New-Object Psobject
		$Properties | Add-Member Noteproperty ResultCode $ResultCode
		$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
		Write-Output $Properties
	}
}

function Write-LinuxVMScript {

<#
    .SYNOPSIS
     
        Function to write Linux answer file

    .EXAMPLE
     
        Write-LinuxVMScript -VMName "CentOS" -TimeStamp "01242012" -ScriptPrefix "1552" -UnattendedScriptPath "C:\system32" -ExtendLVM
		
#>

param (
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the virtual machine. Example: CentOS01')]
    [string]$VMName,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the Hyper-V host. Example: hyperv01.virtualmetric.com')]
    [string]$VMHost,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the Hyper-V Cluster. Example: hyperv.virtualmetric.com')]
    [string]$VMCluster,
	
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the SCVMM server. Example: scvmm01.virtualmetric.com')]
    [string]$VMMServer = 'localhost',
	
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Hostname of your Linux VM')]
    [string]$Hostname,
	
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'IP address of your Linux VM')]
    [Alias('IP')]
    [string]$IPAddress,

    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Subnet mask of your Linux VM')]
    [Alias('Subnet')]
    [string]$SubnetMask,

    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Gateway address of your Linux VM')]
    [Alias('Gateway')]
    [string]$GatewayAddress,
	
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Primary DNS address of your Linux VM')]
    [Alias('DNS1')]
    [string]$PrimaryDNSAddress,
	
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Secondary DNS address of your Linux VM')]
    [Alias('DNS2')]
    [string]$SecondaryDNSAddress,

    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the Linux VM user')]
    [string]$Username,
	
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'New password of the Linux VM user')]
    [string]$Password, 
	
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'New time zone value of the Linux VM')]
    [string]$TimeZone, 
	
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Path of the answer file for custom VM modifications')]
    [string]$AnswerFile,
	
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the control panel you want to install')]
    [string]$Panel,

    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Extend Logical Volume.')]
    [switch]$ExtendLVM,
	
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Install Linux integration components')]
    [switch]$InstallLIC = $false,
	
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Start Linux virtual machine customization script')]
    [switch]$StartCustomization = $false,
	
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'End Linux virtual machine customization script')]
    [switch]$EndCustomization = $false,
	
	[Parameter(
        Mandatory = $true,
        HelpMessage = 'Time Stamp for Operations')]
    [string]$TimeStamp,
	
	[Parameter(
        Mandatory = $true,
        HelpMessage = 'Prefix for unattended answer file')]
    [string]$ScriptPrefix,
	
	[Parameter(
        Mandatory = $true,
        HelpMessage = 'Script path for unattended answer file')]
    [string]$UnattendedScriptPath,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'VM manager name.')]
    [string]$VMManager,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Wmi hostname')]
    [string]$WmiHost,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'XML output')]
    [switch]$OutXML = $false,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Debug Mode')]
    [switch]$DebugMode = $false
)

	# Enable Debug Mode
	if ($DebugMode)
	{
		$DebugPreference = "Continue"
	}
	else
	{
		$ErrorActionPreference = "silentlycontinue"
	}
	
	if ($StartCustomization)
	{
		# Prepend Customization Function Header
		$CustomizationScript = "echo SetLinuxVM Installation Steps:" + "`n"
		$CustomizationScript += "SetLinuxVM-Customization(){" + "`n"
		$CustomizationScript += "timestamp=$TimeStamp" + "`n"
		$CustomizationScript += "echo We are ready to go!"
		# Prepare Customization Function Header
		Add-Content -Value $CustomizationScript -Path "$UnattendedScriptPath\$ScriptPrefix-Unattended.sh"
	}
		
	# Set Hostname
	if ($Hostname) 
	{
		$HostnameScript = "echo Setting Hostname.." + "`n"
		# Detect Distro
		$HostnameScript += 'distro=$(cat /etc/issue | head -n 2 | tr -d "\n" | tr "[:upper:]" "[:lower:]")' + "`n"
		$HostnameScript += 'if [[ $distro == *suse* ]]; then' + "`n"
		$HostnameScript += 'hostname_file=HOSTNAME' + "`n" # Hostname fix for SLES
		$HostnameScript += "else" + "`n"
		$HostnameScript += 'hostname_file=hostname' + "`n"
		$HostnameScript += "fi" + "`n"
		$HostnameScript += 'mv /etc/hosts /home/backup-$timestamp/hosts.bak' + "`n"
		$HostnameScript += 'mv /etc/$hostname_file /home/backup-$timestamp/$hostname_file.bak' + "`n"
		$HostnameScript += "/bin/hostname $Hostname" + "`n"
		$HostnameScript += '/bin/hostname > /etc/$hostname_file' + "`n"
		$HostnameScript += 'if [[ $distro == *red* ]] || [[ $distro == *centos* ]] || [[ $distro == *fedora* ]] || [[ $distro == *cloud* ]]; then' + "`n"
		$HostnameScript += 'sed -i".bak" -e "/hostname/d" /etc/sysconfig/network' + "`n"
		$HostnameScript += 'mv /etc/sysconfig/network.bak /home/backup-$timestamp/network.hostname.bak' + "`n"
		$HostnameScript += "echo 'HOSTNAME=$Hostname' >>/etc/sysconfig/network" + "`n"
		$HostnameScript += "fi" + "`n"
		$HostnameScript += "echo '127.0.0.1 localhost' >>/etc/hosts" + "`n"
		$HostnameScript += "echo '127.0.0.1 $Hostname' >>/etc/hosts" + "`n"
		$HostnameScript += "echo End of Hostname Script."
		
		# Prepare Hostname Script
		Add-Content -Value $HostnameScript -Path "$UnattendedScriptPath\$ScriptPrefix-Unattended.sh"
	}
	
	# Set Network
	if ($GatewayAddress)
	{
		$NetworkScript = "echo Setting Network.." + "`n"
		$IPAddresses = @($IPAddress.Split(" "))
		$IPAddress = $IPAddresses[0]
		If ($SubnetMask -notlike "*.*")
		{
			if ($SubnetMask -lt "24")
			{
				$SubnetMask = "24"
			}
			$SubnetMask = [int]256-[int][System.Math]::Pow(2, 32-$SubnetMask)
			$SubnetMask = "255.255.255.$SubnetMask"
		}		
		$VMNetwork = Get-VMNetwork -VMName $VMName -VMManager $VMManager -WmiHost $WmiHost
		$AdapterMAC = $VMNetwork.EthernetAddress
		$NetworkScript += 'eth0name=$(ifconfig -a | grep -i '
		$NetworkScript += "$AdapterMAC | head -n 1 | cut -c-10 | tr -d ' ')" + "`n"
		$NetworkScript += 'if [[ -z $eth0name ]]; then' + "`n"
		$NetworkScript += "eth0name=eth0" + "`n"
		$NetworkScript += "fi" + "`n"
		# Detect Distro
		$NetworkScript += 'distro=$(cat /etc/issue | head -n 2 | tr -d "\n" | tr "[:upper:]" "[:lower:]")' + "`n"
		$NetworkScript += 'if [[ $distro == *ubuntu* ]] || [[ $distro == *debian* ]]; then' + "`n"
		$NetworkScript += 'mv /etc/network/interfaces /home/backup-$timestamp/interfaces.bak' + "`n"
		$NetworkScript += 'mv /etc/resolv.conf /home/backup-$timestamp/resolv.conf.bak' + "`n"
		# Debian Based IP Configuration
		$NetworkScript += "echo 'auto lo' >>/etc/network/interfaces" + "`n"
		$NetworkScript += "echo 'iface lo inet loopback' >>/etc/network/interfaces" + "`n"
		$NetworkScript += "echo ' ' >>/etc/network/interfaces" + "`n"
		$NetworkScript += 'echo "auto $eth0name" >>/etc/network/interfaces' + "`n"
		$NetworkScript += 'echo "iface $eth0name inet static" >>/etc/network/interfaces' + "`n"
		$NetworkScript += "echo 'address $IPAddress' >>/etc/network/interfaces" + "`n"
		$NetworkScript += "echo 'gateway $GatewayAddress' >>/etc/network/interfaces" + "`n"
		$NetworkScript += "echo 'netmask $SubnetMask' >>/etc/network/interfaces" + "`n"
		$NetworkScript += "echo ' ' >>/etc/network/interfaces" + "`n"
		# Multi IP Provisioning
		[int]$eth=1;
		foreach ($IP in $IPAddresses)
		{
			if ($IP -ne $IPAddress)
			{
				$NetworkScript += 'iface=$eth0name:'
				$NetworkScript += "$eth" + "`n"
				$NetworkScript += 'echo "auto $iface" >>/etc/network/interfaces' + "`n"
				$NetworkScript += 'echo "iface $iface inet static" >>/etc/network/interfaces' + "`n"
				$NetworkScript += "echo 'address $IP' >>/etc/network/interfaces" + "`n"
				$NetworkScript += "echo 'gateway $GatewayAddress' >>/etc/network/interfaces" + "`n"
				$NetworkScript += "echo 'netmask $SubnetMask' >>/etc/network/interfaces" + "`n"
				$NetworkScript += "echo ' ' >>/etc/network/interfaces" + "`n"
				[int]$eth=[int]$eth+1;
			}
		}		
		$NetworkScript += "echo 'search google.com' >>/etc/resolv.conf" + "`n"
		$NetworkScript += "echo 'nameserver $PrimaryDNSAddress' >>/etc/resolv.conf" + "`n"
		$NetworkScript += "echo 'nameserver $SecondaryDNSAddress' >>/etc/resolv.conf" + "`n"
		$NetworkScript += "/etc/init.d/networking restart" + "`n"
		$NetworkScript += "else" + "`n"
		# Suse IP Configuration
		$NetworkScript += 'if [[ $distro == *suse* ]]; then' + "`n"
		$NetworkScript += 'mv /etc/sysconfig/network/ifcfg-$eth0name /home/backup-$timestamp/ifcfg-$eth0name.bak' + "`n"
		$NetworkScript += 'mv /etc/sysconfig/network/routes /home/backup-$timestamp/routes.bak' + "`n"
		$NetworkScript += 'network_path=network' + "`n"
		$NetworkScript += "else" + "`n"
		$NetworkScript += 'mv /etc/sysconfig/network-scripts/ifcfg-$eth0name /home/backup-$timestamp/ifcfg-$eth0name.bak' + "`n"
		$NetworkScript += 'mv /etc/sysconfig/network /home/backup-$timestamp/network.gateway.bak' + "`n"
		$NetworkScript += 'network_path=network-scripts' + "`n"
		$NetworkScript += "fi" + "`n"
		# RedHat Based IP Configuration
		$NetworkScript += 'echo "DEVICE=$eth0name" >>/etc/sysconfig/$network_path/ifcfg-$eth0name' + "`n"
		$NetworkScript += 'echo "BOOTPROTO=static" >>/etc/sysconfig/$network_path/ifcfg-$eth0name' + "`n"
		$NetworkScript += 'if [[ $distro == *suse* ]]; then' + "`n"
		$NetworkScript += "echo 'IPADDR1=$IPAddress' "
		$NetworkScript += '>>/etc/sysconfig/$network_path/ifcfg-$eth0name' + "`n"
		$NetworkScript += "echo 'NETMASK1=$SubnetMask' "
		$NetworkScript += '>>/etc/sysconfig/$network_path/ifcfg-$eth0name' + "`n"
		$NetworkScript += "echo 'LABEL1=0' "
		$NetworkScript += '>>/etc/sysconfig/$network_path/ifcfg-$eth0name' + "`n"
		$NetworkScript += "else" + "`n"
		$NetworkScript += "echo 'IPADDR=$IPAddress' "
		$NetworkScript += '>>/etc/sysconfig/$network_path/ifcfg-$eth0name' + "`n"
		$NetworkScript += "echo 'NETMASK=$SubnetMask' "
		$NetworkScript += '>>/etc/sysconfig/$network_path/ifcfg-$eth0name' + "`n"
		$NetworkScript += "fi" + "`n"
		$NetworkScript += "echo 'GATEWAY=$GatewayAddress' "
		$NetworkScript += '>>/etc/sysconfig/$network_path/ifcfg-$eth0name' + "`n"
		$NetworkScript += 'if [[ $distro == *suse* ]]; then' + "`n"
		$NetworkScript += 'echo "STARTMODE=auto" >>/etc/sysconfig/$network_path/ifcfg-$eth0name' + "`n"
		$NetworkScript += 'echo "FIREWALL=no" >>/etc/sysconfig/$network_path/ifcfg-$eth0name' + "`n"
		$NetworkScript += 'echo "USERCONTROL=no" >>/etc/sysconfig/$network_path/ifcfg-$eth0name' + "`n"
		$NetworkScript += "else" + "`n"
		$NetworkScript += 'echo "ONBOOT=yes" >>/etc/sysconfig/$network_path/ifcfg-$eth0name' + "`n"
		$NetworkScript += "echo 'NETWORKING=yes' >>/etc/sysconfig/network" + "`n"
		$NetworkScript += "echo 'NETWORKING_IPV6=no' >>/etc/sysconfig/network" + "`n"
		$NetworkScript += "fi" + "`n"
		# Multi IP Provisioning
		[int]$eth=1;
		[int]$label=2;
		foreach ($IP in $IPAddresses)
		{
			if ($IP -ne $IPAddress)
			{
				$NetworkScript += 'iface=$eth0name:'
				$NetworkScript += "$eth" + "`n"
				$NetworkScript += 'if [[ $distro == *suse* ]]; then' + "`n"
				$NetworkScript += "echo 'IPADDR$label=$IP' "
				$NetworkScript += '>>/etc/sysconfig/$network_path/ifcfg-$eth0name' + "`n"
				$NetworkScript += "echo 'NETMASK$label=$SubnetMask' "
				$NetworkScript += '>>/etc/sysconfig/$network_path/ifcfg-$eth0name' + "`n"
				$NetworkScript += "echo 'LABEL$label=$eth' "
				$NetworkScript += '>>/etc/sysconfig/$network_path/ifcfg-$eth0name' + "`n"
				$NetworkScript += "else" + "`n"
				$NetworkScript += 'mv /etc/sysconfig/$network_path/ifcfg-$iface /home/backup-$timestamp/ifcfg-$iface.bak' + "`n"
				$NetworkScript += 'echo "DEVICE=$iface" >>/etc/sysconfig/$network_path/ifcfg-$iface' + "`n"
				$NetworkScript += 'echo "BOOTPROTO=static" >>/etc/sysconfig/$network_path/ifcfg-$iface' + "`n"
				$NetworkScript += "echo 'IPADDR=$IP' "
				$NetworkScript += '>>/etc/sysconfig/$network_path/ifcfg-$iface' + "`n"
				$NetworkScript += "echo 'NETMASK=$SubnetMask' "
				$NetworkScript += '>>/etc/sysconfig/$network_path/ifcfg-$iface' + "`n"
				$NetworkScript += 'echo "ONBOOT=yes" >>/etc/sysconfig/$network_path/ifcfg-$iface' + "`n"
				$NetworkScript += "fi" + "`n"
				[int]$eth=[int]$eth+1;
				[int]$label=[int]$label+1;
			}
		}
		# Suse Extra Network Configuration
		$NetworkScript += 'if [[ $distro == *suse* ]]; then' + "`n"
		$NetworkScript += "echo 'default $GatewayAddress' >>/etc/sysconfig/network/routes" + "`n"
		$NetworkScript += "else" + "`n"
		$NetworkScript += 'current_hostname=$(hostname)' + "`n"
		$NetworkScript += 'echo "HOSTNAME=$current_hostname" >>/etc/sysconfig/network' + "`n"
		$NetworkScript += "echo 'GATEWAY=$GatewayAddress' >>/etc/sysconfig/network" + "`n"
		$NetworkScript += "fi" + "`n"
		$NetworkScript += "echo 'search google.com' >>/etc/resolv.conf" + "`n"
		$NetworkScript += "echo 'nameserver $PrimaryDNSAddress' >>/etc/resolv.conf" + "`n"
		$NetworkScript += "echo 'nameserver $SecondaryDNSAddress' >>/etc/resolv.conf" + "`n"
		$NetworkScript += "service network restart" + "`n"
		$NetworkScript += "fi" + "`n"
		$NetworkScript += "echo End of Network Script."
		
		# Prepare Network Script
		Add-Content -Value $NetworkScript -Path "$UnattendedScriptPath\$ScriptPrefix-Unattended.sh"
	}
	
	# Change User Password
	If ($Password)
	{
		$PasswordScript = "echo Setting Password.." + "`n"
		$PasswordScript += "passwd $Username <<EOF" + "`n"
		$PasswordScript += "$Password" + "`n"
		$PasswordScript += "$Password" + "`n"
		$PasswordScript += "EOF" + "`n"
		If ($Username -ne "root")
		{
			$PasswordScript += "passwd root <<EOF" + "`n"
			$PasswordScript += "$Password" + "`n"
			$PasswordScript += "$Password" + "`n"
			$PasswordScript += "EOF" + "`n"
		}
		$PasswordScript += "echo End of Password."
		
		# Prepare Password Script
		Add-Content -Value $PasswordScript -Path "$UnattendedScriptPath\$ScriptPrefix-Unattended.sh"
	}

	# Change Time Zone Configuration
	If ($TimeZone)
	{
		$TimeZoneScript = "echo Setting Time Zone.." + "`n"
		$TimeZoneScript += "ln -sf /usr/share/zoneinfo/$TimeZone /etc/localtime" + "`n"
		$TimeZoneScript += "rm -f /etc/sysconfig/clock" + "`n"
		$TimeZoneScript += "echo ZONE=`"$TimeZone`" >>/etc/sysconfig/clock" + "`n"
		$TimeZoneScript += "echo 'UTC=true' >>/etc/sysconfig/clock" + "`n"
		$TimeZoneScript += "echo 'ARC=false' >>/etc/sysconfig/clock" + "`n"
		$TimeZoneScript += "echo End of Time Zone."
		
		# Prepare Time Zone Script
		Add-Content -Value $TimeZoneScript -Path "$UnattendedScriptPath\$ScriptPrefix-Unattended.sh"
	}
	
	# Installing CPanel for Redhat and CentOS
	If ($Panel -eq "CPanel")
	{	
		$PanelScript = "echo Installing CPanel.." + "`n"
		$PanelScript += "cd /home" + "`n"
		$PanelScript += "wget -N http://httpupdate.cpanel.net/latest" + "`n"
		$PanelScript += "sh latest" + "`n"
		$PanelScript += "echo End of CPanel."
		
		# Prepare Panel Script
		Add-Content -Value $PanelScript -Path "$UnattendedScriptPath\$ScriptPrefix-Unattended.sh"
	}
	elseif ($Panel -eq "Plesk")
	{
		$PanelScript = "echo Installing Parallels Plesk.." + "`n"
		$PanelScript += "cd /home" + "`n"
		$PanelScript += "wget -O - http://autoinstall.plesk.com/one-click-installer | sh" + "`n"
		$PanelScript += "echo End of Parallels Plesk."
		
		# Prepare Panel Script
		Add-Content -Value $PanelScript -Path "$UnattendedScriptPath\$ScriptPrefix-Unattended.sh"
	}

	# Custom Script Support
	If ($AnswerFile)
	{
		$AnswerFileScript = "echo Setting Custom Scripts.." + "`n"
		if (!(Test-Path -Path $AnswerFile)) 
		{
			$ResultCode = "-1"
			$ResultMessage = "Could not find answer file!"
		}
		else
		{
			$Contents = Get-Content $AnswerFile
			Foreach ($Content in $Contents)
			{
				$AnswerFileScript += "$Content" + "`n"
			}
			$ResultCode = "1"
			$ResultMessage = "Answer file is validated."
		}
		$AnswerFileScript += "echo End of Custom Script."
		
		# Prepare Custom Script
		Add-Content -Value $AnswerFileScript -Path "$UnattendedScriptPath\$ScriptPrefix-Unattended.sh"
	}
	
	if ($EndCustomization)
	{
		# Append Customization Function Footer
		$CustomizationScript = 'rm -rf /home/backup-$timestamp/' + "$ScriptPrefix-Unattended.sh" + "`n"
		$CustomizationScript += "}" + "`n"
		$CustomizationScript += "echo - Linux Virtual Machine Customization"
		# Prepare Customization Function Footer
		Add-Content -Value $CustomizationScript -Path "$UnattendedScriptPath\$ScriptPrefix-Unattended.sh"
	}
	
	# Extend Logical Volume
	If ($ExtendLVM)
	{
		$NewPartitionScript = "SetLinuxVM-NewPartition(){" + "`n"
		$NewPartitionScript += 'distro=$(cat /etc/issue | head -n 2 | tr -d "\n" | tr "[:upper:]" "[:lower:]")' + "`n"
		$NewPartitionScript += 'if [[ $distro == *debian* ]]; then' + "`n"
		$NewPartitionScript += 'dpkgstatus=$(dpkg-query -W -f=' + "'" + '${Status}\n' + "' parted)" + "`n"
		$NewPartitionScript += 'if [[ $dpkgstatus == *not* ]]; then' + "`n"
		$NewPartitionScript += 'dpkg -i /home/backup-$timestamp/Parted/debian.parted.deb' + "`n"
		$NewPartitionScript += 'dpkg -i /home/backup-$timestamp/Parted/debian.libparted.deb' + "`n"
		$NewPartitionScript += "else" + "`n"
		$NewPartitionScript += "echo Skipping parted package installation.." + "`n"
		$NewPartitionScript += "fi" + "`n"
		$NewPartitionScript += "fi" + "`n"
		$NewPartitionScript += 'if [[ $distro == *ubuntu* ]]; then' + "`n"
		$NewPartitionScript += 'dpkgstatus=$(dpkg-query -W -f=' + "'" + '${Status}\n' + "' parted)" + "`n"
		$NewPartitionScript += 'if [[ $dpkgstatus == *not* ]]; then' + "`n"
		$NewPartitionScript += 'dpkg -i /home/backup-$timestamp/Parted/ubuntu.parted.deb' + "`n"
		$NewPartitionScript += 'dpkg -i /home/backup-$timestamp/Parted/ubuntu.libparted.deb' + "`n"
		$NewPartitionScript += "else" + "`n"
		$NewPartitionScript += "echo Skipping parted package installation.." + "`n"
		$NewPartitionScript += "fi" + "`n"
		$NewPartitionScript += "fi" + "`n"
		$NewPartitionScript += 'if [[ $distro == *red* ]] || [[ $distro == *centos* ]] || [[ $distro == *fedora* ]] || [[ $distro == *cloud* ]]; then' + "`n"
		$NewPartitionScript += 'rpmstatus=$(rpm -qa | grep parted)' + "`n"
		$NewPartitionScript += 'if [[ $rpmstatus == *parted* ]]; then' + "`n"
		$NewPartitionScript += "echo Skipping parted package installation.." + "`n"
		$NewPartitionScript += "else" + "`n"
		$NewPartitionScript += 'rpm -ivh /home/backup-$timestamp/Parted/redhat.parted.rpm' + "`n"
		$NewPartitionScript += "fi" + "`n"
		$NewPartitionScript += "fi" + "`n"
		$NewPartitionScript += 'if [[ $distro == *suse* ]]; then' + "`n"
		$NewPartitionScript += 'rpmstatus=$(rpm -qa | grep parted)' + "`n"
		$NewPartitionScript += 'if [[ $rpmstatus == *parted* ]]; then' + "`n"
		$NewPartitionScript += "echo Skipping parted package installation.." + "`n"
		$NewPartitionScript += "else" + "`n"
		$NewPartitionScript += 'rpm -ivh /home/backup-$timestamp/Parted/suse.parted.rpm' + "`n"
		$NewPartitionScript += "fi" + "`n"
		$NewPartitionScript += "fi" + "`n"
		$NewPartitionScript += 'device=$(fdisk -l | grep -w 8e | head -n 1 | cut -c-8)' + "`n"
		$NewPartitionScript += 'partcount=$(fdisk -l | grep $device | sed 1d | grep -c $device)' + "`n"
		$NewPartitionScript += 'newpartnum=$(($partcount+1))' + "`n"
		$NewPartitionScript += 'startsector=$(fdisk -l | grep -w 8e | tail -1 | tr " " "\n" | sed "/^$/d" | head -n 3 | tail -1)' + "`n"
		$NewPartitionScript += 'newstartsector=$(($startsector+1))' + "`n"
		$NewPartitionScript += 'endsector=$(fdisk -l | grep sectors | head -n 1 | tr " " "\n" | tail -2 | head -n 1)' + "`n"
		$NewPartitionScript += 'newendsector=$(($endsector-1))' + "`n"
		$NewPartitionScript += 'fdisk $device <<EOF' + "`n"
		$NewPartitionScript += "n" + "`n"
		$NewPartitionScript += "p" + "`n"
		$NewPartitionScript += '$newpartnum' + "`n"
		$NewPartitionScript += '$newstartsector' + "`n"
		$NewPartitionScript += '$newendsector' + "`n"
		$NewPartitionScript += "t" + "`n"
		$NewPartitionScript += '$newpartnum' + "`n"
		$NewPartitionScript += "8e" + "`n"
		$NewPartitionScript += "w" + "`n"
		$NewPartitionScript += "EOF" + "`n"
		$NewPartitionScript += 'partprobe' + "`n"
		$NewPartitionScript += 'rm -rf /home/backup-$timestamp/Parted' + "`n"
		$NewPartitionScript += "}" + "`n"
		$NewPartitionScript += "echo - New Partition on Logical Volume"
		
		# Prepare New Partition Script
		Add-Content -Value $NewPartitionScript -Path "$UnattendedScriptPath\$ScriptPrefix-Unattended.sh"
		
		$ResizeFSScript = "SetLinuxVM-ResizeFS(){" + "`n"
		$ResizeFSScript += 'device=$(fdisk -l | grep -w 8e | head -n 1 | cut -c-8)' + "`n"
		$ResizeFSScript += 'partnumber=$(fdisk -l | grep $device | sed 1d | grep -c $device)' + "`n"
		$ResizeFSScript += 'pvcreate $device$partnumber' + "`n"
		$ResizeFSScript += 'volgroupname=$(vgdisplay | grep -w "VG Name" | cut -b10- | tr -d " ")' + "`n"
		$ResizeFSScript += 'vgextend $volgroupname $device$partnumber' + "`n"
		$ResizeFSScript += 'volgroupchars=$(echo $volgroupname | wc --chars)' + "`n"
		$ResizeFSScript += 'totalchars=$(($volgroupchars+13))' + "`n"
		$ResizeFSScript += 'lvmname=$(df -h | grep -w $volgroupname | head -n 1 | cut -b$totalchars-)' + "`n"
		$ResizeFSScript += 'set $lvmname' + "`n"
		$ResizeFSScript += 'lvmname=$1' + "`n"
		$ResizeFSScript += 'lvextend -l +100%FREE /dev/$volgroupname/$lvmname' + "`n"
		$ResizeFSScript += 'resize2fs /dev/$volgroupname/$lvmname' + "`n"
		$ResizeFSScript += "}" + "`n"
		$ResizeFSScript += "echo - Resize Logical Volume"
		
		# Prepare ResizeFS Script
		Add-Content -Value $ResizeFSScript -Path "$UnattendedScriptPath\$ScriptPrefix-Unattended.sh"
	}
	
	# Install Linux IC
	if ($InstallLIC) 
	{
		$InstallLICScript = "SetLinuxVM-InstallLIC(){" + "`n"
		$InstallLICScript += 'tar -zxvf /home/backup-$timestamp/Linux.IC.v3.4.gz' + "`n"
		$InstallLICScript += 'cd /home/backup-$timestamp/mnt/' + "`n"
		$InstallLICScript += 'distro=$(cat /etc/issue | head -n 2 | tr -d "\n" | tr "[:upper:]" "[:lower:]")' + "`n"
		$InstallLICScript += 'if [[ $distro == *6.0* ]] || [[ $distro == *6.1* ]] || [[ $distro == *6.2* ]]; then' + "`n"
		$InstallLICScript += "cd RHEL6012" + "`n"
		$InstallLICScript += "./install.sh" + "`n"
		$InstallLICScript += 'elif [[ $distro == *6.3* ]]; then' + "`n"
		$InstallLICScript += "cd RHEL63" + "`n"
		$InstallLICScript += "./install.sh" + "`n"		
		$InstallLICScript += 'elif [[ $distro == *5.7* ]]; then' + "`n"
		$InstallLICScript += "cd RHEL57" + "`n"
		$InstallLICScript += "./install-rhel57.sh" + "`n"
		$InstallLICScript += 'elif [[ $distro == *5.8* ]]; then' + "`n"
		$InstallLICScript += "cd RHEL58" + "`n"
		$InstallLICScript += "./install-rhel58.sh" + "`n"
		$InstallLICScript += "else" + "`n"
		$InstallLICScript += "echo Current distribution is not supported." + "`n"
		$InstallLICScript += "fi" + "`n"
		$InstallLICScript += "modprobe hv_vmbus" + "`n"
		$InstallLICScript += "lsmod" + "`n"
		$InstallLICScript += "lsmod | grep hv_vmbus" + "`n"
		$InstallLICScript += "cd /home" + "`n"
		$InstallLICScript += 'rm /home/backup-$timestamp/Linux.IC.v3.4.gz' + "`n"
		$InstallLICScript += 'rm -rf /home/backup-$timestamp/mnt' + "`n"
		$InstallLICScript += "}" + "`n"
		$InstallLICScript += "echo - Linux Integration Services Installation"
		
		# Prepare Install LIC Script
		Add-Content -Value $InstallLICScript -Path "$UnattendedScriptPath\$ScriptPrefix-Unattended.sh"
	}	
	
	$ResultCode = "1"
	$ResultMessage = "The operation completed."
	
	if ($OutXML)
	{
		New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
	}
	else
	{
		$Properties = New-Object Psobject
		$Properties | Add-Member Noteproperty ResultCode $ResultCode
		$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
		Write-Output $Properties
	}
}

function Restart-LinuxVM {

<#
    .SYNOPSIS
     
        Function to restart Linux virtual machine

    .EXAMPLE
     
        Restart-LinuxVM -VMName "CentOS"
		
#>

param (
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the virtual machine. Example: CentOS01')]
    [string]$VMName,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the Hyper-V host. Example: hyperv01.virtualmetric.com')]
    [string]$VMHost,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the Hyper-V Cluster. Example: hyperv.virtualmetric.com')]
    [string]$VMCluster,
	
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the SCVMM server. Example: scvmm01.virtualmetric.com')]
    [string]$VMMServer = 'localhost',
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the Linux VM user')]
    [string]$Username,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'VM Console')]
    $VMConsole,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'VM manager name.')]
    [string]$VMManager,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Wmi hostname')]
    [string]$WmiHost,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'XML output')]
    [switch]$OutXML = $false,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Debug Mode')]
    [switch]$DebugMode = $false
)

	# Enable Debug Mode
	if ($DebugMode)
	{
		$DebugPreference = "Continue"
	}
	else
	{
		$ErrorActionPreference = "silentlycontinue"
	}

	# Connect to VM Console
	if (!$VMConsole)
	{
		if (!$VMName) 
		{
			$ResultCode = "0"
			$ResultMessage = "You should provide a virtual machine name."
		}
		else
		{
			if (!$WmiHost)
			{
				$TestVMConsole = Connect-VMConsole -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer
				$VMConsole = $TestVMConsole.VSMKB
				$ResultCode = $TestVMConsole.ResultCode
				$ResultMessage = $TestVMConsole.ResultMessage
			}
			else
			{
				$TestVMConsole = Connect-VMConsole -VMName $VMName -VMManager $VMManager -WmiHost $WmiHost
				$VMConsole = $TestVMConsole.VSMKB
				$ResultCode = $TestVMConsole.ResultCode
				$ResultMessage = $TestVMConsole.ResultMessage
			}
		}
	}
	else
	{
		$ResultCode = "1"
		$ResultMessage = "Connected to VM console."
	}
	
	if ($ResultCode -eq "1")
	{
		# Restart Linux VM
		$SendCommand = $VMConsole.TypeText("reboot");
		$SendCommand = $VMConsole.Typekey(0x0D)
		$ResultCode = "1"
		$ResultMessage = "The operation completed."
	}
	
	if ($OutXML)
	{
		New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
	}
	else
	{
		$Properties = New-Object Psobject
		$Properties | Add-Member Noteproperty ResultCode $ResultCode
		$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
		Write-Output $Properties
	}
}

function Disconnect-LinuxVM {

<#
    .SYNOPSIS
     
        Function to logoff Linux virtual machine

    .EXAMPLE
     
        Disconnect-LinuxVM -Username "root" -VMName "CentOS"
		
#>

param (
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the virtual machine. Example: CentOS01')]
    [string]$VMName,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the Hyper-V host. Example: hyperv01.virtualmetric.com')]
    [string]$VMHost,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the Hyper-V Cluster. Example: hyperv.virtualmetric.com')]
    [string]$VMCluster,
	
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the SCVMM server. Example: scvmm01.virtualmetric.com')]
    [string]$VMMServer = 'localhost',
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the Linux VM user')]
    [string]$Username,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'VM Console')]
    $VMConsole,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'VM manager name.')]
    [string]$VMManager,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Wmi hostname')]
    [string]$WmiHost,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'XML output')]
    [switch]$OutXML = $false,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Debug Mode')]
    [switch]$DebugMode = $false
)

	# Enable Debug Mode
	if ($DebugMode)
	{
		$DebugPreference = "Continue"
	}
	else
	{
		$ErrorActionPreference = "silentlycontinue"
	}

	# Connect to VM Console
	if (!$VMConsole)
	{
		if (!$VMName) 
		{
			$ResultCode = "0"
			$ResultMessage = "You should provide a virtual machine name."
		}
		else
		{
			if (!$WmiHost)
			{
				$TestVMConsole = Connect-VMConsole -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer
				$VMConsole = $TestVMConsole.VSMKB
				$ResultCode = $TestVMConsole.ResultCode
				$ResultMessage = $TestVMConsole.ResultMessage
			}
			else
			{
				$TestVMConsole = Connect-VMConsole -VMName $VMName -VMManager $VMManager -WmiHost $WmiHost
				$VMConsole = $TestVMConsole.VSMKB
				$ResultCode = $TestVMConsole.ResultCode
				$ResultMessage = $TestVMConsole.ResultMessage
			}
		}
	}
	else
	{
		$ResultCode = "1"
		$ResultMessage = "Connected to VM console."
	}
	
	if ($ResultCode -eq "1")
	{
		# Logoff from Linux VM
		$SendCommand = $VMConsole.TypeText("exit");
		$SendCommand = $VMConsole.Typekey(0x0D)
		if ($Username -ne "root")
		{
			Start-Sleep 1
			$SendCommand = $VMConsole.TypeText("exit");
			$SendCommand = $VMConsole.Typekey(0x0D)
		}
		$ResultCode = "1"
		$ResultMessage = "The operation completed."
	}
	
	if ($OutXML)
	{
		New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
	}
	else
	{
		$Properties = New-Object Psobject
		$Properties | Add-Member Noteproperty ResultCode $ResultCode
		$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
		Write-Output $Properties
	}
}
