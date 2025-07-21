<#
.SYNOPSIS
    Fetect Console color support.
.DESCRIPTION
    Detects the color support capabilities of the terminal.
    Returns '24bit', '8bit', or '4bit' based on the terminal's capabilities.
    
#>
function Get-ColorSupport {
    <#
    .SYNOPSIS
        Detect terminal color support capabilities
    #>
    [CmdletBinding()]
    param()
    
    if ($env:TERM_PROGRAM -eq 'vscode' -or $env:TERM_PROGRAM -eq 'Windows Terminal') {
        return '24bit'
    }
    elseif ($env:COLORTERM -eq 'truecolor' -or $env:COLORTERM -eq '24bit') {
        return '24bit'
    }
    elseif ($env:TERM -match '256color') {
        return '8bit'
    }
    elseif ($PSVersionTable.PSVersion.Major -ge 7) {
        return '4bit'
    }
    else {
        return '4bit'
    }
}

$cmdlet_config = @{
    function = @(
        'Get-ColorSupport'
    )
}

Export-ModuleMember @cmdlet_config