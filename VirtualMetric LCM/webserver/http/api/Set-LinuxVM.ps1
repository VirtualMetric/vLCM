# Copyright (C) 2015 VirtualMetric
# This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

# Get RestAPI Key
$RestAPIKey = $PoSHQuery.RestAPIKey

# Check HTTP POST
if (!$RestAPIKey)
{
	$RestAPIKey = $PoSHPost.RestAPIKey
	$RequestType = "POST"
}
else
{
	$RequestType = "GET"
}

# Request Time
$RequestTime = Get-Date

# Check RestAPI Key
$RestAPIKeyConfig = "$HomeDirectory\config\restapikey.config"
$RestAPIKeyValue = Get-Content -Path $RestAPIKeyConfig

if ($RestAPIKey)
{
	if ($RequestType -eq "GET")
	{
		# Name of the Linux VM you want to set.
		$LinuxVMName = $PoSHQuery.VMName
		
		if (!$LinuxVMName)
		{
			$LinuxVMName = $PoSHQuery.VM
		}
		
		# Name of the Hyper-V host which currently hosts your Linux VM.
		$LinuxVMHost = $PoSHQuery.VMHost
		
		# Name of the SCVMM server which currently hosts your Linux VM.
		$LinuxVMMServer = $PoSHQuery.VMMServer
		
		# Name of the Linux VM template. Example: "CentOS 6.2 x64"
		$LinuxVMTemplateName = $PoSHQuery.VMTemplateName
		
		# Username of the Linux virtual machine.
		$LinuxVMUsername = $PoSHQuery.Username
		
		# Password of the Linux virtual machine's user.
		$LinuxVMPassword = $PoSHQuery.Password
		
		# Hostname of your Linux VM.
		$LinuxVMHostname = $PoSHQuery.Hostname
		
		# IP address of your Linux VM. You can assign single IP for your Linux VM.
		$LinuxVMIPAddress = $PoSHQuery.IPAddress
		
		if (!$LinuxVMIPAddress)
		{
			$LinuxVMIPAddress = $PoSHQuery.IP
		}
	
		# Subnet mask of your Linux VM.
		$LinuxVMSubnet = $PoSHQuery.SubnetMask
		
		if (!$LinuxVMSubnet)
		{
			$LinuxVMSubnet = $PoSHQuery.Subnet
		}

		# Gateway address of your Linux VM. 
		$LinuxVMGateway = $PoSHQuery.GatewayAddress
		
		if (!$LinuxVMGateway)
		{
			$LinuxVMGateway = $PoSHQuery.Gateway
		}
		
		# Primary DNS address of your Linux VM.
		$LinuxVMDNS = $PoSHQuery.DNSAddress
		
		if (!$LinuxVMDNS)
		{
			$LinuxVMDNS = $PoSHQuery.PrimaryDNSAddress 
		}
		
		if (!$LinuxVMDNS)
		{
			$LinuxVMDNS = $PoSHQuery.DNS1
		}
		
		# Secondary DNS address of your Linux VM.
		$LinuxVMDNS2 = $PoSHQuery.SecondaryDNSAddress 
		
		if (!$LinuxVMDNS2)
		{
			$LinuxVMDNS2 = $PoSHQuery.DNS2
		}		
				
		# New password of the Linux VM user.
		$LinuxVMNewPassword = $PoSHQuery.NewPassword
		
		# New time zone value of the Linux VM.
		$LinuxVMTimeZone = $PoSHQuery.TimeZone
		
		# Path of the answer file for custom virtual machine modifications. Example: "C:\answer.txt"
		$LinuxVMAnswerFile = $PoSHQuery.AnswerFile
		
		# Name of the control panel you want to install. Valid values: "CPanel, Plesk"
		$LinuxVMPanel = $PoSHQuery.Panel
		
		# Language of the virtual machine console keyboard. Example: "us"
		$LinuxVMVMKeyboard = $PoSHQuery.VMKeyboard
		
		# Transfer custom files? Please provide path. Example: "C:\Custom.tar"
		$LinuxVMTransferFile = $PoSHQuery.TransferFile
		
		# Extend Logical Volume
		$LinuxVMExtendLVM = $PoSHQuery.ExtendLVM
		
		# Do you want to install Linux integration components?
		$LinuxVMInstallLIC = $PoSHQuery.InstallLIC
		
		# Job Type
		$LinuxVMJobType = $PoSHQuery.JobType
	}
	
	if ($RequestType -eq "POST")
	{
		# Name of the Linux VM you want to set.
		$LinuxVMName = $PoSHPost.VMName
		
		if (!$LinuxVMName)
		{
			$LinuxVMName = $PoSHPost.VM
		}
		
		# Name of the Hyper-V host which currently hosts your Linux VM.
		$LinuxVMHost = $PoSHPost.VMHost
		
		# Name of the SCVMM server which currently hosts your Linux VM.
		$LinuxVMMServer = $PoSHPost.VMMServer
		
		# Name of the Linux VM template. Example: "CentOS 6.2 x64"
		$LinuxVMTemplateName = $PoSHPost.VMTemplateName
		
		# Username of the Linux virtual machine.
		$LinuxVMUsername = $PoSHPost.Username
		
		# Password of the Linux virtual machine's user.
		$LinuxVMPassword = $PoSHPost.Password
		
		# Hostname of your Linux VM.
		$LinuxVMHostname = $PoSHPost.Hostname
		
		# IP address of your Linux VM. You can assign single IP for your Linux VM.
		$LinuxVMIPAddress = $PoSHPost.IPAddress
		
		if (!$LinuxVMIPAddress)
		{
			$LinuxVMIPAddress = $PoSHPost.IP
		}
	
		# Subnet mask of your Linux VM.
		$LinuxVMSubnet = $PoSHPost.SubnetMask
		
		if (!$LinuxVMSubnet)
		{
			$LinuxVMSubnet = $PoSHPost.Subnet
		}

		# Gateway address of your Linux VM. 
		$LinuxVMGateway = $PoSHPost.GatewayAddress
		
		if (!$LinuxVMGateway)
		{
			$LinuxVMGateway = $PoSHPost.Gateway
		}
		
		# Primary DNS address of your Linux VM.
		$LinuxVMDNS = $PoSHPost.DNSAddress
		
		if (!$LinuxVMDNS)
		{
			$LinuxVMDNS = $PoSHPost.PrimaryDNSAddress 
		}
		
		if (!$LinuxVMDNS)
		{
			$LinuxVMDNS = $PoSHPost.DNS1
		}
		
		# Secondary DNS address of your Linux VM.
		$LinuxVMDNS2 = $PoSHPost.SecondaryDNSAddress 
		
		if (!$LinuxVMDNS2)
		{
			$LinuxVMDNS2 = $PoSHPost.DNS2
		}		
				
		# New password of the Linux VM user.
		$LinuxVMNewPassword = $PoSHPost.NewPassword
		
		# New time zone value of the Linux VM.
		$LinuxVMTimeZone = $PoSHPost.TimeZone
		
		# Path of the answer file for custom virtual machine modifications. Example: "C:\answer.txt"
		$LinuxVMAnswerFile = $PoSHPost.AnswerFile
		
		# Name of the control panel you want to install. Valid values: "CPanel, Plesk"
		$LinuxVMPanel = $PoSHPost.Panel
		
		# Language of the virtual machine console keyboard. Example: "us"
		$LinuxVMVMKeyboard = $PoSHPost.VMKeyboard
		
		# Transfer custom files? Please provide path. Example: "C:\Custom.tar"
		$LinuxVMTransferFile = $PoSHPost.TransferFile
		
		# Extend Logical Volume
		$LinuxVMExtendLVM = $PoSHPost.ExtendLVM
		
		# Do you want to install Linux integration components?
		$LinuxVMInstallLIC = $PoSHPost.InstallLIC
		
		# Job Type
		$LinuxVMJobType = $PoSHPost.JobType
	}
	
	# Verification
	if ($LinuxVMName)
	{
		if ($RestAPIKey -eq $RestAPIKeyValue)
		{
			$ResultCode = "1"
			$ApiResponse = "201"
			$ResultMessage = "RestAPI key validated."
		}
		else
		{
			$ResultCode = "0"
			$ApiResponse = "401"
			$ResultMessage = "RestAPI key is not correct."
		}
	}
	else
	{
		$ResultCode = "0"
		$ApiResponse = "400"
		$ResultMessage = "Linux VM is not provided."
	}
}
else
{
	$ResultCode = "0"
	$ApiResponse = "403"
	$ResultMessage = "RestAPIKey is not provided."	
}

