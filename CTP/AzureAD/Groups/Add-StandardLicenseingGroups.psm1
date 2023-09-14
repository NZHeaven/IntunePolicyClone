function Add-StandardLicenseingGroups() {
    New-AzureADMSGroup -DisplayName "LIC_EnterpriseMobilitySecurityE3" -Description "Dynamic Licence Group" -MailEnabled $False -MailNickName "group" -SecurityEnabled $True -GroupTypes "DynamicMembership" -membershipRule "(user.department -eq ""Student"")" -membershipRuleProcessingState "On"
    New-AzureADMSGroup -DisplayName "LIC_MinecraftEducationEditionStudent" -Description "Dynamic Licence Group" -MailEnabled $False -MailNickName "group" -SecurityEnabled $True -GroupTypes "DynamicMembership" -membershipRule "(user.department -eq ""Student"")" -membershipRuleProcessingState "On"
    New-AzureADMSGroup -DisplayName "LIC_Office365A1PlusForFaculty" -Description "Dynamic Licence Group" -MailEnabled $False -MailNickName "group" -SecurityEnabled $True -GroupTypes "DynamicMembership" -membershipRule "(user.department -eq ""Staff Other"")" -membershipRuleProcessingState "On"
    New-AzureADMSGroup -DisplayName "LIC_Microsoft365A3forFaculty" -Description "Dynamic Licence Group" -MailEnabled $False -MailNickName "group" -SecurityEnabled $True -GroupTypes "DynamicMembership" -membershipRule "(user.department -eq ""Staff"")" -membershipRuleProcessingState "On"
    New-AzureADMSGroup -DisplayName "LIC_Microsoft365A3forStudents" -Description "Dynamic Licence Group" -MailEnabled $False -MailNickName "group" -SecurityEnabled $True -GroupTypes "DynamicMembership" -membershipRule "(user.department -eq ""Student"")" -membershipRuleProcessingState "On"
    New-AzureADMSGroup -DisplayName "LIC_Windows10EnterpriseA3forStudents" -Description "Dynamic Licence Group" -MailEnabled $False -MailNickName "group" -SecurityEnabled $True -GroupTypes "DynamicMembership" -membershipRule "(user.department -eq ""Student"")" -membershipRuleProcessingState "On"
    New-AzureADMSGroup -DisplayName "LIC_Microsoft365A5forStudents" -Description "Dynamic Licence Group" -MailEnabled $False -MailNickName "group" -SecurityEnabled $True -GroupTypes "DynamicMembership" -membershipRule "(user.department -eq ""Student"")" -membershipRuleProcessingState "On"
    New-AzureADMSGroup -DisplayName "LIC_Microsoft365A5forFaculty" -Description "Dynamic Licence Group" -MailEnabled $False -MailNickName "group" -SecurityEnabled $True -GroupTypes "DynamicMembership" -membershipRule "(user.department -eq ""Staff"")" -membershipRuleProcessingState "On"
}

Export-ModuleMember Add-StandardLicenseingGroups