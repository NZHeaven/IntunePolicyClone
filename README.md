# CTP-Powershell-Module

PowerShell Module to automate the initial scaffolding of CTP sites.

Module Design to contain helpful cmdlets so users can quickly clone existing CTP sites Intune policies, as well as being able to bulk Create standard policies and groups.

The module Primary works by Downloading Policies from a Exisiting Intune Instance to Json on you local device. You can then edit that Json and Upload to the new Intune Site.

---
## Installation
 Donload the latest release or clone the repo.
- Open powershell and navigate to the root folder. Run the below command to import the module into scope
```
Import-Module .\ctp.psd1
```
---
## General Usage
Once the module is Installed, you can run the documented below CMDLets to Export and Import Polcies. It is important when you go to upload or download from another tenant that you first run: Disconnect-CTP. This will cause you to need to reauth when running the next command.

---

## Individual CMDLETS

### AutoPilot Deployment Profiles
Export All AP Deployment Profiles to a Folder on your Local Machine. Saving each policy as a Json File

```Powershell
Export-APDeploymentProfiles -FolderPath <string>
```

Import AP Deployment Profiles from a Local folder and create in Intune. The folder must contain valid Json Files
```Powershell
Import-APDeploymentProfiles -FolderPath <string>
```
### Compliance Policies
Export All Compliance Policies to a Folder on your Local Machine. The folder must contain valid Json Files

```Powershell
Export-CompliancePolicies -FolderPath <string>
```

Import Compliance Profiles from a Local folder and create in Intune. The folder must contain valid Json Files
```Powershell
Import-CompliancePolicies -FolderPath <string>
```
### Configuration Policies (Including ADMX Policies)
Export ADMX Configuration Policies to a Folder on your Local Machine. Saving the policy as a Directory contain muitple Json Files that make up the ADMX policies

```Powershell
Export-ADMXConfigurationPolicies -FolderPath <string>
```

Import ADMX Configuration Profiles from a Local folder and create in Intune.
```Powershell
Import-ADMXConfigurationPolicies -FolderPath <string>
```
Export All Configuration Profiles to a Folder on your Local Machine. Saving each policy as a Json File
```Powershell
Export-ConfigurationPoliciess -FolderPath <string>
```

Import All Configuration Profiles Profiles from a Local folder and create in Intune. 
```Powershell
Import-ConfigurationPoliciess -FolderPath <string>
```

### Endpoint Secuiity Policies
Export All Endpoint Secuiity Policies Folder on your Local Machine. Saving each policy as a Json File

```Powershell
Export-EndpointSecurityPolicies -FolderPath <string>
```

Import All Endpoint Secuiity policies from a Local folder and create in Intune. The folder must contain a valid Json File
```Powershell
Import-EndpointSecurityPolicies -FolderPath <string>
```
### Settings Catalogue Policies
Export All Settings Catalogue Policies to a Folder on your Local Machine. Saving each policy as a Json File

```Powershell
Export-SettingsCataloguePolicies -FolderPath <string>
```

Import All Settings Catalogue Policies from a Local folder and create in Intune. The folder must contain a valid Json File
```Powershell
Import-SettingsCataloguePolicies-FolderPath <string>
```

# Export-AllIntunePolicies

The `Export-AllIntunePolicies` function allows you to export various Intune configurations from a given tenant. You can choose to export different types of Intune policies, including AutoPilot Deployment Profiles, Compliance Policies, ADMX Configuration Policies, Configuration Policies, Endpoint Security Policies, and Endpoint Settings Catalogue Policies. The exported data will be organized into subfolders within the specified output folder.

## Parameters

- `FolderPath` (Mandatory): Specifies the path to the folder where the exported JSON configurations will be saved.

- `ExportAPDeploymentProfiles`: Indicates whether to export AutoPilot Deployment Profiles. Default is `true`.

- `ExportCompliancePolicies`: Indicates whether to export Compliance Policies. Default is `true`.

- `ExportADMXConfigurationPolicies`: Indicates whether to export ADMX Configuration Policies. Default is `true`.

- `ExportConfigurationPolicies`: Indicates whether to export Configuration Policies. Default is `true`.

- `ExportEndpointSecurityPolicies`: Indicates whether to export Endpoint Security Policies. Default is `true`.

- `ExportSettingsCataloguePolicies`: Indicates whether to export Endpoint Settings Catalogue Policies. Default is `true`.

## Example

```powershell
Export-AllIntunePolicies -FolderPath "C:\ExportedIntuneConfigs"
```

# Import-AllIntunePolicies

## Description

The `Import-AllIntunePolicies` function is used to import various Intune configurations into a target tenant. You can specify which types of Intune policies to import, including AutoPilot Deployment Profiles, Compliance Policies, ADMX Configuration Policies, Configuration Policies, Endpoint Security Policies, and Endpoint Settings Catalogue Policies. It is important to ensure that you have previously run the `Export-AllIntunePolicies` function to obtain the necessary JSON configuration files or have a mirrored folder structure for importing.

## Parameters

- `FolderPath` (Mandatory): Specifies the path to the folder containing the JSON configuration files to be imported.

- `ImportAPDeploymentProfiles`: Indicates whether to import AutoPilot Deployment Profiles. Default is `true`.

- `ImportCompliancePolicies`: Indicates whether to import Compliance Policies. Default is `true`.

- `ImportADMXConfigurationPolicies`: Indicates whether to import ADMX Configuration Policies. Default is `true`.

- `ImportConfigurationPolicies`: Indicates whether to import Configuration Policies. Default is `true`.

- `ImportEndpointSecurityPolicies`: Indicates whether to import Endpoint Security Policies. Default is `true`.

- `ImportSettingsCataloguePolicies`: Indicates whether to import Endpoint Settings Catalogue Policies. Default is `true`.

## Example

```powershell
Import-AllIntunePolicies -FolderPath "C:\ImportedIntuneConfigs"
```

# Helper Functions

## Disconnect-CTP
Call this function when you wish to connect to another Tenant. This will delete your current Token. The next time you all a command it will ask you to reauth.

```Powershell
Disconnect-CTP
```