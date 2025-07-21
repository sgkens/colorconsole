function Format-TerminalText {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$String,

        [Parameter(Mandatory = $false)]
        [switch]$Bold,

        [Parameter(Mandatory = $false)]
        [switch]$Italic,

        [Parameter(Mandatory = $false)]
        [switch]$Underline,

        [Parameter(Mandatory = $false)]
        [switch]$Strikethrough,

        [Parameter(Mandatory = $false)]
        [switch]$Invert, # Swap foreground and background colors

        [Parameter(Mandatory = $false)]
        [switch]$Conceal # Hide text (useful for passwords)
    )

    $escapeSequence = [char]27
    $reset = "${escapeSequence}[0m"
    $formatCodes = @()

    if ($Bold) { $formatCodes += "1" }
    if ($Italic) { $formatCodes += "3" }
    if ($Underline) { $formatCodes += "4" }
    if ($Strikethrough) { $formatCodes += "9" }
    if ($Invert) { $formatCodes += "7" }
    if ($Conceal) { $formatCodes += "8" }

    if ($formatCodes.Count -gt 0) {
        $codeString = $formatCodes -join ";"
        return "${escapeSequence}[${codeString}m$String$reset"
    }
    else {
        return $String # Return original string if no formatting is applied
    }
}

$cmdlet_config = @{
    function = @(
        "Format-TerminalText"
    )
    alias = @(
        "ftxt"
    )
}

Export-ModuleMember @cmdlet_config