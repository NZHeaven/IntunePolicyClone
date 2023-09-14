Function Import-AllIntunePolicies() {
    
    <#
    .SYNOPSIS
    This function is used to Import all intune configurations to a target Tenant
    .DESCRIPTION
    Ensure to run Export-AllIntunePolicies first or Mirror the needed folder structure. Refer to the documentation for this.
    .EXAMPLE
    Import-AllIntunePolicies -Folderpath "path to Temp folder to Import Json Configs too"
    .NOTES
    NAME: Import-AllIntune
    #>
    param(
        [Parameter(Mandatory = $true)]
        $FolderPath,
        $ImportAPDeploymentProfiles = $true,
        $ImportCompliancePolicies = $true,
        $ImportADMXConfigurationPolicies = $true,
        $ImportConfigurationPolicies = $true,
        $ImportEndpointSecurityPolicies = $true,
        $ImportSettingsCataloguePolicies = $true
    )
    

    #AP Deployment Profiles
    if ($ImportAPDeploymentProfiles) { Import-APDeploymentProfiles "$FolderPath\AutoPilot_Deployment_Profiles" }
    
    #Compliance Policies
    if ($ImportCompliancePolicies) { Import-CompliancePolicies "$FolderPath\Compliance_Policies" }

    #ADMX Configuration Policies
    if ($ImportADMXConfigurationPolicies){ Import-ADMXConfigurationPolicies "$FolderPath\ADMXConfigurationPolicies"}
    
    #Configurtaion Policies
    if($ImportConfigurationPolicies){ Import-ConfigurationPolicies "$FolderPath\ConfigurationPolicies"}

    #Endpoint Security Policies
    if($ImportEndpointSecurityPolicies){ Import-EndpointSecurityPolicies "$FolderPath\EndpointSecurityPolicies"}

    #Endpoint Settings Catalogue Policies
    if($ImportSettingsCataloguePolicies){ Import-SettingsCataloguePolicies "$FolderPath\EndpointSettingsCataloguePolicies"}
}

Export-ModuleMember Import-AllIntunePolicies