param (
    [Parameter(Mandatory = $true)] [string] $gatewayServiceConnection,
    [Parameter(Mandatory =$true)] [string] $applicationGatewayRg
)

Set-AzContext $gatewayServiceConnection
get-azapplicationGatewayCustomError -ApplicationGateway $appgw