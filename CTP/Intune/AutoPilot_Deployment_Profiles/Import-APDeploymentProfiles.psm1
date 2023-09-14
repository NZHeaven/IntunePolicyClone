Function Add-APDeploymentProfiles() {
    
    <#
    .SYNOPSIS
    This function is used to add a Auto Pilot Profile using the Graph API REST interface
    .DESCRIPTION
    The function connects to the Graph API Interface and adds a Auto Pilot profile
    .EXAMPLE
    Add-APDeploymentProfiles -JSON $JSON
    .NOTES
    NAME: Add-APDeploymentProfiles
    #>
    
    [cmdletbinding()]
    param
    (
        $JSON
    )
    
    $graphApiVersion = "Beta"
    $Resource = "/deviceManagement/windowsAutopilotDeploymentProfiles"
        
    try {
    
        if ($JSON -eq "" -or $null -eq $JSON) {
    
            write-host "No JSON specified, please specify valid JSON for the iOS Policy..." -f Red
    
        }
    
        else {
    
            Test-JSON -JSON $JSON
    
            $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
            Invoke-RestMethod -Uri $uri -Headers $authToken -Method Post -Body $JSON -ContentType "application/json"
    
        }
    
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
Function Import-APDeploymentProfiles() {
    param(
        [Parameter(Mandatory = $true)]
        $FolderPath    
    )
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
     
    ####################################################
    
    # Replacing quotes for Test-Path
    $FolderPath = $FolderPath.replace('"', '')
    
    if (!(Test-Path "$FolderPath")) {
    
        Write-Host "Import Path for Folder doesn't exist..." -ForegroundColor Red
        Write-Host "Script can't continue..." -ForegroundColor Red
        Write-Host
        break
    
    }
    
    Get-ChildItem $FolderPath -Filter *.json | ForEach-Object {
        try {
            $JSON_Data = Get-Content $_.FullName
            # Excluding entries that are not required - id,createdDateTime,lastModifiedDateTime,version
            $JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id, createdDateTime, lastModifiedDateTime, version
        
            $DisplayName = $JSON_Convert.displayName
        
            $JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
        
            # Adding Scheduled Actions Rule to JSON
            $scheduledActionsForRule = '"scheduledActionsForRule":[{"ruleName":"PasswordRequired","scheduledActionConfigurations":[{"actionType":"block","gracePeriodHours":0,"notificationTemplateId":"","notificationMessageCCList":[]}]}]'        
        
            $JSON_Output = $JSON_Output.trimend("}")
        
            $JSON_Output = $JSON_Output.TrimEnd() + "," + "`r`n"
        
            # Joining the JSON together
            $JSON_Output = $JSON_Output + $scheduledActionsForRule + "`r`n" + "}"
                    
            write-host
            write-host "Autopilot Profile '$DisplayName' Found..." -ForegroundColor Yellow
            write-host
            $JSON_Output
            write-host
            Write-Host "Adding Autopilot Profile '$DisplayName'" -ForegroundColor Yellow
            Add-APDeploymentProfiles -JSON $JSON_Output
        }
        catch {
            Write-Error "Error Importing Autopilot Profile '$DisplayName' - Continuing"
        }
    }
}

Export-ModuleMember -Function Import-APDeploymentProfiles