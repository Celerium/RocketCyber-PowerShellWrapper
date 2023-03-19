$RocketCyber_Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$RocketCyber_Headers.Add("User-Agent", 'RocketCyberAPI-PoSH/v2.0.0 (https://github.com/Celerium/RocketCyber-PowerShellWrapper)')
$RocketCyber_Headers.Add("Content-Type", 'application/json')

Set-Variable -Name "RocketCyber_Headers" -Value $RocketCyber_Headers -Scope global

Import-RocketCyberModuleSettings