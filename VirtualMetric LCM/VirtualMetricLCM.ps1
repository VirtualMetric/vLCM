# Copyright (C) 2015 VirtualMetric
# This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

function Set-LinuxVM {

<#
    .SYNOPSIS
     
        Function to make hostname and IP configuration; install control panel,
        Hyper-V Linux integration components (LIC) and execute custom scripts on a Linux VM.
 
    .DESCRIPTION
     
        This function sets a new hostname and IP configuration to a Linux VM with parameters you provide.
        It changes hostname and ifconfig file of virtual machine.
        Also installs proper Linux integration components for the distribution if it's available.
        This function can also install control panels like CPanel automatically.
        It's possible to use your own answer file to create custom and unique setups.
             
    .PARAMETER  WhatIf
     
        Display what would happen if you would run the function with given parameters.
    
    .PARAMETER  Confirm
     
        Prompts for confirmation for each operation. Allow user to specify Yes/No to all option to stop prompting.
    
    .EXAMPLE
     
        Set-LinuxVM -VMName "Linux01" -Username "root" -Password "123456" -Hostname "server.virtualmetric.com" -IPAddress "192.168.2.2" -SubnetMask "255.255.255.0" -GatewayAddress "192.168.2.1" -PrimaryDNSAddress "8.8.8.8" -SecondaryDNSAddress "8.8.4.4"
        Sets hostname and IP configuration to VM called "Linux01".
		
    .EXAMPLE
     
        Set-LinuxVM -VMName "Linux02" -Username "root" -Password "123456" -Hostname "server.virtualmetric.com" -IPAddress "192.168.2.2" -SubnetMask "255.255.255.0" -GatewayAddress "192.168.2.1" -PrimaryDNSAddress "8.8.8.8" -SecondaryDNSAddress "8.8.4.4" -AnswerFile "C:\answer.txt"
        Sets hostname and IP configuration to VM called "Linux02". Also applies your answer file for custom modifications.
		
    .EXAMPLE
     
        Set-LinuxVM -VMName "Linux03" -Username "root" -Password "123456" -Hostname "server.virtualmetric.com" -IPAddress "192.168.2.2" -SubnetMask "255.255.255.0" -GatewayAddress "192.168.2.1" -PrimaryDNSAddress "8.8.8.8" -SecondaryDNSAddress "8.8.4.4" -Panel "CPanel"
        Sets hostname and IP configuration to VM called "Linux03" and installs CPanel.
		
    .EXAMPLE
     
        Set-LinuxVM -VMName "Linux04" -Username "root" -Password "123456" -Hostname "server.virtualmetric.com" -IPAddress "192.168.2.2" -SubnetMask "255.255.255.0" -GatewayAddress "192.168.2.1" -PrimaryDNSAddress "8.8.8.8" -SecondaryDNSAddress "8.8.4.4" -Panel "Plesk"
        Sets hostname and IP configuration to VM called "Linux04" and installs Parallels Plesk Panel.
		
    .EXAMPLE
     
        Set-LinuxVM -VMName "Linux05" -Username "root" -Password "123456" -Hostname "server.virtualmetric.com" -IPAddress "192.168.2.2" -SubnetMask "255.255.255.0" -GatewayAddress "192.168.2.1" -PrimaryDNSAddress "8.8.8.8" -SecondaryDNSAddress "8.8.4.4" -InstallLIC
        Sets hostname and IP configuration to VM called "Linux05" and installs integration components for this distro.
     
    .EXAMPLE
     
        Set-LinuxVM -VMName "Linux06" -Username "root" -Password "123456" -Hostname "server.virtualmetric.com"
        Sets only hostname to VM called "Linux06". You dont need to set IP address if you use DHCP.
 
    .EXAMPLE
     
        Set-LinuxVM -VMName "Linux07" -VMHost "hyperv01.virtualmetric.com" -Username "root" -Password "123456" -Hostname "server.virtualmetric.com" -IPAddress "192.168.2.2" -SubnetMask "255.255.255.0" -GatewayAddress "192.168.2.1" -PrimaryDNSAddress "8.8.8.8" -SecondaryDNSAddress "8.8.4.4"
        Sets hostname and IP configuration to VM called "Linux07" and runs on Hyper-V host called "hyperv01.virtualmetric.com"
		
    .EXAMPLE
     
        Set-LinuxVM -VMName "Linux08" -VMMServer "scvmm01.virtualmetric.com" -Username "root" -Password "123456" -Hostname "server.virtualmetric.com" -IPAddress "192.168.2.2" -SubnetMask "255.255.255.0" -GatewayAddress "192.168.2.1" -PrimaryDNSAddress "8.8.8.8" -SecondaryDNSAddress "8.8.4.4"
        Sets hostname and IP configuration to VM called "Linux08" and runs on SCVMM server called "scvmm01.virtualmetric.com"
		
    .EXAMPLE
     
        Set-LinuxVM -VMName "Linux09" -Manager "Hyper-V" -Username "virtualmetric" -Password "123456" -Hostname "server.virtualmetric.com" -IPAddress "192.168.2.2" -SubnetMask "255.255.255.0" -GatewayAddress "192.168.2.1" -PrimaryDNSAddress "8.8.8.8" -SecondaryDNSAddress "8.8.4.4"
        Sets hostname and IP configuration to VM called "Linux09" but it uses Hyper-V API instead of SCVMM.
		
    .EXAMPLE
     
        Set-LinuxVM -VMName "Linux10" -Manager "Hyper-V" -VMHost "hyperv01.virtualmetric.com" -Username "virtualmetric" -Password "123456" -Hostname "server.virtualmetric.com" -IPAddress "192.168.2.2" -SubnetMask "255.255.255.0" -GatewayAddress "192.168.2.1" -PrimaryDNSAddress "8.8.8.8" -SecondaryDNSAddress "8.8.4.4"
        Sets hostname and IP configuration to VM called "Linux10" but it uses Hyper-V API instead of SCVMM. Use VMHost switch if VM is on remote Hyper-V host.

    .EXAMPLE
    
        Set-LinuxVM -VMName "Linux11" -Username "root" -Password "123456" -Hostname "server.virtualmetric.com" -IPAddress "192.168.2.2" -SubnetMask "255.255.255.0" -GatewayAddress "192.168.2.1" -PrimaryDNSAddress "8.8.8.8" -SecondaryDNSAddress "8.8.4.4" -ExtendLVM
        Sets hostname and IP configuration to VM called "Linux11" and extends logical volume if you have expanded VM's disk.

    .EXAMPLE
     
        Set-LinuxVM -VMName "Linux12" -Username "root" -Password "123456" -Hostname "server.virtualmetric.com" -IPAddress "192.168.2.2" -SubnetMask "255.255.255.0" -GatewayAddress "192.168.2.1" -PrimaryDNSAddress "8.8.8.8" -SecondaryDNSAddress "8.8.4.4" -TimeZone "Europe/Istanbul"
        Sets hostname and IP configuration to VM called "Linux12" and also changes Time Zone value.
        You can see correct time zone values from this link: http://www.vmware.com/support/developer/vc-sdk/visdk400pubs/ReferenceGuide/timezone.html
		
    .EXAMPLE
     
        Set-LinuxVM -VMName "Linux13" -Username "root" -Password "123456" -Hostname "server.virtualmetric.com" -IPAddress "192.168.2.2" -SubnetMask "255.255.255.0" -GatewayAddress "192.168.2.1" -PrimaryDNSAddress "8.8.8.8" -SecondaryDNSAddress "8.8.4.4" -NewPassword "123654"
        Sets hostname and IP configuration to VM called "Linux13" and changes password of the user.
	
    .EXAMPLE
     
        Set-LinuxVM -VM "Linux14" -Username "root" -Password "123456" -Hostname "server.virtualmetric.com" -IP "192.168.2.2" -Subnet "255.255.255.0" -Gateway "192.168.2.1" -DNS1 "8.8.8.8" -DNS2 "8.8.4.4"
        Sets hostname and IP configuration to VM called "Linux14" using with alias names.
		
    .EXAMPLE
     
        Set-LinuxVM -VM "Linux15" -Username "root" -Password "123456" -Hostname "server.virtualmetric.com" -IP "192.168.2.2" -Subnet "255.255.255.0" -Gateway "192.168.2.1" -DNS1 "8.8.8.8" -DNS2 "8.8.4.4" -NewPassword "123654" -TimeZone "Europe/Istanbul" -ExtendLVM -InstallLIC
        Sets hostname and IP configuration to VM called "Linux15" using with alias names. Extends logical volumes, changes time zone and password. Also install LIC.
		
	.EXAMPLE
     
        Set-LinuxVM -VMName "Linux16" -Username "root" -Password "123456" -TransferFile "C:\Custom.tar"
        Sends custom.tar file into VM called "Linux16". Your file will be placed into /home/backup-timestamp directory.
		
	.EXAMPLE
     
        Set-LinuxVM -VMName "Linux17" -Username "root" -Password "123456" -TransferFile "C:\Custom"
        Sends Custom folder into VM called "Linux17". Your folder will be placed into /home/backup-timestamp directory.

    .INPUTS
         
        Hostname and IP configuration for Linux virtual machine.
 
    .OUTPUTS
 
        None
	
    .NOTES
         
        Author: VirtualMetric
        Website: http://www.virtualmetric.com
        Email: support@virtualmetric.com
        Date created: 03-May-2011
        Last modified: 17-June-2015
        Version: 5.3
 
    .LINK
        
        http://www.setlinuxvm.com
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (

    # Name of the Linux VM you want to set.
    [Parameter(
        Mandatory = $true,
	ValueFromPipelineByPropertyName= $true,
        HelpMessage = 'Name of the Linux VM')]
    [Alias('VM')]
    [string]$VMName,
	
    # Name of the Hyper-V host which currently hosts your Linux VM.
    # This parameter is not required if you have only one Linux VM with the same VM name.
    # This script prevents to modify wrong virtual machine if more than one VM exist with the same name in SCVMM.
    # You should type FQDN of Hyper-V host like hyperv01.virtualmetric.com
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the Hyper-V host which currently hosts your Linux VM')]
    [string]$VMHost,
	
    # Name of the SCVMM server which currently hosts your Linux VM.
    # This parameter is required if you have multiple SCVMM servers.
    # You should type FQDN of SCVMM server like scvmm01.virtualmetric.com
    # Default value: localhost
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the SCVMM server which currently hosts your Linux VM')]
    [string]$VMMServer = 'localhost',
	
    # Name of the Linux VM template. Example: "CentOS 6.2 x64"
    # Template's "Tag" field should contains distro information.
    # Check the picture for example: http://www.virtualmetric.com/linux/tools/SetLinuxVM/template_tag.png
    # Template's "Custom Properties" field should contains username and password.
    # Check the picture for example: http://www.virtualmetric.com/linux/tools/SetLinuxVM/template_cp.png
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the Linux VM template')]
    [string]$VMTemplateName,
		
    # Username of the Linux virtual machine.
    # You should type "Template" If you want to get user information from VM template.
    # Default value: root
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Username of the Linux VM')]
    [string]$Username = 'root',
	
    # Password of the Linux virtual machine's user.
    # You should type "Template" If you want to get password information from VM template.
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Password of the Linux VM user')]
    [string]$Password,
	
    # Hostname of your Linux VM. Most control panels requires fully qualified name (FQDN) for hostname.
    # Hostname value should be like this: server.virtualmetric.com
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Hostname of your Linux VM')]
    [string]$Hostname,
	
    # IP address of your Linux VM. You can assign single IP for your Linux VM.
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'IP address of your Linux VM')]
    [Alias('IP')]
    [string]$IPAddress,

    # Subnet mask of your Linux VM.
    # A few examples of subnet mask value you can set: 255.255.255.0, 255.255.255.240 or 255.255.255.248
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Subnet mask of your Linux VM')]
    [Alias('Subnet')]
    [string]$SubnetMask,
	
    # Gateway address of your Linux VM.
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Gateway address of your Linux VM')]
    [Alias('Gateway')]
    [string]$GatewayAddress,
	
    # Primary DNS address of your Linux VM.
    # Default value: 8.8.8.8 (Google DNS)
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Primary DNS address of your Linux VM')]
    [Alias('DNS1')]
    [string]$PrimaryDNSAddress = '8.8.8.8',
	
    # Secondary DNS address of your Linux VM.
    # Default value: 8.8.4.4 (Google DNS)
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Secondary DNS address of your Linux VM')]
    [Alias('DNS2')]
    [string]$SecondaryDNSAddress = '8.8.4.4',

    # New password of the Linux VM user.
    # Use this parameter if you want to change user password.
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'New password of the Linux VM user')]
    [string]$NewPassword, 
	
    # New time zone value of the Linux VM.
    # Use this parameter if you want to change time zone.
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'New time zone value of the Linux VM')]
    [string]$TimeZone, 
	
    # Path of the answer file for custom virtual machine modifications. Example: "C:\answer.txt"
    # If you want to do additional changes on your Linux VM, add your commands into a file.
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Path of the answer file for custom VM modifications')]
    [string]$AnswerFile,
	
    # Name of the control panel you want to install. Valid values: "CPanel, Plesk"
    # This script allows you to install control panels like CPanel and Parallels Plesk automatically.
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the control panel you want to install')]
    [string]$Panel,
	
    # Language of the virtual machine console keyboard. Example: "us"
	# Default console keyboard language is English (us).
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Language of the virtual machine console keyboard.')]
    [string]$VMKeyboard,
	
	# Transfer custom files? Please provide path. Example: "C:\Custom.tar"
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Transfer custom files? Please provide path.')]
    [string]$TransferFile,
	
    # Extend Logical Volume
    # Use this parameter if you want to extend your logical volume.
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Extend Logical Volume')]
    [switch]$ExtendLVM = $false,

    # Do you want to install Linux integration components?
    # Currently supported distributions: CentOS 5.x, Redhat EL 5.x and Suse Enterprise 10 SP3.
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Install Linux integration components')]
    [switch]$InstallLIC = $false,
	
    # Do you want to output results as XML format?	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'XML output')]
    [switch]$OutXML = $false,
	
	# Debug Mode
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Debug Mode')]
    [switch]$DebugMode = $false
)

