function Add-StandardCARules() {
    param(
        [Parameter(Mandatory = $true)]
        $Exclude_Group_ID,
        $Hybrid = $false,
        $Include_Group_ID
    )
    Set-Variable -Name Exclude_Group_ID -scope Global -Value $Exclude_Group_ID
    Set-Variable -Name Include_Group_ID -scope Global -Value $Include_Group_ID
    Connect-MgGraph -Scopes "Policy.Read.All","Policy.ReadWrite.ConditionalAccess"

    #Create MFA Policies, !Order is important!
    Create_NZ_Location
    Create_Policy_Block_Access_Outside_NZ
    Create_Policy_Access_No_MFA_Complient_Devices -Hybrid $Hybrid
    Create_Policy_Access_With_MFA_Non_Complient_Devices -Hybrid $Hybrid
    Create_Policy_Access_With_MFA_BYOD
    Create_Policy_Block_Legacy_Authentication
}

Export-ModuleMember Add-StandardCARules

function Create_NZ_Location() {
    $params = @{
        "@odata.type"       = "#microsoft.graph.countryNamedLocation"
        DisplayName         = "New Zealand"
        IsTrusted           = $false
        countriesAndRegions = @(
            "NZ"
        )
        countryLookupMethod = "clientIpAddress"
    }
    $responce = New-MgIdentityConditionalAccessNamedLocation -BodyParameter $params
    Set-Variable -Name NamedLocationID -scope Global -Value $responce.ID
    $responce
}
function Create_Policy_Block_Access_Outside_NZ(){
    $params = @{
        conditions = @{
            applications = @{
                includeApplications = @()
                excludeApplications = @()
                includeUserActions = @("urn:user:registersecurityinfo")
                includeAuthenticationContextClassReferences = @()
                applicationFilter = $null
                networkAccess = $null
            }
            clients = $null
            users = @{
                includeUsers = @()
                excludeUsers = @()
                includeGroups = @($Include_Group_ID)
                excludeGroups = @($Exclude_Group_ID)
                includeRoles = @()
                excludeRoles = @()
                includeGuestsOrExternalUsers = $null
                excludeGuestsOrExternalUsers = $null
            }
            clientApplications = $null
            platforms = $null
            locations = @{
                includeLocations = @("All")
                excludeLocations = @($NamedLocationID)
            }
            userRiskLevels = @()
            signInRiskLevels = @()
            signInRiskDetections = $null
            clientAppTypes = @("all")
            times = $null
            devices = $null
            servicePrincipalRiskLevels = @()
        }
        displayName = "Block MFA Registration outside of NZ"
        grantControls = @{
            operator = "AND"
            builtInControls = @("block")
            customAuthenticationFactors = @()
            termsOfUse = @()
            authenticationStrength = $null
        }
        sessionControls = $null
        state = "enabled"
    }
    New-MgIdentityConditionalAccessPolicy -BodyParameter $params
}
function Create_Policy_Access_No_MFA_Complient_Devices(){
    param(
        $Hybrid = $false
    )

    $params = @{
        conditions = @{
            applications = @{
                includeApplications = @("All")
                excludeApplications = @()
                includeUserActions = @()
                includeAuthenticationContextClassReferences = @()
                networkAccess = $null
            }
            clients = $null
            users = @{
                includeUsers = @()
                excludeUsers = @()
                includeGroups = @($Include_Group_ID)
                excludeGroups = @($Exclude_Group_ID)
                includeRoles = @()
                excludeRoles = @()
                includeGuestsOrExternalUsers = $null
                excludeGuestsOrExternalUsers = $null
            }
            clientApplications = $null
            platforms = $null
            locations = $null
            userRiskLevels = @()
            signInRiskLevels = @()
            signInRiskDetections = $null
            clientAppTypes = @("all")
            times = $null
            devices = @{
                deviceFilter = @{
                    mode = "include"
                    rule = 'device.trustType -eq "AzureAD" -and device.deviceOwnership -eq "Company" -and device.isCompliant -eq True'
                }
                includeDevices = @()
                excludeDevices = @()
            }
            servicePrincipalRiskLevels = @()
        }
        displayName = "Grant Access No MFA - AzureAD Joined- Compliant"
        grantControls = $null
        sessionControls = @{
            applicationEnforcedRestrictions = $null
            cloudAppSecurity = $null
            signInFrequency = $null
            persistentBrowser = @{
                mode = "always"
                isEnabled = $true
            }
            continuousAccessEvaluation = $null
            disableResilienceDefaults = $null
            secureSignInSession = $null
            networkAccessSecurity = $null
        }
        state = "enabled"
    }

    #If Hybrid Joined Site, Modify MFA Policy Slightly
    if($Hybrid){
        $params.displayName = "Grant Access With MFA - Hybrid Joined - Compliant"
        $params.conditions.devices.deviceFilter.rule = 'device.trustType -eq "ServerAD" -and device.deviceOwnership -eq "Company" -and device.isCompliant -eq True'
    }
    
    
    New-MgIdentityConditionalAccessPolicy -BodyParameter $params

}
function Create_Policy_Access_With_MFA_Non_Complient_Devices(){
    param(
        $Hybrid = $false
    )

    $params = @{
        conditions = @{
            applications = @{
                includeApplications = @('All')
                excludeApplications = @()
                includeUserActions = @()
                includeAuthenticationContextClassReferences = @()
                networkAccess = $null
            }
            clients = $null
            users = @{
                includeUsers = @()
                excludeUsers = @()
                includeGroups = @($Include_Group_ID)
                excludeGroups = @($Exclude_Group_ID)
                includeRoles = @()
                excludeRoles = @()
                includeGuestsOrExternalUsers = $null
                excludeGuestsOrExternalUsers = $null
            }
            clientApplications = $null
            platforms = $null
            locations = $null
            userRiskLevels = @()
            signInRiskLevels = @()
            signInRiskDetections = $null
            clientAppTypes = @('all')
            times = $null
            devices = @{
                deviceFilter = @{
                    mode = 'include'
                    rule = 'device.trustType -eq "AzureAD" -and device.deviceOwnership -eq "Company" -and device.isCompliant -eq False'
                }
                includeDevices = @()
                excludeDevices = @()
            }
            servicePrincipalRiskLevels = @()
        }
        displayName = 'Grant Access With MFA - Azure AD Joined - Non Compliant'
        grantControls = @{
            operator = 'OR'
            builtInControls = @('mfa')
            customAuthenticationFactors = @()
            termsOfUse = @()
            authenticationStrength = $null
        }
        sessionControls = @{
            applicationEnforcedRestrictions = $null
            cloudAppSecurity = $null
            signInFrequency = @{
                value = 7
                type = 'days'
                frequencyInterval = 'timeBased'
                authenticationType = 'primaryAndSecondaryAuthentication'
                isEnabled = $true
            }
            persistentBrowser = @{
                mode = 'always'
                isEnabled = $true
            }
            continuousAccessEvaluation = $null
            disableResilienceDefaults = $null
            secureSignInSession = $null
            networkAccessSecurity = $null
        }
        state = 'enabled'
    }
    
    #If Hybrid Joined Site, Modify MFA Policy Slightly
    if($Hybrid){
        $params.displayName = "Grant Access With MFA - Hybrid Joined - Non Compliant"
        $params.conditions.devices.deviceFilter.rule = 'device.trustType -eq "ServerAD" -and device.deviceOwnership -eq "Company" -and device.isCompliant -eq True'
    }

    New-MgIdentityConditionalAccessPolicy -BodyParameter $params

}
function Create_Policy_Access_With_MFA_BYOD(){
    $params = @{
        conditions = @{
            applications = @{
                includeApplications = @("All")
                excludeApplications = @()
                includeUserActions = @()
                includeAuthenticationContextClassReferences = @()
                networkAccess = $null
            }
            clients = $null
            users = @{
                includeUsers = @()
                excludeUsers = @()
                includeGroups = @($Include_Group_ID)
                excludeGroups = @($Exclude_Group_ID)
                includeRoles = @()
                excludeRoles = @()
                includeGuestsOrExternalUsers = $null
                excludeGuestsOrExternalUsers = $null
            }
            clientApplications = $null
            platforms = $null
            locations = $null
            userRiskLevels = @()
            signInRiskLevels = @()
            signInRiskDetections = $null
            clientAppTypes = @("all")
            times = $null
            devices = @{
                deviceFilter = @{
                    mode = "exclude"
                    rule = 'device.trustType -eq "AzureAD" -or device.trustType -eq "ServerAD"'
                }
                includeDevices = @()
                excludeDevices = @()
            }
            servicePrincipalRiskLevels = @()
        }
        displayName = "Grant Access with MFA - BYOD"
        grantControls = @{
            operator = "AND"
            builtInControls = @("mfa")
            customAuthenticationFactors = @()
            termsOfUse = @()
            authenticationStrength = $null
        }
        sessionControls = @{
            applicationEnforcedRestrictions = $null
            cloudAppSecurity = $null
            signInFrequency = @{
                value = 3
                type = "days"
                frequencyInterval = "timeBased"
                authenticationType = "primaryAndSecondaryAuthentication"
                isEnabled = $true
            }
            persistentBrowser = $null
            continuousAccessEvaluation = $null
            disableResilienceDefaults = $null
            secureSignInSession = $null
            networkAccessSecurity = $null
        }
        state = "enabled"
    }
    
    New-MgIdentityConditionalAccessPolicy -BodyParameter $params

}
function Create_Policy_Block_Legacy_Authentication(){
    $params = @{
        conditions = @{
            applications = @{
                includeApplications = @("All")
                excludeApplications = @()
                includeUserActions = @()
                includeAuthenticationContextClassReferences = @()
                networkAccess = $null
            }
            clients = $null
            users = @{
                includeUsers = @("All")
                excludeUsers = @()
                includeGroups = @()
                excludeGroups = @()
                includeRoles = @()
                excludeRoles = @()
                includeGuestsOrExternalUsers = $null
                excludeGuestsOrExternalUsers = $null
            }
            clientApplications = $null
            platforms = $null
            locations = $null
            userRiskLevels = @()
            signInRiskLevels = @()
            signInRiskDetections = $null
            clientAppTypes = @("exchangeActiveSync", "other")
            times = $null
            devices = $null
            servicePrincipalRiskLevels = @()
        }
        displayName = "Block Access - Legacy Authentication"
        grantControls = @{
            operator = "AND"
            builtInControls = @("block")
            customAuthenticationFactors = @()
            termsOfUse = @()
            authenticationStrength = $null
        }
        sessionControls = $null
        state = "enabled"
    }

    New-MgIdentityConditionalAccessPolicy -BodyParameter $params
}