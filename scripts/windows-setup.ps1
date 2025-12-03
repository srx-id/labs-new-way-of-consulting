#Requires -Version 5.1
<#
.SYNOPSIS
    SRX Data Science Labs - Windows Setup Script (Doctor Mode)

.DESCRIPTION
    Like a doctor examining a patient - diagnoses your environment health first,
    then automatically treats (installs) what's missing using winget.

.NOTES
    Prerequisites: PowerShell 5.1+ (comes with Windows 10/11)
    NO WSL required - pure Windows native setup
    NO Admin required - uses user-scope installations
#>

param(
    [switch]$DiagnoseOnly,
    [switch]$Verbose
)

# ============================================================================
# Configuration
# ============================================================================
$REQUIRED_PYTHON_VERSION = "3.12"
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$PROJECT_ROOT = Split-Path -Parent $SCRIPT_DIR

# Colors for output
function Write-Color {
    param(
        [string]$Text,
        [string]$Color = "White"
    )
    Write-Host $Text -ForegroundColor $Color
}

function Write-Success { param([string]$Text) Write-Color "[OK] $Text" "Green" }
function Write-Warning { param([string]$Text) Write-Color "[WARNING] $Text" "Yellow" }
function Write-Failure { param([string]$Text) Write-Color "[FAIL] $Text" "Red" }
function Write-Info { param([string]$Text) Write-Color "[INFO] $Text" "Cyan" }
function Write-Header {
    param([string]$Text)
    Write-Host ""
    Write-Color "=== $Text ===" "Magenta"
}

# ============================================================================
# Check if winget is available
# ============================================================================
function Test-Winget {
    try {
        $null = & winget --version 2>&1
        return $true
    } catch {
        return $false
    }
}

$script:HasWinget = Test-Winget

# ============================================================================
# Installation Functions (Auto-execute)
# ============================================================================

function Install-WithWinget {
    param(
        [string]$PackageId,
        [string]$Name
    )

    if (-not $script:HasWinget) {
        Write-Failure "winget not available. Please install manually."
        return $false
    }

    Write-Info "Installing $Name via winget..."
    Write-Info "Running: winget install -e --id $PackageId --accept-source-agreements --accept-package-agreements"

    try {
        # Use --scope user to avoid admin requirement where possible
        $result = & winget install -e --id $PackageId --accept-source-agreements --accept-package-agreements 2>&1
        Write-Host $result

        if ($LASTEXITCODE -eq 0) {
            Write-Success "$Name installed successfully!"
            Write-Warning "You may need to restart your terminal for changes to take effect."
            return $true
        } else {
            Write-Failure "Failed to install $Name. Exit code: $LASTEXITCODE"
            return $false
        }
    } catch {
        Write-Failure "Error installing $Name : $_"
        return $false
    }
}

