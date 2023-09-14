function Disconnect-CTP(){
Write-Host "Disconnecting from Current Tenant, Clearing Cached Auth Token" -ForegroundColor Yellow
Set-Variable -Name AuthToken -Scope global -Value $null
}