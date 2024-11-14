[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)] [string] $gatewayServiceConnection,
    [Parameter(Mandatory =$true)] [string] $applicationGatewayRg
)

Write-Host "gateway Service  Connection $($gatewayServiceConnection)" 
Write-Host "application Gateway Rg $($applicationGatewayRg)" 

#Get-AzContext
Set-AzContext $gatewayServiceConnection

get-azResourceGroup
#
# $gatewayServiceConnection
get-azapplicationGatewayCustomError -ApplicationGateway "SECRWDDEVAG9401"