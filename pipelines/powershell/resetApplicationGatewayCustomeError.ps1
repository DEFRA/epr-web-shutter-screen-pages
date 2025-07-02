[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)] [string] $gatewayName,
    [Parameter(Mandatory = $true)] [string] $applicationGatewayRg,
    [Parameter(Mandatory = $false)] [int] $realPort = 443,
    [Parameter(Mandatory = $false)] [int] $tempPort = 445,
    [Parameter(Mandatory = $false)] [int] $waitTimeSeconds = 5
)

function Update-FrontendPort {
    param (
        [Microsoft.Azure.Commands.Network.Models.PSApplicationGateway] $appGw,
        [int] $fromPort,
        [int] $toPort
    )

    try {
        $frontendPort = $appGw.FrontendPorts | Where-Object { $_.Port -eq $fromPort }
        if ($frontendPort) {
            $frontendPort.Port = $toPort
            Write-Host "Updating Frontend Port from $fromPort to $toPort..." -ForegroundColor Yellow
            Set-AzApplicationGateway -ApplicationGateway $appGw -ErrorAction Stop
            Write-Host "Successfully updated port. Waiting $waitTimeSeconds seconds for changes to propagate..." -ForegroundColor Green
            Start-Sleep -Seconds $waitTimeSeconds
        } else {
            throw "Frontend Port $fromPort not found in Application Gateway configuration"
        }
    }
    catch {
        Write-Host "Error updating frontend port: $_" -ForegroundColor Red
        throw
    }
}

try {
    Write-Host "Fetching Application Gateway: $gatewayName in Resource Group: $applicationGatewayRg" -ForegroundColor Green
    Get-AzApplicationGateway -Name $gatewayName -ResourceGroupName $applicationGatewayRg -ErrorAction Stop
    $appGw = Get-AzApplicationGateway -Name $gatewayName -ResourceGroupName $applicationGatewayRg -ErrorAction Stop
    Write-Host "Application Gateway: $appGw"

    if (-not $appGw) {
        throw "Application Gateway '$gatewayName' not found in Resource Group '$applicationGatewayRg'"
    }

    # Change frontend port to real port to temp port
    Write-Host "Updating Frontend Port from $realPort to $tempPort..." -ForegroundColor Green
    Update-FrontendPort -AppGw $appGw -fromPort $realPort -toPort $tempPort

    Get-AzApplicationGateway -Name $gatewayName -ResourceGroupName $applicationGatewayRg -ErrorAction Stop
    $appGw = Get-AzApplicationGateway -Name $gatewayName -ResourceGroupName $applicationGatewayRg -ErrorAction Stop
    Write-Host "Application Gateway: $appGw"
    # Change frontend temp port back to real port
    Write-Host "Updating Frontend Port from $tempPort to $realPort..." -ForegroundColor Green
    Update-FrontendPort -AppGw $appGw -fromPort $tempPort -toPort $realPort

    Write-Host "Application Gateway cache flushed successfully!" -ForegroundColor Green
}
catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
    exit 1
}
