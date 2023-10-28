<#
    .SYNOPSIS
        Gets a Customer report from the RocketCyber API.

    .DESCRIPTION
        The Get-RocketCyberCustomersReport script gets a Customer report from the RocketCyber API.

        This is a proof of concept script. It is not intended to be used in production.

    .PARAMETER APIKey
        Enter in the RocketCyber API key for authentication

    .PARAMETER APIEndPoint
        Define what RocketCyber endpoint to connect to.
        The default is https://api-us.rocketcyber.com/v2/account

    .PARAMETER id
        Data will be retrieved from this account id.

    .PARAMETER Report
        Defines if the script should output the results to a CSV, HTML or Both.

    .PARAMETER ShowReport
        Switch statement to open the report folder after the script runs.

    .EXAMPLE
        Get-RocketCyberCustomersReport -APIKey 12345 -id 12345

        Gets all Customers from the RocketCyber API and sends the data to a CSV file.

    .EXAMPLE
        Get-RocketCyberCustomersReport -APIKey 12345 -id 12345 -Report HTML

        Gets all Customers from the RocketCyber API and sends the data to a HTML file.

    .EXAMPLE
        Get-RocketCyberCustomersReport -APIKey 12345 -id 12345 -Report All

        Gets all customers from the RocketCyber API and sends the data to both a CSV & HTML file.

    .NOTES
        2022-03 Currently any account returned will always shows with a status of active. This is a known issue with the RocketCyber API.

    .LINK
        https://github.com/Celerium/RocketCyber-Automation
        https://github.com/Celerium/RocketCyber-PowerShellWrapper
        https://api-doc.rocketcyber.com
#>

#Requires -Version 5.0

#Region    [ Parameters ]

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)]
        $APIKEY,

        [Parameter(Mandatory=$false)]
        $APIEndpoint = 'https://api-us.rocketcyber.com/v2/account',

        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [Int64]$id,

        [Parameter(Mandatory=$false)]
        [ValidateSet('All','CSV','HTML')]
        [String]$Report = 'CSV',

        [Parameter(Mandatory=$false)]
        [Switch]$ShowReport

    )

#EndRegion [ Parameters ]

''
Write-Output "Start - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
''

#Region    [ Prerequisites ]

    $ScriptName = 'Get-RocketCyberCustomersReport'
    $ReportFolderName = "$ScriptName-Report"
    $FileDate = Get-Date -Format 'yyyy-MM-dd-HHmm'
    $HTMLDate = (Get-Date -Format 'yyyy-MM-dd h:mmtt').ToLower()

    #Install RocketCyber Module
    Try {
        If(Get-PackageProvider -ListAvailable -Name NuGet -ErrorAction Stop){}
        Else{
            Install-PackageProvider -Name NuGet -Confirm:$False
        }

        If(Get-Module -ListAvailable -Name RocketCyberAPI) {
            Import-module RocketCyberAPI -ErrorAction Stop
        }
        Else {
            Install-Module RocketCyberAPI -Force -ErrorAction Stop
            Import-Module RocketCyberAPI -ErrorAction Stop
        }
    }
    Catch {
        Write-Error $_
        break
    }

    #Settings RocketCyber login information
    Add-RocketCyberBaseURI -base_uri $APIEndpoint
    Add-RocketCyberAPIKey $APIKey -ErrorAction Stop



    #Define & create logging location
    Try{

        $Log = "C:\Audits\$ReportFolderName"

        If ($Report -ne 'Console'){
            $CSVReport  = "$Log\$ScriptName-Report-$FileDate.csv"
            $HTMLReport = "$Log\$ScriptName-Report-$FileDate.html"

            If ((Test-Path -Path $Log -PathType Container) -eq $false){
                New-Item -Path $Log -ItemType Directory > $Null
            }
        }
    }
    Catch{
        Write-Host $_.Exception.Message -ForegroundColor Red -BackgroundColor Black
        ''
        Write-Error $_
        break
    }

#EndRegion [ Prerequisites ]

Write-Output " - (1/3) - $(Get-Date -Format MM-dd-HH:mm) - Getting Customers from RocketCyber"

