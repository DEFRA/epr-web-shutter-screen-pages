[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)] [string] $gatewayServiceConnection,
    [Parameter(Mandatory =$true)] [string] $applicationGatewayRg
)

Write-Host "gateway Service  Connection $($gatewayServiceConnection)" 
Write-Host "application Gateway Rg $($applicationGatewayRg)" 

#Get-AzContext
#Set-AzContext "5ac20727-8367-4439-81c1-1ba4c030ecb0" #$gatewayServiceConnection

get-azResourceGroup
#
# $gatewayServiceConnection
get-azapplicationGatewayCustomError -ApplicationGateway "SECRWDDEVAG9401"