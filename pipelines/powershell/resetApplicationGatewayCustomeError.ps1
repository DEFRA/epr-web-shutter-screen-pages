[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)] [string] $gatewayServiceConnection,
    [Parameter(Mandatory =$true)] [string] $applicationGatewayRg
)

#Get-AzContext
Set-AzContext $gatewayServiceConnection
#'5ac20727-8367-4439-81c1-1ba4c030ecb0'
# $gatewayServiceConnection
get-azapplicationGatewayCustomError -ApplicationGateway $appgw