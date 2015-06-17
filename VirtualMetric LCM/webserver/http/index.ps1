# Copyright (C) 2015 VirtualMetric
# This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

# SetLinuxVM VM hosts config
$VMHostsConfig = "$HomeDirectory\config\vmhosts.config"
$VMHostsList = Get-Content -Path $VMHostsConfig
$HostCount = 1;

# Get values
$VMHostRequest = $PoSHQuery.VMHost
$AddHostRequest = $PoSHQuery.Add
$NewRestAPIRequest = $PoSHQuery.Key
$RefreshHostRequest = $PoSHQuery.Refresh

# RestAPI key
$RestAPIKeyConfig = "$HomeDirectory\config\restapikey.config"
$RestAPIKeyValue = Get-Content -Path $RestAPIKeyConfig

# Refresh SetLinuxVM temp
if ($RefreshHostRequest)
{
	$TempPath = "$HomeDirectory\temp\Search-LinuxVM.$RefreshHostRequest.xml"
	$TestTempPath = Test-Path -Path $TempPath
	if ($TestTempPath)
	{
		Remove-Item -Path $TempPath
	}
@"
<script type="text/javascript">
window.location = "?VMHost=$($RefreshHostRequest)"
</script>
"@
}

# Generate new RestAPI key
if ($NewRestAPIRequest)
{
	$TestRestAPIPath = Test-Path -Path $RestAPIKeyConfig
	if ($TestRestAPIPath)
	{
		Remove-Item -Path $RestAPIKeyConfig
	}
	$NewAPIKey = Get-Random
	Add-Content -Path $RestAPIKeyConfig -Value $NewAPIKey
@"
<script type="text/javascript">
window.location = "/"
</script>
"@
}

# Add new host
if ($AddHostRequest)
{
	try
	{
		$VMManager = Test-WmiObject -NameSpace "root\virtualization" -WmiHost $AddHostRequest
	}
	catch
	{
		$_
	}
	if ($VMManager.ResultCode -eq "1")
	{
		$HostStatus = "NotExist";
		foreach ($VMHost in $VMHostsList)
		{
			if ($VMHost -eq $AddHostRequest)
			{
				$HostStatus = "AlreadyExist";
			}
		}
		if ($HostStatus -eq "NotExist")
		{
			Add-Content -Path $VMHostsConfig -Value $AddHostRequest
		}
	}
@"
<script type="text/javascript">
window.location = "/"
</script>
"@
}

# Get active task information
$RunningTasks = @(Get-Item -Path "$HomeDirectory\temp\Set-LinuxVM.*.xml")
$RunningTaskCount = $RunningTasks.Count

@"
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    <meta name="viewport" content="width=1024px, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    
    <title>SetLinuxVM v5 Web Access</title>
    
    <!-- Stylesheets -->
    <link rel="stylesheet" href="theme/css/reset.css" />
    <link rel="stylesheet" href="theme/css/icons.css" />
    <link rel="stylesheet" href="theme/css/formalize.css" />
    <link rel="stylesheet" href="theme/css/checkboxes.css" />
    <link rel="stylesheet" href="theme/css/sourcerer.css" />
    <link rel="stylesheet" href="theme/css/jqueryui.css" />
    <link rel="stylesheet" href="theme/css/tipsy.css" />
    <link rel="stylesheet" href="theme/css/calendar.css" />
    <link rel="stylesheet" href="theme/css/tags.css" />
    <link rel="stylesheet" href="theme/css/selectboxes.css" />
    <link rel="stylesheet" href="theme/css/960.css" />
    <link rel="stylesheet" href="theme/css/main.css" />
    <link rel="stylesheet" media="all and (orientation:portrait)" href="theme/css/portrait.css" />
    <link rel="apple-touch-icon" href="theme/apple-touch-icon-precomposed.png" />
    <link rel="shortcut icon" href="theme/favicon.ico" type="image/x-icon" />
    
    <!--[if lt IE 9]>
    <script src="theme/js/html5shiv.js"></script>
    <script src="theme/js/excanvas.js"></script>
    <![endif]-->
    
    <!-- JavaScript -->
    <script src="theme/js/jquery.min.js"></script>
    <script src="theme/js/jqueryui.min.js"></script>
    <script src="theme/js/jquery.cookies.js"></script>
    <script src="theme/js/jquery.pjax.js"></script>
    <script src="theme/js/formalize.min.js"></script>
    <script src="theme/js/jquery.metadata.js"></script>
    <script src="theme/js/jquery.validate.js"></script>
    <script src="theme/js/jquery.checkboxes.js"></script>
    <script src="theme/js/jquery.chosen.js"></script>
    <script src="theme/js/jquery.fileinput.js"></script>
    <script src="theme/js/jquery.datatables.js"></script>
    <script src="theme/js/jquery.sourcerer.js"></script>
    <script src="theme/js/jquery.tipsy.js"></script>
    <script src="theme/js/jquery.calendar.js"></script>
    <script src="theme/js/jquery.inputtags.min.js"></script>
    <script src="theme/js/jquery.wymeditor.js"></script>
    <script src="theme/js/jquery.livequery.js"></script>
    <script src="theme/js/jquery.flot.min.js"></script>
    <script src="theme/js/application.js"></script>
	
	<script language="javascript" type="text/javascript">
	`$(window).load(function() {
    `$('#loading').hide();
	});
	</script>	
	
  </head>
  
  <body>
  
  <div id="loading">
	<div style="margin-top: 20%">L o a d i n g  . .</div>
  </div>

    <!-- Primary navigation -->
    <nav id="primary">
      <ul>
        <li class="active">
          <a href="index.ps1">
            <span class="icon32 cloud"></span>
            Virtual Machines
          </a>
        </li>
        <li>
          <a href="#restapikey" class="modal">
            <span class="icon32 key"></span>
            RestAPI Key
          </a>
        </li>
      </ul>
    </nav>
	
	<!-- Secondary navigation -->
    <nav id="secondary">
