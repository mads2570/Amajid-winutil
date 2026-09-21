function Invoke-WPFZapret {
    <#
    .SYNOPSIS
        Installs, configures, or removes Zapret (winws) as a Windows Service or portable tool.
    .PARAMETER Action
        'InstallService', 'RemoveService', or 'RunInteractive'
    .PARAMETER Preset
        'DiscordYoutube' or 'General'
    #>
    [CmdletBinding()]
    param(
        [ValidateSet('InstallService', 'RemoveService', 'RunInteractive')]
        [string]$Action = 'InstallService',
        [ValidateSet('DiscordYoutube', 'General')]
        [string]$Preset = 'DiscordYoutube'
    )

    $installDir = "$env:ProgramFiles\Zapret"
    $serviceName = "zapret"

    if ($Action -eq 'RemoveService') {
        Write-Host ">>> Stopping and removing Zapret Service..." -ForegroundColor Yellow
        Stop-Service -Name $serviceName -ErrorAction SilentlyContinue
        & sc.exe delete $serviceName | Out-Null

        # Also clean up WinDivert driver service if lingering
        Stop-Service -Name "WinDivert" -ErrorAction SilentlyContinue
        & sc.exe delete "WinDivert" | Out-Null
        Write-Host "Zapret Service removed." -ForegroundColor Green
        return
    }

    if (-not (Test-Path $installDir)) {
        New-Item -ItemType Directory -Path $installDir -Force | Out-Null
    }

    $winwsExe = "$installDir\bin\winws.exe"
    if (-not (Test-Path $winwsExe)) {
        $winwsExe = "$installDir\winws.exe"
    }

    # If not installed yet, download from flowseal/zapret-discord-youtube or bol-van/zapret
    if (-not (Test-Path $winwsExe)) {
        Write-Host ">>> Fetching latest Zapret Windows release..." -ForegroundColor Cyan
        try {
            $apiUrl = "https://api.github.com/repos/flowseal/zapret-discord-youtube/releases/latest"
            $releaseInfo = Invoke-RestMethod -Uri $apiUrl -UseBasicParsing
            $asset = $releaseInfo.assets | Where-Object { $_.name -like "*.zip" } | Select-Object -First 1
            $zipPath = "$env:TEMP\zapret.zip"

            Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zipPath -UseBasicParsing

            $tempExtract = "$env:TEMP\zapret_extract"
            if (Test-Path $tempExtract) { Remove-Item $tempExtract -Recurse -Force }
            Expand-Archive -Path $zipPath -DestinationPath $tempExtract -Force

            $innerDir = (Get-ChildItem -Path $tempExtract -Directory | Select-Object -First 1).FullName
            if ($null -eq $innerDir) { $innerDir = $tempExtract }
            Copy-Item -Path "$innerDir\*" -Destination $installDir -Recurse -Force
            Remove-Item $zipPath -Force -ErrorAction SilentlyContinue
            Remove-Item $tempExtract -Recurse -Force -ErrorAction SilentlyContinue

            $winwsExe = "$installDir\bin\winws.exe"
            if (-not (Test-Path $winwsExe)) {
                $winwsExe = "$installDir\winws.exe"
            }
            Write-Host "Zapret downloaded to $installDir." -ForegroundColor Green
        } catch {
            Write-Error "Failed to download Zapret: $_"
            return
        }
    }

    $argsString = if ($Preset -eq 'DiscordYoutube') {
        "--wf-raw=@`"$installDir\rules.txt`" --wf-l3=ipv4,ipv6 --wf-tcp=80,443 --wf-udp=443,50000-65535 --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig"
    } else {
        "--wf-l3=ipv4,ipv6 --wf-tcp=80,443 --dpi-desync=fake,split --dpi-desync-autottl=2"
    }

    if ($Action -eq 'InstallService') {
        Write-Host ">>> Configuring Zapret (winws) as Windows Service..." -ForegroundColor Cyan
        Stop-Service -Name $serviceName -ErrorAction SilentlyContinue
        & sc.exe delete $serviceName | Out-Null

        # If a service_install.bat exists in package, run it or configure via sc.exe
        $serviceBat = Get-ChildItem -Path $installDir -Filter "service_install.bat" -Recurse | Select-Object -First 1
        if ($serviceBat) {
            Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$($serviceBat.FullName)`"" -Wait -WindowStyle Hidden
        } else {
            $binPath = "`"$winwsExe`" $argsString"
            & sc.exe create $serviceName binPath= $binPath start= auto displayName= "Zapret DPI Circumvention Service" | Out-Null
            & sc.exe description $serviceName "Bypasses SNI and DPI filtering using winws packet desync." | Out-Null
            Start-Service -Name $serviceName -ErrorAction SilentlyContinue
        }
        Write-Host "Zapret Service installed successfully." -ForegroundColor Green
    } elseif ($Action -eq 'RunInteractive') {
        Write-Host ">>> Launching Zapret in interactive mode..." -ForegroundColor Cyan
        Start-Process -FilePath $winwsExe -ArgumentList $argsString
    }
}
