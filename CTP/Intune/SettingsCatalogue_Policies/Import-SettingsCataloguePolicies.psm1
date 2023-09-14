Function Add-SettingsCatalogPolicy() {
    
    <#
    .SYNOPSIS
    This function is used to add a Settings Catalog policy using the Graph API REST interface
    .DESCRIPTION
    The function connects to the Graph API Interface and adds a Settings Catalog policy
    .EXAMPLE
    Add-SettingsCatalogPolicy -JSON $JSON
    Adds a Settings Catalog policy in Endpoint Manager
    .NOTES
    NAME: Add-SettingsCatalogPolicy
    #>
    
    [cmdletbinding()]
    
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $JSON
    )
    
    $graphApiVersion = "Beta"
    $Resource = "deviceManagement/configurationPolicies"
    
    try {
    
        if ($JSON -eq "" -or $JSON -eq $null) {
    
            write-host "No JSON specified, please specify valid JSON for the Endpoint Security Disk Encryption Policy..." -f Red
    
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
    
Function Test-JSON() {
    
    <#
    .SYNOPSIS
    This function is used to test if the JSON passed to a REST Post request is valid
    .DESCRIPTION
    The function tests if the JSON passed to the REST Post is valid
    .EXAMPLE
    Test-JSON -JSON $JSON
    Test if the JSON is valid before calling the Graph REST interface
    .NOTES
    NAME: Test-AuthHeader
    #>
    
    param (
    
        $JSON
    
    )
    
    try {
    
        $TestJSON = ConvertFrom-Json $JSON -ErrorAction Stop
        $validJson = $true
    
    }
    
    catch {
    
        $validJson = $false
        $_.Exception
    
    }
    
    if (!$validJson) {
        
        Write-Host "Provided JSON isn't in valid JSON format" -f Red
        break
    
    }
    
}
    
####################################################
    
Function Import-SettingsCataloguePolicies() {
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
    
            if ($User -eq $null -or $User -eq "") {
    
                $User = Read-Host -Prompt "Please specify your user principal name for Azure Authentication"
                Write-Host
    
            }
    
            $global:authToken = Get-AuthToken -User $User
    
        }
    }
    
    # Authentication doesn't exist, calling Get-AuthToken function
    
    else {
    
        if ($User -eq $null -or $User -eq "") {
    
            $User = Read-Host -Prompt "Please specify your user principal name for Azure Authentication"
            Write-Host
    
        }
    
        # Getting the authorization token
        $global:authToken = Get-AuthToken -User $User
    
    }
    
    #endregion
    
    ####################################################
    
    # Replacing quotes for Test-Path
    $FolderPath = $FolderPath.replace('"', '')
    
    if (!(Test-Path "$FolderPath")) {
    
        Write-Host "Import Path for JSON file doesn't exist..." -ForegroundColor Red
        Write-Host "Script can't continue..." -ForegroundColor Red
        Write-Host
        break
    
    }
    
    ####################################################
    
    Get-ChildItem $FolderPath -Filter *.json | ForEach-Object {
        $JSON_Data = get-content $_.FullName
    
        # Excluding entries that are not required - id,createdDateTime,lastModifiedDateTime,version
        $JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id, createdDateTime, lastModifiedDateTime, version, supportsScopeTags
        
        $DisplayName = $JSON_Convert.name
        
        $JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 20
                    
        write-host
        write-host "Settings Catalog Policy '$DisplayName' Found..." -ForegroundColor Yellow
        write-host
        $JSON_Output
        write-host
        Write-Host "Adding Settings Catalog Policy '$DisplayName'" -ForegroundColor Yellow
        Add-SettingsCatalogPolicy -JSON $JSON_Output
    }

}

Export-ModuleMember Import-SettingsCataloguePolicies