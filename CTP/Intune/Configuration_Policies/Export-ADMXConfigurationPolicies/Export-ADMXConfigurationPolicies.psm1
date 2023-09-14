Function Get-GroupPolicyConfigurations() {	
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
	
    $graphApiVersion = "Beta"
    $DCP_resource = "deviceManagement/groupPolicyConfigurations"
	
    try {
		
        $uri = "https://graph.microsoft.com/$graphApiVersion/$($DCP_resource)"
		(Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).Value
		
    }
	
    catch {
		
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
Function Get-GroupPolicyConfigurationsDefinitionValues() {
	
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
		
        [Parameter(Mandatory = $true)]
        [string]$GroupPolicyConfigurationID
		
    )
	
    $graphApiVersion = "Beta"
    #$DCP_resource = "deviceManagement/groupPolicyConfigurations/$GroupPolicyConfigurationID/definitionValues?`$filter=enabled eq true"
    $DCP_resource = "deviceManagement/groupPolicyConfigurations/$GroupPolicyConfigurationID/definitionValues"
	
	
    try {
		
        $uri = "https://graph.microsoft.com/$graphApiVersion/$($DCP_resource)"
		(Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).Value
		
    }
	
    catch {
		
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
Function Get-GroupPolicyConfigurationsDefinitionValuesPresentationValues() {
	
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
		
        [Parameter(Mandatory = $true)]
        [string]$GroupPolicyConfigurationID,
        [string]$GroupPolicyConfigurationsDefinitionValueID
		
    )
    $graphApiVersion = "Beta"
	
    $DCP_resource = "deviceManagement/groupPolicyConfigurations/$GroupPolicyConfigurationID/definitionValues/$GroupPolicyConfigurationsDefinitionValueID/presentationValues"
	
    try {
		
        $uri = "https://graph.microsoft.com/$graphApiVersion/$($DCP_resource)"
		(Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).Value
		
    }
	
    catch {
		
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
Function Get-GroupPolicyConfigurationsDefinitionValuesdefinition () {
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
		
        [Parameter(Mandatory = $true)]
        [string]$GroupPolicyConfigurationID,
        [Parameter(Mandatory = $true)]
        [string]$GroupPolicyConfigurationsDefinitionValueID
		
    )
    $graphApiVersion = "Beta"
    $DCP_resource = "deviceManagement/groupPolicyConfigurations/$GroupPolicyConfigurationID/definitionValues/$GroupPolicyConfigurationsDefinitionValueID/definition"
	
    try {
		
        $uri = "https://graph.microsoft.com/$graphApiVersion/$($DCP_resource)"
		
        $responseBody = Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get
		
		
    }
	
    catch {
		
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
    $responseBody
}

####################################################
Function Get-GroupPolicyDefinitionsPresentations () {
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
		
		
        [Parameter(Mandatory = $true)]
        [string]$groupPolicyDefinitionsID,
        [Parameter(Mandatory = $true)]
        [string]$GroupPolicyConfigurationsDefinitionValueID
		
    )
    $graphApiVersion = "Beta"
    $DCP_resource = "deviceManagement/groupPolicyConfigurations/$groupPolicyDefinitionsID/definitionValues/$GroupPolicyConfigurationsDefinitionValueID/presentationValues?`$expand=presentation"
    try {
		
        $uri = "https://graph.microsoft.com/$graphApiVersion/$($DCP_resource)"
		
		(Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get).Value.presentation
		
		
    }
	
    catch {
		
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
Function Export-ADMXConfigurationPolicies() {
    param(
        [Parameter(Mandatory=$true)]
        $FolderPath
    )
<#
.SYNOPSIS
This function is used to get device ADMX configuration policies from the Graph API REST interface
.DESCRIPTION
The function connects to the Graph API Interface and gets any device configuration policies
.EXAMPLE
Export-ADMXConfigurationPolicies
Returns any device configuration policies configured in Intune
.NOTES
NAME: Export-ADMXConfigurationPolicies
#>
    # Checking if authToken exists before running authentication
    if ($global:authToken) {
	
        # Setting DateTime to Universal time to work in all timezones
        $DateTime = (Get-Date).ToUniversalTime()
	
        # If the authToken exists checking when it expires
        $TokenExpires = ($authToken.ExpiresOn.datetime - $DateTime).Minutes
	
        if ($TokenExpires -le 0) {
		
            write-host "Authentication Token expired" $TokenExpires "minutes ago" -ForegroundColor Yellow
            write-host
		
            # Defining User Principal Name if not present
		
            if ($null -eq $User -or $User -eq "") {
			
                $User = Read-Host -Prompt "Please specify your user principal name for Azure Authentication"
                Write-Host
			
            }
		
            $global:authToken = Get-AuthToken -User $User
		
        }
    }

    # Authentication doesn't exist, calling Get-AuthToken function

    else {
	
        if ($null -eq $User -or $User -eq "") {
		
            $User = Read-Host -Prompt "Please specify your user principal name for Azure Authentication"
            Write-Host
		
        }
	
        # Getting the authorization token
        $global:authToken = Get-AuthToken -User $User
	
    }

    #endregion

    ####################################################


    # If the directory path doesn't exist prompt user to create the directory
    $FolderPath = $FolderPath.replace('"', '')

    if (!(Test-Path "$FolderPath")) {
	
        Write-Host
        Write-Host "Path '$FolderPath' doesn't exist, do you want to create this directory? Y or N?" -ForegroundColor Yellow
	
        $Confirm = read-host
	
        if ($Confirm -eq "y" -or $Confirm -eq "Y") {
		
            new-item -ItemType Directory -Path "$FolderPath" | Out-Null
            Write-Host
		
        }
	
        else {
		
            Write-Host "Creation of directory path was cancelled..." -ForegroundColor Red
            Write-Host
            break
		
        }
	
    }

    ####################################################

    Write-Host

    $DCPs = Get-GroupPolicyConfigurations

    foreach ($DCP in $DCPs) {
        $FolderName = $($DCP.displayName) -replace '\<|\>|:|"|/|\\|\||\?|\*', "_"
        New-Item "$FolderPath\$($FolderName)" -ItemType Directory -Force
	
        $GroupPolicyConfigurationsDefinitionValues = Get-GroupPolicyConfigurationsDefinitionValues -GroupPolicyConfigurationID $DCP.id
        foreach ($GroupPolicyConfigurationsDefinitionValue in $GroupPolicyConfigurationsDefinitionValues) {
            $GroupPolicyConfigurationsDefinitionValue
            $DefinitionValuedefinition = Get-GroupPolicyConfigurationsDefinitionValuesdefinition -GroupPolicyConfigurationID $DCP.id -GroupPolicyConfigurationsDefinitionValueID $GroupPolicyConfigurationsDefinitionValue.id
            $DefinitionValuedefinitionID = $DefinitionValuedefinition.id
            $DefinitionValuedefinitionDisplayName = $DefinitionValuedefinition.displayName
            $GroupPolicyDefinitionsPresentations = Get-GroupPolicyDefinitionsPresentations -groupPolicyDefinitionsID $DCP.id -GroupPolicyConfigurationsDefinitionValueID $GroupPolicyConfigurationsDefinitionValue.id
            $DefinitionValuePresentationValues = Get-GroupPolicyConfigurationsDefinitionValuesPresentationValues -GroupPolicyConfigurationID $DCP.id -GroupPolicyConfigurationsDefinitionValueID $GroupPolicyConfigurationsDefinitionValue.id
            $OutDef = New-Object -TypeName PSCustomObject
            $OutDef | Add-Member -MemberType NoteProperty -Name "definition@odata.bind" -Value "https://graph.microsoft.com/beta/deviceManagement/groupPolicyDefinitions('$definitionValuedefinitionID')"
            $OutDef | Add-Member -MemberType NoteProperty -Name "enabled" -value $($GroupPolicyConfigurationsDefinitionValue.enabled.tostring().tolower())
            if ($DefinitionValuePresentationValues) {
                $i = 0
                $PresValues = @()
                foreach ($Pres in $DefinitionValuePresentationValues) {
                    $P = $pres | Select-Object -Property * -ExcludeProperty id, createdDateTime, lastModifiedDateTime, version
                    $GPDPID = $groupPolicyDefinitionsPresentations[$i].id
                    $P | Add-Member -MemberType NoteProperty -Name "presentation@odata.bind" -Value "https://graph.microsoft.com/beta/deviceManagement/groupPolicyDefinitions('$definitionValuedefinitionID')/presentations('$GPDPID')"
                    $PresValues += $P
                    $i++
                }
                $OutDef | Add-Member -MemberType NoteProperty -Name "presentationValues" -Value $PresValues
            }
            $FileName = (Join-Path $DefinitionValuedefinition.categoryPath $($definitionValuedefinitionDisplayName)) -replace '\<|\>|:|"|/|\\|\||\?|\*', "_"
            $OutDefjson = ($OutDef | ConvertTo-Json -Depth 10).replace("\u0027", "'")
            $OutDefjson | Out-File -FilePath "$FolderPath\$($folderName)\$fileName.json" -Encoding ascii
        }
    }

    Write-Host
}

Export-ModuleMember -Function Export-ADMXConfigurationPolicies