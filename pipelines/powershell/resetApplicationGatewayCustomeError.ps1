# [CmdletBinding()]
# param (
#     [Parameter(Mandatory = $true)] [string] $gatewayName,
#     [Parameter(Mandatory =$true)] [string] $applicationGatewayRg
# )

# Write-Host "gateway Service  Connection $($gatewayServiceConnection)" 
# Write-Host "application Gateway Rg $($applicationGatewayRg)" 

# $AppGw =Get-AzApplicationGateway -Name $gatewayName -ResourceGroupName  $applicationGatewayRg
# Write-output $AppGw

# Stop-AzApplicationGateway -ApplicationGateway $AppGw
# Start-AzApplicationGateway -ApplicationGateway $AppGw

# [CmdletBinding()]
# param (
#     [Parameter(Mandatory = $true)] [string] $gatewayName,
#     [Parameter(Mandatory = $true)] [string] $applicationGatewayRg,
#     [Parameter(Mandatory = $false)] [int] $waitTimeSeconds = 5
# )

# function Update-FrontendPort {
#     param (
#         [Microsoft.Azure.Commands.Network.Models.PSApplicationGateway] $appGw,
#         [int] $fromPort,
#         [int] $toPort
#     )

#     $frontendPort = $appGw.FrontendPorts | Where-Object { $_.Port -eq $fromPort }
#     if ($frontendPort) {
#         $frontendPort.Port = $toPort
#         Write-Host "Updated Frontend Port from $fromPort to $toPort..." -ForegroundColor Yellow
#         Set-AzApplicationGateway -ApplicationGateway $appGw
#         Start-Sleep -Seconds $waitTimeSeconds # wait briefly for Azure to process the update
#     } else {
#         Write-Host "Frontend Port $fromPort not found." -ForegroundColor Red
#         throw "Frontend Port $fromPort not found"
#     }
# }

# try {
#     Write-Host "Fetching Application Gateway: $gatewayName in Resource Group: $applicationGatewayRg" -ForegroundColor Green
#     $AppGw = Get-AzApplicationGateway -Name $gatewayName -ResourceGroupName $applicationGatewayRg -ErrorAction Stop

#     if (-not $AppGw) {
#         Write-Host "Application Gateway '$gatewayName' not found in Resource Group '$applicationGatewayRg'." -ForegroundColor Red
#         exit 1
#     }

#     # Stop the gateway
#     Write-Host "Stopping Application Gateway..." -ForegroundColor Yellow
#     Stop-AzApplicationGateway -ApplicationGateway $AppGw -Force

#     # Wait for gateway to fully stop
#     $retryCount = 0
#     $maxRetries = 6
#     while ($retryCount -lt $maxRetries) {
#         $status = (Get-AzApplicationGateway -Name $gatewayName -ResourceGroupName $applicationGatewayRg).ProvisioningState
#         if ($status -eq "Stopped") {
#             break
#         }
#         Write-Host "Waiting for gateway to stop... (Attempt $($retryCount + 1)/$maxRetries)" -ForegroundColor Yellow
#         Start-Sleep -Seconds 10
#         $retryCount++
#     }

#     if ($retryCount -eq $maxRetries) {
#         throw "Gateway failed to stop within the expected time"
#     }

#     # Temporarily change frontend port from 443 → 445
#     Update-FrontendPort -AppGw $AppGw -fromPort 443 -toPort 445

#     # Change frontend port back from 445 → 443
#     Update-FrontendPort -AppGw $AppGw -fromPort 445 -toPort 443

#     # Start the gateway again
#     Write-Host "Starting Application Gateway..." -ForegroundColor Green
#     Start-AzApplicationGateway -ApplicationGateway $AppGw

#     Write-Host "Application Gateway flushed and restarted successfully!" -ForegroundColor Green
# }
# catch {
#     Write-Host "An error occurred: $_" -ForegroundColor Red
#     exit 1
# }


[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)] [string] $gatewayName,
    [Parameter(Mandatory = $true)] [string] $applicationGatewayRg,
    [Parameter(Mandatory = $false)] [int] $fromPort = 443,
    [Parameter(Mandatory = $false)] [int] $toPort = 445,
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
    $appGw = Get-AzApplicationGateway -Name $gatewayName -ResourceGroupName $applicationGatewayRg -ErrorAction Stop

    if (-not $appGw) {
        throw "Application Gateway '$gatewayName' not found in Resource Group '$applicationGatewayRg'"
    }

    # Change frontend port from original to temporary port
    Update-FrontendPort -AppGw $appGw -fromPort $fromPort -toPort $toPort
    Write-Host "Updating Frontend Port from $fromPort to $toPort..." -ForegroundColor Green

    # Change frontend port back to original port
    Update-FrontendPort -AppGw $appGw -fromPort $toPort -toPort $fromPort
    Write-Host "Updating Frontend Port from $toPort to $fromPort..." -ForegroundColor Green

    Write-Host "Application Gateway cache flushed successfully!" -ForegroundColor Green
}
catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
    exit 1
}