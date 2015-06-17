# Copyright (C) 2015 VirtualMetric
# This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

function Test-PSSnapin {

<#
    .SYNOPSIS
     
        Function to test PS Snapins

    .EXAMPLE
     
        Test-PSSnapin -Name "Microsoft.SystemCenter.VirtualMachineManager"
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (
    [Parameter(
        Mandatory = $true,
        HelpMessage = 'PowerShell Snapin Name. Example: Microsoft.SystemCenter.VirtualMachineManager')]
    [string]$Name,
	
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
	
	$CheckSnapin = Get-PSSnapin -Name $Name -EA SilentlyContinue
	if (!$CheckSnapin)
	{
		$AddSnapin = Add-PSSnapin -Name $Name -EA SilentlyContinue
		$CheckSnapin = Get-PSSnapin -Name $Name -EA SilentlyContinue
		if (!$CheckSnapin)
		{
			$ResultCode = "-1"
			$ResultMessage = "$Name Snapin is not available."
		}
		else
		{
			$ResultCode = "1"
			$ResultMessage = "$Name Snapin is added."
		}
	}
	else
	{
		$ResultCode = "1"
		$ResultMessage = "$Name Snapin is already loaded."
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

function Test-PSModule {

<#
    .SYNOPSIS
     
        Function to test PS Modules

    .EXAMPLE
     
        Test-PSModule -Name "FailoverClusters"
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (
    [Parameter(
        Mandatory = $true,
        HelpMessage = 'PowerShell Module Name. Example: FailoverClusters')]
    [string]$Name,
	
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

	$CheckModule = Get-Module -Name $Name -EA SilentlyContinue
	if (!$CheckModule)
	{
		$ImportModule = Import-Module -Name $Name -EA SilentlyContinue
		$CheckModule = Get-Module -Name $Name -EA SilentlyContinue
		if (!$CheckModule)
		{
			$ResultCode = "-1"
			$ResultMessage = "$Name Module is not available."
		}
		else
		{
			$ResultCode = "1"
			$ResultMessage = "$Name Module is imported."
		}
	}
	else
	{
		$ResultCode = "1"
		$ResultMessage = "$Name Module is already imported."
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

function Test-WmiObject {

<#
    .SYNOPSIS
     
        Function to test Wmi Objects

    .EXAMPLE
     
        Test-WmiObject -NameSpace "root\virtualization" -WmiHost "hyperv01.virtualmetric.com"
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (
    [Parameter(
        Mandatory = $true,
        HelpMessage = 'Wmi NameSpace. Example: root\virtualization')]
    [string]$NameSpace,
	
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

	if (!$WmiHost)
	{
		$CheckWmiObject = Get-WmiObject -Computer "." -Namespace "$NameSpace" -Class "MSVM_VirtualSystemManagementService" -EA SilentlyContinue
		if (!$CheckWmiObject)
		{
			$ResultCode = "-1"
			$ResultMessage = "Could not contact with Wmi Provider."
		}
		else
		{
			$ResultCode = "1"
			$ResultMessage = "Wmi Provider is available."
		}
	}
	else
	{
		$CheckWmiObject = Get-WmiObject -Computer "$WmiHost" -Namespace "$NameSpace" -Class "MSVM_VirtualSystemManagementService" -EA SilentlyContinue
		if (!$CheckWmiObject)
		{
			$ResultCode = "-1"
			$ResultMessage = "Could not contact with Wmi Provider."
		}
		else
		{
			$ResultCode = "1"
			$ResultMessage = "Wmi Provider is available."
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
	
function Test-VMManager {

<#
    .SYNOPSIS
     
        Function to test VM Manager

    .EXAMPLE
     
        Test-VMManager -VMHost "hyperv01.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com"
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the Hyper-V host. Example: hyperv01.virtualmetric.com')]
    [string]$VMHost,
	
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the SCVMM server. Example: scvmm01.virtualmetric.com')]
    [string]$VMMServer = 'localhost',
	
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
	
	$VMManager = Test-PSSnapin -Name "Microsoft.SystemCenter.VirtualMachineManager"
	if ($VMManager.ResultCode -ne "1")
	{
		$VMManager = Test-PSModule -Name "virtualmachinemanager"
		if ($VMManager.ResultCode -ne "1")
		{
			if (!$VMHost)
			{
				$WmiHost = "."
			}
			else
			{
				$WmiHost = $VMHost
			}
			$VMManager = Test-WmiObject -NameSpace "root\virtualization" -WmiHost $WmiHost
			if ($VMManager.ResultCode -eq "1")
			{
				$ResultCode = "1"
				$ResultMessage = "Wmi Provider is available."
				$VMManager = "HyperV"
			}
			else
			{
				$VMManager = Test-WmiObject -NameSpace "root\virtualization\v2" -WmiHost $WmiHost
				if ($VMManager.ResultCode -eq "1")
				{
					$ResultCode = "1"
					$ResultMessage = "Wmi Provider is available."
					$VMManager = "HyperV2"
				}
				else
				{
					$ResultCode = "0"
					$ResultMessage = "Wmi Object is not available."
				}
			}
		}
		else
		{
			$VMManager = Get-SCVMMServer $VMMServer -EA SilentlyContinue
			if ($VMManager)
			{
				$ResultCode = "1"
				$ResultMessage = "SCVMM server connection is available."
				$VMManager = "SCVMM2012"
			}
			else
			{	
				$ResultCode = "0"
				$ResultMessage = "Can not connect to SCVMM server."
			}			
		}
	}
	else
	{
		$GetVMMServer = Get-VMMServer $VMMServer -EA SilentlyContinue
		if ($VMManager.ResultCode -eq "1")
		{
			$ResultCode = "1"
			$ResultMessage = "SCVMM server connection is available."
			$VMManager = "SCVMM"
		}
		else
		{
			$ResultCode = "0"
			$ResultMessage = "Can not connect to SCVMM server."
		}
	}
	
	if ($OutXML)
	{
		if ($ResultCode -eq "1") 
		{ 
			$Properties = New-Object Psobject
			$Properties | Add-Member Noteproperty VMManager $VMManager
			$Properties | New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage -Details
		}
		else
		{
			New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
		}
	}
	else
	{
		$Properties = New-Object Psobject
		$Properties | Add-Member Noteproperty ResultCode $ResultCode
		$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
		if ($ResultCode -eq "1") { $Properties | Add-Member Noteproperty VMManager $VMManager }
		Write-Output $Properties
	}
}

function Get-WmiHost {

<#
    .SYNOPSIS
     
        Function to get Wmi Hostname

    .EXAMPLE
     
        Get-WmiHost -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com"
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (
    [Parameter(
        Mandatory = $true,
        ValueFromPipelineByPropertyName= $true,
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
        HelpMessage = 'VM manager name.')]
    [string]$VMManager,
	
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

	if (!$VMManager) 
	{ 
		$TestVMManager = Test-VMManager -VMHost $VMHost -VMMServer $VMMServer
		
		if ($TestVMManager.ResultCode -eq "1")
		{
			$VMManager = $TestVMManager.VMManager
		}
		
		$ResultCode = $TestVMManager.ResultCode
		$ResultMessage = $TestVMManager.ResultMessage
	}
	else
	{
		$ResultCode = "1"
		$ResultMessage = "VM Manager is available."
	}
	
	if ($ResultCode -eq "1")
	{
		if ($VMManager -eq "SCVMM")
		{		
			if (!$VMHost)
			{
				try 
				{			
					$VMCount = @(Get-VM $VMName).Count
					if ($VMCount -eq "0")
					{
						$ResultCode = "0"
						$ResultMessage = "You have no VM with this name!"
					}
					elseif ($VMCount -eq "1")
					{
						$ResultCode = "1"
						$ResultMessage = "VM is available!"
						$VMStatus = (Get-VM $VMName).Status
						$WmiHost = (Get-VM $VMName).HostName
					}
					else
					{
						$ResultCode = "0"
						$ResultMessage = "You have multiple VMs with same name!"
					}
				}
				catch
				{
					$ResultCode = "0"
					$ResultMessage = $_
				}
			}
			else
			{
				try
				{
					$VMCount = @(Get-VM $VMName -VMHost $VMHost).Count
					if ($VMCount -eq "0")
					{
						$ResultCode = "0"
						$ResultMessage = "You have no VM with this name!"
					}
					elseif ($VMCount -eq "1")
					{
						$ResultCode = "1"
						$ResultMessage = "VM is available!"
						$VMStatus = (Get-VM $VMName -VMHost $VMHost).Status
						$WmiHost = $VMHost
					}
					else
					{
						$ResultCode = "0"
						$ResultMessage = "You have multiple VMs with same name!"
					}
				}
				catch
				{
					$ResultCode = "0"
					$ResultMessage = $_
				}
			}			
		}
		elseif ($VMManager -eq "SCVMM2012")
		{	
			if (!$VMHost)
			{
				try 
				{			
					$VMCount = @(Get-SCVirtualMachine $VMName).Count
					if ($VMCount -eq "0")
					{
						$ResultCode = "0"
						$ResultMessage = "You have no VM with this name!"
					}
					elseif ($VMCount -eq "1")
					{
						$ResultCode = "1"
						$ResultMessage = "VM is available!"
						$VMStatus = (Get-SCVirtualMachine $VMName).Status
						$WmiHost = (Get-SCVirtualMachine $VMName).HostName
					}
					else
					{
						$ResultCode = "0"
						$ResultMessage = "You have multiple VMs with same name!"
					}
				}
				catch
				{
					$ResultCode = "0"
					$ResultMessage = $_
				}
			}
			else
			{
				try
				{
					$VMCount = @(Get-SCVirtualMachine $VMName -VMHost $VMHost).Count
					if ($VMCount -eq "0")
					{
						$ResultCode = "0"
						$ResultMessage = "You have no VM with this name!"
					}
					elseif ($VMCount -eq "1")
					{
						$ResultCode = "1"
						$ResultMessage = "VM is available!"
						$VMStatus = (Get-SCVirtualMachine $VMName -VMHost $VMHost).Status
						$WmiHost = $VMHost
					}
					else
					{
						$ResultCode = "0"
						$ResultMessage = "You have multiple VMs with same name!"
					}
				}
				catch
				{
					$ResultCode = "0"
					$ResultMessage = $_
				}
			}
		}
		elseif ($VMManager -eq "HyperV2")
		{
			if (!$VMHost)
			{
				try
				{
					$VMStatus = (Get-WmiObject -Computer "." -Namespace "root\virtualization\v2" -Query "SELECT * FROM Msvm_ComputerSystem WHERE ElementName like '$VMName' AND caption like 'Virtual%' ").EnabledState
					if (!$VMStatus)
					{
						$FailoverCluster = Test-PSModule -Name FailoverClusters
						if ($FailoverCluster.ResultCode -ne "1")
						{
							$ResultCode = "0"
							$ResultMessage = "VM is not available."
						}
						else
						{
							if (!$VMCluster)
							{
								try
								{
									$VMCount = @(Get-Cluster | Get-ClusterGroup | where {$_.Name -match "$VMName"}).Count
									if ($VMCount -eq "0")
									{
										$ResultCode = "0"
										$ResultMessage = "You have no VM with this name!"
									}
									elseif ($VMCount -eq "1")
									{	
										$ResultCode = "1"	
										$ResultMessage = "VM is available!"								
										$VMConfig = (Get-Cluster | Get-ClusterGroup | where {$_.Name -match "$VMName"})
										$WmiHost = $VMConfig.OwnerNode.Name
									}
									else
									{
										$ResultCode = "0"
										$ResultMessage = "You have multiple VMs with same name!"
									}
								}
								catch
								{
									$ResultCode = "0"
									$ResultMessage = $_
								}
							}
							else
							{
								try
								{
									$VMCount = @(Get-Cluster $VMCluster | Get-ClusterGroup | where {$_.Name -match "$VMName"}).Count
									if ($VMCount -eq "0")
									{
										$ResultCode = "0"
										$ResultMessage = "You have no VM with this name!"
									}
									elseif ($VMCount -eq "1")
									{
										$ResultCode = "1"
										$ResultMessage = "VM is available!"
										$VMConfig = (Get-Cluster $VMCluster | Get-ClusterGroup | where {$_.Name -match "$VMName"})
										$WmiHost = $VMConfig.OwnerNode.Name								
									}
									else
									{
										$ResultCode = "0"
										$ResultMessage = "You have multiple VMs with same name!"
									}
								}
								catch
								{
									$ResultCode = "0"
									$ResultMessage = $_
								}							
							}
						}
					}
					else
					{
						$ResultCode = "1"
						$ResultMessage = "VM is available!"
						$WmiHost = "."
					}
				}
				catch
				{
					$ResultCode = "0"
					$ResultMessage = $_
				}
			}
			else
			{
				$VMStatus = (Get-WmiObject -Computer "$VMHost" -Namespace "root\virtualization\v2" -Query "SELECT * FROM Msvm_ComputerSystem WHERE ElementName like '$VMName' AND caption like 'Virtual%' ").EnabledState
				if (!$VMStatus)
				{
					$ResultCode = "0"
					$ResultMessage = "VM is not available."
				}
				else
				{
					$ResultCode = "1"
					$ResultMessage = "VM is available!"
					$WmiHost = $VMHost
				}
			}
		}
		else
		{
			if (!$VMHost)
			{
				try
				{
					$VMStatus = (Get-WmiObject -Computer "." -Namespace "root\virtualization" -Query "SELECT * FROM Msvm_ComputerSystem WHERE ElementName like '$VMName' AND caption like 'Virtual%' ").EnabledState
					if (!$VMStatus)
					{
						$FailoverCluster = Test-PSModule -Name FailoverClusters
						if ($FailoverCluster.ResultCode -ne "1")
						{
							$ResultCode = "0"
							$ResultMessage = "VM is not available."
						}
						else
						{
							if (!$VMCluster)
							{
								try
								{
									$VMCount = @(Get-Cluster | Get-ClusterGroup | where {$_.Name -match "$VMName"}).Count
									if ($VMCount -eq "0")
									{
										$ResultCode = "0"
										$ResultMessage = "You have no VM with this name!"
									}
									elseif ($VMCount -eq "1")
									{	
										$ResultCode = "1"	
										$ResultMessage = "VM is available!"								
										$VMConfig = (Get-Cluster | Get-ClusterGroup | where {$_.Name -match "$VMName"})
										$WmiHost = $VMConfig.OwnerNode.Name
									}
									else
									{
										$ResultCode = "0"
										$ResultMessage = "You have multiple VMs with same name!"
									}
								}
								catch
								{
									$ResultCode = "0"
									$ResultMessage = $_
								}
							}
							else
							{
								try
								{
									$VMCount = @(Get-Cluster $VMCluster | Get-ClusterGroup | where {$_.Name -match "$VMName"}).Count
									if ($VMCount -eq "0")
									{
										$ResultCode = "0"
										$ResultMessage = "You have no VM with this name!"
									}
									elseif ($VMCount -eq "1")
									{
										$ResultCode = "1"
										$ResultMessage = "VM is available!"
										$VMConfig = (Get-Cluster $VMCluster | Get-ClusterGroup | where {$_.Name -match "$VMName"})
										$WmiHost = $VMConfig.OwnerNode.Name								
									}
									else
									{
										$ResultCode = "0"
										$ResultMessage = "You have multiple VMs with same name!"
									}
								}
								catch
								{
									$ResultCode = "0"
									$ResultMessage = $_
								}							
							}
						}
					}
					else
					{
						$ResultCode = "1"
						$ResultMessage = "VM is available!"
						$WmiHost = "."
					}
				}
				catch
				{
					$ResultCode = "0"
					$ResultMessage = $_
				}
			}
			else
			{
				$VMStatus = (Get-WmiObject -Computer "$VMHost" -Namespace "root\virtualization" -Query "SELECT * FROM Msvm_ComputerSystem WHERE ElementName like '$VMName' AND caption like 'Virtual%' ").EnabledState
				if (!$VMStatus)
				{
					$ResultCode = "0"
					$ResultMessage = "VM is not available."
				}
				else
				{
					$ResultCode = "1"
					$ResultMessage = "VM is available!"
					$WmiHost = $VMHost
				}
			}
		}
	}
	
	if ($OutXML)
	{
		if ($ResultCode -eq "1")
		{
			$Properties = New-Object Psobject
			$Properties | Add-Member Noteproperty WmiHost $WmiHost
			$Properties | New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage -Details
		}
		else
		{
			New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
		}
	}
	else
	{
		$Properties = New-Object Psobject
		$Properties | Add-Member Noteproperty ResultCode $ResultCode
		$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
		if ($ResultCode -eq "1") { $Properties | Add-Member Noteproperty WmiHost $WmiHost }
		Write-Output $Properties
	}
}

# Check VM State
function Test-VMState {

<#
    .SYNOPSIS
     
        Function to test VM State

    .EXAMPLE
     
        Test-VMState -VMName "CentOS01"
	
	.EXAMPLE
     
        Test-VMState -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com"
		
	.EXAMPLE
     
        Test-VMState -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com"

	.EXAMPLE
     
        Test-VMState -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com"
	
	.EXAMPLE
     
        Test-VMState -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com"
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (
    [Parameter(
        Mandatory = $true,
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
	
	if (!$VMManager) 
	{ 
		$TestVMManager = Test-VMManager -VMHost $VMHost -VMMServer $VMMServer
		
		if ($TestVMManager.ResultCode -eq "1")
		{
			$VMManager = $TestVMManager.VMManager
		}
		
		$ResultCode = $TestVMManager.ResultCode
		$ResultMessage = $TestVMManager.ResultMessage
	}
	else
	{
		$ResultCode = "1"
		$ResultMessage = "VM Manager is available."
	}
	
	if ($ResultCode -eq "1")
	{
		if (!$WmiHost) 
		{ 
			$TestWmiHost = Get-WmiHost -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager
			if ($TestWmiHost.ResultCode -eq "1")
			{
				$WmiHost = $TestWmiHost.WmiHost
				$ResultCode = $TestWmiHost.ResultCode
				$ResultMessage = $TestWmiHost.ResultMessage
			}
			else
			{
				$ResultCode = $TestWmiHost.ResultCode
				$ResultMessage = $TestWmiHost.ResultMessage				
			}
		}
		else
		{
			$ResultCode = "1"
			$ResultMessage = "WmiHost is available."		
		}
	}
	
	if ($ResultCode -eq "1")
	{
		if ($VMManager -eq "SCVMM")
		{		
			try 
			{			
				$ResultMessage = "Retrieving VM status..."
				$VMStatus = (Get-VM $VMName -VMHost $WmiHost).Status
				if ($VMStatus -ne "Running")
				{
					$ResultCode = "0"
					$ResultMessage = "VM is not in running state."
				}
				else
				{
					$ResultCode = "1"
					$ResultMessage = "VM state is OK!"
				}
			}
			catch
			{
				$ResultCode = "0"
				$ResultMessage = $_
			}
		}
		elseif ($VMManager -eq "SCVMM2012")
		{
			try 
			{			
				$ResultMessage = "Retrieving VM status..."
				$VMStatus = (Get-SCVirtualMachine $VMName -VMHost $WmiHost).Status
				if ($VMStatus -ne "Running")
				{
					$ResultCode = "0"
					$ResultMessage = "VM is not in running state."
				}
				else
				{
					$ResultCode = "1"
					$ResultMessage = "VM state is OK!"
				}
			}
			catch
			{
				$ResultCode = "0"
				$ResultMessage = $_
			}
		}
		elseif ($VMManager -eq "HyperV2")
		{
			try
			{
				$VMStatus = (Get-WmiObject -Computer "$WmiHost" -Namespace "root\virtualization\v2" -Query "SELECT * FROM Msvm_ComputerSystem WHERE ElementName like '$VMName' AND caption like 'Virtual%' ").EnabledState
				if ($VMStatus -ne "2")
				{
					$ResultCode = "0"
					$ResultMessage = "VM is not in running state."
				}
				else
				{
					$ResultCode = "1"
					$ResultMessage = "VM state is OK!"
				}
			}
			catch
			{
				$ResultCode = "0"
				$ResultMessage = $_
			}
		}
		else
		{
			try
			{
				$VMStatus = (Get-WmiObject -Computer "$WmiHost" -Namespace "root\virtualization" -Query "SELECT * FROM Msvm_ComputerSystem WHERE ElementName like '$VMName' AND caption like 'Virtual%' ").EnabledState
				if ($VMStatus -ne "2")
				{
					$ResultCode = "0"
					$ResultMessage = "VM is not in running state."
				}
				else
				{
					$ResultCode = "1"
					$ResultMessage = "VM state is OK!"
				}
			}
			catch
			{
				$ResultCode = "0"
				$ResultMessage = $_
			}
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

function Test-Credentials {

<#
    .SYNOPSIS
     
        Function to test VM Credentials

    .EXAMPLE
     
        Test-Credentials -Username "root" -Password "password"
		
	.EXAMPLE
     
        Test-Credentials -VMTemplateName "CentOS62x64"
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Username of the VM template. Example: root')]
    [string]$Username,
	
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Password of the VM template. Example: password')]
    [string]$Password,

    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the VM template. Example: CentOS62x64')]
    [string]$VMTemplateName,
	
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
	
	if (!$VMTemplateName)
	{
		$ResultMessage = "No template is specified."
		if (!$Username -or !$Password)
		{
			$ResultCode = "0"
			$ResultMessage = "Username or password information could not be retrieved!"				
		}
		else
		{
			$ResultCode = "1"
			$ResultMessage = "Username and password information validated."
		}
	}
	else
	{	
		if (!$VMManager) 
		{ 
			$TestVMManager = Test-VMManager -VMHost $VMHost -VMMServer $VMMServer
			
			if ($TestVMManager.ResultCode -eq "1")
			{
				$VMManager = $TestVMManager.VMManager
			}
			
			$ResultCode = $TestVMManager.ResultCode
			$ResultMessage = $TestVMManager.ResultMessage
		}
		else
		{
			$ResultCode = "1"
			$ResultMessage = "VM Manager is available."
		}
		
		if ($ResultCode -eq "1")
		{
			if ($VMManager -eq "SCVMM")
			{
				$ConnectVMM = Get-VMMServer $VMMServer -EA SilentlyContinue
				$VMTemplate = Get-Template | Where {$_.Name -eq $VMTemplateName}
				
				if (!$VMTemplate)
				{
					$ResultCode = "0"
					$ResultMessage = "$VMTemplateName is not exist on $VMMServer."
				}
				else
				{
					if (!$Username -or !$Password)
					{
						$Username = $VMTemplate.CustomProperties[0]
						$Password = $VMTemplate.CustomProperties[1]
						if ($Username -eq $null -or $Password -eq $null)
						{
							$ResultCode = "0"
							$ResultMessage = "Username or password information could not be retrieved!"				
						}
						else
						{
							$ResultCode = "1"
							$ResultMessage = "Username and password information validated."
						}
					}
				}
			}
			elseif ($VMManager -eq "SCVMM2012")
			{
				$ConnectVMM = Get-SCVMMServer $VMMServer -EA SilentlyContinue
				$VMTemplate = Get-SCVMTemplate | Where {$_.Name -eq $VMTemplateName}
				
				if (!$VMTemplate)
				{
					$ResultCode = "0"
					$ResultMessage = "$VMTemplateName is not exist on $VMMServer."
				}
				else
				{
					if (!$Username -or !$Password)
					{
						$Username = $VMTemplate.CustomProperties[0]
						$Password = $VMTemplate.CustomProperties[1]
						if ($Username -eq $null -or $Password -eq $null)
						{
							$ResultCode = "0"
							$ResultMessage = "Username or password information could not be retrieved!"				
						}
						else
						{
							$ResultCode = "1"
							$ResultMessage = "Username and password information validated."
						}
					}
				}
			}
			else
			{
				$ResultCode = "0"
				$ResultMessage = "Can not connect to SCVMM server."
			}
		}
	}
		
	if ($OutXML)
	{
		if ($ResultCode -eq "1")
		{
			$Properties = New-Object Psobject
			$Properties | Add-Member Noteproperty Username $Username
			$Properties | Add-Member Noteproperty Password $Password
			$Properties | New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage -Details
		}
		else
		{
			New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
		}
	}
	else
	{
		$Properties = New-Object Psobject
		$Properties | Add-Member Noteproperty ResultCode $ResultCode
		$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
		if ($ResultCode -eq "1")
		{
			$Properties | Add-Member Noteproperty Username $Username
			$Properties | Add-Member Noteproperty Password $Password
		}
		Write-Output $Properties
	}
}

function Connect-VMConsole {

<#
    .SYNOPSIS
     
        Function to connect VM Console

    .EXAMPLE
     
        Connect-VMConsole -VMName "CentOS01"
	
	.EXAMPLE
     
        Connect-VMConsole -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com"
		
	.EXAMPLE
     
        Connect-VMConsole -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com"

	.EXAMPLE
     
        Connect-VMConsole -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com"
	
	.EXAMPLE
     
        Connect-VMConsole -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com"
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (
    [Parameter(
        Mandatory = $true,
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
	
	if (!$WmiHost) 
	{ 
		$TestWmiHost = Get-WmiHost -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager
		if ($TestWmiHost.ResultCode -eq "1")
		{
			$WmiHost = $TestWmiHost.WmiHost
			$ResultCode = $TestWmiHost.ResultCode
			$ResultMessage = $TestWmiHost.ResultMessage
		}
		else
		{
			$ResultCode = $TestWmiHost.ResultCode
			$ResultMessage = $TestWmiHost.ResultMessage				
		}
	}
	else
	{
		$ResultCode = "1"
		$ResultMessage = "WmiHost is available."		
	}
	
	if ($ResultCode -eq "1")
	{	
		$TestVMState = Test-VMState -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost
	
		if ($TestVMState.ResultCode -eq "1")
		{
			if ($VMManager -eq "HyperV2")
			{
				$VMConf = Get-WmiObject -ComputerName "$WmiHost" -Namespace "root\virtualization\v2" -Query "SELECT * FROM Msvm_ComputerSystem WHERE ElementName like '$VMName' AND caption like 'Virtual%' "
			}
			else
			{
				$VMConf = Get-WmiObject -ComputerName "$WmiHost" -Namespace "root\virtualization" -Query "SELECT * FROM Msvm_ComputerSystem WHERE ElementName like '$VMName' AND caption like 'Virtual%' "
			}
			$VSMKB = ($VMConf.getRelated("Msvm_Keyboard") | select-object)
			$ResultCode = "1"
			$ResultMessage = "Connected to virtual keyboard."
		}
		else
		{
			$ResultCode = $TestVMState.ResultCode
			$ResultMessage = $TestVMState.ResultMessage
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
		if ($ResultCode -eq "1")
		{
			$Properties | Add-Member Noteproperty VSMKB $VSMKB
		}
		Write-Output $Properties
	}
}

function Open-VMConsole {

<#
    .SYNOPSIS
     
        Function to simulate VM Console

    .EXAMPLE
     
        Open-VMConsole -VMName "CentOS01"
	
	.EXAMPLE
     
        Open-VMConsole -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com"
		
	.EXAMPLE
     
        Open-VMConsole -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com"

	.EXAMPLE
     
        Open-VMConsole -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com"
	
	.EXAMPLE
     
        Open-VMConsole -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com"
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (
    [Parameter(
        Mandatory = $true,
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

	if (!$WmiHost)
	{
		$TestVMConsole = Connect-VMConsole -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager
		$VMConsole = $TestVMConsole.VSMKB
	}
	else
	{
		$TestVMConsole = Connect-VMConsole -VMName $VMName -WmiHost $WmiHost
		$VMConsole = $TestVMConsole.VSMKB
	}
		
	if ($TestVMConsole.ResultCode -eq "1")
	{
		try
		{		
			# Change console keyboard to English for current session
			$SendCommand = $VMConsole.TypeText("loadkeys us");
			$SendCommand = $VMConsole.Typekey(0x0D)
			Start-Sleep 3
			$host.ui.rawui.backgroundcolor = "black"
			$host.ui.rawui.foregroundcolor = "white"
			cls
			Write-Host "PoSHOS release 6.2 (Final)"
			Write-Host "Kernel 2.6.32.x86_64 on an x86_64"
			Write-Host " "
			
			$ShouldProcess = $true
			while ($ShouldProcess) 
			{
				$SendCommand = Read-Host "[root@localhost]# "
				if ($SendCommand -eq "exit")
				{
					$ShouldProcess = $false
				}
				elseif ($SendCommand -eq "clear")
				{
					cls
					Write-Host "PoSHOS release 6.2 (Final)"
					Write-Host "Kernel 2.6.32.x86_64 on an x86_64"
					Write-Host " "				
				}
				$SendCommand = $VMConsole.TypeText("$SendCommand");
				$SendCommand = $VMConsole.Typekey(0x0D)
				Start-Sleep 1
			}
			$host.ui.rawui.backgroundcolor = "darkmagenta"
			$host.ui.rawui.foregroundcolor = "darkyellow"
			cls
			$ResultCode = "1"
			$ResultMessage = "Console connection is closed."
		}
		catch
		{
			$ResultCode = "0"
			$ResultMessage = $_
		}
	}
	else
	{
		$ResultCode = $TestVMConsole.ResultCode
		$ResultMessage = $TestVMConsole.ResultMessage
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

function Clear-VMConsole {

<#
    .SYNOPSIS
     
        Function to clear content of VM Console

    .EXAMPLE
     
        Clear-VMConsole -VMName "CentOS01"
	
	.EXAMPLE
     
        Clear-VMConsole -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com"
		
	.EXAMPLE
     
        Clear-VMConsole -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com"

	.EXAMPLE
     
        Clear-VMConsole -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com"
	
	.EXAMPLE
     
        Clear-VMConsole -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com"
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (
    [Parameter(
        Mandatory = $true,
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

	if (!$WmiHost)
	{
		$TestVMConsole = Connect-VMConsole -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager
		$VMConsole = $TestVMConsole.VSMKB
	}
	else
	{
		$TestVMConsole = Connect-VMConsole -VMName $VMName -VMManager $VMManager -WmiHost $WmiHost
		$VMConsole = $TestVMConsole.VSMKB
	}
		
	if ($TestVMConsole.ResultCode -eq "1")
	{	
		try
		{
			# Clear VM Console
			$SendCommand = $VMConsole.TypeText("clear;");
			$SendCommand = $VMConsole.Typekey(0x0D)
			$ResultCode = "1"
			$ResultMessage = "Console connection is closed."
		}
		catch
		{
			$ResultCode = "0"
			$ResultMessage = $_
		}
	}
	else
	{
		$ResultCode = $TestVMConsole.ResultCode
		$ResultMessage = $TestVMConsole.ResultMessage
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

function Send-RandomVMString {

<#
    .SYNOPSIS
     
        Function to clear content of VM Console

    .EXAMPLE
     
        Send-RandomVMString -VMName "CentOS01"
	
	.EXAMPLE
     
        Send-RandomVMString -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com"
		
	.EXAMPLE
     
        Send-RandomVMString -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com"

	.EXAMPLE
     
        Send-RandomVMString -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com"
	
	.EXAMPLE
     
        Send-RandomVMString -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com"
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (
    [Parameter(
        Mandatory = $true,
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

	if (!$WmiHost)
	{
		$TestVMConsole = Connect-VMConsole -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager
		$VMConsole = $TestVMConsole.VSMKB
	}
	else
	{
		$TestVMConsole = Connect-VMConsole -VMName $VMName -VMManager $VMManager -WmiHost $WmiHost
		$VMConsole = $TestVMConsole.VSMKB
	}
		
	if ($TestVMConsole.ResultCode -eq "1")
	{	
		try
		{
			# Send Random String
			$RandomVMString = Get-Random
			$SendCommand = $VMConsole.TypeText("$RandomVMString");
			$SendCommand = $VMConsole.Typekey(0x0D)
			$ResultCode = "1"
			$ResultMessage = "Console connection is closed."
		}
		catch
		{
			$ResultCode = "0"
			$ResultMessage = $_
		}
	}
	else
	{
		$ResultCode = $TestVMConsole.ResultCode
		$ResultMessage = $TestVMConsole.ResultMessage
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

function Get-VMNetwork {

<#
    .SYNOPSIS
     
        Function to get VM Network

    .EXAMPLE
     
        Get-VMNetwork -VMName "CentOS01"
	
	.EXAMPLE
     
        Get-VMNetwork -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com"
		
	.EXAMPLE
     
        Get-VMNetwork -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com"

	.EXAMPLE
     
        Get-VMNetwork -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com"
	
	.EXAMPLE
     
        Get-VMNetwork -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com"
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (
    [Parameter(
        Mandatory = $true,
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
	
	if (!$VMManager) 
	{ 
		$TestVMManager = Test-VMManager -VMHost $VMHost -VMMServer $VMMServer
		
		if ($TestVMManager.ResultCode -eq "1")
		{
			$VMManager = $TestVMManager.VMManager
		}
		
		$ResultCode = $TestVMManager.ResultCode
		$ResultMessage = $TestVMManager.ResultMessage
	}
	else
	{
		$ResultCode = "1"
		$ResultMessage = "VM Manager is available."
	}
	
	if ($ResultCode -eq "1")
	{
		if (!$WmiHost) 
		{ 
			$TestWmiHost = Get-WmiHost -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager
			if ($TestWmiHost.ResultCode -eq "1")
			{
				$WmiHost = $TestWmiHost.WmiHost
				$ResultCode = $TestWmiHost.ResultCode
				$ResultMessage = $TestWmiHost.ResultMessage
			}
			else
			{
				$ResultCode = $TestWmiHost.ResultCode
				$ResultMessage = $TestWmiHost.ResultMessage				
			}
		}
		else
		{
			$ResultCode = "1"
			$ResultMessage = "WmiHost is available."
		}
	}
	
	if ($ResultCode -eq "1")
	{
		if ($VMManager -eq "SCVMM")
		{		
			try 
			{			
				$NetworkAdapter = @(Get-VM $VMName -VMHost $WmiHost | Get-VirtualNetworkAdapter)[0]
				if (!$NetworkAdapter)
				{
					$ResultCode = "0"
					$ResultMessage = "No network adapter detected."
				}
				else
				{
					$AdapterNetwork = $NetworkAdapter.VirtualNetwork
					$AdapterMAC = $NetworkAdapter.EthernetAddress
					$AdapterMacType = $NetworkAdapter.PhysicalAddressType
					$AdapterVLAN = $NetworkAdapter.VLanId
					$AdapterType = $NetworkAdapter.VirtualNetworkAdapterType
					$ResultCode = "1"
					$ResultMessage = "Network adapter detected."
				}
			}
			catch
			{
				$ResultCode = "0"
				$ResultMessage = $_
			}
		}
		elseif ($VMManager -eq "SCVMM2012")
		{
			try 
			{			
				$NetworkAdapter = @(Get-SCVirtualMachine $VMName -VMHost $WmiHost | Get-SCVirtualNetworkAdapter)[0]
				if (!$NetworkAdapter)
				{
					$ResultCode = "0"
					$ResultMessage = "No network adapter detected."
				}
				else
				{
					$AdapterNetwork = $NetworkAdapter.VirtualNetwork
					$AdapterMAC = $NetworkAdapter.EthernetAddress
					$AdapterMacType = $NetworkAdapter.PhysicalAddressType
					$AdapterVLAN = $NetworkAdapter.VLanId
					$AdapterType = $NetworkAdapter.VirtualNetworkAdapterType
					$ResultCode = "1"
					$ResultMessage = "Network adapter detected."
				}
			}
			catch
			{
				$ResultCode = "0"
				$ResultMessage = $_
			}
		}
		else
		{
			try
			{
				if ($VMManager -eq "HyperV2")
				{
					$VMConf = Get-WmiObject -ComputerName "$WmiHost" -Namespace "root\virtualization\v2" -Query "SELECT * FROM Msvm_ComputerSystem WHERE ElementName like '$VMName' AND caption like 'Virtual%' "
					$VMSetting = Get-WmiObject -ComputerName $VMConf.__Server -Namespace "root\virtualization\v2" -Query "associators of {$($VMConf.__Path)} where resultclass=MSVM_VirtualSystemSettingData" | where-object {$_.instanceID -eq "Microsoft:$($VMConf.name)"}
					$NetworkAdapter = Get-WmiObject -ComputerName $VMConf.__Server -Namespace "root\virtualization\v2" -Query "associators of {$($VMSetting.__Path)}" | where-object {$_.ElementName -eq 'Ethernet Port' -or $_.ElementName -like '*Network Adapter'}
					if ($NetworkAdapter)
					{
						$NetworkAdapter = @(Get-WmiObject -ComputerName $VMConf.__Server -Namespace "root\virtualization\v2" -Query "associators of {$($VMSetting.__Path)}" | where-object {$_.ElementName -eq 'Ethernet Port' -or $_.ElementName -like '*Network Adapter'})[0]
						$VirtualNetwork = Get-WmiObject -ComputerName $VMConf.__Server -NameSpace "root\virtualization\v2" -Query "associators OF {$($NetworkAdapter.Connection[0])} where resultclass = Msvm_VirtualSwitch"
						$VirtualLAN = Get-WmiObject -ComputerName $VMConf.__Server -Namespace "root\virtualization\v2" -Query "associators of {$($NetworkAdapter.Connection[0])} where assocClass=msvm_bindsto" | foreach-object {Get-WmiObject -ComputerName $VMConf.__Server -Namespace "root\virtualization\v2" -Query "associators of {$_} where assocClass=MSVM_NetWorkElementSettingData"}
						if ($VirtualNetwork)
						{
							$AdapterNetwork = $VirtualNetwork.ElementName
						}
						else
						{
							$AdapterNetwork = "Not connected"
						}
						$AdapterName = $NetworkAdapter.ElementName
						$AdapterRAW = $NetworkAdapter.address
						$AdapterMAC = for ($i = 2 ; $i -le 14 ; $i += 3) { $Result = $AdapterRAW = $AdapterRAW.Insert($i, ':') } ; $AdapterMAC = $Result;
						$AdapterMacType = if ($NetworkAdapter.StaticMacAddress -eq $true) { Write-Output Static } else { Write-Output Dynamic }
						if ($VirtualLAN)
						{
							$AdapterVLAN = $VirtualLAN.accessVlan
						}
						else
						{
							$AdapterVLAN = "Trunk Mode"
						}
						$AdapterType = $NetworkAdapter.ResourceSubType.Split(" ")[1]	
						$ResultCode = "1"
						$ResultMessage = "Network adapter detected."					
					}
					else
					{
						$ResultCode = "0"
						$ResultMessage = "No network adapter detected."
					}
				}
				else
				{
					$VMConf = Get-WmiObject -ComputerName "$WmiHost" -Namespace "root\virtualization" -Query "SELECT * FROM Msvm_ComputerSystem WHERE ElementName like '$VMName' AND caption like 'Virtual%' "
					$VMSetting = Get-WmiObject -ComputerName $VMConf.__Server -Namespace "root\virtualization" -Query "associators of {$($VMConf.__Path)} where resultclass=MSVM_VirtualSystemSettingData" | where-object {$_.instanceID -eq "Microsoft:$($VMConf.name)"}
					$NetworkAdapter = Get-WmiObject -ComputerName $VMConf.__Server -Namespace "root\virtualization" -Query "associators of {$($VMSetting.__Path)}" | where-object {$_.ElementName -eq 'Ethernet Port' -or $_.ElementName -like '*Network Adapter'}
					if ($NetworkAdapter)
					{
						$NetworkAdapter = @(Get-WmiObject -ComputerName $VMConf.__Server -Namespace "root\virtualization" -Query "associators of {$($VMSetting.__Path)}" | where-object {$_.ElementName -eq 'Ethernet Port' -or $_.ElementName -like '*Network Adapter'})[0]
						$VirtualNetwork = Get-WmiObject -ComputerName $VMConf.__Server -NameSpace "root\virtualization" -Query "associators OF {$($NetworkAdapter.Connection[0])} where resultclass = Msvm_VirtualSwitch"
						$VirtualLAN = Get-WmiObject -ComputerName $VMConf.__Server -Namespace "root\virtualization" -Query "associators of {$($NetworkAdapter.Connection[0])} where assocClass=msvm_bindsto" | foreach-object {Get-WmiObject -ComputerName $VMConf.__Server -Namespace "root\virtualization" -Query "associators of {$_} where assocClass=MSVM_NetWorkElementSettingData"}
						if ($VirtualNetwork)
						{
							$AdapterNetwork = $VirtualNetwork.ElementName
						}
						else
						{
							$AdapterNetwork = "Not connected"
						}
						$AdapterName = $NetworkAdapter.ElementName
						$AdapterRAW = $NetworkAdapter.address
						$AdapterMAC = for ($i = 2 ; $i -le 14 ; $i += 3) { $Result = $AdapterRAW = $AdapterRAW.Insert($i, ':') } ; $AdapterMAC = $Result;
						$AdapterMacType = if ($NetworkAdapter.StaticMacAddress -eq $true) { Write-Output Static } else { Write-Output Dynamic }
						if ($VirtualLAN)
						{
							$AdapterVLAN = $VirtualLAN.accessVlan
						}
						else
						{
							$AdapterVLAN = "Trunk Mode"
						}
						$AdapterType = $NetworkAdapter.ResourceSubType.Split(" ")[1]	
						$ResultCode = "1"
						$ResultMessage = "Network adapter detected."					
					}
					else
					{
						$ResultCode = "0"
						$ResultMessage = "No network adapter detected."
					}
				}
			}
			catch
			{
				$ResultCode = "0"
				$ResultMessage = $_
			}
		}
	}
	
	if ($OutXML)
	{
		if ($ResultCode -eq "1")
		{
			$Properties = New-Object Psobject
			$Properties | Add-Member Noteproperty VirtualNetwork $AdapterNetwork
			$Properties | Add-Member Noteproperty EthernetAddress $AdapterMAC
			$Properties | Add-Member Noteproperty EthernetAddressType $AdapterMACType
			$Properties | Add-Member Noteproperty VLanId $AdapterVLAN
			$Properties | Add-Member Noteproperty AdapterType $AdapterType
			$Properties | Add-Member Noteproperty AdapterName $AdapterName
			$Properties | New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage -Details
		}
		else
		{
			New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
		}
	}
	else
	{
		$Properties = New-Object Psobject
		$Properties | Add-Member Noteproperty ResultCode $ResultCode
		$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
		if ($ResultCode -eq "1")
		{
			$Properties | Add-Member Noteproperty VirtualNetwork $AdapterNetwork
			$Properties | Add-Member Noteproperty EthernetAddress $AdapterMAC
			$Properties | Add-Member Noteproperty EthernetAddressType $AdapterMACType
			$Properties | Add-Member Noteproperty VLanId $AdapterVLAN
			$Properties | Add-Member Noteproperty AdapterType $AdapterType
			$Properties | Add-Member Noteproperty AdapterName $AdapterName
		}
		Write-Output $Properties
	}
}

function Set-VMNetwork {

<#
    .SYNOPSIS
     
        Function to set VM Network

    .EXAMPLE
     
        Set-VMNetwork -VMName "CentOS01"
	
	.EXAMPLE
     
        Set-VMNetwork -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com"
		
	.EXAMPLE
     
        Set-VMNetwork -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com"

	.EXAMPLE
     
        Set-VMNetwork -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com"
	
	.EXAMPLE
     
        Set-VMNetwork -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com"
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (
    [Parameter(
        Mandatory = $true,
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

	if (!$VMManager) 
	{ 
		$TestVMManager = Test-VMManager -VMHost $VMHost -VMMServer $VMMServer
		
		if ($TestVMManager.ResultCode -eq "1")
		{
			$VMManager = $TestVMManager.VMManager
		}
		
		$ResultCode = $TestVMManager.ResultCode
		$ResultMessage = $TestVMManager.ResultMessage
	}
	else
	{
		$ResultCode = "1"
		$ResultMessage = "VM Manager is available."
	}
	
	if ($ResultCode -eq "1")
	{
		if (!$WmiHost) 
		{ 
			$TestWmiHost = Get-WmiHost -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager
			if ($TestWmiHost.ResultCode -eq "1")
			{
				$WmiHost = $TestWmiHost.WmiHost
				$ResultCode = $TestWmiHost.ResultCode
				$ResultMessage = $TestWmiHost.ResultMessage
			}
			else
			{
				$ResultCode = $TestWmiHost.ResultCode
				$ResultMessage = $TestWmiHost.ResultMessage				
			}
		}
		else
		{
			$ResultCode = "1"
			$ResultMessage = "WmiHost is available."
		}
	}
	
	if ($ResultCode -eq "1")
	{
		# Get VM Network Information
		$VMNetwork = Get-VMNetwork -VMName $VMName -VMManager $VMManager -WmiHost $WmiHost
		
		if ($VMNetwork.ResultCode -eq "1")
		{
			$AdapterNetwork = $VMNetwork.VirtualNetwork
			$AdapterMAC = $VMNetwork.EthernetAddress
			$AdapterMACType = $VMNetwork.EthernetAddressType
			$AdapterVLAN = $VMNetwork.VLanId
			$AdapterType = $VMNetwork.AdapterType
			$AdapterName = $VMNetwork.AdapterName
			
			if ($AdapterType -eq "Emulated")
			{
				try 
				{	
					if ($AdapterNetwork -ne "Not connected")
					{
						# Get Wmi config of virtual machine
						if ($VMManager -eq "HyperV2")
						{
							$VMConf = Get-WmiObject -ComputerName "$WmiHost" -Namespace "root\virtualization\v2" -Query "SELECT * FROM Msvm_ComputerSystem WHERE ElementName like '$VMName' AND caption like 'Virtual%' "
							$VMSetting = Get-WmiObject -ComputerName $VMConf.__Server -Namespace "root\virtualization\v2" -Query "associators of {$($VMConf.__Path)} where resultclass=MSVM_VirtualSystemSettingData" | Where-Object {$_.instanceID -eq "Microsoft:$($VMConf.name)"}
							$NetworkAdapter = @(Get-WmiObject -ComputerName $VMConf.__Server -Namespace "root\virtualization\v2" -Query "associators of {$($VMSetting.__Path)}" | Where-Object {$_.ElementName -eq 'Ethernet Port' -or $_.ElementName -like '*Network*Adapter*'})[0]
							$VSMgtSvc = Get-WmiObject -ComputerName $VMSetting.__Server -Namespace "root\virtualization\v2" -Class "MSVM_VirtualSystemManagementService"
						}
						else
						{
							$VMConf = Get-WmiObject -ComputerName "$WmiHost" -Namespace "root\virtualization" -Query "SELECT * FROM Msvm_ComputerSystem WHERE ElementName like '$VMName' AND caption like 'Virtual%' "
							$VMSetting = Get-WmiObject -ComputerName $VMConf.__Server -Namespace "root\virtualization" -Query "associators of {$($VMConf.__Path)} where resultclass=MSVM_VirtualSystemSettingData" | Where-Object {$_.instanceID -eq "Microsoft:$($VMConf.name)"}
							$NetworkAdapter = @(Get-WmiObject -ComputerName $VMConf.__Server -Namespace "root\virtualization" -Query "associators of {$($VMSetting.__Path)}" | Where-Object {$_.ElementName -eq 'Ethernet Port' -or $_.ElementName -like '*Network*Adapter*'})[0]
							$VSMgtSvc = Get-WmiObject -ComputerName $VMSetting.__Server -Namespace "root\virtualization" -Class "MSVM_VirtualSystemManagementService"
						}
						# Stop virtual machine
						$StopLinuxVM = $VMConf.RequestStateChange(3)
						$StopLinuxVM = ProcessWMIJob($StopLinuxVM)
						# Remove emulated network adapter
						$RemoveNetworkAdapter = $VSMgtSvc.RemoveVirtualSystemResources($VMConf.__Path, @( $NetworkAdapter.__Path ))
						$RemoveNetworkAdapter = ProcessWMIJob($RemoveNetworkAdapter)
						# Add synthetic network adapter
						[String]$GUID=("{"+[System.GUID]::NewGUID().ToString()+"}")
						[String]$Name=([System.GUID]::NewGUID().ToString())
						if ($VMManager -eq "HyperV2")
						{
							$NetworkAllocation = ((Get-WmiObject -ComputerName $VMConf.__Server -Namespace "root\virtualization\v2" -Query "SELECT * FROM MSVM_AllocationCapabilities WHERE ResourceType = '10' AND ResourceSubType = 'Microsoft Synthetic Ethernet Port'").__Path).Replace("\", "\\")
							$NicRASD = New-Object System.Management.ManagementObject((Get-WmiObject -ComputerName $VMConf.__Server -Namespace "root\virtualization\v2" -Query "SELECT * FROM MSVM_SettingsDefineCapabilities WHERE ValueRange=0 AND GroupComponent = '$NetworkAllocation'").PartComponent)
						}
						else
						{
							$NetworkAllocation = ((Get-WmiObject -ComputerName $VMConf.__Server -Namespace "root\virtualization" -Query "SELECT * FROM MSVM_AllocationCapabilities WHERE ResourceType = '10' AND ResourceSubType = 'Microsoft Synthetic Ethernet Port'").__Path).Replace("\", "\\")
							$NicRASD = New-Object System.Management.ManagementObject((Get-WmiObject -ComputerName $VMConf.__Server -Namespace "root\virtualization" -Query "SELECT * FROM MSVM_SettingsDefineCapabilities WHERE ValueRange=0 AND GroupComponent = '$NetworkAllocation'").PartComponent)
						}
						$NicRASD.VirtualSystemIdentifiers=@($GUID)
						$NicRASD.ElementName = "Network Adapter"
						$AdapterMAC = $AdapterMAC.Replace(":","")
						$NicRASD.address = $AdapterMAC
						$NicRASD.StaticMacAddress = $true
						if ($VMManager -eq "HyperV2")
						{
							$VirtualSwitch = Get-WmiObject -ComputerName $VMConf.__Server -Namespace "root\virtualization\v2" -Query "Select * From MsVM_VirtualSwitch Where elementname like '$AdapterNetwork' "
							$SwitchMgtSvc = (Get-WmiObject -ComputerName $VirtualSwitch.__Server -NameSpace "root\virtualization\v2" -Query "Select * From MsVM_VirtualSwitchManagementService")
						}
						else
						{
							$VirtualSwitch = Get-WmiObject -ComputerName $VMConf.__Server -Namespace "root\virtualization" -Query "Select * From MsVM_VirtualSwitch Where elementname like '$AdapterNetwork' "
							$SwitchMgtSvc = (Get-WmiObject -ComputerName $VirtualSwitch.__Server -NameSpace "root\virtualization" -Query "Select * From MsVM_VirtualSwitchManagementService")
						}
						$Result = $SwitchMgtSvc.CreateSwitchPort($VirtualSwitch.__Path, $Name, $Name)
						$NicRASD.connection = @($Result.CreatedSwitchPort)
						$AddSwitchPort = $VSMgtSvc.AddVirtualSystemResources($VMConf.__Path, @($NicRASD.GetText([System.Management.TextFormat]::WmiDtd20)))
						if ($VMManager -eq "HyperV2")
						{
							$VLANSetting = Get-WmiObject -ComputerName $NicRASD.__Server -Namespace "root\virtualization\v2" -Query "associators of {$($NicRASD.connection[0])} where assocClass=msvm_bindsto" | Foreach-Object {Get-WmiObject -ComputerName $NicRASD.__Server -Namespace "root\virtualization\v2" -Query "associators of {$_} where assocClass=MSVM_NetWorkElementSettingData"}
						}
						else
						{
							$VLANSetting = Get-WmiObject -ComputerName $NicRASD.__Server -Namespace "root\virtualization" -Query "associators of {$($NicRASD.connection[0])} where assocClass=msvm_bindsto" | Foreach-Object {Get-WmiObject -ComputerName $NicRASD.__Server -Namespace "root\virtualization" -Query "associators of {$_} where assocClass=MSVM_NetWorkElementSettingData"}
						}
						if ($AdapterVLAN -ne "Trunk Mode")
						{
							$VLANSetting.accessVlan = $AdapterVLAN
							$SetVLAN = [wmi]$VLANSetting.put().path
						}
						# Start virtual machine
						$StartLinuxVM = $VMConf.RequestStateChange(2)
						$StartLinuxVM = ProcessWMIJob($StartLinuxVM)
						$ResultCode = "1"
						$ResultMessage = "Network adapter is configured."
					}
					else
					{
						$ResultCode = "0"
						$ResultMessage = "Virtual switch name could not be retrieved."
					}
				}
				catch
				{
					$ResultCode = "0"
					$ResultMessage = $_
				}
			}
			else
			{
				$ResultCode = "-1"
				$ResultMessage = "Ethernet adapter is not emulated. No changes made."
			}
		}
		else
		{
			$ResultCode = $VMNetwork.ResultCode
			$ResultMessage = $VMNetwork.ResultMessage
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

function New-LinuxAnswerISO {

<#
    .SYNOPSIS
     
        Function to create Linux Answer file ISO

    .EXAMPLE
     
        New-LinuxAnswerISO -ScriptPrefix "01051255" -UnattendedScriptPath "C:\Answer"
		
    .EXAMPLE
     
        New-LinuxAnswerISO -ScriptPrefix "01051255" -UnattendedScriptPath "C:\Answer" -TransferLIC $True -TransferParted $True
		
    .EXAMPLE
     
        New-LinuxAnswerISO -ScriptPrefix "01051255" -UnattendedScriptPath "C:\Answer" -TransferFile "C:\CustomFile.tar"
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (
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
        HelpMessage = 'Transfer parted package files?')]
    [string]$TransferParted,

	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Transfer linux integration components?')]
    [string]$TransferLIC,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Transfer custom files? Please provide path.')]
    [string]$TransferFile,
	
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

	# ISO Parameters
	$Script = $UnattendedScriptPath + "\" + $ScriptPrefix + "-Unattended.sh"
	$Path = $UnattendedScriptPath + "\" + $ScriptPrefix + ".iso"
	
	# Create Temp Directory
	$TempDirectory = New-Item -ItemType Directory -Path "$UnattendedScriptPath\$ScriptPrefix" -Force
	
	# Copy Unattended Scripts to Temp Directory
	$CheckSource = Test-Path -Path "$Script"
	if ($CheckSource)
	{
		Copy-Item -Path "$Script" -Destination "$UnattendedScriptPath\$ScriptPrefix" | Out-Null
	}
	
	# Copy Parted Package to Temp Directory
	if ($TransferParted)
	{
		Copy-Item -Path "$UnattendedScriptPath\Parted" -Destination "$UnattendedScriptPath\$ScriptPrefix" -Recurse | Out-Null
	}
	
	# Copy Linux Integration Components to Temp Directory
	if ($TransferLIC)
	{
		Copy-Item -Path "$UnattendedScriptPath\LinuxIC\Linux.IC.v3.4.gz" -Destination "$UnattendedScriptPath\$ScriptPrefix" | Out-Null
	}
	
	# Copy Custom Files to Temp Directory
	if ($TransferFile)
	{
		# Check Custom File
		$CheckCustomFile = Test-Path -Path "$TransferFile"
		if (!$CheckCustomFile)
		{
			$ResultCode = "0"
			$ResultMessage = "Could not find custom file."
			
			# Debug Output
			Write-Debug "Could not find custom file. Please check custom file path."
		}
		else
		{
			Copy-Item -Path "$TransferFile" -Destination "$UnattendedScriptPath\$ScriptPrefix" -Recurse | Out-Null
		}
	}

	# Source Directory for ISO
	$Source = "$UnattendedScriptPath\$ScriptPrefix"
	
	# ISO Title
    [string]$Title = "SetLinuxVM" 

	($CP = New-Object System.CodeDom.Compiler.CompilerParameters).CompilerOptions = "/unsafe" 
	if (!("ISOFile" -as [Type])) 
	{ 
		Add-Type -CompilerParameters $CP -TypeDefinition @" 
public class ISOFile 
{ 
    public unsafe static void Create(string Path, object Stream, int BlockSize, int TotalBlocks) 
    { 
        int bytes = 0; 
        byte[] buf = new byte[BlockSize]; 
        System.IntPtr ptr = (System.IntPtr)(&bytes); 
        System.IO.FileStream o = System.IO.File.OpenWrite(Path); 
        System.Runtime.InteropServices.ComTypes.IStream i = Stream as System.Runtime.InteropServices.ComTypes.IStream; 
 
        if (o == null) { return; } 
        while (TotalBlocks-- > 0) { 
            i.Read(buf, BlockSize, ptr); o.Write(buf, 0, bytes); 
        } 
        o.Flush(); o.Close(); 
    } 
} 
"@ 
	}
 	
	if ($ResultCode -eq "1")
	{
		# Create Image
		($Image = New-Object -COM IMAPI2FS.MsftFileSystemImage -Property @{VolumeName=$Title}).ChooseImageDefaultsForMediaType(12)
		
		# Create ISO File
		$Target = New-Item -Path $Path -ItemType File -Force 
	 
		Switch ($Source)
		{ 
			{ $_ -is [string] } { $Image.Root.AddTree((Get-Item $_).FullName, $True); Continue } 
			{ $_ -is [IO.FileInfo] } { $Image.Root.AddTree($_.FullName, $True); Continue } 
			{ $_ -is [IO.DirectoryInfo] } { $Image.Root.AddTree($_.FullName, $True); Continue } 
		}

		$Result = $Image.CreateResultImage() 
		[ISOFile]::Create($Target.FullName,$Result.ImageStream,$Result.BlockSize,$Result.TotalBlocks)
		
		$ResultCode = "1"
		$ResultMessage = "Answer image file is burned."		
	}
	
	# Remove Source File
	$CheckSource = Test-Path -Path "$Script"
	if ($CheckSource)
	{
		Remove-Item -Path $Script -Force
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

function Mount-LinuxAnswerISO {

<#
    .SYNOPSIS
     
        Function to mount Linux answer file

    .EXAMPLE
     
        Mount-LinuxAnswerISO -VMName "CentOS01" -ScriptPrefix "01051255" -UnattendedScriptPath "C:\Answer"
	
	.EXAMPLE
     
        Mount-LinuxAnswerISO -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -ScriptPrefix "01051255" -UnattendedScriptPath "C:\Answer"
		
	.EXAMPLE
     
        Mount-LinuxAnswerISO -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com" -ScriptPrefix "01051255" -UnattendedScriptPath "C:\Answer"

	.EXAMPLE
     
        Mount-LinuxAnswerISO -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com" -ScriptPrefix "01051255" -UnattendedScriptPath "C:\Answer"
	
	.EXAMPLE
     
        Mount-LinuxAnswerISO -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com" -ScriptPrefix "01051255" -UnattendedScriptPath "C:\Answer"
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (
    [Parameter(
        Mandatory = $true,
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
        HelpMessage = 'VM manager name.')]
    [string]$VMManager,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Wmi hostname')]
    [string]$WmiHost,

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

	if (!$WmiHost) 
	{ 
		$TestWmiHost = Get-WmiHost -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager
		if ($TestWmiHost.ResultCode -eq "1")
		{
			$WmiHost = $TestWmiHost.WmiHost
			$ResultCode = $TestWmiHost.ResultCode
			$ResultMessage = $TestWmiHost.ResultMessage
		}
		else
		{
			$ResultCode = $TestWmiHost.ResultCode
			$ResultMessage = $TestWmiHost.ResultMessage				
		}
	}
	else
	{
		$ResultCode = "1"
		$ResultMessage = "WmiHost is available."
	}
	
	if ($ResultCode -eq "1")
	{
		try 
		{	
			# Linux Answer Image Path
			$AnswerImagePath = $UnattendedScriptPath + "\" + $ScriptPrefix + ".iso"
			
			# Check Source File
			$CheckAnswerImagePath = Test-Path -Path "$AnswerImagePath"
			if (!$CheckAnswerImagePath)
			{
				$ResultCode = "0"
				$ResultMessage = "Could not find answer file."
			}
			else
			{
				$ResultCode = "1"
				$ResultMessage = "Answer file is exist."
			}
			
			if ($ResultCode -eq "1")
			{
				if ($WmiHost -eq ".")
				{
					$ShareHost = "localhost"
				}
				else
				{
					$ShareHost = $WmiHost
				}

				# ISO Path
				$ISOPath = $AnswerImagePath
				
				# Test Wmi Host ISO Path
				$DestISOPath = "\\$ShareHost\C$\Windows\System32\" + $ScriptPrefix + ".iso"
				$DestISOPathTest = Test-Path $DestISOPath
				if (!$DestISOPathTest)
				{
					Copy-Item $ISOPath -Destination "\\$ShareHost\C$\Windows\System32"
				}
				
				if ($VMManager -eq "HyperV2")
				{
					$VMMS = Get-WmiObject -Namespace "root\virtualization\v2" -Class "Msvm_VirtualSystemManagementService" -Computername "$WmiHost"
					$VMConf = Get-WmiObject -Class "MSVM_ComputerSystem" -filter "ElementName='$VMName'" -Namespace "root\virtualization\v2" -Computername "$WmiHost"
				}
				else
				{
					$VMMS = Get-WmiObject -Namespace "root\virtualization" -Class "Msvm_VirtualSystemManagementService" -Computername "$WmiHost"
					$VMConf = Get-WmiObject -Class "MSVM_ComputerSystem" -filter "ElementName='$VMName'" -Namespace "root\virtualization" -Computername "$WmiHost"
				}
				$VMSetting = $VMConf.getRelated("Msvm_VirtualSystemSettingData") | where {$_.SettingType -eq 3}
				$DVDDrive = $VMSetting.getRelated("Msvm_ResourceAllocationSettingData") | where{$_.ResourceType -eq 16} | select -first 1
				if (!$DVDDrive) 
				{
					$ResultCode = "0"
					$ResultMessage = "No DVD drive exist on that virtual machine."
				}
				else
				{
					$ResultCode = "1"
					$ResultMessage = "DVD drive is available."
				}
				
				if ($ResultCode -eq "1")
				{
					# Suspend virtual machine
					$SuspendLinuxVM = $VMConf.RequestStateChange(32769)
					$SuspendLinuxVM = ProcessWMIJob($SuspendLinuxVM)
					Start-Sleep 5
				
					$DVDRASD = $VMSetting.getRelated("Msvm_ResourceAllocationSettingData") | where {$_.Parent -eq $DVDDrive.__Path}
					if ($DVDRASD) 
					{ 
						$Result1 = $VMMS.RemoveVirtualSystemResources($VMConf, @($DVDRASD)) 
					}
					if ($VMManager -eq "HyperV2")
					{
						$DVDAllocationCapabilities = (Get-WmiObject -Computername "$WmiHost" -Namespace "root\virtualization\v2" -Class "Msvm_AllocationCapabilities" -filter "ResourceType=21 and ResourceSubType='Microsoft Virtual CD/DVD Disk'").__Path.Replace('\', '\\')
						$DVDSettingsData = [wmi](Get-WmiObject -Computername "$WmiHost" -Namespace "root\virtualization\v2" -Class "Msvm_SettingsDefineCapabilities" -filter "GroupComponent='$DVDAllocationCapabilities' and ValueRange=0").PartComponent
					}
					else
					{
						$DVDAllocationCapabilities = (Get-WmiObject -Computername "$WmiHost" -Namespace "root\virtualization" -Class "Msvm_AllocationCapabilities" -filter "ResourceType=21 and ResourceSubType='Microsoft Virtual CD/DVD Disk'").__Path.Replace('\', '\\')
						$DVDSettingsData = [wmi](Get-WmiObject -Computername "$WmiHost" -Namespace "root\virtualization" -Class "Msvm_SettingsDefineCapabilities" -filter "GroupComponent='$DVDAllocationCapabilities' and ValueRange=0").PartComponent
					}
					$ISOPath = "C:\Windows\System32\" + $ScriptPrefix + ".iso"
					$DVDSettingsData.Connection = @($ISOPath)
					$DVDSettingsData.Parent = $DVDDrive.__Path
					$Result2 = $VMMS.AddVirtualSystemResources($VMConf, $DVDSettingsData.GetText(1))
					$ResultCode = "1"
					$ResultMessage = "Linux image file is mounted."
					
					# Start virtual machine
					$StartLinuxVM = $VMConf.RequestStateChange(2)
					$StartLinuxVM = ProcessWMIJob($StartLinuxVM)
					Start-Sleep 5
				}
			}
		}
		catch
		{
			$ResultCode = "0"
			$ResultMessage = $_
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

function Dismount-LinuxAnswerISO {

<#
    .SYNOPSIS
     
        Function to dismount Linux answer file

    .EXAMPLE
     
        Dismount-LinuxAnswerISO -VMName "CentOS01" -ScriptPrefix "01051255" -UnattendedScriptPath "C:\Answer"
	
	.EXAMPLE
     
        Dismount-LinuxAnswerISO -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -ScriptPrefix "01051255" -UnattendedScriptPath "C:\Answer"
		
	.EXAMPLE
     
        Dismount-LinuxAnswerISO -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com" -ScriptPrefix "01051255" -UnattendedScriptPath "C:\Answer"

	.EXAMPLE
     
        Dismount-LinuxAnswerISO -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com" -ScriptPrefix "01051255" -UnattendedScriptPath "C:\Answer"
	
	.EXAMPLE
     
        Dismount-LinuxAnswerISO -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com" -ScriptPrefix "01051255" -UnattendedScriptPath "C:\Answer"
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (
    [Parameter(
        Mandatory = $true,
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
        HelpMessage = 'VM manager name.')]
    [string]$VMManager,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Wmi hostname')]
    [string]$WmiHost,
	
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
	
	if (!$WmiHost) 
	{ 
		$TestWmiHost = Get-WmiHost -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager
		if ($TestWmiHost.ResultCode -eq "1")
		{
			$WmiHost = $TestWmiHost.WmiHost
			$ResultCode = $TestWmiHost.ResultCode
			$ResultMessage = $TestWmiHost.ResultMessage
		}
		else
		{
			$ResultCode = $TestWmiHost.ResultCode
			$ResultMessage = $TestWmiHost.ResultMessage				
		}
	}
	else
	{
		$ResultCode = "1"
		$ResultMessage = "WmiHost is available."
	}
	
	if ($ResultCode -eq "1")
	{	
		try 
		{	
			if ($VMManager -eq "HyperV2")
			{
				$VMMS = Get-WmiObject -Namespace "root\virtualization\v2" -Class "Msvm_VirtualSystemManagementService" -Computername "$WmiHost"
				$VMConf = Get-WmiObject MSVM_ComputerSystem -filter "ElementName='$VMName'" -Namespace "root\virtualization\v2" -Computername "$WmiHost"
			}
			else
			{
				$VMMS = Get-WmiObject -Namespace "root\virtualization" -Class "Msvm_VirtualSystemManagementService" -Computername "$WmiHost"
				$VMConf = Get-WmiObject MSVM_ComputerSystem -filter "ElementName='$VMName'" -Namespace "root\virtualization" -Computername "$WmiHost"
			}
			$VMSetting = $VMConf.getRelated("Msvm_VirtualSystemSettingData") | where {$_.SettingType -eq 3}
			$DVDDrive = $VMSetting.getRelated("Msvm_ResourceAllocationSettingData") | where {$_.ResourceType -eq 16} | select -first 1
			if (!$DVDDrive) 
			{
				$ResultCode = "0"
				$ResultMessage = "No DVD drive exists on that virtual machine"
			}
			else
			{
				$ResultCode = "1"
				$ResultMessage = "DVD drive is available."
			}
			
			if ($ResultCode -eq "1")
			{
				$DVDRASD = $VMSetting.getRelated("Msvm_ResourceAllocationSettingData") | where {$_.Parent -eq $DVDDrive.__Path}
				if ($DVDRASD) 
				{ 
					$Result1 = $VMMS.RemoveVirtualSystemResources($VMConf, @($DVDRASD)) 
					$ResultCode = "1"
					$ResultMessage = "Linux answer image file is dismounted."
				}
				else
				{
					$ResultCode = "-1"
					$ResultMessage = "Could not dismount Linux answer image file."
				}
				
				if ($WmiHost -eq ".")
				{
					$ShareHost = "localhost"
				}
				else
				{
					$ShareHost = $WmiHost
				}
			
				# Test Wmi Host ISO Path
				$DestISOPath = "\\$ShareHost\C$\Windows\System32\" + $ScriptPrefix + ".iso"
				$DestISOPathTest = Test-Path $DestISOPath
				if ($DestISOPathTest)
				{
					Remove-Item -Path $DestISOPath -Force
				}

				# Test Local ISO Path				
				$LocalISOPath = $UnattendedScriptPath + "\" + $ScriptPrefix + ".iso"
				$LocalISOPathTest = Test-Path $LocalISOPath
				if ($LocalISOPathTest)
				{
					Remove-Item -Path $LocalISOPath -Force
					Remove-Item -Path "$UnattendedScriptPath\$ScriptPrefix" -Confirm:$false -Recurse -Force
				}
			}
		}
		catch
		{
			$ResultCode = "0"
			$ResultMessage = $_
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

function Watch-LinuxVM {

<#
    .SYNOPSIS
     
        Function to monitor Linux VM

    .EXAMPLE
     
        Watch-LinuxVM -VMName "CentOS01"
	
	.EXAMPLE
     
        Watch-LinuxVM -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com"
		
	.EXAMPLE
     
        Watch-LinuxVM -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com"

	.EXAMPLE
     
        Watch-LinuxVM -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com"
	
	.EXAMPLE
     
        Watch-LinuxVM -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com"
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (
    [Parameter(
        Mandatory = $true,
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
	
	if (!$WmiHost) 
	{ 
		$TestWmiHost = Get-WmiHost -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager
		if ($TestWmiHost.ResultCode -eq "1")
		{
			$WmiHost = $TestWmiHost.WmiHost
			$ResultCode = $TestWmiHost.ResultCode
			$ResultMessage = $TestWmiHost.ResultMessage
		}
		else
		{
			$ResultCode = $TestWmiHost.ResultCode
			$ResultMessage = $TestWmiHost.ResultMessage				
		}
	}
	else
	{
		$ResultCode = "1"
		$ResultMessage = "WmiHost is available."		
	}
	
	if ($ResultCode -eq "1")
	{		
		try 
		{	
			$xRes = 8
			$yRes = 8
			$Assembly = [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
			if ($VMManager -eq "HyperV2")
			{
				$VMMS = Get-WmiObject -Namespace "root\virtualization\v2" -Class "Msvm_VirtualSystemManagementService" -Computername "$WmiHost"
				$VMConf = Get-WmiObject MSVM_ComputerSystem -filter "ElementName='$VMName'" -Namespace "root\virtualization\v2" -Computername "$WmiHost"
				$VMSetting = Get-WmiObject -Namespace "root\virtualization\v2" -Query "Associators of {$VMConf} Where ResultClass=Msvm_VirtualSystemSettingData AssocClass=Msvm_SettingsDefineState" -ComputerName "$WmiHost"
			}
			else
			{
				$VMMS = Get-WmiObject -Namespace "root\virtualization" -Class "Msvm_VirtualSystemManagementService" -Computername "$WmiHost"
				$VMConf = Get-WmiObject MSVM_ComputerSystem -filter "ElementName='$VMName'" -Namespace "root\virtualization" -Computername "$WmiHost"
				$VMSetting = Get-WmiObject -Namespace "root\virtualization" -Query "Associators of {$VMConf} Where ResultClass=Msvm_VirtualSystemSettingData AssocClass=Msvm_SettingsDefineState" -ComputerName "$WmiHost"
			}			
			$RawImageData = $VMMS.GetVirtualSystemThumbnailImage($VMSetting, "$xRes", "$yRes")
			$ImageData = $RawImageData.ImageData
			$ResultCode = "1"
			$ResultMessage = "VM state captured."
		}
		catch
		{
			$ResultCode = "0"
			$ResultMessage = $_
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
		if ($ResultCode -eq "1")
		{
			$Properties | Add-Member Noteproperty ImageData $ImageData
		}
		Write-Output $Properties
	}	
}

Function Wait-VMReboot {

<#
    .SYNOPSIS
     
        Function to monitor Linux VM reboot

    .EXAMPLE
     
        Wait-VMReboot -VMName "CentOS01"
	
	.EXAMPLE
     
        Wait-VMReboot -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com"
		
	.EXAMPLE
     
        Wait-VMReboot -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com"

	.EXAMPLE
     
        Wait-VMReboot -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com"
	
	.EXAMPLE
     
        Wait-VMReboot -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com"
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (
    [Parameter(
        Mandatory = $true,
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
        HelpMessage = 'VM manager name.')]
    [string]$VMManager,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Wmi hostname')]
    [string]$WmiHost,
	
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
	
	$ShouldProcess = $true
	while ($ShouldProcess) 
	{
		$State1 = (Watch-LinuxVM -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -WmiHost $WmiHost).ImageData
		Start-Sleep 10
		$State2 = (Watch-LinuxVM -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -WmiHost $WmiHost).ImageData
		if ("$State1" -eq "$State2")
		{
			Start-Sleep 10
			$State1 = (Watch-LinuxVM -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -WmiHost $WmiHost).ImageData
			Start-Sleep 10
			$State2 = (Watch-LinuxVM -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -WmiHost $WmiHost).ImageData
			if ("$State1" -eq "$State2")
			{
				$ShouldProcess = $false
			}
		}
	}
}

Function Test-VMLogin {

<#
    .SYNOPSIS
     
        Function to monitor Linux VM login

    .EXAMPLE
     
        Test-VMLogin -VMName "CentOS01"
	
	.EXAMPLE
     
        Test-VMLogin -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com"
		
	.EXAMPLE
     
        Test-VMLogin -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com"

	.EXAMPLE
     
        Test-VMLogin -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com"
	
	.EXAMPLE
     
        Test-VMLogin -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com"
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (
    [Parameter(
        Mandatory = $true,
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

	$ClearVMConsole = Clear-VMConsole -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost
	Start-Sleep 2
	$State1 = (Watch-LinuxVM -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost).ImageData
	Start-Sleep 1
	$ClearVMConsole = Clear-VMConsole -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost
	Start-Sleep 1
	$ClearVMConsole = Clear-VMConsole -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost
	Start-Sleep 2
	$State2 = (Watch-LinuxVM -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost).ImageData
	if ("$State1" -eq "$State2")
	{
		$ResultCode = "1"
		$ResultMessage = "Logged to Linux virtual machine."
	}
	else
	{
		$ResultCode = "0"
		$ResultMessage = "Can not login to virtual machine."
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

Function Wait-VMProcess {

<#
    .SYNOPSIS
     
        Function to monitor Linux VM service

    .EXAMPLE
     
        Wait-VMProcess -VMName "CentOS01"
	
	.EXAMPLE
     
        Wait-VMProcess -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com"
		
	.EXAMPLE
     
        Wait-VMProcess -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com"

	.EXAMPLE
     
        Wait-VMProcess -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com"
	
	.EXAMPLE
     
        Wait-VMProcess -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com"
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (
    [Parameter(
        Mandatory = $true,
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
        HelpMessage = 'VM manager name.')]
    [string]$VMManager,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Wmi hostname')]
    [string]$WmiHost,
	
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

	$ShouldProcess = $true
	while ($ShouldProcess) 
	{
		$State1 = (Watch-LinuxVM -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost).ImageData
		Start-Sleep 1
		$State2 = (Watch-LinuxVM -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost).ImageData
		if ("$State1" -eq "$State2")
		{
			$ClearVMConsole = Clear-VMConsole -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost
			Start-Sleep 2
			$State1 = (Watch-LinuxVM -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost).ImageData
			$RandomVMString = Send-RandomVMString -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost
			Start-Sleep 1
			$ClearVMConsole = Clear-VMConsole -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost
			Start-Sleep 2
			$State2 = (Watch-LinuxVM -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager -WmiHost $WmiHost).ImageData
			if ("$State1" -eq "$State2")
			{
				$ShouldProcess = $false
			}
		}
	}
}

Function New-RequirementCheck {

<#
    .SYNOPSIS
     
        Function to check requirements for SetLinuxVM

    .EXAMPLE
     
        New-RequirementCheck -VMName "CentOS01"
	
	.EXAMPLE
     
        New-RequirementCheck -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com"
		
	.EXAMPLE
     
        New-RequirementCheck -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com"

	.EXAMPLE
     
        New-RequirementCheck -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com"
	
	.EXAMPLE
     
        New-RequirementCheck -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com"
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Username of the VM template. Example: root')]
    [string]$Username,
	
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Password of the VM template. Example: password')]
    [string]$Password,

    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Name of the VM template. Example: CentOS62x64')]
    [string]$VMTemplateName,
	
    [Parameter(
        Mandatory = $true,
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

	# Determine VM Manager
	$TestVMManager = Test-VMManager -VMHost $VMHost -VMMServer $VMMServer
	$VMManager = $TestVMManager.VMManager
	
	if ($TestVMManager.ResultCode -eq "1")
	{	
		# Determine Wmi Host
		$TestWmiHost = Get-WmiHost -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager
		$WmiHost = $TestWmiHost.WmiHost
		
		if ($TestWmiHost.ResultCode -eq "1")
		{		
			# Check virtual machine state
			# SetLinuxVM can not manage virtual machine if VM is stopped.
			$TestVMState = Test-VMState -VMName $VMName -VMManager $VMManager -WmiHost $WmiHost
			
			if ($TestVMState.ResultCode -eq "1")
			{
				# Check credentials and set username and password
				$Credentials = Test-Credentials -Username $Username -Password $Password -VMTemplateName $VMTemplateName -VMMServer $VMMServer -VMManager $VMManager
				if ($Credentials.ResultCode -eq "1")
				{
					$Username = $Credentials.Username
					$Password = $Credentials.Password
					$ResultCode = $Credentials.ResultCode
					$ResultMessage = $Credentials.ResultMessage
				}
				else
				{
					if ($Username -eq $null) { $Username = "root" }
					if ($Password -eq $null) { $Password = " " }
					$ResultCode = $Credentials.ResultCode
					$ResultMessage = $Credentials.ResultMessage
				}
			}
			else
			{
				$ResultCode = $TestVMState.ResultCode
				$ResultMessage = $TestVMState.ResultMessage
			}
		}
		else
		{
			$ResultCode = $TestWmiHost.ResultCode
			$ResultMessage = $TestWmiHost.ResultMessage
		}
	}
	else
	{
		$ResultCode = $TestVMManager.ResultCode
		$ResultMessage = $TestVMManager.ResultMessage
	}
	
	# Check Temp Directory
	if ($ResultCode -eq "1")
	{
		$CheckTempPath = Test-Path -Path $env:temp
		if (!$CheckTempPath)
		{
			$ResultCode = "0"
			$ResultMessage = "Could not reach to temp folder. $env:temp is not exist."
		}
	}
	
	if ($OutXML)
	{
		$Properties = New-Object Psobject
		$Properties | Add-Member Noteproperty VMManager $VMManager
		$Properties | Add-Member Noteproperty WmiHost $WmiHost
		$Properties | Add-Member Noteproperty Username $Username
		$Properties | Add-Member Noteproperty Password $Password
		$Properties | New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage -Details
	}
	else
	{
		$Properties = New-Object Psobject
		$Properties | Add-Member Noteproperty ResultCode $ResultCode
		$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
		$Properties | Add-Member Noteproperty VMManager $VMManager
		$Properties | Add-Member Noteproperty WmiHost $WmiHost
		$Properties | Add-Member Noteproperty Username $Username
		$Properties | Add-Member Noteproperty Password $Password
		Write-Output $Properties
	}
}

Function Get-UnattendedScriptPath {

<#
    .SYNOPSIS
     
        Function to get unattended script path of SetLinuxVM

    .EXAMPLE
     
        Get-UnattendedScriptPath

#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (	
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

	# Get unattended script path
	$UnattendedScriptPath = (Convert-Path (Get-Location -PSProvider FileSystem)) + "\scripts"
	$UnattendedScriptPathTest = Test-Path -Path "$UnattendedScriptPath"
	if (!$UnattendedScriptPathTest)
	{
		$UnattendedScriptPath = "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\SetLinuxVM\scripts"
		$UnattendedScriptPathTest = Test-Path -Path "$UnattendedScriptPath"
		if (!$UnattendedScriptPathTest)
		{
			$UnattendedScriptPath = "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\Modules\SetLinuxVM\scripts"
			$UnattendedScriptPathTest = Test-Path -Path "$UnattendedScriptPath"
			if (!$UnattendedScriptPathTest)
			{
				$ResultCode = "0"
				$ResultMessage = "Could not find scripts directory."
			}
			else
			{
				$ResultCode = "1"
				$ResultMessage = "Scripts directory found."
			}
		}
		else
		{
			$ResultCode = "1"
			$ResultMessage = "Scripts directory found."
		}
	}
	else
	{
		$ResultCode = "1"
		$ResultMessage = "Scripts directory found."
	}
	
	if ($OutXML)
	{
		$Properties = New-Object Psobject
		$Properties | Add-Member Noteproperty UnattendedScriptPath $UnattendedScriptPath
		$Properties | New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage -Details
	}
	else
	{
		$Properties = New-Object Psobject
		$Properties | Add-Member Noteproperty ResultCode $ResultCode
		$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
		$Properties | Add-Member Noteproperty UnattendedScriptPath $UnattendedScriptPath
		Write-Output $Properties
	}
}

Function Get-LinuxVM {

<#
    .SYNOPSIS
     
        Function to get KVP information from Linux VM

    .EXAMPLE
     
        Get-LinuxVM -VMName "CentOS01"
	
	.EXAMPLE
     
        Get-LinuxVM -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com"
		
	.EXAMPLE
     
        Get-LinuxVM -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com"

	.EXAMPLE
     
        Get-LinuxVM -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com"
	
	.EXAMPLE
     
        Get-LinuxVM -VMName "CentOS01" -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com"
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (
    [Parameter(
        Mandatory = $true,
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
	
	if (!$WmiHost) 
	{ 
		$TestWmiHost = Get-WmiHost -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer -VMManager $VMManager
		if ($TestWmiHost.ResultCode -eq "1")
		{
			$WmiHost = $TestWmiHost.WmiHost
			$ResultCode = $TestWmiHost.ResultCode
			$ResultMessage = $TestWmiHost.ResultMessage
		}
		else
		{
			$ResultCode = $TestWmiHost.ResultCode
			$ResultMessage = $TestWmiHost.ResultMessage				
		}
	}
	else
	{
		$ResultCode = "1"
		$ResultMessage = "WmiHost is available."		
	}
	
	if ($ResultCode -eq "1")
	{
		try
		{
			filter Import-CimXml
			{
				$CimXml = [Xml]$_
				$CimObj = New-Object -TypeName System.Object
				foreach ($CimProperty in $CimXml.SelectNodes("/INSTANCE/PROPERTY"))
				{
					if ($CimProperty.Name -eq "Name" -or $CimProperty.Name -eq "Data")
					{
						$CimObj | Add-Member -MemberType NoteProperty -Name $CimProperty.NAME -Value $CimProperty.VALUE
					}
				}
				$CimObj
			}
			if ($VMManager -eq "HyperV2")
			{
				$VMConf = Get-WmiObject -ComputerName "$WmiHost" -Namespace "root\virtualization\v2" -Query "SELECT * FROM Msvm_ComputerSystem WHERE ElementName like '$VMName' AND caption like 'Virtual%' "
				$KVPData = Get-WmiObject -ComputerName "$WmiHost" -Namespace "root\virtualization\v2" -Query "Associators of {$VMConf} Where AssocClass=Msvm_SystemDevice ResultClass=Msvm_KvpExchangeComponent"
			}
			else
			{
				$VMConf = Get-WmiObject -ComputerName "$WmiHost" -Namespace "root\virtualization" -Query "SELECT * FROM Msvm_ComputerSystem WHERE ElementName like '$VMName' AND caption like 'Virtual%' "
				$KVPData = Get-WmiObject -ComputerName "$WmiHost" -Namespace "root\virtualization" -Query "Associators of {$VMConf} Where AssocClass=Msvm_SystemDevice ResultClass=Msvm_KvpExchangeComponent"
			}
			$KVPExport = $KVPData.GuestIntrinsicExchangeItems
			if ($KVPExport)
			{
				$KVPExport = $KVPExport | Import-CimXml
				$OSName = ($KVPExport | where {$_.Name -eq "OSName"}).Data
				$OSVersion = ($KVPExport | where {$_.Name -eq "OSVersion"}).Data
				$ProcessorArchitecture = ($KVPExport | where {$_.Name -eq "ProcessorArchitecture"}).Data
				$Hostname = ($KVPExport | where {$_.Name -eq "FullyQualifiedDomainName"}).Data
				$NetworkAddressIPv4 = ($KVPExport | where {$_.Name -eq "NetworkAddressIPv4"}).Data
				$NetworkAddressIPv6 = ($KVPExport | where {$_.Name -eq "NetworkAddressIPv6"}).Data
				$IntegrationServicesVersion = ($KVPExport | where {$_.Name -eq "IntegrationServicesVersion"}).Data
				$ResultCode = "1"
				$ResultMessage = "VM information is detected."
			}
			else
			{
				$OSName = $Null
				$OSVersion = $Null
				$ProcessorArchitecture = $Null
				$Hostname = $Null
				$NetworkAddressIPv4 = $Null
				$NetworkAddressIPv6 = $Null
				$IntegrationServicesVersion = $Null
				$ResultCode = "-1"
				$ResultMessage = "VM information is not available."
			}
		}
		catch
		{
			$ResultCode = "0"
			$ResultMessage = $_
		}
	}

	if ($OutXML)
	{
		$Properties = New-Object Psobject
		$Properties | Add-Member Noteproperty VMName $VMName
		$Properties | Add-Member Noteproperty OSName $OSName
		$Properties | Add-Member Noteproperty OSVersion $OSVersion
		$Properties | Add-Member Noteproperty ProcessorArchitecture $ProcessorArchitecture
		$Properties | Add-Member Noteproperty Hostname $Hostname
		$Properties | Add-Member Noteproperty NetworkAddressIPv4 $NetworkAddressIPv4
		$Properties | Add-Member Noteproperty NetworkAddressIPv6 $NetworkAddressIPv6
		$Properties | Add-Member Noteproperty IntegrationServicesVersion $IntegrationServicesVersion
		$Properties | New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage -Details
	}
	else
	{
		$Properties = New-Object Psobject
		$Properties | Add-Member Noteproperty ResultCode $ResultCode
		$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
		$Properties | Add-Member Noteproperty VMName $VMName
		$Properties | Add-Member Noteproperty OSName $OSName
		$Properties | Add-Member Noteproperty OSVersion $OSVersion
		$Properties | Add-Member Noteproperty ProcessorArchitecture $ProcessorArchitecture
		$Properties | Add-Member Noteproperty Hostname $Hostname
		$Properties | Add-Member Noteproperty NetworkAddressIPv4 $NetworkAddressIPv4
		$Properties | Add-Member Noteproperty NetworkAddressIPv6 $NetworkAddressIPv6
		$Properties | Add-Member Noteproperty IntegrationServicesVersion $IntegrationServicesVersion
		Write-Output $Properties
	}
}

Function Search-LinuxVMHost {

<#
    .SYNOPSIS
     
        Function to list all Linux VMHosts

	.EXAMPLE
     
        Search-LinuxVMHost
		
	.EXAMPLE
     
        Search-LinuxVMHost -VMCluster "hyperv.virtualmetric.com"

	.EXAMPLE
     
        Search-LinuxVMHost -VMMServer "scvmm01.virtualmetric.com"
	
	.EXAMPLE
     
        Search-LinuxVMHost -VMCluster "hyperv.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com"
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (
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

	if (!$VMManager) 
	{ 
		$TestVMManager = Test-VMManager -VMHost $VMHost -VMMServer $VMMServer
		
		if ($TestVMManager.ResultCode -eq "1")
		{
			$VMManager = $TestVMManager.VMManager
		}
		
		$ResultCode = $TestVMManager.ResultCode
		$ResultMessage = $TestVMManager.ResultMessage
	}
	else
	{
		$ResultCode = "1"
		$ResultMessage = "VM Manager is available."
	}
	
	if ($ResultCode -eq "1")
	{	
		if ($VMManager -eq "SCVMM")
		{		
			try 
			{	
				$VMHosts = Get-VMHost
				$ResultCode = "1"
				$ResultMessage = "VM Host detected."
				if ($OutXML)
				{
					$xml = "<?xml version=""1.0"" encoding=""utf-8""?>`n"
					$xml += "<Result>`n"
					$xml += " <Code>$ResultCode</Code>`n"
					$xml += " <Message>$ResultMessage</Message>`n"
				}
				foreach ($VMHost in $VMHosts)
				{
					$VMHost = $VMHost.FQDN
					if (!$OutXML)
					{
						$Properties = New-Object Psobject
						$Properties | Add-Member Noteproperty ResultCode $ResultCode
						$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
						$Properties | Add-Member Noteproperty VMHost $VMHost
						Write-Output $Properties
					}
					else
					{
						$xml += " <OperationResult>`n"
						$xml += "  <VMHost>$VMHost</VMHost>`n"
						$xml += " </OperationResult>`n"
					}
				}
				if ($OutXML)
				{
					$xml += "</Result>`n"
					$xml
				}
			}
			catch
			{
				$ResultCode = "0"
				$ResultMessage = $_
				$Properties = New-Object Psobject
				$Properties | Add-Member Noteproperty ResultCode $ResultCode
				$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
				if($OutXML)
				{
					New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
				}
				else
				{
					Write-Output $Properties
				}
			}
		}
		elseif ($VMManager -eq "SCVMM2012")
		{
			try 
			{	
				$VMHosts = Get-SCVMHost
				$ResultCode = "1"
				$ResultMessage = "VM Host detected."
				if ($OutXML)
				{
					$xml = "<?xml version=""1.0"" encoding=""utf-8""?>`n"
					$xml += "<Result>`n"
					$xml += " <Code>$ResultCode</Code>`n"
					$xml += " <Message>$ResultMessage</Message>`n"
				}
				foreach ($VMHost in $VMHosts)
				{
					$VMHost = $VMHost.FQDN
					if (!$OutXML)
					{
						$Properties = New-Object Psobject
						$Properties | Add-Member Noteproperty ResultCode $ResultCode
						$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
						$Properties | Add-Member Noteproperty VMHost $VMHost
						Write-Output $Properties
					}
					else
					{
						$xml += " <OperationResult>`n"
						$xml += "  <VMHost>$VMHost</VMHost>`n"
						$xml += " </OperationResult>`n"
					}
				}
				if ($OutXML)
				{
					$xml += "</Result>`n"
					$xml
				}
			}
			catch
			{
				$ResultCode = "0"
				$ResultMessage = $_
				$Properties = New-Object Psobject
				$Properties | Add-Member Noteproperty ResultCode $ResultCode
				$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
				if($OutXML)
				{
					New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
				}
				else
				{
					Write-Output $Properties
				}
			}
		}
		else
		{
			try 
			{		
				$FailoverCluster = Test-PSModule -Name FailoverClusters
				if ($FailoverCluster.ResultCode -ne "1")
				{
					if ($VMManager -eq "HyperV2")
					{
						$VMHost = hostname
						$ResultCode = "1"
						$ResultMessage = "VM host detected."
						if ($OutXML)
						{
							$xml = "<?xml version=""1.0"" encoding=""utf-8""?>`n"
							$xml += "<Result>`n"
							$xml += " <Code>$ResultCode</Code>`n"
							$xml += " <Message>$ResultMessage</Message>`n"
						}
						if (!$OutXML)
						{
							$Properties = New-Object Psobject
							$Properties | Add-Member Noteproperty ResultCode $ResultCode
							$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
							$Properties | Add-Member Noteproperty VMHost $VMHost
							Write-Output $Properties
						}
						else
						{
							$xml += " <OperationResult>`n"
							$xml += "  <VMHost>$VMHost</VMHost>`n"
							$xml += " </OperationResult>`n"
						}
						if ($OutXML)
						{
							$xml += "</Result>`n"
							$xml
						}
					}
					elseif ($VMManager -eq "HyperV")
					{
						$VMHost = hostname
						$ResultCode = "1"
						$ResultMessage = "VM host detected."
						if ($OutXML)
						{
							$xml = "<?xml version=""1.0"" encoding=""utf-8""?>`n"
							$xml += "<Result>`n"
							$xml += " <Code>$ResultCode</Code>`n"
							$xml += " <Message>$ResultMessage</Message>`n"
						}
						if (!$OutXML)
						{
							$Properties = New-Object Psobject
							$Properties | Add-Member Noteproperty ResultCode $ResultCode
							$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
							$Properties | Add-Member Noteproperty VMHost $VMHost
							Write-Output $Properties
						}
						else
						{
							$xml += " <OperationResult>`n"
							$xml += "  <VMHost>$VMHost</VMHost>`n"
							$xml += " </OperationResult>`n"
						}
						if ($OutXML)
						{
							$xml += "</Result>`n"
							$xml
						}
					}
					else
					{
						$ResultCode = "0"
						$ResultMessage = "Could not detect VM host."
						$Properties = New-Object Psobject
						$Properties | Add-Member Noteproperty ResultCode $ResultCode
						$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
						if($OutXML)
						{
							New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
						}
						else
						{
							Write-Output $Properties
						}
					}
				}
				else
				{			
					if (!$VMCluster)
					{
						try
						{
							$ClusterNodes = (Get-Cluster -EA SilentlyContinue | Get-ClusterNode)
							if (!$ClusterNodes)
							{
								if ($VMManager -eq "HyperV2")
								{
									$VMHost = hostname
									$ResultCode = "1"
									$ResultMessage = "VM host detected."
									if ($OutXML)
									{
										$xml = "<?xml version=""1.0"" encoding=""utf-8""?>`n"
										$xml += "<Result>`n"
										$xml += " <Code>$ResultCode</Code>`n"
										$xml += " <Message>$ResultMessage</Message>`n"
									}
									if (!$OutXML)
									{
										$Properties = New-Object Psobject
										$Properties | Add-Member Noteproperty ResultCode $ResultCode
										$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
										$Properties | Add-Member Noteproperty VMHost $VMHost
										Write-Output $Properties
									}
									else
									{
										$xml += " <OperationResult>`n"
										$xml += "  <VMHost>$VMHost</VMHost>`n"
										$xml += " </OperationResult>`n"
									}
									if ($OutXML)
									{
										$xml += "</Result>`n"
										$xml
									}
								}
								elseif ($VMManager -eq "HyperV")
								{
									$VMHost = hostname
									$ResultCode = "1"
									$ResultMessage = "VM host detected."
									if ($OutXML)
									{
										$xml = "<?xml version=""1.0"" encoding=""utf-8""?>`n"
										$xml += "<Result>`n"
										$xml += " <Code>$ResultCode</Code>`n"
										$xml += " <Message>$ResultMessage</Message>`n"
									}
									if (!$OutXML)
									{
										$Properties = New-Object Psobject
										$Properties | Add-Member Noteproperty ResultCode $ResultCode
										$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
										$Properties | Add-Member Noteproperty VMHost $VMHost
										Write-Output $Properties
									}
									else
									{
										$xml += " <OperationResult>`n"
										$xml += "  <VMHost>$VMHost</VMHost>`n"
										$xml += " </OperationResult>`n"
									}
									if ($OutXML)
									{
										$xml += "</Result>`n"
										$xml
									}
								}
								else
								{
									$ResultCode = "0"
									$ResultMessage = "Could not detect VM host."
									$Properties = New-Object Psobject
									$Properties | Add-Member Noteproperty ResultCode $ResultCode
									$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
									if($OutXML)
									{
										New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
									}
									else
									{
										Write-Output $Properties
									}
								}
							}
							else
							{
								foreach ($ClusterNode in $ClusterNodes)
								{
									$VMHost = $ClusterNode.Name
									$ResultCode = "1"
									$ResultMessage = "VM host detected."
									if ($OutXML)
									{
										$xml = "<?xml version=""1.0"" encoding=""utf-8""?>`n"
										$xml += "<Result>`n"
										$xml += " <Code>$ResultCode</Code>`n"
										$xml += " <Message>$ResultMessage</Message>`n"
									}
									if (!$OutXML)
									{
										$Properties = New-Object Psobject
										$Properties | Add-Member Noteproperty ResultCode $ResultCode
										$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
										$Properties | Add-Member Noteproperty VMHost $VMHost
										Write-Output $Properties
									}
									else
									{
										$xml += " <OperationResult>`n"
										$xml += "  <VMHost>$VMHost</VMHost>`n"
										$xml += " </OperationResult>`n"
									}
									if ($OutXML)
									{
										$xml += "</Result>`n"
										$xml
									}
								}
							}
						}
						catch
						{
							$ResultCode = "0"
							$ResultMessage = $_
							$Properties = New-Object Psobject
							$Properties | Add-Member Noteproperty ResultCode $ResultCode
							$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
							if($OutXML)
							{
								New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
							}
							else
							{
								Write-Output $Properties
							}
						}
					}
					else
					{
						try
						{
							$ClusterNodes = (Get-Cluster $VMCluster -EA SilentlyContinue | Get-ClusterNode)
							foreach ($ClusterNode in $ClusterNodes)
							{
								$VMHost = $ClusterNode.Name
								$ResultCode = "1"
								$ResultMessage = "VM host detected."
								if ($OutXML)
								{
									$xml = "<?xml version=""1.0"" encoding=""utf-8""?>`n"
									$xml += "<Result>`n"
									$xml += " <Code>$ResultCode</Code>`n"
									$xml += " <Message>$ResultMessage</Message>`n"
								}
								if (!$OutXML)
								{
									$Properties = New-Object Psobject
									$Properties | Add-Member Noteproperty ResultCode $ResultCode
									$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
									$Properties | Add-Member Noteproperty VMHost $VMHost
									Write-Output $Properties
								}
								else
								{
									$xml += " <OperationResult>`n"
									$xml += "  <VMHost>$VMHost</VMHost>`n"
									$xml += " </OperationResult>`n"
								}
								if ($OutXML)
								{
									$xml += "</Result>`n"
									$xml
								}
							}
						}
						catch
						{
							$ResultCode = "0"
							$ResultMessage = $_
							$Properties = New-Object Psobject
							$Properties | Add-Member Noteproperty ResultCode $ResultCode
							$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
							if($OutXML)
							{
								New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
							}
							else
							{
								Write-Output $Properties
							}
						}
					}
				}
			}
			catch
			{
				$ResultCode = "0"
				$ResultMessage = $_
				$Properties = New-Object Psobject
				$Properties | Add-Member Noteproperty ResultCode $ResultCode
				$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
				if($OutXML)
				{
					New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
				}
				else
				{
					Write-Output $Properties
				}
			}
		}
	}
	else
	{
		$Properties = New-Object Psobject
		$Properties | Add-Member Noteproperty ResultCode $ResultCode
		$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
		if($OutXML)
		{
			New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
		}
		else
		{
			Write-Output $Properties
		}
	}
}

Function Search-LinuxVM {

<#
    .SYNOPSIS
     
        Function to list all Linux VMs

	.EXAMPLE
     
        Search-LinuxVM -VMHost "hyperv01.virtualmetric.com"
		
	.EXAMPLE
     
        Search-LinuxVM -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com"

	.EXAMPLE
     
        Search-LinuxVM -VMHost "hyperv01.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com"
	
	.EXAMPLE
     
        Search-LinuxVM -VMHost "hyperv01.virtualmetric.com" -VMCluster "hyperv.virtualmetric.com" -VMMServer "scvmm01.virtualmetric.com"
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (
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

	if (!$VMManager) 
	{ 
		$TestVMManager = Test-VMManager -VMHost $VMHost -VMMServer $VMMServer
		
		if ($TestVMManager.ResultCode -eq "1")
		{
			$VMManager = $TestVMManager.VMManager
		}
		
		$ResultCode = $TestVMManager.ResultCode
		$ResultMessage = $TestVMManager.ResultMessage
	}
	else
	{
		$ResultCode = "1"
		$ResultMessage = "VM Manager is available."
	}
	
	if ($ResultCode -eq "1")
	{	
		if ($VMManager -eq "SCVMM")
		{		
			try 
			{	
				if (!$VMHost)
				{
					$VMs = Get-VM | Where {$_.OperatingSystem.Name -match "Linux" -or $_.OperatingSystem.Name -eq "Unknown" -and $_.Status -eq "Running"}
				}
				else
				{
					$VMs = Get-VM -VMHost $VMHost | Where {$_.OperatingSystem.Name -match "Linux" -or $_.OperatingSystem.Name -eq "Unknown" -and $_.Status -eq "Running"}
				}
				
				if (!$VMs)
				{
					$ResultCode = "-1"
					$ResultMessage = "No Linux VM detected."
					$Properties = New-Object Psobject
					$Properties | Add-Member Noteproperty ResultCode $ResultCode
					$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
					if($OutXML)
					{
						New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
					}
					else
					{
						Write-Output $Properties
					}
				}
				else
				{
					$ResultCode = "1"
					$ResultMessage = "Linux VM detected."
					if ($OutXML)
					{
						$xml = "<?xml version=""1.0"" encoding=""utf-8""?>`n"
						$xml += "<Result>`n"
						$xml += " <Code>$ResultCode</Code>`n"
						$xml += " <Message>$ResultMessage</Message>`n"
					}
					foreach ($VM in $VMs)
					{
						$VMName = $VM.Name
						$VMHost = $VM.VMHost
						$LinuxVM = Get-LinuxVM -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer
						$LinuxVMVMName = $LinuxVM.VMName
						$LinuxVMOSName = $LinuxVM.OSName
						$LinuxVMOSVersion = $LinuxVM.OSVersion
						$LinuxVMProcessorArchitecture = $LinuxVM.ProcessorArchitecture
						$LinuxVMHostname = $LinuxVM.Hostname
						$LinuxVMNetworkAddressIPv4 = $LinuxVM.NetworkAddressIPv4
						$LinuxVMNetworkAddressIPv6 = $LinuxVM.NetworkAddressIPv6
						$LinuxVMIntegrationServicesVersion = $LinuxVM.IntegrationServicesVersion
						if (!$LinuxVMOSName -or $LinuxVMOSName -notmatch "Windows")
						{
							# Linux VM Detection
							$LinuxVMDetection = "1"
							
							if (!$OutXML)
							{
								$Properties = New-Object Psobject
								$Properties | Add-Member Noteproperty ResultCode $ResultCode
								$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
								$Properties | Add-Member Noteproperty VMName $LinuxVMVMName
								$Properties | Add-Member Noteproperty OSName $LinuxVMOSName
								$Properties | Add-Member Noteproperty OSVersion $LinuxVMOSVersion
								$Properties | Add-Member Noteproperty ProcessorArchitecture $LinuxVMProcessorArchitecture
								$Properties | Add-Member Noteproperty Hostname $LinuxVMHostname
								$Properties | Add-Member Noteproperty NetworkAddressIPv4 $LinuxVMNetworkAddressIPv4
								$Properties | Add-Member Noteproperty NetworkAddressIPv6 $LinuxVMNetworkAddressIPv6
								$Properties | Add-Member Noteproperty IntegrationServicesVersion $LinuxVMIntegrationServicesVersion
								Write-Output $Properties
							}
							else
							{
								$xml += " <OperationResult>`n"
								$xml += "  <VMName>$LinuxVMVMName</VMName>`n"
								$xml += "  <OSName>$LinuxVMOSName</OSName>`n"
								$xml += "  <OSVersion>$LinuxVMOSVersion</OSVersion>`n"
								$xml += "  <ProcessorArchitecture>$LinuxVMProcessorArchitecture</ProcessorArchitecture>`n"
								$xml += "  <Hostname>$LinuxVMHostname</Hostname>`n"
								$xml += "  <NetworkAddressIPv4>$LinuxVMNetworkAddressIPv4</NetworkAddressIPv4>`n"
								$xml += "  <NetworkAddressIPv6>$LinuxVMNetworkAddressIPv6</NetworkAddressIPv6>`n"
								$xml += "  <IntegrationServicesVersion>$LinuxVMIntegrationServicesVersion</IntegrationServicesVersion>`n"
								$xml += " </OperationResult>`n"
							}
						}
					}
					
					if ($OutXML)
					{
						$xml += "</Result>`n"
					}
					
					if ($LinuxVMDetection -eq "1")
					{
						if ($OutXML)
						{
							$xml
						}
					}
					else
					{
						$ResultCode = "-1"
						$ResultMessage = "No Linux VM detected."
						
						$Properties = New-Object Psobject
						$Properties | Add-Member Noteproperty ResultCode $ResultCode
						$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
						if($OutXML)
						{
							New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
						}
						else
						{
							Write-Output $Properties
						}
					}
				}
			}
			catch
			{
				$ResultCode = "0"
				$ResultMessage = $_
				$Properties = New-Object Psobject
				$Properties | Add-Member Noteproperty ResultCode $ResultCode
				$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
				if($OutXML)
				{
					New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
				}
				else
				{
					Write-Output $Properties
				}
			}
		}
		elseif ($VMManager -eq "SCVMM2012")
		{
			try 
			{	
				if (!$VMHost)
				{
					$VMs = Get-SCVirtualMachine | Where {$_.OperatingSystem.Name -match "Linux" -or $_.OperatingSystem.Name -eq "Unknown" -and $_.Status -eq "Running"}
				}
				else
				{
					$VMs = Get-SCVirtualMachine -VMHost $VMHost | Where {$_.OperatingSystem.Name -match "Linux" -or $_.OperatingSystem.Name -eq "Unknown" -and $_.Status -eq "Running"}
				}
				
				if (!$VMs)
				{
					$ResultCode = "-1"
					$ResultMessage = "No Linux VM detected."
					
					$Properties = New-Object Psobject
					$Properties | Add-Member Noteproperty ResultCode $ResultCode
					$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
					if($OutXML)
					{
						New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
					}
					else
					{
						Write-Output $Properties
					}
				}
				else
				{
					$ResultCode = "1"
					$ResultMessage = "Linux VM detected."
					
					if ($OutXML)
					{
						$xml = "<?xml version=""1.0"" encoding=""utf-8""?>`n"
						$xml += "<Result>`n"
						$xml += " <Code>$ResultCode</Code>`n"
						$xml += " <Message>$ResultMessage</Message>`n"
					}
					
					foreach ($VM in $VMs)
					{
						$VMName = $VM.Name
						$VMHost = $VM.VMHost
						$LinuxVM = Get-LinuxVM -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer
						$LinuxVMVMName = $LinuxVM.VMName
						$LinuxVMOSName = $LinuxVM.OSName
						$LinuxVMOSVersion = $LinuxVM.OSVersion
						$LinuxVMProcessorArchitecture = $LinuxVM.ProcessorArchitecture
						$LinuxVMHostname = $LinuxVM.Hostname
						$LinuxVMNetworkAddressIPv4 = $LinuxVM.NetworkAddressIPv4
						$LinuxVMNetworkAddressIPv6 = $LinuxVM.NetworkAddressIPv6
						$LinuxVMIntegrationServicesVersion = $LinuxVM.IntegrationServicesVersion
						if (!$LinuxVMOSName -or $LinuxVMOSName -notmatch "Windows")
						{
							# Linux VM Detection
							$LinuxVMDetection = "1"
							
							if (!$OutXML)
							{
								$Properties = New-Object Psobject
								$Properties | Add-Member Noteproperty ResultCode $ResultCode
								$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
								$Properties | Add-Member Noteproperty VMName $LinuxVMVMName
								$Properties | Add-Member Noteproperty OSName $LinuxVMOSName
								$Properties | Add-Member Noteproperty OSVersion $LinuxVMOSVersion
								$Properties | Add-Member Noteproperty ProcessorArchitecture $LinuxVMProcessorArchitecture
								$Properties | Add-Member Noteproperty Hostname $LinuxVMHostname
								$Properties | Add-Member Noteproperty NetworkAddressIPv4 $LinuxVMNetworkAddressIPv4
								$Properties | Add-Member Noteproperty NetworkAddressIPv6 $LinuxVMNetworkAddressIPv6
								$Properties | Add-Member Noteproperty IntegrationServicesVersion $LinuxVMIntegrationServicesVersion
								Write-Output $Properties
							}
							else
							{
								$xml += " <OperationResult>`n"
								$xml += "  <VMName>$LinuxVMVMName</VMName>`n"
								$xml += "  <OSName>$LinuxVMOSName</OSName>`n"
								$xml += "  <OSVersion>$LinuxVMOSVersion</OSVersion>`n"
								$xml += "  <ProcessorArchitecture>$LinuxVMProcessorArchitecture</ProcessorArchitecture>`n"
								$xml += "  <Hostname>$LinuxVMHostname</Hostname>`n"
								$xml += "  <NetworkAddressIPv4>$LinuxVMNetworkAddressIPv4</NetworkAddressIPv4>`n"
								$xml += "  <NetworkAddressIPv6>$LinuxVMNetworkAddressIPv6</NetworkAddressIPv6>`n"
								$xml += "  <IntegrationServicesVersion>$LinuxVMIntegrationServicesVersion</IntegrationServicesVersion>`n"
								$xml += " </OperationResult>`n"
							}
						}
					}
					
					if ($OutXML)
					{
						$xml += "</Result>`n"
					}
					
					if ($LinuxVMDetection -eq "1")
					{
						if ($OutXML)
						{
							$xml
						}
					}
					else
					{
						$ResultCode = "-1"
						$ResultMessage = "No Linux VM detected."
						
						$Properties = New-Object Psobject
						$Properties | Add-Member Noteproperty ResultCode $ResultCode
						$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
						if($OutXML)
						{
							New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
						}
						else
						{
							Write-Output $Properties
						}
					}
				}
			}
			catch
			{
				$ResultCode = "0"
				$ResultMessage = $_
				$Properties = New-Object Psobject
				$Properties | Add-Member Noteproperty ResultCode $ResultCode
				$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
				if($OutXML)
				{
					New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
				}
				else
				{
					Write-Output $Properties
				}
			}
		}
		else
		{
			try 
			{		
				$FailoverCluster = Test-PSModule -Name FailoverClusters
				if ($FailoverCluster.ResultCode -ne "1")
				{
					if (!$VMHost)
					{
						$WmiHost = "."
					}
					else
					{
						$WmiHost = $VMHost
					}
					if ($VMManager -eq "HyperV2")
					{
						$VMs = Get-WmiObject -ComputerName "$WmiHost" -Namespace "root\virtualization\v2" -Query "SELECT * FROM Msvm_ComputerSystem" | Where {$_.EnabledState -eq "2"}
					}
					else
					{
						$VMs = Get-WmiObject -ComputerName "$WmiHost" -Namespace "root\virtualization" -Query "SELECT * FROM Msvm_ComputerSystem" | Where {$_.EnabledState -eq "2"}
					}
					
					if (!$VMs)
					{
						$ResultCode = "-1"
						$ResultMessage = "No Linux VM detected."
						$Properties = New-Object Psobject
						$Properties | Add-Member Noteproperty ResultCode $ResultCode
						$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
						if($OutXML)
						{
							New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
						}
						else
						{
							Write-Output $Properties
						}
					}
					else
					{
						$ResultCode = "1"
						$ResultMessage = "Linux VM detected."
						if ($OutXML)
						{
							$xml = "<?xml version=""1.0"" encoding=""utf-8""?>`n"
							$xml += "<Result>`n"
							$xml += " <Code>$ResultCode</Code>`n"
							$xml += " <Message>$ResultMessage</Message>`n"
						}
						foreach ($VM in $VMs)
						{
							$VMName = $VM.ElementName
							$VMHost = $VM.__SERVER
							if ($VMName -ne $VMHost)
							{
								$LinuxVM = Get-LinuxVM -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer
								$LinuxVMVMName = $LinuxVM.VMName
								$LinuxVMOSName = $LinuxVM.OSName
								$LinuxVMOSVersion = $LinuxVM.OSVersion
								$LinuxVMProcessorArchitecture = $LinuxVM.ProcessorArchitecture
								$LinuxVMHostname = $LinuxVM.Hostname
								$LinuxVMNetworkAddressIPv4 = $LinuxVM.NetworkAddressIPv4
								$LinuxVMNetworkAddressIPv6 = $LinuxVM.NetworkAddressIPv6
								$LinuxVMIntegrationServicesVersion = $LinuxVM.IntegrationServicesVersion
								if (!$LinuxVMOSName -or $LinuxVMOSName -notmatch "Windows")
								{
									# Linux VM Detection
									$LinuxVMDetection = "1"
									
									if (!$OutXML)
									{
										$Properties = New-Object Psobject
										$Properties | Add-Member Noteproperty ResultCode $ResultCode
										$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
										$Properties | Add-Member Noteproperty VMName $LinuxVMVMName
										$Properties | Add-Member Noteproperty OSName $LinuxVMOSName
										$Properties | Add-Member Noteproperty OSVersion $LinuxVMOSVersion
										$Properties | Add-Member Noteproperty ProcessorArchitecture $LinuxVMProcessorArchitecture
										$Properties | Add-Member Noteproperty Hostname $LinuxVMHostname
										$Properties | Add-Member Noteproperty NetworkAddressIPv4 $LinuxVMNetworkAddressIPv4
										$Properties | Add-Member Noteproperty NetworkAddressIPv6 $LinuxVMNetworkAddressIPv6
										$Properties | Add-Member Noteproperty IntegrationServicesVersion $LinuxVMIntegrationServicesVersion
										Write-Output $Properties
									}
									else
									{
										$xml += " <OperationResult>`n"
										$xml += "  <VMName>$LinuxVMVMName</VMName>`n"
										$xml += "  <OSName>$LinuxVMOSName</OSName>`n"
										$xml += "  <OSVersion>$LinuxVMOSVersion</OSVersion>`n"
										$xml += "  <ProcessorArchitecture>$LinuxVMProcessorArchitecture</ProcessorArchitecture>`n"
										$xml += "  <Hostname>$LinuxVMHostname</Hostname>`n"
										$xml += "  <NetworkAddressIPv4>$LinuxVMNetworkAddressIPv4</NetworkAddressIPv4>`n"
										$xml += "  <NetworkAddressIPv6>$LinuxVMNetworkAddressIPv6</NetworkAddressIPv6>`n"
										$xml += "  <IntegrationServicesVersion>$LinuxVMIntegrationServicesVersion</IntegrationServicesVersion>`n"
										$xml += " </OperationResult>`n"
									}
								}
							}
						}

						if ($OutXML)
						{
							$xml += "</Result>`n"
						}
						
						if ($LinuxVMDetection -eq "1")
						{
							if ($OutXML)
							{
								$xml
							}
						}
						else
						{
							$ResultCode = "-1"
							$ResultMessage = "No Linux VM detected."
							
							$Properties = New-Object Psobject
							$Properties | Add-Member Noteproperty ResultCode $ResultCode
							$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
							if($OutXML)
							{
								New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
							}
							else
							{
								Write-Output $Properties
							}
						}
					}
				}
				else
				{
					if (!$VMHost)
					{				
						if (!$VMCluster)
						{
							try
							{
								$ClusterNodes = (Get-Cluster -EA SilentlyContinue | Get-ClusterNode)
								if (!$ClusterNodes)
								{
									if (!$VMHost)
									{
										$WmiHost = "."
									}
									else
									{
										$WmiHost = $VMHost
									}
									if ($VMManager -eq "HyperV2")
									{
										$VMs = Get-WmiObject -ComputerName "$WmiHost" -Namespace "root\virtualization\v2" -Query "SELECT * FROM Msvm_ComputerSystem" | Where {$_.EnabledState -eq "2"}
									}
									else
									{
										$VMs = Get-WmiObject -ComputerName "$WmiHost" -Namespace "root\virtualization" -Query "SELECT * FROM Msvm_ComputerSystem" | Where {$_.EnabledState -eq "2"}
									}
									
									if (!$VMs)
									{
										$ResultCode = "-1"
										$ResultMessage = "No Linux VM detected."
										$Properties = New-Object Psobject
										$Properties | Add-Member Noteproperty ResultCode $ResultCode
										$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
										if($OutXML)
										{
											New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
										}
										else
										{
											Write-Output $Properties
										}
									}
									else
									{
										$ResultCode = "1"
										$ResultMessage = "Linux VM detected."
										if ($OutXML)
										{
											$xml = "<?xml version=""1.0"" encoding=""utf-8""?>`n"
											$xml += "<Result>`n"
											$xml += " <Code>$ResultCode</Code>`n"
											$xml += " <Message>$ResultMessage</Message>`n"
										}					
										foreach ($VM in $VMs)
										{
											$VMName = $VM.ElementName
											$VMHost = $VM.__SERVER
											if ($VMName -ne $VMHost)
											{
												$LinuxVM = Get-LinuxVM -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer
												$LinuxVMVMName = $LinuxVM.VMName
												$LinuxVMOSName = $LinuxVM.OSName
												$LinuxVMOSVersion = $LinuxVM.OSVersion
												$LinuxVMProcessorArchitecture = $LinuxVM.ProcessorArchitecture
												$LinuxVMHostname = $LinuxVM.Hostname
												$LinuxVMNetworkAddressIPv4 = $LinuxVM.NetworkAddressIPv4
												$LinuxVMNetworkAddressIPv6 = $LinuxVM.NetworkAddressIPv6
												$LinuxVMIntegrationServicesVersion = $LinuxVM.IntegrationServicesVersion
												if (!$LinuxVMOSName -or $LinuxVMOSName -notmatch "Windows")
												{
													# Linux VM Detection
													$LinuxVMDetection = "1"
													
													if (!$OutXML)
													{
														$Properties = New-Object Psobject
														$Properties | Add-Member Noteproperty ResultCode $ResultCode
														$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
														$Properties | Add-Member Noteproperty VMName $LinuxVMVMName
														$Properties | Add-Member Noteproperty OSName $LinuxVMOSName
														$Properties | Add-Member Noteproperty OSVersion $LinuxVMOSVersion
														$Properties | Add-Member Noteproperty ProcessorArchitecture $LinuxVMProcessorArchitecture
														$Properties | Add-Member Noteproperty Hostname $LinuxVMHostname
														$Properties | Add-Member Noteproperty NetworkAddressIPv4 $LinuxVMNetworkAddressIPv4
														$Properties | Add-Member Noteproperty NetworkAddressIPv6 $LinuxVMNetworkAddressIPv6
														$Properties | Add-Member Noteproperty IntegrationServicesVersion $LinuxVMIntegrationServicesVersion
														Write-Output $Properties
													}
													else
													{
														$xml += " <OperationResult>`n"
														$xml += "  <VMName>$LinuxVMVMName</VMName>`n"
														$xml += "  <OSName>$LinuxVMOSName</OSName>`n"
														$xml += "  <OSVersion>$LinuxVMOSVersion</OSVersion>`n"
														$xml += "  <ProcessorArchitecture>$LinuxVMProcessorArchitecture</ProcessorArchitecture>`n"
														$xml += "  <Hostname>$LinuxVMHostname</Hostname>`n"
														$xml += "  <NetworkAddressIPv4>$LinuxVMNetworkAddressIPv4</NetworkAddressIPv4>`n"
														$xml += "  <NetworkAddressIPv6>$LinuxVMNetworkAddressIPv6</NetworkAddressIPv6>`n"
														$xml += "  <IntegrationServicesVersion>$LinuxVMIntegrationServicesVersion</IntegrationServicesVersion>`n"
														$xml += " </OperationResult>`n"
													}
												}
											}
										}

										if ($OutXML)
										{
											$xml += "</Result>`n"
										}
										
										if ($LinuxVMDetection -eq "1")
										{
											if ($OutXML)
											{
												$xml
											}
										}
										else
										{
											$ResultCode = "-1"
											$ResultMessage = "No Linux VM detected."
											
											$Properties = New-Object Psobject
											$Properties | Add-Member Noteproperty ResultCode $ResultCode
											$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
											if($OutXML)
											{
												New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
											}
											else
											{
												Write-Output $Properties
											}
										}
									}
								}
								else
								{
									foreach ($ClusterNode in $ClusterNodes)
									{
										$WmiHost = $ClusterNode.Name
										if ($VMManager -eq "HyperV2")
										{
											$VMs = Get-WmiObject -ComputerName "$WmiHost" -Namespace "root\virtualization\v2" -Query "SELECT * FROM Msvm_ComputerSystem" | Where {$_.EnabledState -eq "2"}
										}
										else
										{
											$VMs = Get-WmiObject -ComputerName "$WmiHost" -Namespace "root\virtualization" -Query "SELECT * FROM Msvm_ComputerSystem" | Where {$_.EnabledState -eq "2"}
										}
										
										if (!$VMs)
										{
											$ResultCode = "-1"
											$ResultMessage = "No Linux VM detected."
											$Properties = New-Object Psobject
											$Properties | Add-Member Noteproperty ResultCode $ResultCode
											$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
											if($OutXML)
											{
												New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
											}
											else
											{
												Write-Output $Properties
											}
										}
										else
										{
											$ResultCode = "1"
											$ResultMessage = "Linux VM detected."
											if ($OutXML)
											{
												$xml = "<?xml version=""1.0"" encoding=""utf-8""?>`n"
												$xml += "<Result>`n"
												$xml += " <Code>$ResultCode</Code>`n"
												$xml += " <Message>$ResultMessage</Message>`n"
											}
											foreach ($VM in $VMs)
											{
												$VMName = $VM.ElementName
												$VMHost = $VM.__SERVER
												if ($VMName -ne $VMHost)
												{
													$LinuxVM = Get-LinuxVM -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer
													$LinuxVMVMName = $LinuxVM.VMName
													$LinuxVMOSName = $LinuxVM.OSName
													$LinuxVMOSVersion = $LinuxVM.OSVersion
													$LinuxVMProcessorArchitecture = $LinuxVM.ProcessorArchitecture
													$LinuxVMHostname = $LinuxVM.Hostname
													$LinuxVMNetworkAddressIPv4 = $LinuxVM.NetworkAddressIPv4
													$LinuxVMNetworkAddressIPv6 = $LinuxVM.NetworkAddressIPv6
													$LinuxVMIntegrationServicesVersion = $LinuxVM.IntegrationServicesVersion
													if (!$LinuxVMOSName -or $LinuxVMOSName -notmatch "Windows")
													{
														# Linux VM Detection
														$LinuxVMDetection = "1"
														
														if (!$OutXML)
														{
															$Properties = New-Object Psobject
															$Properties | Add-Member Noteproperty ResultCode $ResultCode
															$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
															$Properties | Add-Member Noteproperty VMName $LinuxVMVMName
															$Properties | Add-Member Noteproperty OSName $LinuxVMOSName
															$Properties | Add-Member Noteproperty OSVersion $LinuxVMOSVersion
															$Properties | Add-Member Noteproperty ProcessorArchitecture $LinuxVMProcessorArchitecture
															$Properties | Add-Member Noteproperty Hostname $LinuxVMHostname
															$Properties | Add-Member Noteproperty NetworkAddressIPv4 $LinuxVMNetworkAddressIPv4
															$Properties | Add-Member Noteproperty NetworkAddressIPv6 $LinuxVMNetworkAddressIPv6
															$Properties | Add-Member Noteproperty IntegrationServicesVersion $LinuxVMIntegrationServicesVersion
															Write-Output $Properties														}
														else
														{
															$xml += " <OperationResult>`n"
															$xml += "  <VMName>$LinuxVMVMName</VMName>`n"
															$xml += "  <OSName>$LinuxVMOSName</OSName>`n"
															$xml += "  <OSVersion>$LinuxVMOSVersion</OSVersion>`n"
															$xml += "  <ProcessorArchitecture>$LinuxVMProcessorArchitecture</ProcessorArchitecture>`n"
															$xml += "  <Hostname>$LinuxVMHostname</Hostname>`n"
															$xml += "  <NetworkAddressIPv4>$LinuxVMNetworkAddressIPv4</NetworkAddressIPv4>`n"
															$xml += "  <NetworkAddressIPv6>$LinuxVMNetworkAddressIPv6</NetworkAddressIPv6>`n"
															$xml += "  <IntegrationServicesVersion>$LinuxVMIntegrationServicesVersion</IntegrationServicesVersion>`n"
															$xml += " </OperationResult>`n"
														}
													}
												}
											}

											if ($OutXML)
											{
												$xml += "</Result>`n"
											}
											
											if ($LinuxVMDetection -eq "1")
											{
												if ($OutXML)
												{
													$xml
												}
											}
											else
											{
												$ResultCode = "-1"
												$ResultMessage = "No Linux VM detected."
												
												$Properties = New-Object Psobject
												$Properties | Add-Member Noteproperty ResultCode $ResultCode
												$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
												if($OutXML)
												{
													New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
												}
												else
												{
													Write-Output $Properties
												}
											}
										}
									}
								}
							}
							catch
							{
								$ResultCode = "0"
								$ResultMessage = $_
								$Properties = New-Object Psobject
								$Properties | Add-Member Noteproperty ResultCode $ResultCode
								$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
								if($OutXML)
								{
									New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
								}
								else
								{
									Write-Output $Properties
								}
							}
						}
						else
						{
							try
							{
								$ClusterNodes = (Get-Cluster $VMCluster -EA SilentlyContinue | Get-ClusterNode)
								foreach ($ClusterNode in $ClusterNodes)
								{
									$WmiHost = $ClusterNode.Name
									if ($VMManager -eq "HyperV2")
									{
										$VMs = Get-WmiObject -ComputerName "$WmiHost" -Namespace "root\virtualization\v2" -Query "SELECT * FROM Msvm_ComputerSystem" | Where {$_.EnabledState -eq "2"}
									}
									else
									{
										$VMs = Get-WmiObject -ComputerName "$WmiHost" -Namespace "root\virtualization" -Query "SELECT * FROM Msvm_ComputerSystem" | Where {$_.EnabledState -eq "2"}
									}
									
									if (!$VMs)
									{
										$ResultCode = "-1"
										$ResultMessage = "No Linux VM detected."
										$Properties = New-Object Psobject
										$Properties | Add-Member Noteproperty ResultCode $ResultCode
										$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
										if($OutXML)
										{
											New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
										}
										else
										{
											Write-Output $Properties
										}
									}
									else
									{
										$ResultCode = "1"
										$ResultMessage = "Linux VM detected."
										if ($OutXML)
										{
											$xml = "<?xml version=""1.0"" encoding=""utf-8""?>`n"
											$xml += "<Result>`n"
											$xml += " <Code>$ResultCode</Code>`n"
											$xml += " <Message>$ResultMessage</Message>`n"
										}										
										foreach ($VM in $VMs)
										{
											$VMName = $VM.ElementName
											$VMHost = $VM.__SERVER
											if ($VMName -ne $VMHost)
											{
												$LinuxVM = Get-LinuxVM -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer
												$LinuxVMVMName = $LinuxVM.VMName
												$LinuxVMOSName = $LinuxVM.OSName
												$LinuxVMOSVersion = $LinuxVM.OSVersion
												$LinuxVMProcessorArchitecture = $LinuxVM.ProcessorArchitecture
												$LinuxVMHostname = $LinuxVM.Hostname
												$LinuxVMNetworkAddressIPv4 = $LinuxVM.NetworkAddressIPv4
												$LinuxVMNetworkAddressIPv6 = $LinuxVM.NetworkAddressIPv6
												$LinuxVMIntegrationServicesVersion = $LinuxVM.IntegrationServicesVersion
												if (!$LinuxVMOSName -or $LinuxVMOSName -notmatch "Windows")
												{
													# Linux VM Detection
													$LinuxVMDetection = "1"
													
													if (!$OutXML)
													{
														$Properties = New-Object Psobject
														$Properties | Add-Member Noteproperty ResultCode $ResultCode
														$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
														$Properties | Add-Member Noteproperty VMName $LinuxVMVMName
														$Properties | Add-Member Noteproperty OSName $LinuxVMOSName
														$Properties | Add-Member Noteproperty OSVersion $LinuxVMOSVersion
														$Properties | Add-Member Noteproperty ProcessorArchitecture $LinuxVMProcessorArchitecture
														$Properties | Add-Member Noteproperty Hostname $LinuxVMHostname
														$Properties | Add-Member Noteproperty NetworkAddressIPv4 $LinuxVMNetworkAddressIPv4
														$Properties | Add-Member Noteproperty NetworkAddressIPv6 $LinuxVMNetworkAddressIPv6
														$Properties | Add-Member Noteproperty IntegrationServicesVersion $LinuxVMIntegrationServicesVersion
														Write-Output $Properties
													}
													else
													{
														$xml += " <OperationResult>`n"
														$xml += "  <VMName>$LinuxVMVMName</VMName>`n"
														$xml += "  <OSName>$LinuxVMOSName</OSName>`n"
														$xml += "  <OSVersion>$LinuxVMOSVersion</OSVersion>`n"
														$xml += "  <ProcessorArchitecture>$LinuxVMProcessorArchitecture</ProcessorArchitecture>`n"
														$xml += "  <Hostname>$LinuxVMHostname</Hostname>`n"
														$xml += "  <NetworkAddressIPv4>$LinuxVMNetworkAddressIPv4</NetworkAddressIPv4>`n"
														$xml += "  <NetworkAddressIPv6>$LinuxVMNetworkAddressIPv6</NetworkAddressIPv6>`n"
														$xml += "  <IntegrationServicesVersion>$LinuxVMIntegrationServicesVersion</IntegrationServicesVersion>`n"
														$xml += " </OperationResult>`n"
													}
												}
											}
										}
										
										if ($OutXML)
										{
											$xml += "</Result>`n"
										}
										
										if ($LinuxVMDetection -eq "1")
										{
											if ($OutXML)
											{
												$xml
											}
										}
										else
										{
											$ResultCode = "-1"
											$ResultMessage = "No Linux VM detected."
											
											$Properties = New-Object Psobject
											$Properties | Add-Member Noteproperty ResultCode $ResultCode
											$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
											if($OutXML)
											{
												New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
											}
											else
											{
												Write-Output $Properties
											}
										}
									}
								}
							}
							catch
							{
								$ResultCode = "0"
								$ResultMessage = $_
								$Properties = New-Object Psobject
								$Properties | Add-Member Noteproperty ResultCode $ResultCode
								$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
								if($OutXML)
								{
									New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
								}
								else
								{
									Write-Output $Properties
								}
							}
						}
					}
					else
					{
						try
						{
							$WmiHost = $VMHost
							if ($VMManager -eq "HyperV2")
							{
								$VMs = Get-WmiObject -ComputerName "$WmiHost" -Namespace "root\virtualization\v2" -Query "SELECT * FROM Msvm_ComputerSystem" | Where {$_.EnabledState -eq "2"}
							}
							else
							{
								$VMs = Get-WmiObject -ComputerName "$WmiHost" -Namespace "root\virtualization" -Query "SELECT * FROM Msvm_ComputerSystem" | Where {$_.EnabledState -eq "2"}
							}
							
							if (!$VMs)
							{
								$ResultCode = "-1"
								$ResultMessage = "No Linux VM detected."
								$Properties = New-Object Psobject
								$Properties | Add-Member Noteproperty ResultCode $ResultCode
								$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
								if($OutXML)
								{
									New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
								}
								else
								{
									Write-Output $Properties
								}
							}
							else
							{
								$ResultCode = "1"
								$ResultMessage = "Linux VM detected."
								if ($OutXML)
								{
									$xml = "<?xml version=""1.0"" encoding=""utf-8""?>`n"
									$xml += "<Result>`n"
									$xml += " <Code>$ResultCode</Code>`n"
									$xml += " <Message>$ResultMessage</Message>`n"
								}
								foreach ($VM in $VMs)
								{
									$VMName = $VM.ElementName
									$VMHost = $VM.__SERVER
									if ($VMName -ne $VMHost)
									{
										$LinuxVM = Get-LinuxVM -VMName $VMName -VMHost $VMHost -VMCluster $VMCluster -VMMServer $VMMServer
										$LinuxVMVMName = $LinuxVM.VMName
										$LinuxVMOSName = $LinuxVM.OSName
										$LinuxVMOSVersion = $LinuxVM.OSVersion
										$LinuxVMProcessorArchitecture = $LinuxVM.ProcessorArchitecture
										$LinuxVMHostname = $LinuxVM.Hostname
										$LinuxVMNetworkAddressIPv4 = $LinuxVM.NetworkAddressIPv4
										$LinuxVMNetworkAddressIPv6 = $LinuxVM.NetworkAddressIPv6
										$LinuxVMIntegrationServicesVersion = $LinuxVM.IntegrationServicesVersion
										if (!$LinuxVMOSName -or $LinuxVMOSName -notmatch "Windows")
										{
											# Linux VM Detection
											$LinuxVMDetection = "1"
											
											if (!$OutXML)
											{
												$Properties = New-Object Psobject
												$Properties | Add-Member Noteproperty ResultCode $ResultCode
												$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
												$Properties | Add-Member Noteproperty VMName $LinuxVMVMName
												$Properties | Add-Member Noteproperty OSName $LinuxVMOSName
												$Properties | Add-Member Noteproperty OSVersion $LinuxVMOSVersion
												$Properties | Add-Member Noteproperty ProcessorArchitecture $LinuxVMProcessorArchitecture
												$Properties | Add-Member Noteproperty Hostname $LinuxVMHostname
												$Properties | Add-Member Noteproperty NetworkAddressIPv4 $LinuxVMNetworkAddressIPv4
												$Properties | Add-Member Noteproperty NetworkAddressIPv6 $LinuxVMNetworkAddressIPv6
												$Properties | Add-Member Noteproperty IntegrationServicesVersion $LinuxVMIntegrationServicesVersion
												Write-Output $Properties
											}
											else
											{
												$xml += " <OperationResult>`n"
												$xml += "  <VMName>$LinuxVMVMName</VMName>`n"
												$xml += "  <OSName>$LinuxVMOSName</OSName>`n"
												$xml += "  <OSVersion>$LinuxVMOSVersion</OSVersion>`n"
												$xml += "  <ProcessorArchitecture>$LinuxVMProcessorArchitecture</ProcessorArchitecture>`n"
												$xml += "  <Hostname>$LinuxVMHostname</Hostname>`n"
												$xml += "  <NetworkAddressIPv4>$LinuxVMNetworkAddressIPv4</NetworkAddressIPv4>`n"
												$xml += "  <NetworkAddressIPv6>$LinuxVMNetworkAddressIPv6</NetworkAddressIPv6>`n"
												$xml += "  <IntegrationServicesVersion>$LinuxVMIntegrationServicesVersion</IntegrationServicesVersion>`n"
												$xml += " </OperationResult>`n"
											}
										}
									}
								}

								if ($OutXML)
								{
									$xml += "</Result>`n"
								}
								
								if ($LinuxVMDetection -eq "1")
								{
									if ($OutXML)
									{
										$xml
									}
								}
								else
								{
									$ResultCode = "-1"
									$ResultMessage = "No Linux VM detected."
									
									$Properties = New-Object Psobject
									$Properties | Add-Member Noteproperty ResultCode $ResultCode
									$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
									if($OutXML)
									{
										New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
									}
									else
									{
										Write-Output $Properties
									}
								}
							}
						}
						catch
						{
							$ResultCode = "0"
							$ResultMessage = $_
							$Properties = New-Object Psobject
							$Properties | Add-Member Noteproperty ResultCode $ResultCode
							$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
							if($OutXML)
							{
								New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
							}
							else
							{
								Write-Output $Properties
							}
						}					
					}
				}
			}
			catch
			{
				$ResultCode = "0"
				$ResultMessage = $_
				$Properties = New-Object Psobject
				$Properties | Add-Member Noteproperty ResultCode $ResultCode
				$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
				if($OutXML)
				{
					New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
				}
				else
				{
					Write-Output $Properties
				}
			}
		}
	}
	else
	{
		$Properties = New-Object Psobject
		$Properties | Add-Member Noteproperty ResultCode $ResultCode
		$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
		if($OutXML)
		{
			New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage
		}
		else
		{
			Write-Output $Properties
		}
	}	
}

function ProcessWMIJob {

<#
    .SYNOPSIS
     
        Function to watch wmi process

    .EXAMPLE
     
        ProcessWMIJob($Process)
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (
	[System.Management.ManagementBaseObject]$Result	
)

	if ($Result.ReturnValue -eq 4096) 
	{  
		$Job = [WMI]$Result.Job 

		while ($Job.JobState -eq 4) 
		{
			Start-Sleep -seconds 1 
			$Job.PSBase.Get() 
		}  
		
		if ($Job.JobState -ne 7) 
		{  
			$ResultCode = "-1"
			$ResultMessage = "Hyper-V WMI job failed."
		}
		else
		{
			$ResultCode = "1"
			$ResultMessage = "Hyper-V WMI job completed."
		}
	}  
	elseif ($Result.ReturnValue -ne 0) 
	{
		$ResultCode = "-1"
		$ResultMessage = "Hyper-V WMI job failed."
	}

	$Properties = New-Object Psobject
	$Properties | Add-Member Noteproperty ResultCode $ResultCode
	$Properties | Add-Member Noteproperty ResultMessage $ResultMessage
	Write-Output $Properties
}


function New-XML {

<#
    .SYNOPSIS
     
        Function to export results as xml format

    .EXAMPLE
     
        New-XML
		
#>

param($ResultCode="-1", $ResultMessage="The operation failed", $RootTag="Result", $ItemTag="OperationResult", $ChildItems="*", $Attributes=$Null, [switch]$Details=$false)

Begin {
	
	$xml = "<?xml version=""1.0"" encoding=""utf-8""?>`n"
	$xml += "<$RootTag>`n"
	$xml += " <Code>$ResultCode</Code>`n"
	$xml += " <Message>$ResultMessage</Message>`n"
}

Process {

	if ($Details)
	{
		$xml += " <$ItemTag"
		if ($Attributes)
		{
			foreach ($attr in $_ | Get-Member -type *Property $attributes)
			{ 
				$name = $attr.Name
				$xml += " $Name=`"$($_.$Name)`""
			}
		}
		$xml += ">`n"
		foreach ($child in $_ | Get-Member -Type *Property $childItems)
		{
			$name = $child.Name
			$xml += " <$Name>$($_.$Name)</$Name>`n"
		}
		$xml += " </$ItemTag>`n"
	}
}

End {

	$xml += "</$RootTag>`n"
	$xml
}
}

Function New-TimeStamp {

<#
    .SYNOPSIS
     
        Function to create new time stamp

    .EXAMPLE
     
        New-TimeStamp
		
#>

    $now = Get-Date
    $yr = $now.Year.ToString()
	$mo = $now.Month.ToString()
	$dy = $now.Day.ToString()
	$hr = $now.Hour.ToString()
	$mi = $now.Minute.ToString()
	$sd = $now.Second.ToString()
	Write-Output $yr$mo$dy$hr$mi$sd
}

function Confirm-SetLinuxVMWAPrivileges {

<#
    .SYNOPSIS
     
        Function to test administrative privileges

    .EXAMPLE
     
        Confirm-SetLinuxVMWAPrivileges
		
#>

	$User = [Security.Principal.WindowsIdentity]::GetCurrent()
	if((New-Object Security.Principal.WindowsPrincipal $User).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator))
	{
		$Result = "Validated"
	}
	$Result
}
