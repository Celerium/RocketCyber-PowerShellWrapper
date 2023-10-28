<#
    .SYNOPSIS
        Gets an Incident report from the RocketCyber API.

    .DESCRIPTION
        The Get-RocketCyberIncidentsReport script gets a Incident report from the RocketCyber API.

        This is a proof of concept script. It is not intended to be used in production.

    .PARAMETER APIKey
        Enter in the RocketCyber API key for authentication

    .PARAMETER APIEndPoint
        Define what RocketCyber endpoint to connect to.
        The default is https://api-us.rocketcyber.com/v2/account

    .PARAMETER Days
        Defines the time period to get incidents from.

    .PARAMETER Report
        Defines if the script should output the results to a CSV, HTML or Both.

    .PARAMETER ShowReport
        Switch statement to open the report folder after the script runs.

    .EXAMPLE
        Get-RocketCyberIncidentsReport -APIKey 12345

        Gets all Incidents from the RocketCyber API and sends the data to a CSV file.

    .EXAMPLE
        Get-RocketCyberIncidentsReport -APIKey 12345 -Days -180 -Report HTML

        Gets all Incidents from the RocketCyber API and sends the data to a HTMl file.
        Any active Incidents that have not had activity in the past 180 days will be classified as inactive.

    .EXAMPLE
        Get-RocketCyberIncidentsReport -APIKey 12345 -Days -30 -Report All

        Gets all Incidents from the RocketCyber API and sends the data to both a CSV & HTML file.
        Any active Incidents that have not had activity in the past 30 days will be classified as inactive.

    .NOTES
        Provide a better example script, as this is a not a great proof of concept.

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
        [ValidateRange([Int]::MinValue,-1)]
        [Int]$Days,

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

    $ScriptName = 'Get-RocketCyberIncidentsReport'
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
            If ($Days){
                $CSVReport  = "$Log\$ScriptName-$($Days -replace '-')Days-$FileDate.csv"
                $HTMLReport = "$Log\$ScriptName-$($Days -replace '-')Days-$FileDate.html"
            }
            Else{
                $CSVReport  = "$Log\$ScriptName-$FileDate.csv"
                $HTMLReport = "$Log\$ScriptName-$FileDate.html"
            }

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

Write-Output " - (1/3) - $(Get-Date -Format MM-dd-HH:mm) - Getting Incidents from RocketCyber"

#Region     [ RocketCyber API ]

    #Grabs Incidents from the RocketCyber API
    $Page_Number = 1
    $PageResults = [System.Collections.ArrayList]@()
    If ($Days){
        $TimeSpan = (Get-Date).AddDays([Int]$Days).ToUniversalTime()
        $Command = Get-RocketCyberIncidents -id $id -pageNumber $Page_Number -startDate $TimeSpan
    }
    Else{
        $Command = Get-RocketCyberIncidents -id $id -pageNumber $Page_Number
    }

        Do {
            $Current_Page = $Command
            Write-Verbose "Page $Page_Number of $($current_page.totalPages)"
            $PageResults += $Current_Page.data
            Write-Verbose "$($PageResults.count) records retrieved"
            $Page_Number++
        }
        While ( $current_page.totalPages -ne $Page_Number -1 -and $current_page.totalPages -ne 0)

        If ($PageResults.count -eq 0){
            Write-Host "No Incidents found" -ForegroundColor Yellow
            break
        }

    #Customize the results
        Try{
            $CustomerName = Get-RocketCyberAccount -id $id

            $RocketCyberIncidentResults = $PageResults | Select-Object `
                @{Name='customerName';Expression={$CustomerName.name}}, `
                @{Name='Status';Expression={$_.status}}, `
                @{Name='ID';Expression={$_.id}}, `
                @{Name='Title  ';Expression={$_.title}}, `
                @{Name='NeedsReview';Expression={   If ( ($_.updatedAt -lt (Get-Date).AddDays([Int]$Days).ToUniversalTime()) -and ($_.Status -eq 'open') ){'Yes'}
                                                    Else{$null}}}, `
                @{Name='resolvedAt';Expression={[DateTime]$_.resolvedAt | Get-Date -Format 'yyyy-MM-dd hh:mm'}}, `
                @{Name='publishedAt';Expression={[DateTime]$_.publishedAt | Get-Date -Format 'yyyy-MM-dd hh:mm'}}, `
                @{Name='createdAt';Expression={[DateTime]$_.createdAt | Get-Date -Format 'yyyy-MM-dd hh:mm'}}, `
                @{Name='updatedAt';Expression={[DateTime]$_.updatedAt | Get-Date -Format 'yyyy-MM-dd hh:mm'}}
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
            $RocketCyberIncidentResults | Select-Object $ScriptName,* | Export-Csv $CSVReport -NoTypeInformation
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
            $TotalIncidents = ($RocketCyberIncidentResults.id).count
            $ActiveIncidents = ($RocketCyberIncidentResults | Where-Object {$_.status -eq 'open' }).count

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
                $SummaryCards = $SummaryCards -replace ('xCARD1Valuex',$TotalIncidents)
                $SummaryCards = $SummaryCards -replace ('xCARD2Valuex',$ActiveIncidents)

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
            $TableResults = $RocketCyberIncidentResults | ConvertTo-Html -As Table -Fragment -Property customerName,Status,ID,Title,NeedsReview,resolvedAt,updatedAt,createdAt `
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