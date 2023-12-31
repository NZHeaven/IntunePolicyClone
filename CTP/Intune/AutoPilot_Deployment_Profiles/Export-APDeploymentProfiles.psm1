Function Get-APDeploymentProfiles() {
    <#
    .SYNOPSIS
    This function is used to get Autopilot Deployment Profiles
    .DESCRIPTION
    This function is used to get Autopilot Deployment Profiles
    .EXAMPLE
    Get-APDeploymentProfile
    Returns any Autopilot Deployment Profiles configured in Intune
    .NOTES
    NAME: Get-APDeploymentProfile
    #>
    $graphApiVersion = "Beta"
    $Resource = "deviceManagement/windowsAutopilotDeploymentProfiles"
        
    try {  
        $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
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
Function Export-JSONData() {
    
    <#
    .SYNOPSIS
    This function is used to export JSON data returned from Graph
    .DESCRIPTION
    This function is used to export JSON data returned from Graph
    .EXAMPLE
    Export-JSONData -JSON $JSON
    Export the JSON inputted on the function
    .NOTES
    NAME: Export-JSONData
    #>
    
    param (
    
        $JSON,
        $ExportPath
    
    )
    
    try {
    
        if ($JSON -eq "" -or $null -eq $JSON) {
    
            write-host "No JSON specified, please specify valid JSON..." -f Red
    
        }
    
        elseif (!$ExportPath) {
    
            write-host "No export path parameter set, please provide a path to export the file" -f Red
    
        }
    
        elseif (!(Test-Path $ExportPath)) {
    
            write-host "$ExportPath doesn't exist, can't export JSON Data" -f Red
    
        }
    
        else {
    
            $JSON1 = ConvertTo-Json $JSON -Depth 5
    
            $JSON_Convert = $JSON1 | ConvertFrom-Json
    
            $displayName = $JSON_Convert.displayName
    
            # Updating display name to follow file naming conventions - https://msdn.microsoft.com/en-us/library/windows/desktop/aa365247%28v=vs.85%29.aspx
            $DisplayName = $DisplayName -replace '\<|\>|:|"|/|\\|\||\?|\*', "_"
    
            $Properties = ($JSON_Convert | Get-Member | Where-Object { $_.MemberType -eq "NoteProperty" }).Name
    
            $FileName_JSON = "$DisplayName" + "_" + $(get-date -f dd-MM-yyyy-H-mm-ss) + ".json"
    
            $Object = New-Object System.Object
    
            foreach ($Property in $Properties) {
    
                $Object | Add-Member -MemberType NoteProperty -Name $Property -Value $JSON_Convert.$Property
    
            }
    
            write-host "Export Path:" "$ExportPath"
    
            $JSON1 | Set-Content -LiteralPath "$ExportPath\$FileName_JSON"
            write-host "JSON created in $ExportPath\$FileName_JSON..." -ForegroundColor cyan
                
        }
    
    }
    
    catch {
    
        $_.Exception
    
    }
    
}
    
####################################################
    
Function Export-APDeploymentProfiles() {
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

    #endregion

    ####################################################
    # If the directory path doesn't exist prompt user to create the directory
    $FolderPath = $FolderPath.replace('"', '')

    if (!(Test-Path "$FolderPath")) {

        Write-Host
        Write-Host "Path $Folderpath doesn't exist, do you want to create this directory? Y or N?" -ForegroundColor Yellow

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

    Write-Host

    ####################################################

    $APs = Get-APDeploymentProfiles

    foreach ($AP in $APs) {
        write-host "Device Compliance Policy:"$AP.displayName -f Yellow
        Export-JSONData -JSON $AP -ExportPath "$FolderPath"
        Write-Host
    }
}

Export-ModuleMember -function Export-APDeploymentProfiles