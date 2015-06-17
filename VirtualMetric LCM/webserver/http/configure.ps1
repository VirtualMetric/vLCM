# Copyright (C) 2015 VirtualMetric
# This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

# SetLinuxVM VM hosts config
$VMHostsConfig = "$HomeDirectory\config\vmhosts.config"
$VMHostsList = Get-Content -Path $VMHostsConfig
$HostCount = 1;

# Get values
$VMNameRequest = $PoSHQuery.VMName
$VMHostRequest = $PoSHQuery.VMHost
$NewRestAPIRequest = $PoSHQuery.Key

# RestAPI key
$RestAPIKeyConfig = "$HomeDirectory\config\restapikey.config"
$RestAPIKeyValue = Get-Content -Path $RestAPIKeyConfig

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

if (!$VMNameRequest -or !$VMHostRequest)
{
@"
<script type="text/javascript">
window.location = "/"
</script>
"@
}

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
          <a href="#restapikey"  class="modal">
            <span class="icon32 key"></span>
            RestAPI Key
          </a>
        </li>
      </ul>
    </nav>
	 
    <section id="maincontainer">
      <div id="main" class="container_12">
      
        <div class="box">
          <div class="box-header">
            <h1>Virtual Machine: $($VMNameRequest)</h1>

            <ul>
              <li class="active"><a href="#one">Configuration</a></li>
            </ul>
          </div>

          <div class="box-content">
            <div class="tab-content" id="one">

              <form action="api/Set-LinuxVM.ps1" method="post">

                <div class="column-left">
					
				  <p>
                    <strong>Credentials:</strong>
                  </p>
				
                  <p>
                    <input type="text" name="username" id="username" placeholder="Username" class="{validate:{required:true, minlength:3}}" />
                  </p>

                  <p>
                    <input type="password" name="password" id="password" placeholder="Password" class="{validate:{required:true, minlength:6}}" />
                  </p>

                  <p>
                    <input type="password" name="password_confirmfeef" id="password_confirm" placeholder="Confirm Password" class="{validate:{equalTo: '#password'}}" />
                  </p>
				  		  
				  <p>
                    <strong>Name:</strong> <input type="text" name="vmname" id="vmname" placeholder="VM Name" class="{validate:{required:true}}" value="$($VMNameRequest)" />
                  </p>
				  
				  <p>
                    <strong>Host:</strong> <input type="text" name="vmhost" id="vmhost" placeholder="VM Host" class="{validate:{required:true}}" value="$($VMHostRequest)" />
                  </p>

                  <p>
                    <strong>REST Key:</strong> <input type="text" name="restapikey" id="restapi" placeholder="REST Key" class="{validate:{required:true}}" value="$($RestAPIKeyValue)" />
                  </p>

                </div>

                <div class="column-right">
				  <p>
                    <strong>Customization:</strong>
                  </p>
				
				  <p>
                    <input type="text" name="hostname" id="hostname" placeholder="Hostname" />
                  </p>
				  
				  <p>
                    <input type="password" name="newpassword" id="newpassword" placeholder="New Password" class="{validate:{minlength:6}}" />
                  </p>

                  <p>
                    <input type="password" name="newpassword_confirmfeef" id="newpassword_confirm" placeholder="Confirm New Password" class="{validate:{equalTo: '#newpassword'}}" />
                  </p>
				  
				  <div class="column-left">
   				  <p>
                    <strong>IP Address:</strong> <input type="text" name="ipaddress" id="ipaddress" placeholder="IP Address" />
                  </p>
				  
				  <p>
                    <strong>Gateway Address:</strong> <input type="text" name="gatewayaddress" id="gatewayaddress" placeholder="Gateway Address" />
                  </p>
				  </div>
				  
				  <div class="column-right">
				  <p>
                    <strong>Subnet Address:</strong> <input type="text" name="subnetaddress" id="subnetaddress" placeholder="Subnet Address" />
                  </p>
				  
				  <p>
                    <strong>DNS Address:</strong> <input type="text" name="dnsaddress" id="dnsaddress" placeholder="DNS Server" />
                  </p>
				  </div>
				  
				  <p>
					<strong>Advanced Options:</strong>
				  <div class="column-left">
                    <p>
                      <input type="checkbox" name="InstallLIC" id="option1" />
                      <label for="option1">Install Linux Integration Services</label>
                    </p>
                  </div>

                  <div class="column-right">
                    <p>
                      <input type="checkbox" name="ExtendLVM" id="option2" />
                      <label for="option2">Extend Logical Volume</label>
                    </p>
                  </div>
				  </p>
                </div>
				
				<input type="hidden" name="jobtype" id="jobtype" value="new" />
				
                <div class="clear"></div>

                <div class="action_bar">
                  <input type="submit" class="button blue" value="Provision" />
                  <a href="#modal" class="modal button">Cancel</a>
                </div>

              </form>

            </div>
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
"@
