<#
    .SYNOPSIS
        Creates an adaptive color string for use in console output.

    .DESCRIPTION
        The New-AdaptiveColor function takes a string and an optional color, and returns the string with the specified color.

    .PARAMETER String
        The input string to be colorized.
    
    .PARAMETER HexColor
        The color to be applied to the string.
    
    .PARAMETER BackgroundHex
        The background color to be applied to the string.
    
    .PARAMETER ForceDepth
        The depth of the color to be applied to the string.
    
    .PARAMETER Format
        The formatting to be applied to the string.

    .EXAMPLE
        New-AdaptiveColor -String "Hello World" -HexColor "#FF0000"
        New-AdaptiveColor -String "Hello World" -HexColor "#FF0000" -BackgroundHex "#00FF00"
#>
function New-AdaptiveColor {
    [CmdletBinding()]
    [Alias('acole')]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$String,

        [Parameter(Mandatory = $false, Position = 1)]
        [string]$HexColor, # Made optional as formatting can be applied without color

        [Parameter(Mandatory = $false)]
        [string]$BackgroundHex,

        [Parameter(Mandatory = $false)]
        [ValidateSet('4bit', '8bit', '24bit', 'auto')]
        [string]$ForceDepth = 'auto',

        [Parameter(Mandatory = $false)]
        [ValidateSet('Bold', 'Italic', 'Underline', 'Strikethrough', 'Invert', 'Conceal')]
        [string[]]$Format # New parameter for formatting
    )

    $escapeSequence = [char]27
    $reset = "${escapeSequence}[0m"
    $fullCodeParts = @()

    # --- Handle Formatting ---
    if ($Format) {
        $formatMap = @{
            'Bold'          = '1'
            'Italic'        = '3'
            'Underline'     = '4'
            'Strikethrough' = '9'
            'Invert'        = '7'
            'Conceal'       = '8'
        }
        foreach ($f in $Format) {
            if ($formatMap.ContainsKey($f)) {
                $fullCodeParts += $formatMap[$f]
            }
        }
    }

    # --- Handle Colors ---
    $colorSupport = if ($ForceDepth -eq 'auto') { Get-ColorSupport } else { $ForceDepth }

    # Foreground Color
    if ($HexColor) {
        try {
            $rgb = ConvertFrom-HexToRgb -HexColor $HexColor
            $colorInfo = Convert-ColorDepth -Red $rgb.R -Green $rgb.G -Blue $rgb.B -TargetDepth $colorSupport
            $fullCodeParts += $colorInfo.Code
        }
        catch {
            Write-Warning "Invalid foreground hex color: $HexColor. Skipping foreground color."
        }
    }

    # Background Color
    if ($BackgroundHex) {
        try {
            $bgRgb = ConvertFrom-HexToRgb -HexColor $BackgroundHex
            $bgColorInfo = Convert-ColorDepth -Red $bgRgb.R -Green $bgRgb.G -Blue $bgRgb.B -TargetDepth $colorSupport

            switch ($colorSupport) {
                '24bit' {
                    $fullCodeParts += "48;2;$($bgRgb.R);$($bgRgb.G);$($bgRgb.B)"
                }
                '8bit' {
                    $fullCodeParts += "48;5;$($bgColorInfo.Index)"
                }
                '4bit' {
                    $bgColorCode = ([int]$bgColorInfo.Code + 10).ToString()
                    $fullCodeParts += $bgColorCode
                }
            }
        }
        catch {
            Write-Warning "Invalid background hex color: $BackgroundHex. Skipping background color."
        }
    }

    # Construct the final result string
    if ($fullCodeParts.Count -gt 0) {
        $codeString = $fullCodeParts -join ";"
        return "${escapeSequence}[${codeString}m$String$reset"
    }
    else {
        return $String # Return original string if no color or formatting is applied
    }
}

$cmdlet_config = @{
    function = @(
        'New-AdaptiveColor'
    )
    alias = @(
        'acole'
    )
}

Export-ModuleMember @cmdlet_config