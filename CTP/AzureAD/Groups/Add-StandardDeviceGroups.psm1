function Add-StandardDeviceGroups(){
    New-AzureADMSGroup -DisplayName "Windows_School_Owned_Devices" -Description "Dynamic Windows School owned Devices Group" -MailEnabled $False -MailNickName "group" -SecurityEnabled $True -GroupTypes "DynamicMembership" -membershipRule "(device.deviceOSType -eq ""Windows"") and (device.deviceOwnership -eq ""Company"")" -membershipRuleProcessingState "On"
    New-AzureADMSGroup -DisplayName "Windows_Autopilot_Devices" -Description "Dynamic Autopilot Group" -MailEnabled $False -MailNickName "group" -SecurityEnabled $True -GroupTypes "DynamicMembership" -membershipRule "(device.devicePhysicalIDs -any (_ -contains ""[ZTDId]""))" -membershipRuleProcessingState "On"
}

Export-ModuleMember Add-StandardDeviceGroups