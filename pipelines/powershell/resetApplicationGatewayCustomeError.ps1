[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)] [string] $gatewayName,
    [Parameter(Mandatory =$true)] [string] $applicationGatewayRg
)

Write-Host "gateway Service  Connection $($gatewayServiceConnection)" 
Write-Host "application Gateway Rg $($applicationGatewayRg)" 


$AppGw =Get-AzApplicationGateway -Name $gatewayName -ResourceGroupName  $applicationGatewayRg
# $AppGw =Get-AzApplicationGateway
Write-output $AppGw

$SettingsList  = Get-AzApplicationGatewayBackendHttpSetting -ApplicationGateway $AppGw

#Set-AzApplicationGatewayBackendHttpSetting -ApplicationGateway $AppGw -Name  "obligation-checker-settings" -Port 443  -Protocol "Https" -CookieBasedAffinity Disabled -RequestTimeout 40

Write-output $SettingsList
 ##Stop-AzApplicationGateway -ApplicationGateway $AppGw
 ##Start-AzApplicationGateway -ApplicationGateway $AppGw
 