"@
if ($VMHostRequest -eq $null)
{
@"  
	<ul>
		$(foreach ($VMHost in $VMHostsList) 
		{
			if ($HostCount -eq "1")
			{
				$MainVMHost = $VMHost
				$licontent = '<li class="active"><a href="?VMHost=' + $VMHost + '">' + $VMHost + '</a></li>'
			}
			else
			{
				$licontent = '<li><a href="?VMHost=' + $VMHost + '">' + $VMHost + '</a></li>'
			}
			$licontent
			$HostCount = $HostCount + 1;
		})
        <li><a href="#addnewhost" class="modal">+ ADD NEW HOST</a></li>
      </ul>
      
      <div id="notifications">
        <ul>
        </ul>
      </div>
    </nav>
	   
    <section id="maincontainer">
		
    <div id="main">
	
		<div class="quick-actions">
			<a href="index.ps1?Refresh=$($MainVMHost)">
				<span class="icon32 refresh"></span>
				refresh host
			</a>
			<a href="#runningtasks" class="modal">
				<span class="icon32 flag"></span>
				running tasks
			</a>
		</div>
		
		<script type="text/javascript">
		`$(function() {
			`$.ajax({
				type: "GET",
				url: "api/Search-LinuxVM.psxml?RestAPIKey=$($RestAPIKeyValue)&VMHost=$($MainVMHost)",
				contentType: "text/html; charset=utf-8",
				dataType: "xml",
				cache: false,
				processData: false,
				success: function(data, status, xhr) {
					var tableRows = '';
					`$(xhr.responseText).find("OperationResult").each(function(){
						tableRows += '<tr><td>' + `$(this).find("VMName").text() + '</td><td>' + `$(this).find("Hostname").text() + '</td><td>' + `$(this).find("OSName").text() + '</td><td>' + `$(this).find("OSVersion").text() + '</td><td>' + `$(this).find("ProcessorArchitecture").text() + '</td><td>' + `$(this).find("IntegrationServicesVersion").text() + '</td><td><a href="configure.ps1?VMName=' + `$(this).find("VMName").text() + '&VMHost=$($MainVMHost)">Configure</a></td></tr>';
					});
					`$("#getLinuxVMs tbody").html(tableRows);
					`$('#getLinuxVMs').dataTable( {
						"sPaginationType": "full_numbers"
					});
					
					`$('.dataTables_wrapper').each(function() {
						var table = `$(this);
						var table = `$(this);
						var info = table.find('.dataTables_info');
						var paginate = table.find('.dataTables_paginate');
			
						table.find('.datatable').after('<div class="action_bar nomargin"></div>');
						table.find('.action_bar').prepend(info).append(paginate);
					});
				}
			});
		});
		</script>
        <div class="box">
          <div class="box-header">
            <h1>List of running Linux virtual machines</h1>
          </div>
          <table class="datatable" id="getLinuxVMs">
            <thead>
              <tr>
                <th>VM Name</th>
				<th>Hostname</th>
                <th>OS Name</th>
                <th>OS Version</th>
				<th>Processor Architecture</th>
				<th>LIS Version</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
            </tbody>
          </table>
        </div>
      
      </div>
    </section>
  </body>
</html>
"@
}
else
{
@"  
	<ul>
		$(foreach ($VMHost in $VMHostsList) 
		{ 
			if ($VMHostRequest -eq $VMHost)
			{
				$MainVMHost = $VMHost
				$licontent = '<li class="active"><a href="?VMHost=' + $VMHost + '">' + $VMHost + '</a></li>'
			}
			else
			{
				$licontent = '<li><a href="?VMHost=' + $VMHost + '">' + $VMHost + '</a></li>'
			}
			$licontent
		})
        <li><a href="#addnewhost" class="modal">+ ADD NEW HOST</a></li>
      </ul>
      
      <div id="notifications">
        <ul>
        </ul>
      </div>
    </nav>
     
    <section id="maincontainer">
	
    <div id="main">
	  
	  	<div class="quick-actions">
			<a href="index.ps1?Refresh=$($MainVMHost)">
				<span class="icon32 refresh"></span>
				refresh host
			</a>
			<a href="#runningtasks" class="modal">
				<span class="icon32 flag"></span>
				running tasks
			</a>
		</div>

		<script type="text/javascript">
		`$(function() {
			`$.ajax({
				type: "GET",
				url: "api/Search-LinuxVM.psxml?RestAPIKey=$($RestAPIKeyValue)&VMHost=$($MainVMHost)",
				contentType: "text/html; charset=utf-8",
				dataType: "xml",
				cache: false,
				processData: false,
				success: function(data, status, xhr) {
					var tableRows = '';
					`$(xhr.responseText).find("OperationResult").each(function(){
						tableRows += '<tr><td>' + `$(this).find("VMName").text() + '</td><td>' + `$(this).find("Hostname").text() + '</td><td>' + `$(this).find("OSName").text() + '</td><td>' + `$(this).find("OSVersion").text() + '</td><td>' + `$(this).find("ProcessorArchitecture").text() + '</td><td>' + `$(this).find("IntegrationServicesVersion").text() + '</td><td><a href="configure.ps1?VMName=' + `$(this).find("VMName").text() + '&VMHost=$($MainVMHost)">Configure</a></td></tr>';
					});
					`$("#getLinuxVMs tbody").html(tableRows);
					`$('#getLinuxVMs').dataTable( {
						"sPaginationType": "full_numbers"
					});
					
					`$('.dataTables_wrapper').each(function() {
						var table = `$(this);
						var table = `$(this);
						var info = table.find('.dataTables_info');
						var paginate = table.find('.dataTables_paginate');
			
						table.find('.datatable').after('<div class="action_bar nomargin"></div>');
						table.find('.action_bar').prepend(info).append(paginate);
					});
				}
			});
		});
		</script>
        <div class="box">
          <div class="box-header">
            <h1>List of running Linux virtual machines</h1>
          </div>
          <table class="datatable" id="getLinuxVMs">
            <thead>
              <tr>
                <th>VM Name</th>
				<th>Hostname</th>
                <th>OS Name</th>
                <th>OS Version</th>
				<th>Processor Architecture</th>
				<th>LIS Version</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
            </tbody>
          </table>
        </div>
      
      </div>
    </section>
  </body>
</html>
"@
}

