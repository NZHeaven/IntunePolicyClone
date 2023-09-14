function import-ADMX
{
<#
http://www.scconfigmgr.com/2019/01/17/use-intune-graph-api-export-and-import-intune-admx-templates/
Version 1.0 2019 Jan.17 First version
#>
	
	Param (
		
		[Parameter(Mandatory = $true)]
		[string]$ImportPath
		
	)
	
	####################################################
	
	

	####################################################
	
	Function New-GroupPolicyConfigurations()
	{
		
<#
.SYNOPSIS
This function is used to add an device configuration policy using the Graph API REST interface
.DESCRIPTION
The function connects to the Graph API Interface and adds a device configuration policy
.EXAMPLE
Add-DeviceConfigurationPolicy -JSON $JSON
Adds a device configuration policy in Intune
.NOTES
NAME: Add-DeviceConfigurationPolicy
#>
		
		[cmdletbinding()]
		param
		(
			$DisplayName
		)
		
		$jsonCode = @"
{
    "description":"",
    "displayName":"$($DisplayName)"
}
"@
		
		$graphApiVersion = "Beta"
		$DCP_resource = "deviceManagement/groupPolicyConfigurations"
		Write-Verbose "Resource: $DCP_resource"
		
		try
		{
			
			$uri = "https://graph.microsoft.com/$graphApiVersion/$($DCP_resource)"
			$responseBody = Invoke-RestMethod -Uri $uri -Headers $authToken -Method Post -Body $jsonCode -ContentType "application/json"
			
			
		}
		
		catch
		{
			
			$ex = $_.Exception
			$errorResponse = $ex.Response.GetResponseStream()
			$reader = New-Object System.IO.StreamReader($errorResponse)
			$reader.BaseStream.Position = 0
			$reader.DiscardBufferedData()
			$responseBody = $reader.ReadToEnd();
			Write-Host "Response content:`n$responseBody" -f Red
			Write-Error "Request to $Uri failed with HTTP Status $($ex.Response.StatusCode) $($ex.Response.StatusDescription)"
			write-host
			break
			
		}
		$responseBody.id
	}
	
	
	Function New-GroupPolicyConfigurationsDefinitionValues()
	{
		
    <#
    .SYNOPSIS
    This function is used to get device configuration policies from the Graph API REST interface
    .DESCRIPTION
    The function connects to the Graph API Interface and gets any device configuration policies
    .EXAMPLE
    Get-DeviceConfigurationPolicy
    Returns any device configuration policies configured in Intune
    .NOTES
    NAME: Get-GroupPolicyConfigurations
    #>
		
		[cmdletbinding()]
		Param (
			
			[string]$GroupPolicyConfigurationID,
			$JSON
			
		)
		
		$graphApiVersion = "Beta"
		
		$DCP_resource = "deviceManagement/groupPolicyConfigurations/$($GroupPolicyConfigurationID)/definitionValues"
		write-host $DCP_resource
		try
		{
			if ($JSON -eq "" -or $null -eq $JSON)
			{
				
				write-host "No JSON specified, please specify valid JSON for the Device Configuration Policy..." -f Red
				
			}
			
			else
			{
				
				Test-JSON -JSON $JSON
				
				$uri = "https://graph.microsoft.com/$graphApiVersion/$($DCP_resource)"
				Invoke-RestMethod -Uri $uri -Headers $authToken -Method Post -Body $JSON -ContentType "application/json"
			}
			
		}
		
		catch
		{
			
			$ex = $_.Exception
			$errorResponse = $ex.Response.GetResponseStream()
			$reader = New-Object System.IO.StreamReader($errorResponse)
			$reader.BaseStream.Position = 0
			$reader.DiscardBufferedData()
			$responseBody = $reader.ReadToEnd();
			Write-Host "Response content:`n$responseBody" -f Red
			Write-Error "Request to $Uri failed with HTTP Status $($ex.Response.StatusCode) $($ex.Response.StatusDescription)"
			write-host
			break
			
		}
		
	}
	
	####################################################
	
	#region Authentication
	
	write-host
	
	# Checking if authToken exists before running authentication
	if ($global:authToken)
	{
		
		# Setting DateTime to Universal time to work in all timezones
		$DateTime = (Get-Date).ToUniversalTime()
		
		# If the authToken exists checking when it expires
		$TokenExpires = ($authToken.ExpiresOn.datetime - $DateTime).Minutes
		
		if ($TokenExpires -le 0)
		{
			
			write-host "Authentication Token expired" $TokenExpires "minutes ago" -ForegroundColor Yellow
			write-host
			
			# Defining User Principal Name if not present
			
			if ($null -eq $User -or $User -eq "")
			{
				
				$User = Read-Host -Prompt "Please specify your user principal name for Azure Authentication"
				Write-Host
				
			}
			
			$global:authToken = Get-AuthToken -User $User
			
		}
	}
	
	# Authentication doesn't exist, calling Get-AuthToken function
	
	else
	{
		
		if ($null -eq $User -or $User -eq "")
		{
			
			$User = Read-Host -Prompt "Please specify your user principal name for Azure Authentication"
			Write-Host
			
		}
		
		# Getting the authorization token
		$global:authToken = Get-AuthToken -User $User
		
	}
	
	#endregion
	
	####################################################
	
	$ImportPath = $ImportPath.replace('"', '')
	
	if (!(Test-Path "$ImportPath"))
	{
		
		Write-Host "Import Path doesn't exist..." -ForegroundColor Red
		Write-Host "Script can't continue..." -ForegroundColor Red
		break
		
	}
	$PolicyName = (Get-Item $ImportPath).Name
	Write-Host "Adding ADMX Configuration Policy '$PolicyName'" -ForegroundColor Yellow
	$GroupPolicyConfigurationID = New-GroupPolicyConfigurations -DisplayName $PolicyName
	
	$JsonFiles = Get-ChildItem $ImportPath
	
	foreach ($JsonFile in $JsonFiles)
	{
		
		Write-Host "Adding ADMX Configuration setting $($JsonFile.Name)" -ForegroundColor Yellow
		$JSON_Data = Get-Content "$($JsonFile.FullName)"
		
		# Excluding entries that are not required - id,createdDateTime,lastModifiedDateTime,version
		$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id, createdDateTime, lastModifiedDateTime, version, supportsScopeTags
		$JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
		New-GroupPolicyConfigurationsDefinitionValues -JSON $JSON_Output -GroupPolicyConfigurationID $GroupPolicyConfigurationID
	}
}

function Import-ADMXConfigurationPolicies() {
	param(
		[Parameter(Mandatory=$true)]
		$FolderPath
	)
    $FolderPath = $FolderPath.replace('"', '')
    # If the directory path doesn't exist prompt user to create the directory
    
    if (!(Test-Path "$FolderPath"))
    {
        Write-Host "Path '$FolderPath' doesn't exist" -ForegroundColor Yellow
        break
    }
    
    Get-ChildItem "$FolderPath" | Where-Object { $_.PSIsContainer -eq $True } | ForEach-Object { 
		try {
			import-ADMX $_.FullName -ErrorAction Continue
		}
		catch {
			Write-Error "Error Importing ADMX Configuration Policy - Continuing"
		}	
		
	}
}

Export-ModuleMember -Function Import-ADMXConfigurationPolicies