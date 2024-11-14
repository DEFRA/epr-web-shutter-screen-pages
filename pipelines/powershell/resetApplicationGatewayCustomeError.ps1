[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)] [string] $gatewayServiceConnection,
    [Parameter(Mandatory =$true)] [string] $applicationGatewayRg
)

Write-Host "gateway Service  Connection $($gatewayServiceConnection)" 
Write-Host "application Gateway Rg $($applicationGatewayRg)" 

#Get-AzContext
#Set-AzContext "5ac20727-8367-4439-81c1-1ba4c030ecb0" #$gatewayServiceConnection

#get-azResourceGroup
#
# $gatewayServiceConnection
#get-azapplicationGatewayCustomError -ApplicationGateway "SECRWDDEVAG9401"
#Get-AzApplicationGatewayAvailableServerVariableAndHeader -ServerVariable
#Get-AzApplicationGatewayAvailableWafRuleSet
$AppGw =Get-AzApplicationGateway -Name "SECADPSNDAG1401" -ResourceGroupName "SECADPSNDRG1401"

Write-Host "----"
Write-output $AppGw
Write-Host "----"

#$AppGw = Get-AzApplicationGateway -Name $applicationGatewayRg -ResourceGroupName $applicationGatewayRg
#$Settings  = Get-AzApplicationGatewayBackendSetting -Name "Settings01" -ApplicationGateway $AppGw

#Get-AzApplicationGatewayCustomError -ApplicationGateway $AppGw #-StatusCode HttpStatus502
#Get-AzApplicationGatewayListener -Name "Listener01" -ApplicationGateway $Appgw
$Listeners = Get-AzApplicationGatewayListener -ApplicationGateway $AppGw

Write-Host "----"
Write-output $Listeners
Write-Host "----"
Stop-AzApplicationGateway -ApplicationGateway $AppGw
Start-AzApplicationGateway -ApplicationGateway $AppGw

 #Get-AzApplicationGatewayWebApplicationFirewallConfiguration -ApplicationGateway $AppGW