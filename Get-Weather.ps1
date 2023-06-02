<#
.SYNOPSIS
Get the weather report for a city

.DESCRIPTION
Gets the weather report for a city from website - http://wttr.in/ courtsey Igor Chubin [Twitter- @igor_chubin]
By default the weather forecast will display for current conditions, today's and next two days' forecast.

.PARAMETER Location
    Name of City, Landmark, Airport, Area Codes, GPS Coordinates

.PARAMETER Unit
    Optional parameter. Choose one of the following options:
    m - metric (SI) (used by default everywhere except US)
    u - USCS (used by default in US)
    M - show wind speed in m/s

.PARAMETER ViewOptions
    Optional parameter. Combine 1 or more of the following values:
    n - narrow version (only day and night)
    q - quiet version (no "Weather report" text)
    Q - superquiet version (no "Weather report", no city name)

.PARAMETER Current
    Switch to include current weather conditions

.PARAMETER Today
    Switch to include current and today's weather report

.PARAMETER Tomorrow
    Switch to include current, today's and tomorrow's weather report

.EXAMPLE
    Get the weather report for a city
    Get-Weather "New York"

.EXAMPLE
    Get the weather report for a landmark
    Get-Weather "~Golden+Gate+Bridge"

.EXAMPLE
    Get the weather report for an airport
    Get-Weather "~Golden Gate Bridge" -DayAfterTomorrow

.EXAMPLE
    Get the weather report for a city piped to this function.
    "New York" | Get-Weather

.EXAMPLE
    Get the weather report by area code.
    Get-Weather 90210

.EXAMPLE
    Get the weather report by GPS coordiantes.
    Get-Weather "-78.46,106.79"

.EXAMPLE
    Get the weather report for a city piped to this function.
    "New York" | Get-Weather

.NOTES
#>
Function Get-Weather {
    [Alias('Wttr')]
    [Cmdletbinding()]
    Param(
            [Parameter(
                HelpMessage = 'Enter name of the City or Landmark or Airport Code to get the weather report for that location.',
                Mandatory = $true,
                Position = 0,
                ValueFromPipeline = $true
            )]
            [string] $Location,

            [Parameter(
                HelpMessage = 'Enter a unit (m, U, or M). Default is U.',
                Position = 1
            )]
            [ValidateSet("m", "u", "M")]
            [string] $Unit = "u",

            [Parameter(
                HelpMessage = 'Enter a view option (m, U, or M). Default is 1.',
                Position = 2
            )]
            [ValidateSet("n", "q", "Q", "T")]
            [string[]] $ViewOptions = "F",

            [switch] $Current,
            [switch] $Today,
            [switch] $Tomorrow
    )

    Process
    {
        # Foreach($Item in $City){
            try {

                Write-Verbose -Message "Location is $Location"
                Write-Verbose -Message "Unit is $Unit"
                Write-Verbose -Message "View Option is $ViewOptions"

                Write-Verbose -Message "Building URL string"

                $Url = "https://wttr.in/$Location"
                $Url += "?"

                $ForecastDays = -1

                if($Current) {
                    $ForecastDays = 0
                }

                if($Today) {
                    $ForecastDays = 1
                }

                if($Tomorrow) {
                    $ForecastDays = 2
                }

                if($ForecastDays -ne -1) {
                    $Url += "$ForecastDays"
                }

                if ($Unit) {
                    $Url += $Unit
                }
                else {
                    $Url += "u"
                }

                Write-Verbose -Message "Join all elements of ViewOption array"
                
                $Url += -join $ViewOptions
                if($ViewOptions -notcontains "F") {
                    $URL += "F"
                }

                Write-Verbose "URL is $Url"

                (Invoke-WebRequest $Url).Content
            }
            catch {
                $_.exception.Message
            }
        # }            
    }

}
