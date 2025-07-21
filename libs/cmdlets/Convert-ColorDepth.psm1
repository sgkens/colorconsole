function Convert-ColorDepth {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateRange(0, 255)]
        [int]$Red,

        [Parameter(Mandatory = $true)]
        [ValidateRange(0, 255)]
        [int]$Green,

        [Parameter(Mandatory = $true)]
        [ValidateRange(0, 255)]
        [int]$Blue,

        [Parameter(Mandatory = $true)]
        [ValidateSet('4bit', '8bit', '24bit')]
        [string]$TargetDepth
    )

    switch ($TargetDepth) {
        '24bit' {
            # Return original RGB values
            return @{ R = $Red; G = $Green; B = $Blue; Code = "38;2;$Red;$Green;$Blue" }
        }

        '8bit' {
            # Convert RGB to 8-bit (216-color cube + grayscale)

            # First check if it's close to grayscale
            $grayThreshold = 10
            if ([Math]::Abs($Red - $Green) -lt $grayThreshold -and
                [Math]::Abs($Green - $Blue) -lt $grayThreshold -and
                [Math]::Abs($Red - $Blue) -lt $grayThreshold) {

                # Map to grayscale colors (232-255)
                $gray = [Math]::Round(($Red + $Green + $Blue) / 3.0)
                if ($gray -lt 8) { $index = 16 } # Use color 16 (black-ish)
                elseif ($gray -gt 238) { $index = 231 } # Use color 231 (white-ish)
                else {
                    $index = 232 + [Math]::Round(($gray - 8) / 10.0)
                    $index = [Math]::Min(255, [Math]::Max(232, $index))
                }
            }
            else {
                # Map to 216-color RGB cube (16-231)
                $r6 = [Math]::Round($Red / 51.0)  # 0-5 range
                $g6 = [Math]::Round($Green / 51.0)
                $b6 = [Math]::Round($Blue / 51.0)

                $r6 = [Math]::Min(5, [Math]::Max(0, $r6))
                $g6 = [Math]::Min(5, [Math]::Max(0, $g6))
                $b6 = [Math]::Min(5, [Math]::Max(0, $b6))

                $index = 16 + ($r6 * 36) + ($g6 * 6) + $b6
            }

            return @{ Index = $index; Code = "38;5;$index" }
        }

        '4bit' {
            # Convert RGB to closest 4-bit color (0-15)

            # Calculate luminance for bright vs normal
            $luminance = (0.299 * $Red + 0.587 * $Green + 0.114 * $Blue) / 255.0
            $isBright = $luminance -gt 0.5

            # Find the dominant color component
            $maxVal = [Math]::Max([Math]::Max($Red, $Green), $Blue)
            $minVal = [Math]::Min([Math]::Min($Red, $Green), $Blue)
            $saturation = if ($maxVal -eq 0) { 0 } else { ($maxVal - $minVal) / $maxVal }

            # If low saturation, it's grayscale
            if ($saturation -lt 0.3) {
                return @{
                    Index = if ($isBright) { 15 } else { 0 }  # White or Black
                    Code  = if ($isBright) { "97" } else { "30" }
                    Name  = if ($isBright) { "brightwhite" } else { "black" }
                }
            }

            # Determine primary color
            $colorIndex = 0
            $colorName = "black"
            $colorCode = "30"

            if ($Red -ge $Green -and $Red -ge $Blue) {
                # Red dominant
                if ($Green -gt $Blue * 1.5) {
                    # Red + Green = Yellow
                    $colorIndex = if ($isBright) { 11 } else { 3 }
                    $colorName = if ($isBright) { "brightyellow" } else { "yellow" }
                    $colorCode = if ($isBright) { "93" } else { "33" }
                }
                else {
                    # Pure Red
                    $colorIndex = if ($isBright) { 9 } else { 1 }
                    $colorName = if ($isBright) { "brightred" } else { "red" }
                    $colorCode = if ($isBright) { "91" } else { "31" }
                }
            }
            elseif ($Green -ge $Red -and $Green -ge $Blue) {
                # Green dominant
                if ($Blue -gt $Red * 1.5) {
                    # Green + Blue = Cyan
                    $colorIndex = if ($isBright) { 14 } else { 6 }
                    $colorName = if ($isBright) { "brightcyan" } else { "cyan" }
                    $colorCode = if ($isBright) { "96" } else { "36" }
                }
                else {
                    # Pure Green
                    $colorIndex = if ($isBright) { 10 } else { 2 }
                    $colorName = if ($isBright) { "brightgreen" } else { "green" }
                    $colorCode = if ($isBright) { "92" } else { "32" }
                }
            }
            else {
                # Blue dominant
                if ($Red -gt $Green * 1.5) {
                    # Blue + Red = Magenta
                    $colorIndex = if ($isBright) { 13 } else { 5 }
                    $colorName = if ($isBright) { "brightmagenta" } else { "magenta" }
                    $colorCode = if ($isBright) { "95" } else { "35" }
                }
                else {
                    # Pure Blue
                    $colorIndex = if ($isBright) { 12 } else { 4 }
                    $colorName = if ($isBright) { "brightblue" } else { "blue" }
                    $colorCode = if ($isBright) { "94" } else { "34" }
                }
            }

            return @{
                Index = $colorIndex
                Code  = $colorCode
                Name  = $colorName
            }
        }
    }
}

$cmdlet_config = @{
    function = @(
        'Convert-ColorDepth'
    )
    alias = @(
        'cdepth'
    )
}

Export-ModuleMember @cmdlet_config