#Region     [ RocketCyber API ]

    #Customize the results
        Try{
            $RocketCyberCustomers = Get-RocketCyberCustomers -id $id

            $RocketCyberCustomerResults = ForEach ($Customer in $RocketCyberCustomers){
                $CustomerId = ($Customer.Path).Split('.')[$($Customer.Path.Split('.').Count-1)]

                $CustomerFirewalls = (Get-RocketCyberFirewalls -id $CustomerId).data
                $CustomerAgents = (Get-RocketCyberAgents -id $CustomerId).data

                $Customer | Select-Object `
                @{Name='Status';Expression={$_.Status}}, `
                @{Name='customerName';Expression={$_.Name}}, `
                @{Name='customerId';Expression={$CustomerId}}, `
                @{Name='accountPath';Expression={$_.Path}}, `
                @{Name='Type';Expression={$_.type}}, `
                @{Name='Firewalls';Expression={($CustomerFirewalls).Count}}, `
                @{Name='Agents';Expression={($CustomerAgents).Count}}
            }
        }
        Catch{
            Write-Host $_.Exception.Message -ForegroundColor Red -BackgroundColor Black
            ''
            Write-Error $_
            break
        }

#EndRegion  [ RocketCyber API ]

#Region     [ CSV Report ]

    Try{
        If($Report -eq 'All' -or $Report -eq 'CSV'){
            Write-Output " - (2/3) - $(Get-Date -Format MM-dd-HH:mm) - Generating CSV"
            $RocketCyberCustomerResults | Select-Object $ScriptName,* | Export-Csv $CSVReport -NoTypeInformation
        }
    }
    Catch{
        Write-Host $_.Exception.Message -ForegroundColor Red -BackgroundColor Black
        ''
        Write-Error $_
        break
    }

#EndRegion  [ CSV Report ]

#Region    [ HTML Report]

    Try{
        If ($Report -eq 'All' -or $Report -eq 'HTML'){
            Write-Output " - (3/3) - $(Get-Date -Format MM-dd-HH:mm) - Generating HTML"

            #HTML card header data to highlight useful information
            $TotalCustomers = ($RocketCyberCustomerResults.Path).count
            $InActiveCustomers = ($RocketCyberCustomerResults | Where-Object {$_.Status -ne 'Active'}).count
            $TotalFirewalls = ($RocketCyberCustomerResults.Firewalls| Measure-Object -Sum).Sum
            $TotalAgents = ($RocketCyberCustomerResults.Agents | Measure-Object -Sum).Sum

        #Region    [ HTML Report Building Blocks ]

            # Build the HTML header
            # This grabs the raw text from files to shorten the amount of lines in the PSScript
            # General idea is that the HTML assets would infrequently be changed once set
                $Meta = Get-Content -Path "$PSScriptRoot\Assets\Meta.html" -Raw
                $Meta = $Meta -replace 'xTITLECHANGEx',"$ScriptName"
                $CSS = Get-Content -Path "$PSScriptRoot\Assets\Styles.css" -Raw
                $JavaScript = Get-Content -Path "$PSScriptRoot\Assets\JavaScriptHeader.html" -Raw
                $Head = $Meta + ("<style>`n") + $CSS + ("`n</style>") + $JavaScript

            # HTML Body Building Blocks (In order)
                $TopNav = Get-Content -Path "$PSScriptRoot\Assets\TopBar.html" -Raw
                $DivMainStart = '<div id="layoutSidenav">'
                $SideBar = Get-Content -Path "$PSScriptRoot\Assets\SideBar.html" -Raw
                $SideBar = $SideBar -replace ('xTIMESETx',"$HTMLDate")
                $DivSecondStart = '<div id="layoutSidenav_content">'
                $PreLoader = Get-Content -Path "$PSScriptRoot\Assets\PreLoader.html" -Raw
                $MainStart = '<main>'

            #Base Table Container
                $BaseTableContainer = Get-Content -Path "$PSScriptRoot\Assets\TableContainer.html" -Raw

            #Summary Header
                $SummaryTableContainer = $BaseTableContainer
                $SummaryTableContainer = $SummaryTableContainer -replace ('xHEADERx',"$ScriptName - Summary")
                $SummaryTableContainer = $SummaryTableContainer -replace ('xBreadCrumbx','')

            #Summary Cards
            #HTML in Summary.html would be edited depending on the report and summary info you want to show
                $SummaryCards = Get-Content -Path "$PSScriptRoot\Assets\Summary.html" -Raw
                $SummaryCards = $SummaryCards -replace ('xCARD1Valuex',$TotalCustomers)
                $SummaryCards = $SummaryCards -replace ('xCARD2Valuex',$InActiveCustomers)
                $SummaryCards = $SummaryCards -replace ('xCARD3Valuex',$TotalFirewalls)
                $SummaryCards = $SummaryCards -replace ('xCARD4Valuex',$TotalAgents)

            #Body table headers, would be duplicated\adjusted depending on how many tables you want to show
                $BodyTableContainer = $BaseTableContainer
                $BodyTableContainer = $BodyTableContainer -replace ('xHEADERx',"$ScriptName - Details")
                $BodyTableContainer = $BodyTableContainer -replace ('xBreadCrumbx',"Data gathered from $(hostname)")

            #Ending HTML
                $DivEnd = '</div>'
                $MainEnd = '</main>'
                $JavaScriptEnd = Get-Content -Path "$PSScriptRoot\Assets\JavaScriptEnd.html" -Raw

        #EndRegion [ HTML Report Building Blocks ]
        #Region    [ Example HTML Report Data\Structure ]

            #Creates an HTML table from PowerShell function results without any extra HTML tags
            $TableResults = $RocketCyberCustomerResults | ConvertTo-Html -As Table -Fragment -Property Status,customerName,customerId,Firewalls,Agents `
                                            -PostContent    '   <ul>
                                                                    <li>Note: SAMPLE 1 = Only applies to stuff and things</li>
                                                                    <li>Note: SAMPLE 2 = Only applies to stuff and things</li>
                                                                    <li>Note: SAMPLE 3 = Only applies to stuff and things</li>
                                                                </ul>
                                                            '

            #Table section segregation
            #PS doesn't create a <thead> tag so I have find the first row and make it so
            $TableHeader = $TableResults -split "`r`n" | Where-Object {$_ -match '<th>'}
            #Unsure why PS makes empty <colgroup> as it contains no data
            $TableColumnGroup = $TableResults -split "`r`n" | Where-Object {$_ -match '<colgroup>'}

            #Table ModIfications
            #Replacing empty html table tags with simple replaceable names
            #It was annoying me that empty rows showed in the raw HTML and I couldn't delete them as they were not $NUll but were empty
            $TableResults = $TableResults -replace ($TableHeader,'xblanklinex')
            $TableResults = $TableResults -replace ($TableColumnGroup,'xblanklinex')
            $TableResults = $TableResults | Where-Object {$_ -ne 'xblanklinex'} | ForEach-Object {$_.Replace('xblanklinex','')}

            #Inject modified data back into the table
            #Makes the table have a <thead> tag
            $TableResults = $TableResults -replace '<Table>',"<Table>`n<thead>$TableHeader</thead>"
            $TableResults = $TableResults -replace '<table>','<table class="dataTable-table" style="width: 100%;">'

            #Mark Focus Data to draw attention\talking points
            #Need to understand RegEx more as this doesn't scale at all
            $TableResults = $TableResults -replace '<td>Yes</td>','<td class="WarningStatus">Yes</td>'


            #Building the final HTML report using the various ordered HTML building blocks from above.
            #This is injecting html\css\javascript in a certain order into a file to make an HTML report
            $HTML = ConvertTo-HTML -Head $Head -Body "  $TopNav $DivMainStart $SideBar $DivSecondStart $PreLoader $MainStart
                                                        $SummaryTableContainer $SummaryCards $DivEnd $DivEnd $DivEnd
                                                        $BodyTableContainer $TableResults $DivEnd $DivEnd $DivEnd
                                                        $MainEnd $DivEnd $DivEnd $JavaScriptEnd
                                                    "
            $HTML = $HTML -replace '<body>','<body class="sb-nav-fixed">'
            $HTML | Out-File $HTMLReport -Encoding utf8

        }
    }
    Catch{
    Write-Host $_.Exception.Message -ForegroundColor Red -BackgroundColor Black
    ''
    Write-Error $_
    break
    }
#EndRegion [ HTML Report ]

If ($ShowReport){
    Invoke-Item $Log
}

''
Write-Output "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
''