function Install-UV-Direct {
    Write-Info "Installing uv via PowerShell script..."
    Write-Info "Running: irm https://astral.sh/uv/install.ps1 | iex"

    try {
        # This installs to user directory, no admin needed
        Invoke-Expression (Invoke-RestMethod https://astral.sh/uv/install.ps1)

        # Refresh PATH
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","User") + ";" + [System.Environment]::GetEnvironmentVariable("Path","Machine")

        Write-Success "uv installed successfully!"
        return $true
    } catch {
        Write-Failure "Failed to install uv: $_"
        return $false
    }
}

# ============================================================================
# Diagnostic Functions
# ============================================================================

function Test-WindowsVersion {
    Write-Header "Doctor's Examination: Operating System"

    $osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
    $version = $osInfo.Version
    $name = $osInfo.Caption

    Write-Info "OS: $name"
    Write-Info "Version: $version"

    $majorVersion = [int]($version.Split('.')[0])
    if ($majorVersion -ge 10) {
        Write-Success "Windows 10 or later detected"
        return $true
    } else {
        Write-Failure "Windows 10 or later required"
        return $false
    }
}

function Test-AndInstall-Python {
    Write-Header "Doctor's Examination: Python"

    # Try different Python commands
    $pythonCommands = @("python", "python3", "py")
    $pythonFound = $false
    $pythonCmd = ""
    $pythonVer = ""

    foreach ($cmd in $pythonCommands) {
        try {
            $output = & $cmd --version 2>&1
            if ($output -match "Python (\d+\.\d+\.\d+)") {
                $pythonVer = $Matches[1]
                $pythonCmd = $cmd
                $pythonFound = $true
                break
            }
        } catch {
            continue
        }
    }

    if (-not $pythonFound) {
        Write-Failure "Python not found"

        if (-not $DiagnoseOnly) {
            Write-Host ""
            $response = Read-Host "Install Python 3.12 now? (Y/n)"
            if ($response -eq "" -or $response -match "^[Yy]") {
                Install-WithWinget "Python.Python.3.12" "Python 3.12"
                Write-Warning "Please RESTART your terminal after installation, then run this script again."
                return $false
            }
        }
        return $false
    }

    Write-Info "Found: Python $pythonVer (command: $pythonCmd)"

    # Check version meets requirement
    $versionParts = $pythonVer.Split('.')
    $major = [int]$versionParts[0]
    $minor = [int]$versionParts[1]

    $requiredParts = $REQUIRED_PYTHON_VERSION.Split('.')
    $reqMajor = [int]$requiredParts[0]
    $reqMinor = [int]$requiredParts[1]

    if ($major -gt $reqMajor -or ($major -eq $reqMajor -and $minor -ge $reqMinor)) {
        Write-Success "Python version $pythonVer meets requirement (>= $REQUIRED_PYTHON_VERSION)"
        return $true
    } else {
        Write-Failure "Python $pythonVer is below required version $REQUIRED_PYTHON_VERSION"

        if (-not $DiagnoseOnly) {
            Write-Host ""
            $response = Read-Host "Install Python 3.12 now? (Y/n)"
            if ($response -eq "" -or $response -match "^[Yy]") {
                Install-WithWinget "Python.Python.3.12" "Python 3.12"
                Write-Warning "Please RESTART your terminal after installation, then run this script again."
            }
        }
        return $false
    }
}

function Test-AndInstall-UV {
    Write-Header "Doctor's Examination: uv Package Manager"

    try {
        $output = & uv --version 2>&1
        if ($output -match "uv (\d+\.\d+\.\d+)") {
            $uvVersion = $Matches[1]
            Write-Success "uv $uvVersion is installed"
            return $true
        }
    } catch {
        # uv not found
    }

    Write-Failure "uv is not installed"
    Write-Info "uv is a fast Python package manager (10-100x faster than pip)"

    if (-not $DiagnoseOnly) {
        Write-Host ""
        $response = Read-Host "Install uv now? (Y/n)"
        if ($response -eq "" -or $response -match "^[Yy]") {
            # Try direct install first (no admin needed)
            if (Install-UV-Direct) {
                return $true
            }
            # Fallback to winget
            Install-WithWinget "astral-sh.uv" "uv"
            Write-Warning "Please RESTART your terminal after installation, then run this script again."
        }
    }
    return $false
}

function Test-AndInstall-Git {
    Write-Header "Doctor's Examination: Git"

    try {
        $output = & git --version 2>&1
        if ($output -match "git version (\d+\.\d+\.\d+)") {
            $gitVersion = $Matches[1]
            Write-Success "Git $gitVersion is installed"
            return $true
        }
    } catch {
        # git not found
    }

    Write-Warning "Git is not installed"
    Write-Info "Git is optional but recommended for version control"

    if (-not $DiagnoseOnly) {
        Write-Host ""
        $response = Read-Host "Install Git now? (Y/n)"
        if ($response -eq "" -or $response -match "^[Yy]") {
            Install-WithWinget "Git.Git" "Git"
            Write-Warning "Please RESTART your terminal after installation."
        }
    }
    return $false
}

function Test-Make {
    Write-Header "Doctor's Examination: GNU Make (Optional)"

    try {
        $output = & make --version 2>&1
        if ($output -match "GNU Make (\d+\.\d+)") {
            $makeVersion = $Matches[1]
            Write-Success "GNU Make $makeVersion is installed"
            return $true
        }
    } catch {
        # make not found
    }

    Write-Warning "GNU Make is not installed (optional)"
    Write-Info "Without Make, you can still run commands directly:"
    Write-Info "  Instead of 'make setup' -> use: uv sync"
    Write-Info "  Instead of 'make run'   -> use: uv run streamlit run app.py"
    Write-Info ""
    Write-Info "To install Make (may require admin):"
    Write-Info "  winget install GnuWin32.Make"

    return $false
}

function Test-IDETools {
    Write-Header "Doctor's Examination: AI Coding Tools"

    $ideTools = @(
        @{
            Name = "Claude Code"
            Commands = @("claude")
            CheckType = "command"
        },
        @{
            Name = "Cursor"
            Paths = @(
                "$env:LOCALAPPDATA\Programs\cursor\Cursor.exe",
                "$env:PROGRAMFILES\Cursor\Cursor.exe"
            )
            CheckType = "path"
        },
        @{
            Name = "VS Code"
            Commands = @("code")
            Paths = @(
                "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe",
                "$env:PROGRAMFILES\Microsoft VS Code\Code.exe"
            )
            CheckType = "both"
        },
        @{
            Name = "Aider"
            Commands = @("aider")
            CheckType = "command"
        },
        @{
            Name = "Windsurf"
            Commands = @("windsurf")
            Paths = @(
                "$env:LOCALAPPDATA\Programs\windsurf\Windsurf.exe"
            )
            CheckType = "both"
        }
    )

    $foundTools = @()

    foreach ($tool in $ideTools) {
        $found = $false

        # Check commands
        if ($tool.CheckType -eq "command" -or $tool.CheckType -eq "both") {
            foreach ($cmd in $tool.Commands) {
                try {
                    $null = Get-Command $cmd -ErrorAction Stop
                    $found = $true
                    break
                } catch {
                    continue
                }
            }
        }

        # Check paths
        if (-not $found -and ($tool.CheckType -eq "path" -or $tool.CheckType -eq "both")) {
            foreach ($path in $tool.Paths) {
                if (Test-Path $path) {
                    $found = $true
                    break
                }
            }
        }

        if ($found) {
            Write-Success "$($tool.Name) is installed"
            $foundTools += $tool.Name
        }
    }

    if ($foundTools.Count -gt 0) {
        Write-Info "Found AI coding tools: $($foundTools -join ', ')"
        return $true
    } else {
        Write-Warning "No AI coding tools found"
        Write-Info ""
        Write-Info "You need at least one AI coding tool for Vibe Coding."
        Write-Info "Recommended options:"
        Write-Info ""
        Write-Color "  Cursor (AI-first code editor):" "Yellow"
        Write-Info "    https://cursor.sh/download"
        Write-Info ""
        Write-Color "  VS Code (with GitHub Copilot):" "Yellow"
        Write-Info "    winget install Microsoft.VisualStudioCode"
        Write-Info ""
        Write-Color "  Claude Code (Anthropic CLI):" "Yellow"
        Write-Info "    npm install -g @anthropic-ai/claude-code"
        Write-Info ""
        return $false
    }
}

function Test-ProjectRoot {
    Write-Header "Doctor's Examination: Project Directory"

    if (Test-Path $PROJECT_ROOT) {
        Write-Success "Project root: $PROJECT_ROOT"
        return $true
    } else {
        Write-Failure "Project root not found: $PROJECT_ROOT"
        return $false
    }
}

function Test-LabFolders {
    Write-Header "Doctor's Examination: Lab Folders"

    $labs = @(
        "lab-01-nyc-neighborhood-signals",
        "lab-02-us-safety-drivers",
        "lab-03-hospitality-demand",
        "lab-04-streaming-catalog",
        "lab-05-nyc-mobility-externalities"
    )

    $foundLabs = @()

    foreach ($lab in $labs) {
        $labPath = Join-Path $PROJECT_ROOT $lab
        $pyprojectPath = Join-Path $labPath "pyproject.toml"

        if (Test-Path $pyprojectPath) {
            $foundLabs += $lab
        }
    }

    if ($foundLabs.Count -gt 0) {
        Write-Success "Found $($foundLabs.Count) lab(s) ready to use"
        foreach ($lab in $foundLabs) {
            Write-Info "  - $lab"
        }
        return $true
    } else {
        Write-Warning "No lab folders found with pyproject.toml"
        return $false
    }
}

# ============================================================================
# Summary and Next Steps
# ============================================================================

function Show-Summary {
    param(
        [bool]$PythonOK,
        [bool]$UvOK,
        [bool]$GitOK,
        [bool]$MakeOK,
        [bool]$IdeOK,
        [bool]$LabsOK
    )

    Write-Header "Doctor's Diagnosis Summary"

    $criticalOK = $PythonOK -and $UvOK

    Write-Info ""
    Write-Color "Critical (Required):" "Yellow"
    if ($PythonOK) { Write-Success "Python 3.12+" } else { Write-Failure "Python 3.12+" }
    if ($UvOK) { Write-Success "uv Package Manager" } else { Write-Failure "uv Package Manager" }

    Write-Info ""
    Write-Color "Recommended:" "Yellow"
    if ($IdeOK) { Write-Success "AI Coding Tool" } else { Write-Warning "AI Coding Tool (install one)" }
    if ($GitOK) { Write-Success "Git" } else { Write-Warning "Git (optional)" }
    if ($MakeOK) { Write-Success "GNU Make" } else { Write-Warning "GNU Make (optional - can use uv directly)" }

    Write-Info ""
    Write-Color "Labs:" "Yellow"
    if ($LabsOK) { Write-Success "Lab folders found" } else { Write-Warning "Lab folders not found" }

    return $criticalOK
}

function Show-NextSteps {
    param([bool]$HasMake)

    Write-Header "Next Steps"

    Write-Info "1. Go to a lab folder:"
    Write-Color "   cd lab-01-nyc-neighborhood-signals" "Green"
    Write-Info ""

    if ($HasMake) {
        Write-Info "2. Set up the lab:"
        Write-Color "   make setup" "Green"
        Write-Info ""
        Write-Info "3. Run the dashboard:"
        Write-Color "   make run" "Green"
    } else {
        Write-Info "2. Set up the lab (without Make):"
        Write-Color "   uv sync" "Green"
        Write-Info ""
        Write-Info "3. Run the dashboard:"
        Write-Color "   uv run streamlit run app.py" "Green"
    }

    Write-Info ""
    Write-Info "Lab folders available:"
    Write-Info "  - lab-01-nyc-neighborhood-signals  (Port 8501)"
    Write-Info "  - lab-02-us-safety-drivers         (Port 8502)"
    Write-Info "  - lab-03-hospitality-demand        (Port 8503)"
    Write-Info "  - lab-04-streaming-catalog         (Port 8504)"
    Write-Info "  - lab-05-nyc-mobility-externalities (Port 8505)"
    Write-Info ""
    Write-Color "Happy Vibe Coding!" "Cyan"
}

# ============================================================================
# Main Execution
# ============================================================================

function Main {
    Write-Host ""
    Write-Color "================================================" "Cyan"
    Write-Color "  SRX DATA SCIENCE LABS - ENVIRONMENT DOCTOR" "Cyan"
    Write-Color "  Like a doctor: diagnose first, then treat" "Cyan"
    Write-Color "================================================" "Cyan"
    Write-Host ""

    if (-not $script:HasWinget) {
        Write-Warning "winget not found. Auto-installation may be limited."
        Write-Info "winget comes with Windows 10 (version 1809+) and Windows 11."
        Write-Info "If missing, install 'App Installer' from Microsoft Store."
        Write-Host ""
    }

    # Run diagnostics (with auto-install offers)
    $windowsOK = Test-WindowsVersion

    if (-not $windowsOK) {
        Write-Failure "Windows 10 or later is required."
        exit 1
    }

    $pythonOK = Test-AndInstall-Python
    $uvOK = Test-AndInstall-UV
    $gitOK = Test-AndInstall-Git
    $makeOK = Test-Make
    $ideOK = Test-IDETools
    $projectOK = Test-ProjectRoot
    $labsOK = Test-LabFolders

    # Show summary
    $criticalOK = Show-Summary -PythonOK $pythonOK -UvOK $uvOK -GitOK $gitOK -MakeOK $makeOK -IdeOK $ideOK -LabsOK $labsOK

    Write-Host ""

    if (-not $criticalOK) {
        Write-Failure "Critical requirements not met."
        Write-Info "Please install missing components and RESTART your terminal."
        Write-Info "Then run this script again."
        exit 1
    }

    Write-Success "Environment is ready!"
    Show-NextSteps -HasMake $makeOK
}

# Run main
Main
