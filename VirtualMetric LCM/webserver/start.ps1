# Copyright (C) 2015 VirtualMetric
# This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

function Start-SetLinuxVMWA {
 
<#
    .SYNOPSIS
     
        Powershell Web Server to serve HTML and Powershell web contents.
 
    .DESCRIPTION
     
        Listens a port to serve web content. Supports HTML and Powershell.
    
    .PARAMETER  WhatIf
     
        Display what would happen if you would run the function with given parameters.
    
    .PARAMETER  Confirm
     
        Prompts for confirmation for each operation. Allow user to specify Yes/No to all option to stop prompting.
    
    .EXAMPLE
     
        Start-SetLinuxVMWA -IP 127.0.0.1 -Port 8080
		
    .EXAMPLE
     
        Start-SetLinuxVMWA -IP 127.0.0.1 -Port 8080 -SSL -SSLIP 127.0.0.1 -SSLPort 8443
		
    .EXAMPLE
     
        Start-SetLinuxVMWA -Hostname "virtualmetric.com" -Port 8080
		
    .EXAMPLE
     
        Start-SetLinuxVMWA -Hostname "virtualmetric.com" -Port 8080 -SSL -SSLIP 127.0.0.1 -SSLPort 8443
		
    .EXAMPLE
     
        Start-SetLinuxVMWA -Hostname "virtualmetric.com,www.virtualmetric.com" -Port 8080

    .INPUTS
    
        None
 
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

    # Hostname
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'IP Address or Hostname')]
	[Alias('IP')]
    [string]$Hostname,
	
    # Port Number
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Port Number')]
    [string]$Port,
	
    # SSL IP Address
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'SSL IP Address')]
    [string]$SSLIP,
	
    # SSL Port Number
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'SSL Port Number')]
    [string]$SSLPort,
	
    # SSL Port Number
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'SSL Friendly Name. Example: poshserver.net')]
    [string]$SSLName,
	
    # Home Directory
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Home Directory. Example: C:\inetpub\wwwroot')]
    [string]$HomeDirectory,
	
    # Log Directory
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Log Directory. Example: C:\inetpub\wwwroot')]
    [string]$LogDirectory,
	
    # Static REST Key
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Static REST API key')]
    [string]$StaticRESTKey,
	
    # Enable SSL
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Enable SSL')]
    [switch]$SSL = $false,
	
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
	
	# SetLinuxVM Admin Privileges Verification
	$Privileges = Confirm-SetLinuxVMWAPrivileges

	if ($Privileges -ne "Validated")
	{
		Write-Host " "
		Write-Host "Please execute SetLinuxVMWA with administrative privileges."
		Write-Host "Aborting.."
		Write-Host " "
		Break;
	}
		
	# Get SetLinuxVMWA Module Path
	$ModulePaths = ($env:PSModulePath).Split(";")
	
	Foreach ($ModulePath in $ModulePaths)
	{
		$ModulePath = "$ModulePath\SetLinuxVM\webserver"
		$ModulePath = $ModulePath.Replace("\\","\")
		$ModulePathTest = Test-Path $ModulePath
		if ($ModulePathTest)
		{
			$SetLinuxVMWAModulePath = $ModulePath
		}
	}
	
	if (!$SetLinuxVMWAModulePath)
	{
		Write-Warning "Could not detect SetLinuxVMWA module path."
		Write-Warning "Aborting.."
		Break;
	}
	
	# Get Home and Log Directories
	if (!$HomeDirectory) { $HomeDirectory = "$SetLinuxVMWAModulePath\http" }
	if (!$LogDirectory) { $LogDirectory = "$SetLinuxVMWAModulePath\logs" }
		
	# Get PoSH Server Module Path
	$ModulePaths = ($env:PSModulePath).Split(";")
	
	Foreach ($ModulePath in $ModulePaths)
	{
		$ModulePath = "$ModulePath\PoSHServer"
		$ModulePath = $ModulePath.Replace("\\","\")
		$ModulePathTest = Test-Path $ModulePath
		if ($ModulePathTest)
		{
			$PoSHModulePath = $ModulePath
		}
	}
	
	if (!$PoSHModulePath)
	{
		Write-Host " "
		Write-Host " "
		Write-Warning "SetLinuxVMWA v5.2 requires PoSH Server v3.1 or above.."
		Write-Warning "Please download and install it from http://www.poshserver.net"
		Write-Warning "PoSHServer is a secure, fast and lightweight web server to run SetLinuxVMWA web interface."
		Write-Warning "Since IIS is not recommended on Hyper-V server, you can safely use PoSHServer."
		Write-Warning "Thanks for using PoSHServer."
		Write-Warning "Aborting.."
		Break;
	}
	
	# Configure Static REST Key
	if ($StaticRESTKey)
	{
		$RestAPIKeyConfig = "$HomeDirectory\config\restapikey.config"
		Clear-Content -Path $RestAPIKeyConfig
		Add-Content -Path $RestAPIKeyConfig -Value $StaticRESTKey
	}
	
	if ($DebugMode)
	{
		if ($SSL)
		{
			Start-PoSHServer -Hostname $Hostname -Port $Port -SSL -SSLIP $SSLIP -SSLPort $SSLPort -SSLName $SSLName -HomeDirectory $HomeDirectory -LogDirectory $LogDirectory -CustomConfig "$SetLinuxVMWAModulePath\config.ps1" -CustomChildConfig "$SetLinuxVMWAModulePath\childconfig.ps1" -DebugMode -asJob
		}
		else
		{
			Start-PoSHServer -Hostname $Hostname -Port $Port -HomeDirectory $HomeDirectory -LogDirectory $LogDirectory -CustomConfig "$SetLinuxVMWAModulePath\config.ps1" -CustomChildConfig "$SetLinuxVMWAModulePath\childconfig.ps1" -DebugMode -asJob
		}
	}
	else
	{
		if ($SSL)
		{
			Start-PoSHServer -Hostname $Hostname -Port $Port -SSL -SSLIP $SSLIP -SSLPort $SSLPort -SSLName $SSLName -HomeDirectory $HomeDirectory -LogDirectory $LogDirectory -CustomConfig "$SetLinuxVMWAModulePath\config.ps1" -CustomChildConfig "$SetLinuxVMWAModulePath\childconfig.ps1" -asJob
		}
		else
		{
			Start-PoSHServer -Hostname $Hostname -Port $Port -HomeDirectory $HomeDirectory -LogDirectory $LogDirectory -CustomConfig "$SetLinuxVMWAModulePath\config.ps1" -CustomChildConfig "$SetLinuxVMWAModulePath\childconfig.ps1" -asJob
		}
	}
}