# Process
if ($ResultCode -eq "1")
{
	# Temp Files Path
	$TempPath = "$HomeDirectory\temp\Set-LinuxVM.$LinuxVMName.xml"
	$OldTempPath = "$HomeDirectory\temp\History.Set-LinuxVM.$LinuxVMName.xml"
	
	# Check Temp Files
	$TempPathTest = Test-Path $TempPath
	$OldTempPathTest = Test-Path $OldTempPath
	
	if ($LinuxVMJobType -eq "New")
	{		
		if (!$TempPathTest)
		{
			# Result Code
			$ResultCode = "1"
			$ApiResponse = "202"
			$ResultMessage = "Started virtual machine preparation."
			
			# Generate Job ID
			$JobID = Get-Random
			Add-Content -Path $TempPath -Value $JobID -EA SilentlyContinue
	
			$AsyncSetLinuxVMArgs = @($LinuxVMName,$LinuxVMHost,$LinuxVMMServer,$LinuxVMTemplateName,$LinuxVMUsername,$LinuxVMPassword,$LinuxVMHostname,$LinuxVMIPAddress,$LinuxVMSubnet,$LinuxVMGateway,$LinuxVMDNS,$LinuxVMDNS2,$LinuxVMNewPassword,$LinuxVMTimeZone,$LinuxVMAnswerFile,$LinuxVMPanel,$LinuxVMVMKeyboard,$LinuxVMTransferFile,$LinuxVMExtendLVM,$LinuxVMInstallLIC,$TempPath,$OldTempPath,$JobID,$RequestTime)
			$AsyncSetLinuxVM = Start-Job -scriptblock {
			param ($LinuxVMName, $LinuxVMHost, $LinuxVMMServer, $LinuxVMTemplateName, $LinuxVMUsername, $LinuxVMPassword, $LinuxVMHostname, $LinuxVMIPAddress, $LinuxVMSubnet, $LinuxVMGateway, $LinuxVMDNS, $LinuxVMDNS2, $LinuxVMNewPassword, $LinuxVMTimeZone, $LinuxVMAnswerFile, $LinuxVMPanel, $LinuxVMVMKeyboard, $LinuxVMTransferFile, $LinuxVMExtendLVM, $LinuxVMInstallLIC, $TempPath, $OldTempPath, $JobID, $RequestTime)

				Import-Module SetLinuxVM
				if (!$LinuxVMInstallLIC -and $LinuxVMExtendLVM)
				{
					$Output = Set-LinuxVM -VMName "$LinuxVMName" -VMHost $LinuxVMHost -VMMServer $LinuxVMMServer -VMTemplateName $LinuxVMTemplateName -Username "$LinuxVMUsername" -Password "$LinuxVMPassword" -Hostname "$LinuxVMHostname" -IP "$LinuxVMIPAddress" -Subnet "$LinuxVMSubnet" -Gateway "$LinuxVMGateway" -DNS1 "$LinuxVMDNS" -DNS2 "$LinuxVMDNS2" -TimeZone $LinuxVMTimeZone -AnswerFile $LinuxVMAnswerFile -Panel $LinuxVMPanel -VMKeyboard $LinuxVMVMKeyboard -TransferFile $LinuxVMTransferFile -ExtendLVM
				}
				elseif ($LinuxVMInstallLIC -and !$LinuxVMExtendLVM)
				{
					$Output = Set-LinuxVM -VMName "$LinuxVMName" -VMHost $LinuxVMHost -VMMServer $LinuxVMMServer -VMTemplateName $LinuxVMTemplateName -Username "$LinuxVMUsername" -Password "$LinuxVMPassword" -Hostname "$LinuxVMHostname" -IP "$LinuxVMIPAddress" -Subnet "$LinuxVMSubnet" -Gateway "$LinuxVMGateway" -DNS1 "$LinuxVMDNS" -DNS2 "$LinuxVMDNS2" -TimeZone $LinuxVMTimeZone -AnswerFile $LinuxVMAnswerFile -Panel $LinuxVMPanel -VMKeyboard $LinuxVMVMKeyboard -TransferFile $LinuxVMTransferFile -InstallLIC
				}
				elseif ($LinuxVMInstallLIC -and $LinuxVMExtendLVM)
				{
					$Output = Set-LinuxVM -VMName "$LinuxVMName" -VMHost $LinuxVMHost -VMMServer $LinuxVMMServer -VMTemplateName $LinuxVMTemplateName -Username "$LinuxVMUsername" -Password "$LinuxVMPassword" -Hostname "$LinuxVMHostname" -IP "$LinuxVMIPAddress" -Subnet "$LinuxVMSubnet" -Gateway "$LinuxVMGateway" -DNS1 "$LinuxVMDNS" -DNS2 "$LinuxVMDNS2" -TimeZone $LinuxVMTimeZone -AnswerFile $LinuxVMAnswerFile -Panel $LinuxVMPanel -VMKeyboard $LinuxVMVMKeyboard -TransferFile $LinuxVMTransferFile -InstallLIC -ExtendLVM
				}
				else
				{
					$Output = Set-LinuxVM -VMName "$LinuxVMName" -VMHost $LinuxVMHost -VMMServer $LinuxVMMServer -VMTemplateName $LinuxVMTemplateName -Username "$LinuxVMUsername" -Password "$LinuxVMPassword" -Hostname "$LinuxVMHostname" -IP "$LinuxVMIPAddress" -Subnet "$LinuxVMSubnet" -Gateway "$LinuxVMGateway" -DNS1 "$LinuxVMDNS" -DNS2 "$LinuxVMDNS2" -TimeZone $LinuxVMTimeZone -AnswerFile $LinuxVMAnswerFile -Panel $LinuxVMPanel -VMKeyboard $LinuxVMVMKeyboard -TransferFile $LinuxVMTransferFile
				}
				
				# Generate Api Output
				$ResultCode = $Output.ResultCode
				$ResultMessage = $Output.ResultMessage
				$VMName = $Output.VMName
				$ApiResponse = $Output.ApiResponse
				$TotalSeconds = $Output.TotalSeconds
				$StartTime = $Output.StartTime
				$FinishTime = $Output.FinishTime
				
				$Output = New-Object Psobject
				$Output | Add-Member Noteproperty VMName $VMName
				$Output | Add-Member Noteproperty ApiResponse $ApiResponse
				$Output | Add-Member Noteproperty RequestTime $RequestTime
				$Output | Add-Member Noteproperty JobID $JobID
				$Output | Add-Member Noteproperty TotalSeconds $TotalSeconds
				$Output | Add-Member Noteproperty StartTime $StartTime
				$Output | Add-Member Noteproperty FinishTime $FinishTime
				$ApiOutput = $Output | New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage -Details
				
				# Check Old Temp
				$OldTempPathTest = Test-Path $OldTempPath
				
				# Remove Old Temp
				if ($OldTempPathTest)
				{
					Remove-Item -Path $OldTempPath
				}
				
				# Generate Old Temp
				Add-Content -Path $OldTempPath -Value $ApiOutput -EA SilentlyContinue
				
				# Remove Temp
				Remove-Item -Path $TempPath
				
			} -ArgumentList $AsyncSetLinuxVMArgs

			# Generate Api Output
			$Output = New-Object Psobject
			$Output | Add-Member Noteproperty VMName $LinuxVMName
			$Output | Add-Member Noteproperty ApiResponse $ApiResponse
			$Output | Add-Member Noteproperty RequestTime $RequestTime
			$Output | Add-Member Noteproperty JobID $JobID
			$ApiOutput = $Output | New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage -Details
			
			# Remove Old Temp
			if ($OldTempPathTest)
			{
				Remove-Item -Path $OldTempPath
			}
				
			# Generate Old Temp
			Add-Content -Path $OldTempPath -Value $ApiOutput -EA SilentlyContinue
		}
		else
		{
			# Result Code
			$ResultCode = "1"
			$ApiResponse = "300"
			$ResultMessage = "Virtual machine is currently in another job."
			
			# Request Time
			$RequestTime = Get-Date
			
			# Get Job ID
			$JobID = Get-Content -Path $TempPath
			
			# Generate Api Output
			$Output = New-Object Psobject
			$Output | Add-Member Noteproperty VMName $LinuxVMName
			$Output | Add-Member Noteproperty ApiResponse $ApiResponse
			$Output | Add-Member Noteproperty RequestTime $RequestTime
			$Output | Add-Member Noteproperty JobID $JobID
			$ApiOutput = $Output | New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage -Details
		}
	}
	else
	{
		if ($OldTempPathTest)
		{
			$ApiOutput = Get-Content -Path $OldTempPath
		}
		else
		{
			$ResultCode = "0"
			$ApiResponse = "204"
			$ResultMessage = "There is no preparation job for this virtual machine."
			
			# Generate Api Output
			$Output = New-Object Psobject
			$Output | Add-Member Noteproperty VMName $LinuxVMName
			$Output | Add-Member Noteproperty ApiResponse $ApiResponse
			$Output | Add-Member Noteproperty RequestTime $RequestTime
			$ApiOutput = $Output | New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage -Details
		}
	}
}

# Generate Api Output
if (!$ApiOutput)
{
	# Generate Api Output
	$ApiOutput = New-Object Psobject
	$ApiOutput | Add-Member Noteproperty ApiResponse $ApiResponse
	$ApiOutput | Add-Member Noteproperty RequestTime $RequestTime
	$ApiOutput = $ApiOutput | New-XML -ResultCode $ResultCode -ResultMessage $ResultMessage -Details
}

if ($MimeType -eq "text/psxml")
{
@"
$($ApiOutput)
"@
}
else
{
@"
<script type="text/javascript">
window.location = "/"
</script>
"@
}

# Clear Variables
$RestAPIKey = $null;
$ApiOutput = $null;
