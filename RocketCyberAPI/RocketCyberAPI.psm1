$RocketCyber_Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$RocketCyber_Headers.Add("Content-Type", 'application/json')

Set-Variable -Name "RocketCyber_Headers" -Value $RocketCyber_Headers -Scope global

Import-RocketCyberModuleSettings