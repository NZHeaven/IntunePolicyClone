Function Export-AllIntunePolicies() {
    
    <#
    .SYNOPSIS
    This function is used to export all intune configurations from a given tenant.
    .DESCRIPTION
    This function is used to export all intune configurations from a given tenant. it will call all the subfunctions from the Intune sub Module
    .EXAMPLE
    Export-AllIntune -Folderpath "path to Temp folder to export Json Configs too"
    .NOTES
    NAME: Export-AllIntune
    #>
    param(
        [Parameter(Mandatory = $true)]
        $FolderPath,
        $ExportAPDeploymentProfiles = $true,
        $ExportCompliancePolicies = $true,
        $ExportADMXConfigurationPolicies = $true,
        $ExportConfigurationPolicies = $true,
        $ExportEndpointSecurityPolicies = $true,
        $ExportSettingsCataloguePolicies = $true
    )
    
    Scaffold_Temp_Folders -FolderPath $FolderPath

    #AP Deployment Profiles
    if ($ExportAPDeploymentProfiles) { Export-APDeploymentProfiles "$FolderPath\AutoPilot_Deployment_Profiles" }
    
    #Compliance Policies
    if ($ExportCompliancePolicies) { Export-CompliancePolicies "$FolderPath\Compliance_Policies" }

    #ADMX Configuration Policies
    if ($ExportADMXConfigurationPolicies){ Export-ADMXConfigurationPolicies "$FolderPath\ADMXConfigurationPolicies"}
    
    #Configurtaion Policies
    if($ExportConfigurationPolicies){ Export-ConfigurationPolicies "$FolderPath\ConfigurationPolicies"}

    #Endpoint Security Policies
    if($ExportEndpointSecurityPolicies){ Export-EndpointSecurityPolicies "$FolderPath\EndpointSecurityPolicies"}

    #Endpoint Settings Catalogue Policies
    if($ExportEndpointSecurityPolicies){ Export-SettingsCataloguePolicies "$FolderPath\EndpointSettingsCataloguePolicies"}
}

function Scaffold_Temp_Folders() {
    param (
        [Parameter(Mandatory = $true)]
        $FolderPath
    )

    New-Item -Path "$FolderPath\AutoPilot_Deployment_Profiles" -ItemType Directory -ErrorAction Ignore
    New-Item -Path "$FolderPath\Compliance_Policies" -ItemType Directory -ErrorAction Ignore
    New-Item -Path "$FolderPath\ADMXConfigurationPolicies" -ItemType Directory -ErrorAction Ignore
    New-Item -Path "$FolderPath\ConfigurationPolicies" -ItemType Directory -ErrorAction Ignore
    New-Item -Path "$FolderPath\EndpointSecurityPolicies" -ItemType Directory -ErrorAction Ignore
    New-Item -Path "$FolderPath\EndpointSettingsCataloguePolicies" -ItemType Directory -ErrorAction Ignore
}

Export-ModuleMember Export-AllIntunePolicies