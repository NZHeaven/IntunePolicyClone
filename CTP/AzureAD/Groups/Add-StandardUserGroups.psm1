function Add-StandardUserGroups() {
    New-AzureADMSGroup -DisplayName "All_Staff" -Description "Dynamic Staff Group" -MailEnabled $False -MailNickName "group" -SecurityEnabled $True -GroupTypes "DynamicMembership" -membershipRule "(user.department -eq ""Staff"")" -membershipRuleProcessingState "On"
    New-AzureADMSGroup -DisplayName "All_Students" -Description "Dynamic Student Group" -MailEnabled $False -MailNickName "group" -SecurityEnabled $True -GroupTypes "DynamicMembership" -membershipRule "(user.department -eq ""Student"")" -membershipRuleProcessingState "On"
}

Export-ModuleMember Add-StandardUserGroups