#Region '.\Private\apiCalls\ConvertTo-RocketCyberQueryString.ps1' 0
function ConvertTo-RocketCyberQueryString {
<#
    .SYNOPSIS
        Converts uri filter parameters

    .DESCRIPTION
        The Invoke-RocketCyberRequest cmdlet converts & formats uri filter parameters
        from a function which are later used to make the full resource uri for
        an API call

        This is an internal helper function the ties in directly with the
        Invoke-RocketCyberRequest & any public functions that define parameters

    .PARAMETER uri_Filter
        Hashtable of values to combine a functions parameters with
        the resource_Uri parameter.

        This allows for the full uri query to occur

    .PARAMETER resource_Uri
        Defines the short resource uri (url) to use when creating the API call

    .EXAMPLE
        ConvertTo-RocketCyberQueryString -uri_Filter $uri_Filter -resource_Uri '/account'

        Example: (From public function)
            $uri_Filter = @{}

            ForEach ( $Key in $PSBoundParameters.GetEnumerator() ){
                if( $excludedParameters -contains $Key.Key ){$null}
                else{ $uri_Filter += @{ $Key.Key = $Key.Value } }
            }

            1x key = https://api-us.rocketcyber.com/v3/account?accountId=12345
            2x key = https://api-us.rocketcyber.com/v3/account?accountId=12345&details=True

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/ConvertTo-RocketCyberQueryString.html

#>

    [CmdletBinding()]
    [alias("ConvertTo-RCQueryString")]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [hashtable]$uri_Filter,

        [Parameter(Mandatory = $true)]
        [String]$resource_Uri
    )

    begin {}

    process {

        if (-not $uri_Filter) {
            return ""
        }

        $excludedParameters =   'Debug', 'ErrorAction', 'ErrorVariable', 'InformationAction', 'InformationVariable',
                                'OutBuffer', 'OutVariable', 'PipelineVariable', 'Verbose', 'WarningAction', 'WarningVariable',
                                'allPages','startDate','endDate', 'eventSummary'

        $query_Parameters = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)

        ForEach ( $Key in $uri_Filter.GetEnumerator() ){

            if( $excludedParameters -contains $Key.Key ){$null}
            elseif ( $Key.Value.GetType().IsArray ){
                Write-Verbose "[ $($Key.Key) ] is an array parameter"
                foreach ($Value in $Key.Value) {
                    #$ParameterName = $Key.Key
                    $query_Parameters.Add($Key.Key, $Value)
                }
            }
            else{
                $query_Parameters.Add($Key.Key, $Key.Value)
            }

        }

        # Build the request and load it with the query string.
        $uri_Request        = [System.UriBuilder]($RocketCyber_Base_URI + $resource_Uri)
        $uri_Request.Query  = $query_Parameters.ToString()

        return $uri_Request

    }

    end {}

}
#EndRegion '.\Private\apiCalls\ConvertTo-RocketCyberQueryString.ps1' 96
#Region '.\Private\apiCalls\Invoke-RocketCyberRequest.ps1' 0
function Invoke-RocketCyberRequest {
<#
    .SYNOPSIS
        Makes an API request

    .DESCRIPTION
        The Invoke-RocketCyberRequest cmdlet invokes an API request to RocketCyber API.

        This is an internal function that is used by all public functions

        As of 2023-08 the RocketCyber v1 API only supports GET requests

    .PARAMETER method
        Defines the type of API method to use

        Allowed values:
        'GET'

    .PARAMETER resource_Uri
        Defines the resource uri (url) to use when creating the API call

    .PARAMETER uri_Filter
        Used with the internal function [ ConvertTo-RocketCyberQueryString ] to combine
        a functions parameters with the resource_Uri parameter.

        This allows for the full uri query to occur

        The full resource path is made with the following data
        $RocketCyber_Base_URI + $resource_Uri + ConvertTo-RocketCyberQueryString

    .PARAMETER data
        Place holder parameter to use when other methods are supported
        by the RocketCyber v1 API

    .PARAMETER allPages
        Returns all items from an endpoint

        When using this parameter there is no need to use either the page or perPage
        parameters

    .EXAMPLE
        Invoke-RocketCyberRequest -method GET -resource_Uri '/account' -uri_Filter $uri_Filter

        Invoke a rest method against the defined resource using any of the provided parameters

        Example:
            Name                           Value
            ----                           -----
            Method                         GET
            Uri                            https://api-us.rocketcyber.com/v3/account?accountId=12345&details=True
            Headers                        {Authorization = Bearer 123456789}
            Body


    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Invoke-RocketCyberRequest.html

#>

    [CmdletBinding()]
    [alias("Invoke-RCRequest")]
    param (
        [Parameter( Mandatory = $false) ]
        [ValidateSet('GET')]
        [String]$method = 'GET',

        [Parameter(Mandatory = $true)]
        [String]$resource_Uri,

        [Parameter( Mandatory = $false) ]
        [Hashtable]$uri_Filter = $null,

        [Parameter( Mandatory = $false) ]
        [Hashtable]$data = $null,

        [Parameter( Mandatory = $false) ]
        [Switch]$allPages

    )

    begin {}

    process {

        # Load Web assembly when needed as PowerShell Core has the assembly preloaded
        if ( !("System.Web.HttpUtility" -as [Type]) ) {
            Add-Type -Assembly System.Web
        }

        $query_string = ConvertTo-RocketCyberQueryString -uri_Filter $uri_Filter -resource_Uri $resource_Uri

        Set-Variable -Name 'RocketCyber_queryString' -Value $query_string -Scope Global -Force

        if ($null -eq $data) {
            $body = $null
        } else {
            $body = @{'data'= $data} | ConvertTo-Json -Depth $RocketCyber_JSON_Conversion_Depth
        }

        try {
            $Api_Token = Get-RocketCyberAPIKey -PlainText

            $parameters = [ordered] @{
                "Method"    = $method
                "Uri"       = $query_string.Uri
                "Headers"   = @{ 'Authorization' = 'Bearer {0}' -f $Api_Token; 'Content-Type' = 'application/json' }
                "Body"      = $body
            }
            Set-Variable -Name 'RocketCyber_invokeParameters' -Value $parameters -Scope Global -Force

            if ($allPages){

                Write-Verbose "Gathering all items from [  $( $RocketCyber_Base_URI + $resource_Uri ) ] "

                $page_number = 1
                $all_responseData = [System.Collections.Generic.List[object]]::new()

                do {

                    $parameters['Uri'] = $query_string.Uri -replace '_page=\d+',"_page=$page_number"

                    $current_page = Invoke-RestMethod @parameters -ErrorAction Stop

                    Write-Verbose "[ $page_number ] of [ $($current_page.totalPages) ] pages"

                        foreach ($item in $current_page.data){
                            $all_responseData.add($item)
                        }

                    $page_number++

                } while ( $current_page.totalPages -ne $page_number - 1 -and $current_page.totalPages -ne 0 )

            }
            else{
                $api_response = Invoke-RestMethod @parameters -ErrorAction Stop
            }

        }
        catch {

            $exceptionError = $_.Exception.Message
            Write-Warning 'The [ RocketCyber_invokeParameters, RocketCyber_queryString, & RocketCyber_CmdletNameParameters ] variables can provide extra details'

            switch -Wildcard ($exceptionError) {
                '*404*' { Write-Error "Invoke-RocketCyberRequest : [ $resource_Uri ] not found!" }
                '*429*' { Write-Error 'Invoke-RocketCyberRequest : API rate limited' }
                '*504*' { Write-Error "Invoke-RocketCyberRequest : Gateway Timeout" }
                default { Write-Error $_ }
            }

        }
        finally {

            $Auth = $RocketCyber_invokeParameters['headers']['Authorization']
            $RocketCyber_invokeParameters['headers']['Authorization'] = $Auth.Substring( 0, [Math]::Min($Auth.Length, 10) ) + '*******'

        }


        if($allPages){

            Set-Variable -Name test_all_responseData -Value $all_responseData -Scope Global -Force

            #Making output consistent
            if( [string]::IsNullOrEmpty($all_responseData.data) -and ($all_responseData | Measure-Object).Count -eq 0 ){
                $api_response = $null
            }
            else{
                $count = ($all_responseData | Measure-Object).Count

                $api_response = [PSCustomObject]@{
                    totalCount  = $count
                    currentPage = $null
                    totalPages  = $null
                    dataCount   = $count
                    data        = $all_responseData
                }
            }

            return $api_response

        }
        else{ return $api_response }

    }

    end {}

}
#EndRegion '.\Private\apiCalls\Invoke-RocketCyberRequest.ps1' 194
#Region '.\Private\apiKeys\Add-RocketCyberAPIKey.ps1' 0
function Add-RocketCyberAPIKey {
<#
    .SYNOPSIS
        Sets your API bearer token used to authenticate all API calls.

    .DESCRIPTION
        The Add-RocketCyberAPIKey cmdlet sets your API bearer token which is used to
        authenticate all API calls made to RocketCyber. Once the API bearer token is
        defined, it is encrypted using SecureString.

        The RocketCyber API bearer tokens are generated via the RocketCyber web interface
        at Provider Settings > RocketCyber API

    .PARAMETER Api_Key
        Define your API bearer token that was generated from RocketCyber.

    .EXAMPLE
        Add-RocketCyberAPIKey

        Prompts to enter in the API bearer token

    .EXAMPLE
        Add-RocketCyberAPIKey -Api_key 'your_api_key'

        The RocketCyber API will use the string entered into the [ -Api_Key ] parameter.

    .EXAMPLE
        '12345' | Add-RocketCyberAPIKey

        The Add-RocketCyberAPIKey function will use the string passed into it as its API bearer token.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Add-RocketCyberAPIKey.html
#>

    [CmdletBinding()]
    [alias( "Add-RCAPIKey", "Set-RCAPIKey", "Set-RocketCyberAPIKey" )]
    Param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [AllowEmptyString()]
        [Alias('ApiKey')]
        [string]$Api_Key
    )

    begin {}

    process{

        if ($Api_Key) {
            $x_api_key = ConvertTo-SecureString $Api_Key -AsPlainText -Force

            Set-Variable -Name 'RocketCyber_API_Key' -Value $x_api_key -Option ReadOnly -Scope Global -Force
        }
        else {
            $x_api_key = Read-Host -Prompt 'Please enter your API key' -AsSecureString

            Set-Variable -Name 'RocketCyber_API_Key' -Value $x_api_key -Option ReadOnly -Scope Global -Force
        }

    }

    end {}
}
#EndRegion '.\Private\apiKeys\Add-RocketCyberAPIKey.ps1' 67
#Region '.\Private\apiKeys\Get-RocketCyberAPIKey.ps1' 0
function Get-RocketCyberAPIKey {
<#
    .SYNOPSIS
        Gets the RocketCyber API bearer token global variable.

    .DESCRIPTION
        The Get-RocketCyberAPIKey cmdlet gets the RocketCyber API bearer token
        global variable and returns it as a SecureString.

    .PARAMETER PlainText
        Decrypt and return the API key in plain text.

    .EXAMPLE
        Get-RocketCyberAPIKey

        Gets the RocketCyber API bearer token global variable and
        returns it as a SecureString.

    .EXAMPLE
        Get-RocketCyberAPIKey -PlainText

        Gets and decrypts the API key from the global variable and
        returns the API key in plain text

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Get-RocketCyberAPIKey.html
#>

    [CmdletBinding()]
    [alias("Get-RCAPIKey")]
    Param (
        [Parameter( Mandatory = $false) ]
        [Switch]$plainText
    )

    begin {}

    process{

        try {

            if ($RocketCyber_API_Key){
                if ($PlainText){
                    $Api_Key = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($RocketCyber_API_Key)
                    ( [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($Api_Key) ).ToString()
                }
                else{$RocketCyber_API_Key}
            }
            else{
                Write-Warning 'The RocketCyber API key is not set. Run Add-RocketCyberAPIKey to set the API key.'
            }
        }
        catch {
            Write-Error $_
        }
        finally {
            if ($Api_Key) {
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($Api_Key)
            }
        }

    }

    end{}

}
#EndRegion '.\Private\apiKeys\Get-RocketCyberAPIKey.ps1' 70
#Region '.\Private\apiKeys\Remove-RocketCyberAPIKey.ps1' 0
function Remove-RocketCyberAPIKey {
<#
    .SYNOPSIS
        Removes the RocketCyber API bearer token global variable.

    .DESCRIPTION
        The Remove-RocketCyberAPIKey cmdlet removes the RocketCyber API
        bearer token global variable.

    .EXAMPLE
        Remove-RocketCyberAPIKey

        Removes the RocketCyber API bearer token global variable.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Remove-RocketCyberAPIKey.html
#>

    [CmdletBinding(SupportsShouldProcess)]
    [alias("Remove-RCAPIKey")]
    Param ()

    begin {}

    process{

        if ($RocketCyber_API_Key) {
            Remove-Variable -Name 'RocketCyber_API_Key' -Scope Global -Force
        }
        else{
            Write-Warning "The RocketCyber API key variable is not set. Nothing to remove"
        }

    }

    end{}

}
#EndRegion '.\Private\apiKeys\Remove-RocketCyberAPIKey.ps1' 42
#Region '.\Private\apiKeys\Test-RocketCyberAPIKey.ps1' 0
function Test-RocketCyberAPIKey {
<#
    .SYNOPSIS
        Test the RocketCyber API bearer token.

    .DESCRIPTION
        The Test-RocketCyberAPIKey cmdlet tests the base URI & API
        bearer token that was defined in the
        Add-RocketCyberBaseURI & Add-RocketCyberAPIKey cmdlets.

    .PARAMETER base_uri
        Define the base URI for the RocketCyber API connection using RocketCyber's URI or a custom URI.

        The default base URI is https://api-us.rocketcyber.com/v3

    .PARAMETER id
        Data will be retrieved from this account id.

    .EXAMPLE
        Test-RocketCyberBaseURI -id 12345

        Tests the base URI & API bearer token that was defined in the
        Add-RocketCyberBaseURI & Add-RocketCyberAPIKey cmdlets.

        The default full base uri test path is:
            https://api-us.rocketcyber.com/v2/account/id

    .EXAMPLE
        Test-RocketCyberBaseURI -base_uri http://myapi.gateway.example.com -id 12345

        Tests the base URI & API bearer token that was defined in the
        Add-RocketCyberBaseURI & Add-RocketCyberAPIKey cmdlets.

        The full base uri test path in this example is:
            http://myapi.gateway.example.com/id

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Test-RocketCyberAPIKey.html
#>

    [CmdletBinding()]
    [alias("Test-RCAPIKey")]
    Param (
        [Parameter( Mandatory = $false) ]
        [string]$base_uri = $RocketCyber_Base_URI
    )

    begin { $resource_uri = "/account" }

    process {

        Write-Verbose "Testing API key against [ $($base_uri + $resource_uri) ]"

        try {

            $Api_Token = Get-RocketCyberAPIKey -PlainText

            $RocketCyber_Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
            $RocketCyber_Headers.Add("Content-Type", 'application/json')
            $RocketCyber_Headers.Add('Authorization', "Bearer $Api_Token")

            $rest_output = Invoke-WebRequest -Method Get -Uri ($base_uri + $resource_uri) -Headers $RocketCyber_Headers -ErrorAction Stop
        }
        catch {

            [PSCustomObject]@{
                Method = $_.Exception.Response.Method
                StatusCode = $_.Exception.Response.StatusCode.value__
                StatusDescription = $_.Exception.Response.StatusDescription
                Message = $_.Exception.Message
                URI = $($base_uri + $resource_uri)
            }

        } finally {
            Remove-Variable -Name RocketCyber_Headers -Force
        }

        if ($rest_output){
            $data = @{}
            $data = $rest_output

            [PSCustomObject]@{
                StatusCode = $data.StatusCode
                StatusDescription = $data.StatusDescription
                URI = $($base_uri + $resource_uri)
            }
        }

    }

    end {}

}
#EndRegion '.\Private\apiKeys\Test-RocketCyberAPIKey.ps1' 97
#Region '.\Private\baseUri\Add-RocketCyberBaseURI.ps1' 0
function Add-RocketCyberBaseURI {
<#
    .SYNOPSIS
        Sets the base URI for the RocketCyber API connection.

    .DESCRIPTION
        The Add-RocketCyberBaseURI cmdlet sets the base URI which is later used
        to construct the full URI for all API calls.

    .PARAMETER base_uri
        Define the base URI for the RocketCyber API connection using
        RocketCyber's URI or a custom URI.

    .PARAMETER data_center
        RocketCyber's URI connection point that can be one of the predefined data centers.

        The accepted values for this parameter are:
        [ US, EU ]
        US = https://api-us.rocketcyber.com/v3
        EU = https://api-eu.rocketcyber.com/v3

    .EXAMPLE
        Add-RocketCyberBaseURI

        The base URI will use https://api-us.rocketcyber.com/v3 which is RocketCyber's default URI.

    .EXAMPLE
        Add-RocketCyberBaseURI -data_center EU

        The base URI will use https://api-eu.rocketcyber.com/v3 which is RocketCyber's Europe URI.

    .EXAMPLE
        Add-RocketCyberBaseURI -base_uri http://myapi.gateway.example.com

        A custom API gateway of http://myapi.gateway.example.com will be used for
        all API calls to RocketCyber's API.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Add-RocketCyberBaseURI.html
#>

    [CmdletBinding()]
    [alias( "Add-RCBaseURI", "Set-RCBaseURI", "Set-RocketCyberBaseURI" )]
    Param (
        [Parameter(Mandatory = $false , ValueFromPipeline = $true)]
        [string]$base_uri = 'https://api-us.rocketcyber.com/v3',

        [Parameter( Mandatory = $false) ]
        [ValidateSet( 'US', 'EU' )]
        [String]$data_center
    )

    begin {}

    process{

        # Trim superfluous forward slash from address (if applicable)
        if ($base_uri[$base_uri.Length-1] -eq "/") {
            $base_uri = $base_uri.Substring(0,$base_uri.Length-1)
        }

        switch ($data_center) {
            'US' { $base_uri = "https://api-us.rocketcyber.com/v3" }
            'EU' { $base_uri = "https://api-eu.rocketcyber.com/v3" }
            Default {}
        }

        Set-Variable -Name 'RocketCyber_Base_URI' -Value $base_uri -Option ReadOnly -Scope Global -Force

    }

    end {}
}
#EndRegion '.\Private\baseUri\Add-RocketCyberBaseURI.ps1' 77
#Region '.\Private\baseUri\Get-RocketCyberBaseURI.ps1' 0
function Get-RocketCyberBaseURI {
<#
    .SYNOPSIS
        Shows the RocketCyber base URI global variable.

    .DESCRIPTION
        The Get-RocketCyberBaseURI cmdlet shows the RocketCyber base URI global variable value.

    .EXAMPLE
        Get-RocketCyberBaseURI

        Shows the RocketCyber base URI global variable value.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Get-RocketCyberBaseURI.html
#>

    [CmdletBinding()]
    [alias("Get-RCBaseURI")]
    Param ()

    begin {}

    process {

        switch ([bool]$RocketCyber_Base_URI) {
            $true   { $RocketCyber_Base_URI }
            $false  { Write-Warning "The RocketCyber base URI is not set. Run Add-RocketCyberBaseURI to set the base URI." }
        }

    }

    end {}
}
#EndRegion '.\Private\baseUri\Get-RocketCyberBaseURI.ps1' 38
#Region '.\Private\baseUri\Remove-RocketCyberBaseURI.ps1' 0
function Remove-RocketCyberBaseURI {
<#
    .SYNOPSIS
        Removes the RocketCyber base URI global variable.

    .DESCRIPTION
        The Remove-RocketCyberBaseURI cmdlet removes the RocketCyber base URI global variable.

    .EXAMPLE
        Remove-RocketCyberBaseURI

        Removes the RocketCyber base URI global variable.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Remove-RocketCyberBaseURI.html
#>

    [CmdletBinding(SupportsShouldProcess)]
    [alias("Remove-RCBaseURI")]
    Param ()

    begin {}

    process {

        switch ([bool]$RocketCyber_Base_URI) {
            $true   { Remove-Variable -Name "RocketCyber_Base_URI" -Scope Global -Force }
            $false  { Write-Warning "The RocketCyber base URI variable is not set. Nothing to remove" }
        }

    }

    end {}

}
#EndRegion '.\Private\baseUri\Remove-RocketCyberBaseURI.ps1' 39
#Region '.\Private\moduleSettings\Export-RocketCyberModuleSettings.ps1' 0
function Export-RocketCyberModuleSettings {
<#
    .SYNOPSIS
        Exports the RocketCyber BaseURI, API, & JSON configuration information to file.

    .DESCRIPTION
        The Export-RocketCyberModuleSettings cmdlet exports the RocketCyber BaseURI, API, & JSON configuration information to file.

        Making use of PowerShell's System.Security.SecureString type, exporting module settings encrypts your API key in a format
        that can only be unencrypted with the your Windows account as this encryption is tied to your user principal.
        This means that you cannot copy your configuration file to another computer or user account and expect it to work.

    .PARAMETER RocketCyberConfPath
        Define the location to store the RocketCyber configuration file.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\RocketCyberAPI

    .PARAMETER RocketCyberConfFile
        Define the name of the RocketCyber configuration file.

        By default the configuration file is named:
            config.psd1

    .EXAMPLE
        Export-RocketCyberModuleSettings

        Validates that the BaseURI, API, and JSON depth are set then exports their values
        to the current user's RocketCyber configuration file located at:
            $env:USERPROFILE\RocketCyberAPI\config.psd1

    .EXAMPLE
        Export-RocketCyberModuleSettings -RocketCyberConfPath C:\RocketCyberAPI -RocketCyberConfFile MyConfig.psd1

        Validates that the BaseURI, API, and JSON depth are set then exports their values
        to the current user's RocketCyber configuration file located at:
            C:\RocketCyberAPI\MyConfig.psd1

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Export-RocketCyberModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    [alias("Export-RCModuleSettings")]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'set')]
        [string]$RocketCyberConfPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop'){"RocketCyberAPI"}else{".RocketCyberAPI"}) ),

        [Parameter(Mandatory = $false, ParameterSetName = 'set')]
        [string]$RocketCyberConfFile = 'config.psd1'
    )

    begin {}

    process {

        Write-Warning "Secrets are stored using Windows Data Protection API (DPAPI)"
        Write-Warning "DPAPI provides user context encryption in Windows but NOT in other operating systems like Linux or UNIX. It is recommended to use a more secure & cross-platform storage method"

        $RocketCyberConfig = Join-Path -Path $RocketCyberConfPath -ChildPath $RocketCyberConfFile

        # Confirm variables exist and are not null before exporting
        if ($RocketCyber_Base_URI -and $RocketCyber_API_Key -and $RocketCyber_JSON_Conversion_Depth) {
            $secureString = $RocketCyber_API_KEY | ConvertFrom-SecureString

            if ($IsWindows -or $PSEdition -eq 'Desktop') {
                New-Item -Path $RocketCyberConfPath -ItemType Directory -Force | ForEach-Object { $_.Attributes = $_.Attributes -bor "Hidden" }
            }
            else{
                New-Item -Path $RocketCyberConfPath -ItemType Directory -Force
            }
@"
    @{
        RocketCyber_Base_URI = '$RocketCyber_Base_URI'
        RocketCyber_API_Key = '$secureString'
        RocketCyber_JSON_Conversion_Depth = '$RocketCyber_JSON_Conversion_Depth'
    }
"@ | Out-File -FilePath $RocketCyberConfig -Force
        }
        else {
            Write-Error "Failed to export RocketCyber module settings to [ $RocketCyberConfPath\$RocketCyberConfFile ]"
            Write-Error $_
            exit 1
        }

    }

    end {}

}
#EndRegion '.\Private\moduleSettings\Export-RocketCyberModuleSettings.ps1' 94
#Region '.\Private\moduleSettings\Get-RocketCyberModuleSettings.ps1' 0
function Get-RocketCyberModuleSettings {
<#
    .SYNOPSIS
        Gets the saved RocketCyber configuration settings

    .DESCRIPTION
        The Get-RocketCyberModuleSettings cmdlet gets the saved RocketCyber configuration settings

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\RocketCyberAPI

    .PARAMETER RocketCyberConfPath
        Define the location to store the RocketCyber configuration file.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\RocketCyberAPI

    .PARAMETER RocketCyberConfFile
        Define the name of the RocketCyber configuration file.

        By default the configuration file is named:
            config.psd1

    .PARAMETER openConfFile
        Opens the RocketCyber configuration file

    .EXAMPLE
        Get-RocketCyberModuleSettings

        Gets the contents of the configuration file that was created with the
        Export-RocketCyberModuleSettings

        The default location of the RocketCyber configuration file is:
            $env:USERPROFILE\RocketCyberAPI\config.psd1

    .EXAMPLE
        Get-RocketCyberModuleSettings -RocketCyberConfPath C:\RocketCyberAPI -RocketCyberConfFile MyConfig.psd1 -openConfFile

        Opens the configuration file from the defined location in the default editor

        The location of the RocketCyber configuration file in this example is:
            C:\RocketCyberAPI\MyConfig.psd1

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Get-RocketCyberModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    [alias("Export-RCModuleSettings")]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [String]$RocketCyberConfPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop'){"RocketCyberAPI"}else{".RocketCyberAPI"}) ),

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [String]$RocketCyberConfFile = 'config.psd1',

        [Parameter(Mandatory = $false, ParameterSetName = 'show')]
        [Switch]$openConfFile
    )

    begin{
        $RocketCyberConfig = Join-Path -Path $RocketCyberConfPath -ChildPath $RocketCyberConfFile
    }

    process{

        if ( Test-Path -Path $RocketCyberConfig ) {

            if($openConfFile){
                Invoke-Item -Path $RocketCyberConfig
            }
            else{
                Import-LocalizedData -BaseDirectory $RocketCyberConfPath -FileName $RocketCyberConfFile
            }

        }
        else {
            Write-Verbose "No configuration file found at [ $RocketCyberConfig ]"
        }

    }

    end{}

}
#EndRegion '.\Private\moduleSettings\Get-RocketCyberModuleSettings.ps1' 89
#Region '.\Private\moduleSettings\Import-RocketCyberModuleSettings.ps1' 0
function Import-RocketCyberModuleSettings {
<#
    .SYNOPSIS
        Imports the RocketCyber BaseURI, API, & JSON configuration information to the current session.

    .DESCRIPTION
        The Import-RocketCyberModuleSettings cmdlet imports the RocketCyber BaseURI, API, & JSON configuration
        information stored in the RocketCyber configuration file to the users current session.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\RocketCyberAPI

    .PARAMETER RocketCyberConfPath
        Define the location to store the RocketCyber configuration file.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\RocketCyberAPI

    .PARAMETER RocketCyberConfFile
        Define the name of the RocketCyber configuration file.

        By default the configuration file is named:
            config.psd1

    .EXAMPLE
        Import-RocketCyberModuleSettings

        Validates that the configuration file created with the Export-RocketCyberModuleSettings cmdlet exists
        then imports the stored data into the current users session.

        The default location of the RocketCyber configuration file is:
            $env:USERPROFILE\RocketCyberAPI\config.psd1

    .EXAMPLE
        Import-RocketCyberModuleSettings -RocketCyberConfPath C:\RocketCyberAPI -RocketCyberConfFile MyConfig.psd1

        Validates that the configuration file created with the Export-RocketCyberModuleSettings cmdlet exists
        then imports the stored data into the current users session.

        The location of the RocketCyber configuration file in this example is:
            C:\RocketCyberAPI\MyConfig.psd1

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Import-RocketCyberModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    [alias("Import-RCModuleSettings")]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'set')]
        [string]$RocketCyberConfPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop'){"RocketCyberAPI"}else{".RocketCyberAPI"}) ),

        [Parameter(Mandatory = $false, ParameterSetName = 'set')]
        [string]$RocketCyberConfFile = 'config.psd1'
    )

    begin {
        $RocketCyberConfig = Join-Path -Path $RocketCyberConfPath -ChildPath $RocketCyberConfFile
    }

    process {

        if ( Test-Path $RocketCyberConfig ) {
            $tmp_config = Import-LocalizedData -BaseDirectory $RocketCyberConfPath -FileName $RocketCyberConfFile

                # Send to function to strip potentially superfluous slash (/)
                Add-RocketCyberBaseURI $tmp_config.RocketCyber_Base_URI

                $tmp_config.RocketCyber_API_key = ConvertTo-SecureString $tmp_config.RocketCyber_API_key

                Set-Variable -Name 'RocketCyber_Base_URI' -Value $tmp_config.RocketCyber_Base_URI -Option ReadOnly -Scope Global -Force

                Set-Variable -Name 'RocketCyber_API_Key' -Value $tmp_config.RocketCyber_API_key -Option ReadOnly -Scope Global -Force

                Set-Variable -Name 'RocketCyber_JSON_Conversion_Depth' -Value $tmp_config.RocketCyber_JSON_Conversion_Depth -Scope Global -Force

            Write-Verbose "The RocketCyberAPI Module configuration loaded successfully from [ $RocketCyberConfig ]"

            # Clean things up
            Remove-Variable "tmp_config"
        }
        else {
            Write-Verbose "No configuration file found at [ $RocketCyberConfig ] run Add-RocketCyberAPIKey & Add-RocketCyberBaseURI to get started."

            Add-RocketCyberBaseURI

            Set-Variable -Name "RocketCyber_Base_URI" -Value $(Get-RocketCyberBaseURI) -Option ReadOnly -Scope Global -Force
            Set-Variable -Name "RocketCyber_JSON_Conversion_Depth" -Value 100 -Scope Global -Force
        }

    }

    end {}

}
#EndRegion '.\Private\moduleSettings\Import-RocketCyberModuleSettings.ps1' 99
#Region '.\Private\moduleSettings\Initialize-RocketCyberModuleSettings.ps1' 0
#Used to auto load either baseline settings or saved configurations when the module is imported
Import-RocketCyberModuleSettings -Verbose:$false
#EndRegion '.\Private\moduleSettings\Initialize-RocketCyberModuleSettings.ps1' 3
#Region '.\Private\moduleSettings\Remove-RocketCyberModuleSettings.ps1' 0
function Remove-RocketCyberModuleSettings {
<#
    .SYNOPSIS
        Removes the stored RocketCyber configuration folder.

    .DESCRIPTION
        The Remove-RocketCyberModuleSettings cmdlet removes the RocketCyber folder and its files.
        This cmdlet also has the option to remove sensitive RocketCyber variables as well.

        By default configuration files are stored in the following location and will be removed:
            $env:USERPROFILE\RocketCyberAPI

    .PARAMETER RocketCyberConfPath
        Define the location of the RocketCyber configuration folder.

        By default the configuration folder is located at:
            $env:USERPROFILE\RocketCyberAPI

    .PARAMETER AndVariables
        Define if sensitive RocketCyber variables should be removed as well.

        By default the variables are not removed.

    .EXAMPLE
        Remove-RocketCyberModuleSettings

        Checks to see if the default configuration folder exists and removes it if it does.

        The default location of the RocketCyber configuration folder is:
            $env:USERPROFILE\RocketCyberAPI

    .EXAMPLE
        Remove-RocketCyberModuleSettings -RocketCyberConfPath C:\RocketCyberAPI -AndVariables

        Checks to see if the defined configuration folder exists and removes it if it does.
        If sensitive RocketCyber variables exist then they are removed as well.

        The location of the RocketCyber configuration folder in this example is:
            C:\RocketCyberAPI

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Internal/Remove-RocketCyberModuleSettings.html
#>

    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'set')]
    [alias("Remove-RCModuleSettings")]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'set')]
        [string]$RocketCyberConfPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop'){"RocketCyberAPI"}else{".RocketCyberAPI"}) ),

        [Parameter(Mandatory = $false, ParameterSetName = 'set')]
        [switch]$AndVariables
    )

    begin {}

    process {

        if(Test-Path $RocketCyberConfPath)  {

            Remove-Item -Path $RocketCyberConfPath -Recurse -Force -WhatIf:$WhatIfPreference

            If ($AndVariables) {
                Remove-RocketCyberAPIKey
                Remove-RocketCyberBaseURI
            }

            if ($WhatIfPreference -eq $false){

                if (!(Test-Path $RocketCyberConfPath)) {
                    Write-Output "The RocketCyberAPI configuration folder has been removed successfully from [ $RocketCyberConfPath ]"
                }
                else {
                    Write-Error "The RocketCyberAPI configuration folder could not be removed from [ $RocketCyberConfPath ]"
                }

            }

        }
        else {
            Write-Warning "No configuration folder found at [ $RocketCyberConfPath ]"
        }

    }

    end {}

}
#EndRegion '.\Private\moduleSettings\Remove-RocketCyberModuleSettings.ps1' 92
#Region '.\Public\Get-RocketCyberAccounts.ps1' 0
function Get-RocketCyberAccounts {
<#
    .SYNOPSIS
        Gets account information for a given ID.

    .DESCRIPTION
        The Get-RocketCyberAccount cmdlet gets account information all
        accounts or for a given ID from the RocketCyber API.

    .PARAMETER accountId
        The account ID to pull data for.

        If not provided, data will be pulled for all accounts
        accessible by the bearer token.

    .PARAMETER details
        Should additional details for each sub-accounts be displayed
        in the return data.

    .EXAMPLE
        Get-RocketCyberAccount

        Account data will be retrieved from all accounts accessible
        by the bearer token

    .EXAMPLE
        Get-RocketCyberAccount -accountId 12345

        Account data will be retrieved for the account with the accountId 12345.

    .EXAMPLE
        12345 | Get-RocketCyberAccount

        Account data will be retrieved for the account with the accountId 12345.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Accounts/Get-RocketCyberAccounts.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    [alias("Get-RCAccounts")]
    Param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'index')]
        [ValidateRange(1, [int64]::MaxValue)]
        [Int64]$accountId,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [Switch]$details

    )

    begin{ $resource_Uri = '/account' }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        Set-Variable -Name 'RocketCyber_accountParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-RocketCyberRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters

    }

    end{}

}
#EndRegion '.\Public\Get-RocketCyberAccounts.ps1' 70
#Region '.\Public\Get-RocketCyberAgents.ps1' 0
function Get-RocketCyberAgents {
<#
    .SYNOPSIS
        Gets RocketCyber agents from an account.

    .DESCRIPTION
        The Get-RocketCyberAgents cmdlet gets agent information
        for all accounts or for agents associated to an account ID.

    .PARAMETER accountId
        The account id associated to the device

        If not provided, data will be pulled for all accounts
        accessible by the bearer token.

        Multiple comma separated values can be inputted

    .PARAMETER id
        The agent id

        Multiple comma separated values can be inputted

    .PARAMETER hostname
        The device hostname

        Multiple comma separated values can be inputted

    .PARAMETER ip
        The IP address tied to the device

        Multiple comma separated values can be inputted

    .PARAMETER created
        The date range for when agents were created

        Both the start and end dates are optional, but at least one is
        required to use this parameter.

        Cannot be used with the startDate & endDate parameters

        Start UTC Time | End UTC Time

        Example:
            2022-05-09T00:33:38.245Z|2022-05-10T23:59:38.245Z
            2022-05-09T00:33:38.245Z|
                                    |2022-05-10T23:59:38.245Z

    .PARAMETER startDate
        The friendly start date for when agents were created

        Both the start and end dates are optional, but at least one is
        required to use this parameter.

        Cannot be used with the created parameter

        Date needs to be inputted as yyyy-mm-dd hh:mm:ss

        Example:
            2022-05-09 12:30:10

    .PARAMETER endDate
        The friendly end date for when agents were created

        Both the start and end dates are optional, but at least one is
        required to use this parameter.

        Cannot be used with the created parameter

        Date needs to be inputted as yyyy-mm-dd hh:mm:ss

        Example:
            2022-05-09 12:30:10

    .PARAMETER os
        The OS used by the device

        As of 2023-03 using * do not appear to work correctly

        Example:
            Windows*
            Windows

    .PARAMETER version
        The agent version.

        As of 2023-03 this filter appears not to work correctly

        Example:
            Server 2019

    .PARAMETER connectivity
        The connectivity status of the agent

        Multiple comma separated values can be inputted

        Allowed values:
            'online', 'offline', 'isolated'

    .PARAMETER page
        The target page of data.

        This is used with pageSize parameter to determine how many
        and which items to return.

        [Default] 1

    .PARAMETER pageSize
        The number of items to return from the data set.

        [Default] 1000
        [Maximum] 1000

    .PARAMETER sort
        The sort order for the items queried.

        Not all values can be sorted

        Example:
            hostname:asc
            accountId:desc

    .PARAMETER allPages
        Returns all items from an endpoint

    .EXAMPLE
        Get-RocketCyberAgents

        Gets the first 1000 agents from all accounts accessible
        by the bearer token

    .EXAMPLE
        Get-RocketCyberAgents -id 12345

        Gets the first 1000 agents from account 12345.

    .EXAMPLE
        Get-RocketCyberAgents -id 12345 -sort hostname:asc

        Gets the first 1000 agents from account 12345.

        Data is sorted by hostname and returned in ascending order.

    .EXAMPLE
        Get-RocketCyberAgents -id 12345 -connectivity offline,isolated

        Gets the first 1000 offline agents from account 12345 that are
        either offline or isolated.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Agents/Get-RocketCyberAgents.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    [alias("Get-RCAgents")]
    Param (
        [Parameter( Mandatory = $false) ]
        [ValidateRange(1, [int64]::MaxValue)]
        [Int64[]]$accountId,

        [Parameter( Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String[]]$id,

        [Parameter( Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String[]]$hostname,

        [Parameter( Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String[]]$ip,

        [Parameter( Mandatory = $false, ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [String]$created,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByCustomTime')]
        [ValidateNotNullOrEmpty()]
        [DateTime]$startDate,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByCustomTime')]
        [ValidateNotNullOrEmpty()]
        [DateTime]$endDate,

        [Parameter( Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String]$os,

        [Parameter( Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String]$version,

        [Parameter( Mandatory = $false) ]
        [ValidateSet( 'online', 'offline', 'isolated' )]
        [String[]]$connectivity,

        [Parameter( Mandatory = $false ) ]
        [ValidateRange(1, [int]::MaxValue)]
        [Int]$page,

        [Parameter( Mandatory = $false ) ]
        [ValidateRange(1, 1000)]
        [Int]$pageSize,

        [Parameter( Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String]$sort,

        [Parameter( Mandatory = $false) ]
        [Switch]$allPages
    )

    begin{ $resource_Uri = '/agents' }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Add default PSBoundParameters
        if( -not $PSBoundParameters.ContainsKey('page') )       { $PSBoundParameters.page = 1 }
        if( -not $PSBoundParameters.ContainsKey('pageSize') )   { $PSBoundParameters.pageSize = 1000 }

        if ($PSCmdlet.ParameterSetName -eq 'indexByCustomTime') {

            if ($startDate) {
                $startTime    = $startDate.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ss.fffZ')
                Write-Verbose "Converting [ $startDate ] to [ $startTime ]"
            }
            if ($endDate)   {
                $endTime      = $endDate.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ss.fffZ')
                Write-Verbose "Converting [ $endDate ] to [ $endTime ]"
            }

                if ([bool]$startDate -eq $true -and [bool]$endDate -eq $true) {
                    $created_query = $startTime + '|' + $endTime
                }
                elseif ([bool]$startDate -eq $true -and [bool]$endDate -eq $false) {
                    $created_query = $startTime + '|'
                }
                else{
                    $created_query = '|' + $endTime
                }

            $PSBoundParameters += @{ 'created' = $created_query }

        }

        Set-Variable -Name 'RocketCyber_agentParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-RocketCyberRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end{}

}
#EndRegion '.\Public\Get-RocketCyberAgents.ps1' 259
#Region '.\Public\Get-RocketCyberApps.ps1' 0
function Get-RocketCyberApps {
<#
    .SYNOPSIS
        Gets an accounts apps from the RocketCyber API.

    .DESCRIPTION
        The Get-RocketCyberApps cmdlet gets an accounts apps
        from the RocketCyber API.

        Can be used with the Get-RocketCyberEvents cmdlet

    .PARAMETER accountId
        The account ID to pull data for.

        If not provided, data will be pulled for all accounts
        accessible by the bearer token.

    .PARAMETER status
        The type of apps to request

        Acceptable values are:
            'active', 'inactive'

        The default value is 'active'

    .EXAMPLE
        Get-RocketCyberApps

        Gets active apps from accounts accessible
        by the bearer token

    .EXAMPLE
        Get-RocketCyberApps -accountId 12345

        Gets active apps from account 12345.

    .EXAMPLE
        Get-RocketCyberApps -accountId 12345 -status inactive

        Gets inactive apps from account 12345.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Apps/Get-RocketCyberApps.html

#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    [alias("Get-RCApps")]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateRange(1, [int64]::MaxValue)]
        [Int64]$accountId,

        [Parameter( Mandatory = $false, ParameterSetName = 'index')]
        [ValidateSet( 'active', 'inactive' )]
        [String]$status
    )

    begin{ $resource_Uri = '/apps' }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        Set-Variable -Name 'RocketCyber_appParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-RocketCyberRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters

    }

    end{}

}
#EndRegion '.\Public\Get-RocketCyberApps.ps1' 77
#Region '.\Public\Get-RocketCyberDefender.ps1' 0
function Get-RocketCyberDefender {
<#
    .SYNOPSIS
        Gets defender information from the RocketCyber API.

    .DESCRIPTION
        The Get-RocketCyberDefender cmdlet gets an accounts defender information
        from the RocketCyber API.

        This includes various health & risk values

    .PARAMETER accountId
        The account ID to pull data for.

        If not provided, data will be pulled for all accounts
        accessible by the bearer token.

    .EXAMPLE
        Get-RocketCyberDefender

        Gets defender information all accounts accessible
        by the bearer token

    .EXAMPLE
        Get-RocketCyberDefender -accountId 12345

        Gets defender information from account 12345

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Defender/Get-RocketCyberDefender.html

#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    [alias("Get-RCDefender")]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateRange(1, [int64]::MaxValue)]
        [Int64]$accountId
    )

    begin{ $resource_Uri = '/defender' }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        Set-Variable -Name 'RocketCyber_defenderParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-RocketCyberRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters

    }

    end{}

}
#EndRegion '.\Public\Get-RocketCyberDefender.ps1' 60
#Region '.\Public\Get-RocketCyberEvents.ps1' 0
function Get-RocketCyberEvents {
<#
    .SYNOPSIS
        Gets app event information from the RocketCyber API.

    .DESCRIPTION
        The Get-RocketCyberEvents cmdlet gets app event information for
        events associated to all or a defined account ID.

        Use the Get-RockerCyberApp cmdlet to get app ids

    .PARAMETER appId
        The app ID.

    .PARAMETER verdict
        The verdict of the event.

        Multiple comma separated values can be inputted

        Allowed Values:
        'informational', 'suspicious', 'malicious'

    .PARAMETER accountId
        The account id associated to the device

        If not provided, data will be pulled for all accounts
        accessible by the bearer token.

        Multiple comma separated values can be inputted

    .PARAMETER eventSummary
        Shows summary of events for each app

    .PARAMETER details
        This parameter allows users to target specific attributes within the details object.

        This requires you to define the attribute path (period separated) and the expected value.

        The value can include wildcards (*)

        Example: (appId 7)
            attributes.direction:outbound

    .PARAMETER dates
        The date range for event detections.

        Both the start and end dates are optional, but at least one is
        required to use this parameter.

        Cannot be used with the startDate & endDate parameters

        Start Time  |  End Time

        Example:
            2022-05-09  |2022-05-10
            2022-05-09  |
                        |2022-05-10

    .PARAMETER page
        The target page of data.

        This is used with pageSize parameter to determine how many
        and which items to return.

        [Default] 1

    .PARAMETER pageSize
        The number of items to return from the data set.

        [Default] 1000
        [Maximum] 1000

    .PARAMETER sort
        The sort order for the items queried.

        Not all values can be sorted

        Example:
            verdict:asc
            dates:desc

    .PARAMETER allPages
        Returns all items from an endpoint

    .EXAMPLE
        Get-RocketCyberEvents -appId 7

        Gets the first 1000 appId 7 events from all accounts accessible
        by the bearer token

    .EXAMPLE
        Get-RocketCyberEvents -accountId 12345 -appId 7

        Gets the first 1000 appId 7 events from account 12345

    .EXAMPLE
        Get-RocketCyberEvents -appId 7 -sort dates:desc

        Gets the first 1000 appId 7 events and the data set is sort
        by dates in descending order.

    .EXAMPLE
        Get-RocketCyberEvents -appId 7 -verdict suspicious

        Gets the first 1000 appId 7 events and the data set is sort
        by dates in descending order.

    .NOTES
        As of 2023-03
            Other than the parameters shown here, app specific parameters vary from app to app,
            however I have not found any documentation around this.

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Events/Get-RocketCyberEvents.html

#>

    [CmdletBinding(DefaultParameterSetName = 'indexByEvent')]
    [alias("Get-RCEvents")]
    Param (
        [Parameter( Mandatory = $true, ParameterSetName = 'indexByEvent')]
        [ValidateRange(1, [int]::MaxValue)]
        [Int]$appId,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByEvent')]
        [ValidateSet( 'informational', 'suspicious', 'malicious' )]
        [String[]]$verdict,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByEvent')]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByEventSummary')]
        [ValidateRange(1, [int64]::MaxValue)]
        [Int64[]]$accountId,

        [Parameter( Mandatory = $true, ParameterSetName = 'indexByEventSummary')]
        [Switch]$eventSummary,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByEvent')]
        [ValidateNotNullOrEmpty()]
        [String]$details,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByEvent')]
        [ValidateNotNullOrEmpty()]
        [String]$dates,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByEvent')]
        [ValidateRange(1, [int]::MaxValue)]
        [Int]$page,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByEvent')]
        [ValidateRange(1, 1000)]
        [Int]$pageSize,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByEvent')]
        [ValidateNotNullOrEmpty()]
        [String]$sort,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByEvent')]
        [Switch]$allPages
    )

    begin{

        switch ( [bool]$eventSummary ) {
            $true   { $resource_uri = "/events/summary" }
            $false  { $resource_uri = "/events" }
        }

    }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Add default PSBoundParameters
        if ( $($PSCmdlet.ParameterSetName) -eq 'indexByEvent' ){

            if( -not $PSBoundParameters.ContainsKey('page') )       { $PSBoundParameters.page = 1 }
            if( -not $PSBoundParameters.ContainsKey('pageSize') )   { $PSBoundParameters.pageSize = 1000 }

        }

        Set-Variable -Name 'RocketCyber_eventParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-RocketCyberRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end{}

}
#EndRegion '.\Public\Get-RocketCyberEvents.ps1' 191
#Region '.\Public\Get-RocketCyberFirewalls.ps1' 0
function Get-RocketCyberFirewalls {
<#
    .SYNOPSIS
        Gets RocketCyber firewalls from an account.

    .DESCRIPTION
        The Get-RocketCyberFirewalls cmdlet gets firewalls from
        an account.

    .PARAMETER accountId
        The account id associated to the device

        If not provided, data will be pulled for all accounts
        accessible by the bearer token.

        Multiple comma separated values can be inputted

    .PARAMETER deviceId
        The device ID tied to the device.

    .PARAMETER ipAddress
        The IP address tied to the device.

        As of 2023-03 this endpoint does not return
        IP address information

        Example:
            172.25.5.254

    .PARAMETER macAddress
        The MAC address tied to the device.

        Example:
            ae:b1:69:29:55:24

        Multiple comma separated values can be inputted

    .PARAMETER type
        The type of device.

        Example:
            SonicWall,Fortinet

        Multiple comma separated values can be inputted

    .PARAMETER counters
        Flag to include additional firewall counter data

    .PARAMETER page
        The target page of data.

        This is used with pageSize parameter to determine how many
        and which items to return.

        [Default] 1

    .PARAMETER pageSize
        The number of items to return from the data set.

        [Default] 1000
        [Maximum] 1000

    .PARAMETER sort
        The sort order for the items queried.

        Not all values can be sorted

        Example:
            accountId:asc
            accountId:desc

    .PARAMETER allPages
        Returns all items from an endpoint

    .EXAMPLE
        Get-RocketCyberFirewalls

        Gets the first 1000 agents from all accounts accessible
        by the bearer token

    .EXAMPLE
        Get-RocketCyberFirewalls -accountId 12345

        The first 1000 firewalls are pulled from accountId 12345

    .EXAMPLE
        Get-RocketCyberFirewalls -macAddress '11:22:33:aa:bb:cc'

        Get the firewall with the defined macAddress

    .EXAMPLE
        Get-RocketCyberFirewalls -type SonicWall,Fortinet

        Get firewalls with the defined type

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Firewalls/Get-RocketCyberFirewalls.html
#>

    [CmdletBinding()]
    [alias("Get-RCFirewalls")]
    Param (
        [Parameter( Mandatory = $false) ]
        [ValidateRange(1, [int64]::MaxValue)]
        [Int64[]]$accountId,

        [Parameter( Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String]$deviceId,

        [Parameter( Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String]$ipAddress,

        [Parameter( Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String[]]$macAddress,

        [Parameter( Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String[]]$type,

        [Parameter( Mandatory = $false) ]
        [Switch]$counters,

        [Parameter( Mandatory = $false ) ]
        [ValidateRange(1, [int]::MaxValue)]
        [Int]$page,

        [Parameter( Mandatory = $false ) ]
        [ValidateRange(1, 1000)]
        [Int]$pageSize,

        [Parameter( Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String]$sort,

        [Parameter( Mandatory = $false) ]
        [Switch]$allPages
    )

    begin{ $resource_Uri = '/firewalls' }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Add default PSBoundParameters
        if( -not $PSBoundParameters.ContainsKey('page') )       { $PSBoundParameters.page = 1 }
        if( -not $PSBoundParameters.ContainsKey('pageSize') )   { $PSBoundParameters.pageSize = 1000 }

        Set-Variable -Name 'RocketCyber_firewallParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-RocketCyberRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end{}

}
#EndRegion '.\Public\Get-RocketCyberFirewalls.ps1' 164
#Region '.\Public\Get-RocketCyberIncidents.ps1' 0
function Get-RocketCyberIncidents {
<#
    .SYNOPSIS
        Gets incident information from the RocketCyber API

    .DESCRIPTION
        The Get-RocketCyberIncidents cmdlet gets incident information
        associated to all or a defined account ID.

    .PARAMETER id
        The RocketCyber incident ID.

        Multiple comma separated values can be inputted

    .PARAMETER title
        The title of the incident.

        Example:
            Office*

        Multiple comma separated values can be inputted

    .PARAMETER accountId
        The account id associated to the device

        If not provided, data will be pulled for all accounts
        accessible by the bearer token.

        Multiple comma separated values can be inputted

    .PARAMETER description
        The description of the incident.

        NOTE: Wildcards are required to search for specific text.

        Example:
            administrative

    .PARAMETER remediation
        The remediation for the incident.

        NOTE: Wildcards are required to search for specific text.

        Example:
            permission*

        As of 2023-03 this parameters does not appear to work

    .PARAMETER resolvedAt
        This returns incidents resolved between the start and end date.

        Both the start and end dates are optional, but at least one is
        required to use this parameter.

        Start Time  |  End Time

        Example:
            2022-05-09  |2022-05-10
            2022-05-09  |
                        |2022-05-10

    .PARAMETER createdAt
        This returns incidents created between the start and end date.

        Both the start and end dates are optional, but at least one is
        required to use this parameter.

        Start Time  |  End Time

        Example:
            2022-05-09  |2022-05-10
            2022-05-09  |
                        |2022-05-10

    .PARAMETER status
        The type of incidents to request.

        Allowed Values:
            'open', 'resolved'

        As of 2023-03 the documentation defines the
        allowed values listed below but not all work

        'all', 'open', 'closed'

    .PARAMETER page
        The target page of data.

        This is used with pageSize parameter to determine how many
        and which items to return.

        [Default] 1

    .PARAMETER pageSize
        The number of items to return from the data set.

        [Default] 1000
        [Maximum] 1000

    .PARAMETER sort
        The sort order for the items queried.

        Not all values can be sorted

        Example:
            accountId:asc
            title:desc

    .PARAMETER allPages
        Returns all items from an endpoint

    .EXAMPLE
        Get-RocketCyberIncidents

        Gets the first 1000 incidents from all accounts accessible
        by the bearer token

    .EXAMPLE
        Get-RocketCyberIncidents -accountId 12345 -Id 9876

        Gets the defined incident Id from the defined accountId

    .EXAMPLE
        Get-RocketCyberIncidents -title nmap -resolvedAt '2023-01-01|'

        Gets the first 1000 incidents from all accounts accessible
        by the bearer token that were resolved after the defined
        startDate with the defined word in the title.

    .EXAMPLE
        Get-RocketCyberIncidents -description audit -createdAt '|2023-03-01'

        Gets the first 1000 incidents from all accounts accessible
        by the bearer token that were created before the defined
        endDate with the defined word in the description.

    .EXAMPLE
        Get-RocketCyberIncidents -status resolved -sort title:asc

        Gets the first 1000 resolved incidents from all accounts accessible
        by the bearer token and the data is return by title in
        ascending order.

    .NOTES
        As of 2023-03:
            Any parameters that say wildcards are required is not valid

            Using wildcards in the query string do not work as the endpoint
            already search's via wildcard. If you use a wildcard '*' it
            will not return any results.

        The remediation parameter does not appear to work

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Incidents/Get-RocketCyberIncidents.html

#>

    [CmdletBinding()]
    [alias("Get-RCIncidents")]
    Param (
        [Parameter( Mandatory = $false) ]
        [ValidateRange(1, [int]::MaxValue)]
        [Int[]]$id,

        [Parameter( Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String[]]$title,

        [Parameter( Mandatory = $false) ]
        [ValidateRange(1, [int64]::MaxValue)]
        [Int64[]]$accountId,

        [Parameter( Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String[]]$description,

        [Parameter( Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String]$remediation,

        [Parameter( Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String]$resolvedAt,

        [Parameter( Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String]$createdAt,

        [Parameter( Mandatory = $false) ]
        [ValidateSet( 'open', 'resolved' )]
        [String[]]$status,

        [Parameter( Mandatory = $false ) ]
        [ValidateRange(1, [int]::MaxValue)]
        [Int]$page,

        [Parameter( Mandatory = $false ) ]
        [ValidateRange(1, 1000)]
        [Int]$pageSize,

        [Parameter( Mandatory = $false) ]
        [ValidateNotNullOrEmpty()]
        [String]$sort,

        [Parameter( Mandatory = $false) ]
        [Switch]$allPages
    )

    begin{ $resource_Uri = '/incidents' }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Add default PSBoundParameters
        if( -not $PSBoundParameters.ContainsKey('page') )       { $PSBoundParameters.page = 1 }
        if( -not $PSBoundParameters.ContainsKey('pageSize') )   { $PSBoundParameters.pageSize = 1000 }

        Set-Variable -Name 'RocketCyber_incidentParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-RocketCyberRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end{}

}
#EndRegion '.\Public\Get-RocketCyberIncidents.ps1' 229
#Region '.\Public\Get-RocketCyberOffice.ps1' 0
function Get-RocketCyberOffice {
<#
    .SYNOPSIS
        Gets office information from the RocketCyber API

    .DESCRIPTION
        The Get-RocketCyberOffice cmdlet gets office information
        from all or a defined accountId.

    .PARAMETER accountId
        The account ID to pull data for.

        If not provided, data will be pulled for all accounts
        accessible by the bearer token.

    .EXAMPLE
        Get-RocketCyberOffice

        Office data will be retrieved from all accounts accessible
        by the bearer token

    .EXAMPLE
        Get-RocketCyberOffice -accountId 12345

        Office data will be retrieved from the accountId 12345

    .EXAMPLE
        12345 | Get-RocketCyberOffice

        Office data will be retrieved from the accountId 12345

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/RocketCyber-PowerShellWrapper/site/Office/Get-RocketCyberOffice.html

#>

    [CmdletBinding()]
    [alias("Get-RCOffice")]
    Param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateRange(1, [int64]::MaxValue)]
        [Int64]$accountId

    )

    begin{ $resource_Uri = '/office' }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        Set-Variable -Name 'RocketCyber_officeParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-RocketCyberRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters

    }

    end{}

}
#EndRegion '.\Public\Get-RocketCyberOffice.ps1' 64
