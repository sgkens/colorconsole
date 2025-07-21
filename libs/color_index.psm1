# 4-bit ANSI colors (0-15)
$ascii_4bit = @{
    'black'         = @{ color = 'black'; code = '30'; description = 'Black foreground' }
    'red'           = @{ color = 'red'; code = '31'; description = 'Red foreground' }
    'green'         = @{ color = 'green'; code = '32'; description = 'Green foreground' }
    'yellow'        = @{ color = 'yellow'; code = '33'; description = 'Yellow foreground' }
    'blue'          = @{ color = 'blue'; code = '34'; description = 'Blue foreground' }
    'magenta'       = @{ color = 'magenta'; code = '35'; description = 'Magenta foreground' }
    'cyan'          = @{ color = 'cyan'; code = '36'; description = 'Cyan foreground' }
    'white'         = @{ color = 'white'; code = '37'; description = 'White foreground' }
    'brightblack'   = @{ color = 'brightblack'; code = '90'; description = 'Bright black (gray) foreground' }
    'brightred'     = @{ color = 'brightred'; code = '91'; description = 'Bright red foreground' }
    'brightgreen'   = @{ color = 'brightgreen'; code = '92'; description = 'Bright green foreground' }
    'brightyellow'  = @{ color = 'brightyellow'; code = '93'; description = 'Bright yellow foreground' }
    'brightblue'    = @{ color = 'brightblue'; code = '94'; description = 'Bright blue foreground' }
    'brightmagenta' = @{ color = 'brightmagenta'; code = '95'; description = 'Bright magenta foreground' }
    'brightcyan'    = @{ color = 'brightcyan'; code = '96'; description = 'Bright cyan foreground' }
    'brightwhite'   = @{ color = 'brightwhite'; code = '97'; description = 'Bright white foreground' }
}

# 8-bit ANSI colors (0-255)
$ascii_8bit = @{}

# Standard colors (0-15) - same as 4-bit
for ($i = 0; $i -le 15; $i++) {
    $colorName = switch ($i) {
        0 { 'black' }
        1 { 'red' }
        2 { 'green' }
        3 { 'yellow' }
        4 { 'blue' }
        5 { 'magenta' }
        6 { 'cyan' }
        7 { 'white' }
        8 { 'brightblack' }
        9 { 'brightred' }
        10 { 'brightgreen' }
        11 { 'brightyellow' }
        12 { 'brightblue' }
        13 { 'brightmagenta' }
        14 { 'brightcyan' }
        15 { 'brightwhite' }
    }
    $ascii_8bit[$i.ToString()] = @{ color = $colorName; code = $i; description = "8-bit color $i ($colorName)" }
}

# 216 RGB colors (16-231)
for ($i = 16; $i -le 231; $i++) {
    $n = $i - 16
    $r = [math]::Floor($n / 36)
    $g = [math]::Floor(($n % 36) / 6)
    $b = $n % 6
    
    $rVal = if ($r -eq 0) { 0 } else { 55 + $r * 40 }
    $gVal = if ($g -eq 0) { 0 } else { 55 + $g * 40 }
    $bVal = if ($b -eq 0) { 0 } else { 55 + $b * 40 }
    
    $ascii_8bit[$i.ToString()] = @{ 
        color       = "rgb($rVal,$gVal,$bVal)"; 
        code        = $i; 
        description = "8-bit RGB color $i (R:$rVal G:$gVal B:$bVal)" 
    }
}

# Grayscale colors (232-255)
for ($i = 232; $i -le 255; $i++) {
    $gray = 8 + ($i - 232) * 10
    $ascii_8bit[$i.ToString()] = @{ 
        color       = "gray$gray"; 
        code        = $i; 
        description = "8-bit grayscale color $i (Gray level: $gray)" 
    }
}

# 24-bit colors (RGB values)
$ascii_24bit = @{
    'info'       = @{ 
        color       = 'truecolor'; 
        code        = '38;2;r;g;b'; 
        description = '24-bit true color format: ESC[38;2;r;g;b;m where r,g,b are 0-255' 
    }
    'background' = @{ 
        color       = 'truecolor_bg'; 
        code        = '48;2;r;g;b'; 
        description = '24-bit true color background: ESC[48;2;r;g;b;m where r,g,b are 0-255' 
    }
}