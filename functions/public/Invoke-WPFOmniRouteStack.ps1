function Invoke-WPFOmniRouteStack {
    <#
    .SYNOPSIS
        Sets up OmniRoute local AI routing profile, OpenClaw agent environment, and OpenCode routing.
    #>
    [CmdletBinding()]
    param()

    Write-Host ">>> Starting OmniRoute, OpenClaw & OpenCode Setup..." -ForegroundColor Cyan

    $userProfile = $env:USERPROFILE
    $omnirouteDir = Join-Path $userProfile ".omniroute"
    $openclawDir = Join-Path $userProfile ".openclaw"
    $workspaceDir = Join-Path $openclawDir "workspace"

    # 1. Ensure directories exist
    foreach ($dir in @($omnirouteDir, $openclawDir, $workspaceDir)) {
        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
            Write-Host "Created directory: $dir" -ForegroundColor Green
        }
    }

    # 2. Provision .omniroute environment if not present
    $envFile = Join-Path $omnirouteDir ".env"
    if (-not (Test-Path $envFile)) {
        # Generate random 256-bit encryption key
        $bytes = New-Object byte[] 32
        [Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($bytes)
        $hexKey = ($bytes | ForEach-Object { $_.ToString("x2") }) -join ""
        "STORAGE_ENCRYPTION_KEY=$hexKey`n" | Set-Content -Path $envFile -Encoding utf8
        Write-Host "Generated OmniRoute storage encryption key at $envFile" -ForegroundColor Green
    }

    # 3. Check for OmniRoute installer
    $downloadsSetup = Join-Path $userProfile "Downloads\OmniRoute.Setup.3.8.49.exe"
    if (Test-Path $downloadsSetup) {
        Write-Host "Found OmniRoute installer in Downloads. Launching..." -ForegroundColor Cyan
        Start-Process -FilePath $downloadsSetup
    } else {
        Write-Host "OmniRoute configuration ready at $omnirouteDir." -ForegroundColor Green
    }

    # 4. Check for Node.js (prerequisite for OpenClaw)
    if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
        Write-Host "Node.js not detected. Installing Node.js LTS via winget..." -ForegroundColor Yellow
        try {
            winget install --id OpenJS.NodeJS.LTS -e --silent --accept-package-agreements --accept-source-agreements
        } catch {
            Write-Warning "Could not install Node.js automatically: $_"
        }
    }

    # 5. Initialize openclaw.json with OmniRoute & OpenCode configuration
    $openclawConfigFile = Join-Path $openclawDir "openclaw.json"
    if (-not (Test-Path $openclawConfigFile)) {
        Write-Host "Creating default OpenClaw + OmniRoute + OpenCode configuration..." -ForegroundColor Cyan
        $configObject = @{
            agents = @{
                defaults = @{
                    model = @{
                        primary = "omniroute/auto/smart"
                        fallbacks = @(
                            "omniroute/auto/best-chat",
                            "omniroute/auto/best-reasoning",
                            "omniroute/baseten/openai/gpt-oss-120b",
                            "omniroute/baseten/deepseek-ai/DeepSeek-V4-Pro"
                        )
                    }
                    models = @{
                        "omniroute/auto/smart" = @{}
                        "omniroute/auto/best-chat" = @{}
                        "omniroute/auto/best-reasoning" = @{}
                        "omniroute/auto/best-coding" = @{}
                        "omniroute/auto/best-fast" = @{}
                    }
                    workspace = $workspaceDir
                }
            }
            gateway = @{
                bind = "loopback"
                mode = "local"
                port = 18789
                controlUi = @{
                    allowInsecureAuth = $true
                }
                auth = @{
                    mode = "token"
                    token = [Guid]::NewGuid().ToString("N")
                }
            }
            models = @{
                providers = @{
                    omniroute = @{
                        baseUrl = "http://localhost:20128/v1"
                        api = "openai-completions"
                    }
                }
            }
            plugins = @{
                entries = @{
                    opencode = @{
                        enabled = $true
                    }
                }
            }
        }

        $configObject | ConvertTo-Json -Depth 6 | Set-Content -Path $openclawConfigFile -Encoding utf8
        Write-Host "OpenClaw configuration created at $openclawConfigFile" -ForegroundColor Green
    } else {
        Write-Host "Existing OpenClaw configuration preserved at $openclawConfigFile" -ForegroundColor Green
    }

    Write-Host ">>> OmniRoute, OpenClaw & OpenCode stack setup finished!" -ForegroundColor Green
}
