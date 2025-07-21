function New-PalletColor {
    [CmdletBinding()]
    [Alias('psole')]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$String,
        
        [Parameter(Mandatory = $false, Position = 1, ParameterSetName = 'ByCode')]
        [ValidateRange(0, 255)]
        [int]$Code,
        
        [Parameter(Mandatory = $false, Position = 1, ParameterSetName = 'ByColor')]
        [string]$Color,
        
        [Parameter(Mandatory = $false)]
        [ValidateRange(0, 255)]
        [int]$BackgroundCode
    )
    
    $escapeSequence = [char]27
    $reset = "${escapeSequence}[0m"
    
    # Determine the color code to use
    if ($PSCmdlet.ParameterSetName -eq 'ByCode') {
        $colorCode = $Code
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'ByColor') {
        if ($ascii_8bit.ContainsKey($Color)) {
            $colorCode = $ascii_8bit[$Color].code
        }
        else {
            # Try to find by color name
            $foundColor = $ascii_8bit.GetEnumerator() | Where-Object { $_.Value.color -eq $Color } | Select-Object -First 1
            if ($foundColor) {
                $colorCode = $foundColor.Value.code
            }
            else {
                Write-Warning "Color '$Color' not found in 8-bit palette. Using default."
                return $String
            }
        }
    }
    else {
        # Default to white if no color specified
        $colorCode = 7
    }
    
    # Build the color string
    $colorString = "${escapeSequence}[38;5;${colorCode}m$String"
    
    # Add background color if specified
    if ($BackgroundCode -ne $null) {
        $colorString = "${escapeSequence}[48;5;${BackgroundCode}m$colorString"
    }
    
    return "$colorString$reset"
}

$cmdlet_config = @{
    function = @(
        'New-PalletColor'
    )
    alias = @(
        'psole'
    )
}

Export-ModuleMember @cmdlet_config