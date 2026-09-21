Function Show-CTTLogo {
    <#
        .SYNOPSIS
            Displays the Amajid WinUtil logo in ASCII art.
        .DESCRIPTION
            This function displays the logo in ASCII art format.
        .PARAMETER None
            No parameters are required for this function.
        .EXAMPLE
            Show-CTTLogo
    #>

    $asciiArt = @"
    _                     _ _     _  __        ___       _   _ _
   / \   _ __ ___   __ _ (_) (_) __| | \ \      / (_)_ __ | | | | |_(_) |
  / _ \ | '_ ` _ \ / _` || | | |/ _` |  \ \ /\ / /| | '_ \| | | | __| | |
 / ___ \| | | | | | (_| || | | | (_| |   \ V  V / | | | | | |_| | |_| | |
/_/   \_\_| |_| |_|\__,_|/ | |_|\__,_|    \_/\_/  |_|_| |_|\___/ \__|_|_|
                       |__/

================ Amajid Windows Utility ================
================= Custom Toolbox & Dev =================
"@

    Write-Host $asciiArt -ForegroundColor Cyan
}

