function New-TrueColor {
    [CmdletBinding()]
    [Alias('tsole')]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$String,
        
        [Parameter(Mandatory = $false, Position = 1, ParameterSetName = 'Hex')]
        [string]$Hex,
        
        [Parameter(Mandatory = $false, ParameterSetName = 'RGB')]
        [ValidateRange(0, 255)]
        [int]$Red,
        
        [Parameter(Mandatory = $false, ParameterSetName = 'RGB')]
        [ValidateRange(0, 255)]
        [int]$Green,
        
        [Parameter(Mandatory = $false, ParameterSetName = 'RGB')]
        [ValidateRange(0, 255)]
        [int]$Blue,
        
        [Parameter(Mandatory = $false)]
        [string]$BackgroundHex,
        
        [Parameter(Mandatory = $false)]
        [ValidateRange(0, 255)]
        [int]$BackgroundRed,
        
        [Parameter(Mandatory = $false)]
        [ValidateRange(0, 255)]
        [int]$BackgroundGreen,
        
        [Parameter(Mandatory = $false)]
        [ValidateRange(0, 255)]
        [int]$BackgroundBlue
    )
    
    $escapeSequence = [char]27
    $reset = "${escapeSequence}[0m"
    
    # Determine RGB values for foreground
    if ($PSCmdlet.ParameterSetName -eq 'Hex') {
        if (-not $Hex) {
            # Default to white if no hex specified
            $Hex = '#FFFFFF'
        }
        try {
            $rgb = ConvertFrom-HexToRgb -HexColor $Hex
            $r = $rgb.R
            $g = $rgb.G
            $b = $rgb.B
        }
        catch {
            Write-Error "Invalid hex color: $Hex"
            return $String
        }
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'RGB') {
        $r = if ($Red -ne $null) { $Red } else { 255 }
        $g = if ($Green -ne $null) { $Green } else { 255 }
        $b = if ($Blue -ne $null) { $Blue } else { 255 }
    }
    else {
        # Default to white
        $r = 255
        $g = 255
        $b = 255
    }
    
    # Build the color string
    $colorString = "${escapeSequence}[38;2;${r};${g};${b}m$String"
    
    # Add background color if specified
    if ($BackgroundHex) {
        try {
            $bgRgb = ConvertFrom-HexToRgb -HexColor $BackgroundHex
            $colorString = "${escapeSequence}[48;2;$($bgRgb.R);$($bgRgb.G);$($bgRgb.B)m$colorString"
        }
        catch {
            Write-Warning "Invalid background hex color: $BackgroundHex"
        }
    }
    elseif ($BackgroundRed -ne $null -or $BackgroundGreen -ne $null -or $BackgroundBlue -ne $null) {
        $bgR = if ($BackgroundRed -ne $null) { $BackgroundRed } else { 0 }
        $bgG = if ($BackgroundGreen -ne $null) { $BackgroundGreen } else { 0 }
        $bgB = if ($BackgroundBlue -ne $null) { $BackgroundBlue } else { 0 }
        $colorString = "${escapeSequence}[48;2;${bgR};${bgG};${bgB}m$colorString"
    }
    
    return "$colorString$reset"
}

$cmdlet_config = @{
    function = @(
        'New-TrueColor'
    )
    alias = @(
        'tsole'
    )
}

Export-ModuleMember @cmdlet_config