@"
<div id="addnewhost" class="box">
  <div class="box-header">
    <h1>Add New Host</h1>
  </div>
  
  <div class="box-content">
    <form method="get">
      <p>
        <input type="text" name="Add" id="title" placeholder="Hostname" />
      </p>
	  
      <div class="action_bar">
        <input type="submit" class="button blue" value="Add" />
        <a href="#" class="close button">Cancel</a>
      </div>
    </form>
  </div>
</div>

<div id="restapikey" class="box">
  <div class="box-header">
    <h1>RestAPI Key Generation</h1>
  </div>
  
  <div class="box-content">
    <form method="get">
      <p>
        <input type="text" name="Key" id="title" placeholder="RestAPI Key" value="$($RestAPIKeyValue)" />
      </p>
	  
      <div class="action_bar">
        <input type="submit" class="button blue" value="Generate New" />
        <a href="#" class="close button">Cancel</a>
      </div>
    </form>
  </div>
</div>

<div id="runningtasks" class="box">
  <div class="box-header">
    <h1>Running Tasks</h1>
  </div>
  
  <div class="box-content">
    <p>Currently running tasks: $($RunningTaskCount)</p>

		$(foreach ($RunningTask in $RunningTasks) 
		{ 
			$taskcontent = '<p><li>' + $RunningTask + '</li></p>'
			$taskcontent = $taskcontent.Replace("Set-LinuxVM.","+")
			$taskcontent = $taskcontent.Split("+")[1]
			$taskcontent = $taskcontent.Replace(".xml","")
			$taskcontent = '<p><li>' + $taskcontent + '</li></p>'
			$taskcontent
		})
        <div class="action_bar">
        <a href="#" class="close button blue">Close</a>
      </div>
  </div>
</div>
"@
