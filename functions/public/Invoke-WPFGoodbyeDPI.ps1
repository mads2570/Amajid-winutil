function Invoke-WPFGoodbyeDPI {
    <#
    .SYNOPSIS
        Installs, configures, or removes GoodbyeDPI as a Windows Service or portable tool.
    .PARAMETER Action
        'InstallService', 'RemoveService', or 'RunInteractive'
    .PARAMETER Mode
        Preset mode, default is '1' (standard balanced DPI circumvention)
    #>
    [CmdletBinding()]
    param(
        [ValidateSet('InstallService', 'RemoveService', 'RunInteractive')]
        [string]$Action = 'InstallService',
        [string]$Mode = '-1 -p -r -s -e 1 -k 1 -n -e 2'
    )

    $installDir = "$env:ProgramFiles\GoodbyeDPI"
    $serviceName = "GoodbyeDPI"

    if ($Action -eq 'RemoveService') {
        Write-Host ">>> Stopping and removing GoodbyeDPI Service..." -ForegroundColor Yellow
        Stop-Service -Name $serviceName -ErrorAction SilentlyContinue
        & sc.exe delete $serviceName | Out-Null
        Write-Host "GoodbyeDPI Service removed." -ForegroundColor Green
        return
    }

    # Ensure target directory exists
    if (-not (Test-Path $installDir)) {
        New-Item -ItemType Directory -Path $installDir -Force | Out-Null
    }

    $exePath = "$installDir\x86_64\goodbyedpi.exe"

    if (-not (Test-Path $exePath)) {
        Write-Host ">>> Fetching latest GoodbyeDPI from GitHub..." -ForegroundColor Cyan
        try {
            $apiUrl = "https://api.github.com/repos/ValdikSS/GoodbyeDPI/releases/latest"
            $releaseInfo = Invoke-RestMethod -Uri $apiUrl -UseBasicParsing
            $asset = $releaseInfo.assets | Where-Object { $_.name -like "*.zip" } | Select-Object -First 1
            $zipPath = "$env:TEMP\goodbyedpi.zip"

            Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zipPath -UseBasicParsing

            $tempExtract = "$env:TEMP\goodbyedpi_extract"
            if (Test-Path $tempExtract) { Remove-Item $tempExtract -Recurse -Force }
            Expand-Archive -Path $zipPath -DestinationPath $tempExtract -Force

            $innerDir = (Get-ChildItem -Path $tempExtract -Directory | Select-Object -First 1).FullName
            Copy-Item -Path "$innerDir\*" -Destination $installDir -Recurse -Force
            Remove-Item $zipPath -Force -ErrorAction SilentlyContinue
            Remove-Item $tempExtract -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "GoodbyeDPI downloaded successfully to $installDir." -ForegroundColor Green
        } catch {
            Write-Error "Failed to download GoodbyeDPI: $_"
            return
        }
    }

    if ($Action -eq 'InstallService') {
        Write-Host ">>> Configuring GoodbyeDPI as a Windows Service..." -ForegroundColor Cyan
        Stop-Service -Name $serviceName -ErrorAction SilentlyContinue
        & sc.exe delete $serviceName | Out-Null

        $binPath = "`"$exePath`" $Mode"
        & sc.exe create $serviceName binPath= $binPath start= auto displayName= "GoodbyeDPI Passive DPI Blocker" | Out-Null
        & sc.exe description $serviceName "Bypasses Deep Packet Inspection systems using WinDivert driver." | Out-Null
        Start-Service -Name $serviceName -ErrorAction SilentlyContinue
        Write-Host "GoodbyeDPI Service installed and started (Automatic)." -ForegroundColor Green
    } elseif ($Action -eq 'RunInteractive') {
        Write-Host ">>> Launching GoodbyeDPI in interactive console mode..." -ForegroundColor Cyan
        Start-Process -FilePath $exePath -ArgumentList $Mode
    }
}
