function ConvertFrom-HexToRgb {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$HexColor
    )
    
    # Remove # if present
    $hex = $HexColor.TrimStart('#')
    
    # Validate hex format
    if ($hex.Length -ne 6 -or $hex -notmatch '^[0-9A-Fa-f]+$') {
        throw "Invalid hex color format. Use format: #RRGGBB or RRGGBB"
    }
    
    $r = [Convert]::ToInt32($hex.Substring(0, 2), 16)
    $g = [Convert]::ToInt32($hex.Substring(2, 2), 16)
    $b = [Convert]::ToInt32($hex.Substring(4, 2), 16)
    
    return @{ R = $r; G = $g; B = $b }
}

$cmdlet_config = @{
    function = @(
        'ConvertFrom-HexToRgb'
    )
}

Export-ModuleMember @cmdlet_config