begin {

	# Enable Debug Mode
	if ($DebugMode)
	{
		$DebugPreference = "Continue"
	}
	else
	{
		$ErrorActionPreference = "silentlycontinue"
	}
	
	# Start Time
	$StartTime = Get-Date

	if ($Hostname -or $IPAddress -or $NewPassword -or $TimeZone -or $AnswerFile -or $Panel -or $ExtendLVM -or $InstallLIC -or $TransferFile)
	{
		# Prerequirement Check
		$Prerequirements = New-RequirementCheck -Username $Username -Password $Password -VMTemplateName $VMTemplateName -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer
		
		# Result code and message
		$ResultCode = $Prerequirements.ResultCode
		$ResultMessage = $Prerequirements.ResultMessage
		
		# Api response message
		if ($ResultCode -eq "0")
		{
			$ApiResponse = "400"
		}
		else
		{
			$ApiResponse = "100"
		}
	}
	else
	{
		# Result code and message
		$ResultCode = "0"
		$ApiResponse = "550"
		$ResultMessage = "No action needed."
	}
	
	# Debug Output
	Write-Debug "Prerequirement Check: $ResultMessage"
}

process {

	if ($ResultCode -eq "1")
	{
		# Global Variables
		$WmiHost = $Prerequirements.WmiHost
		$Username = $Prerequirements.Username
		$Password = $Prerequirements.Password
		$VMManager = $Prerequirements.VMManager
	
		# Open console connection to virtual machine
		$TestVMConsole = Connect-VMConsole -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost
		$VMConsole = $TestVMConsole.VSMKB
		
		# Result code and message
		$ResultCode = $TestVMConsole.ResultCode
		$ResultMessage = $TestVMConsole.ResultMessage
		
		# Debug Output
		Write-Debug "Console Connection Check: $ResultMessage"
		
		if ($ResultCode -eq "1")
		{
			# Login to virtual machine
			$ConnectLinuxVM = Connect-LinuxVM -VMConsole $VMConsole -Username $Username -Password $Password -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost
			
			# Result code and message
			$ResultCode = $ConnectLinuxVM.ResultCode
			$ResultMessage = $ConnectLinuxVM.ResultMessage
			
			# Debug Output
			Write-Debug "Connect Linux VM: $ResultMessage"
			
			if ($ResultCode -eq "1")
			{
				# Create timestamp
				$TimeStamp = New-TimeStamp
				
				# Get unattended script path
				$GetUnattendedScriptPath = Get-UnattendedScriptPath
				
				# Result code and message
				$ResultCode = $GetUnattendedScriptPath.ResultCode
				$ResultMessage = $GetUnattendedScriptPath.ResultMessage
				
				# Debug Output
				Write-Debug "Script Path Check: $ResultMessage"
				
				# Change linux virtual machine keyboard
				Set-LinuxVMKeyboard -VMKeyboard $VMKeyboard -VMConsole $VMConsole -VMManager $VMManager -WmiHost $WmiHost | Out-Null
			
				if ($ResultCode -eq "1")
				{
					# Script prefix
					$ScriptPrefix = Get-Random
					
					# Unattended script path
					$UnattendedScriptPath = $GetUnattendedScriptPath.UnattendedScriptPath
					
					# Start virtual machine customization
					if ($Hostname -or $IPAddress -or $NewPassword -or $TimeZone -or $AnswerFile -or $Panel) {
						Write-LinuxVMScript -TimeStamp $TimeStamp -ScriptPrefix $ScriptPrefix -UnattendedScriptPath $UnattendedScriptPath -StartCustomization -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost | Out-Null
					}
					
					# Set hostname of virtual machine
					if ($Hostname) { 
						Write-LinuxVMScript -TimeStamp $TimeStamp -ScriptPrefix $ScriptPrefix -UnattendedScriptPath $UnattendedScriptPath -Hostname $Hostname -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost | Out-Null 
					}

					# Set network configuration of virtual machine
					if ($IPAddress -and $SubnetMask -and $GatewayAddress) { 
						Write-LinuxVMScript -TimeStamp $TimeStamp -ScriptPrefix $ScriptPrefix -UnattendedScriptPath $UnattendedScriptPath -IP $IPAddress -Subnet $SubnetMask -Gateway $GatewayAddress -PrimaryDNSAddress $PrimaryDNSAddress -SecondaryDNSAddress $SecondaryDNSAddress -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost | Out-Null 
					}

					# Set new password to virtual machine
					if ($NewPassword) { 
						Write-LinuxVMScript -TimeStamp $TimeStamp -ScriptPrefix $ScriptPrefix -UnattendedScriptPath $UnattendedScriptPath -Username $Username -Password $NewPassword -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost | Out-Null 
					}	

					# Set new timezone to virtual machine
					if ($TimeZone) { 
						Write-LinuxVMScript -TimeStamp $TimeStamp -ScriptPrefix $ScriptPrefix -UnattendedScriptPath $UnattendedScriptPath -TimeZone $TimeZone -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost | Out-Null 
					}
					
					# Answer file for virtual machine
					if ($AnswerFile) { 
						Write-LinuxVMScript -TimeStamp $TimeStamp -ScriptPrefix $ScriptPrefix -UnattendedScriptPath $UnattendedScriptPath -AnswerFile $AnswerFile -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost | Out-Null 
					}

					# Install control panel on virtual machine
					if ($Panel) { 
						Write-LinuxVMScript -TimeStamp $TimeStamp -ScriptPrefix $ScriptPrefix -UnattendedScriptPath $UnattendedScriptPath -Panel $Panel -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost | Out-Null 
					}

					# End virtual machine customization
					if ($Hostname -or $IPAddress -or $NewPassword -or $TimeZone -or $AnswerFile -or $Panel) {
						Write-LinuxVMScript -TimeStamp $TimeStamp -ScriptPrefix $ScriptPrefix -UnattendedScriptPath $UnattendedScriptPath -EndCustomization -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost | Out-Null
					}
					
					# Extend logical volume of virtual machine
					if ($ExtendLVM) { 
						Write-LinuxVMScript -TimeStamp $TimeStamp -ScriptPrefix $ScriptPrefix -UnattendedScriptPath $UnattendedScriptPath -ExtendLVM -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost | Out-Null
						$TransferParted = $True
					}
					
					# Install linux integration services
					if ($InstallLIC) { 
						Write-LinuxVMScript -TimeStamp $TimeStamp -ScriptPrefix $ScriptPrefix -UnattendedScriptPath $UnattendedScriptPath -InstallLIC -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost | Out-Null 
						$TransferLIC = $True
					}
					
					# File transfer check
					if (!$Hostname -and !$IPAddress -and !$NewPassword -and !$TimeZone -and !$AnswerFile -and !$Panel -and !$ExtendLVM -and !$InstallLIC -and $TransferFile)
					{
						$FileTransferOnly = $True
						
						# Debug Output
						Write-Debug "File transfer only mode."
					}
					
					# Burn answer image file
					New-LinuxAnswerISO -ScriptPrefix $ScriptPrefix -UnattendedScriptPath $UnattendedScriptPath -TransferParted $TransferParted -TransferLIC $TransferLIC -TransferFile $TransferFile -VMManager $VMManager -WmiHost $WmiHost | Out-Null
					
					# Mount linux answer image
					$MountLinuxAnswerISO = Mount-LinuxAnswerISO -ScriptPrefix $ScriptPrefix -UnattendedScriptPath $UnattendedScriptPath -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost
					
					# Result code and message
					$ResultCode = $MountLinuxAnswerISO.ResultCode
					$ResultMessage = $MountLinuxAnswerISO.ResultMessage
					
					# Debug Output
					Write-Debug "Mount ISO Check: $ResultMessage"
					
					if ($ResultCode -eq "1")
					{	
						# Mount linux answer disc
						Update-LinuxVM -VMConsole $VMConsole -TimeStamp $TimeStamp -ScriptPrefix $ScriptPrefix -UnattendedScriptPath $UnattendedScriptPath -MountAnswerISO -TransferFile $TransferFile -FileTransferOnly $FileTransferOnly -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost | Out-Null

						# Linux virtual machine customization
						if ($Hostname -or $IPAddress -or $NewPassword -or $TimeZone -or $AnswerFile -or $Panel)
						{
							Update-LinuxVM -VMConsole $VMConsole -TimeStamp $TimeStamp -ScriptPrefix $ScriptPrefix -UnattendedScriptPath $UnattendedScriptPath -Customization -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost | Out-Null
						}
						
						# Extend logical volume of virtual machine
						if ($ExtendLVM) 
						{ 
							# Create new partition
							Update-LinuxVM -VMConsole $VMConsole -TimeStamp $TimeStamp -ScriptPrefix $ScriptPrefix -UnattendedScriptPath $UnattendedScriptPath -ExtendLVM "NewPartition" -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost | Out-Null
						
							# Resize logical volume
							Update-LinuxVM -VMConsole $VMConsole -TimeStamp $TimeStamp -ScriptPrefix $ScriptPrefix -UnattendedScriptPath $UnattendedScriptPath -ExtendLVM "ResizeFS" -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost | Out-Null
						}
						
						# Install linux integration services
						if ($InstallLIC)
						{
							# Install linux integration services
							Update-LinuxVM -VMConsole $VMConsole -TimeStamp $TimeStamp -ScriptPrefix $ScriptPrefix -UnattendedScriptPath $UnattendedScriptPath -InstallLIC -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost | Out-Null
							
							# Set synthetic network adapter
							$SyntheticNetwork = Set-VMNetwork -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost
							
							# Result code and message
							$ResultCode = $SyntheticNetwork.ResultCode
							$ResultMessage = $SyntheticNetwork.ResultMessage
							
							# Debug Output
							Write-Debug "Network Adapter Check: $ResultMessage"
							
							if ($ResultCode -eq "1")
							{
								$DisconnectStatus = "1"
							}
						}
						
						# Debug Output
						Write-Debug "Customization Check: $ResultMessage"
					}
					else
					{
						# Result code and message
						$ResultCode = $MountLinuxAnswerISO.ResultCode
						$ResultMessage = $MountLinuxAnswerISO.ResultMessage
					}
					
					# Dismount linux answer image 
					Dismount-LinuxAnswerISO -ScriptPrefix $ScriptPrefix -UnattendedScriptPath $UnattendedScriptPath -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost | Out-Null
					
					# Logoff from virtual machine					
					if ($DisconnectStatus -ne "1")
					{
						Disconnect-LinuxVM -Username $Username -VMConsole $VMConsole -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost | Out-Null
					}

					# Result code and message
					$ResultCode = "1"
					$ApiResponse = "200"
					$ResultMessage = "Linux virtual machine preparation is completed."
				}
				else
				{
					# Result code and message
					$ResultCode = $GetUnattendedScriptPath.ResultCode
					$ApiResponse = "400"
					$ResultMessage = $GetUnattendedScriptPath.ResultMessage
				}
			}
			else
			{
				# Result code and message
				$ResultCode = $ConnectLinuxVM.ResultCode
				$ApiResponse = "400"
				$ResultMessage = $ConnectLinuxVM.ResultMessage
			}
		}
		else
		{
			# Result code and message
			$ResultCode = $TestVMConsole.ResultCode
			$ApiResponse = "400"
			$ResultMessage = $TestVMConsole.ResultMessage
		}
	}
	
	# Finish Time
	$FinishTime = Get-Date
	
	# Total Preparation Time
	$TotalSeconds = ($FinishTime - $StartTime).TotalSeconds
	
	# Debug Output
	Write-Debug "Job Check: $ResultMessage"
}
 
end {

	if ($OutXML)
	{
		$Properties = New-Object Psobject
		$Properties | Add-Member Noteproperty VMName $VMName
		$Properties | Add-Member Noteproperty ApiResponse $ApiResponse
		$Properties | Add-Member Noteproperty StartTime $StartTime
		$Properties | Add-Member Noteproperty FinishTime $FinishTime
		$Properties | Add-Member Noteproperty TotalSeconds $TotalSeconds
		$Properties | New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage -Details		
	}
	else
	{
		$Properties = New-Object Psobject
		$Properties | Add-Member Noteproperty VMName $VMName
		$Properties | Add-Member Noteproperty ApiResponse $ApiResponse
		$Properties | Add-Member Noteproperty StartTime $StartTime
		$Properties | Add-Member Noteproperty FinishTime $FinishTime
		$Properties | Add-Member Noteproperty TotalSeconds $TotalSeconds
		$Properties | Add-Member Noteproperty ResultCode $ResultCode
		$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
		Write-Output $Properties
	}
}
} # End of function Set-LinuxVM
