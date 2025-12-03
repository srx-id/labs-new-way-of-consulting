#Requires -Version 5.1
<#
.SYNOPSIS
    SRX Data Science Labs - Windows Setup Script (Doctor Mode)

.DESCRIPTION
    Like a doctor examining a patient - diagnoses your environment health first,
    then prescribes and administers the treatment (installations) as needed.

.NOTES
    Prerequisites: PowerShell 5.1+ (comes with Windows 10/11)
    NO WSL required - pure Windows native setup
#>

param(
    [switch]$SkipInstall,
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
# Diagnostic Results Storage
# ============================================================================
$script:DiagnosticResults = @{
    Windows = $false
    Python = $false
    PythonVersion = ""
    UV = $false
    Make = $false
    Git = $false
    IDE = $false
    IDEName = ""
    ProjectRoot = $false
    PyProjectToml = $false
    Makefile = $false
    Venv = $false
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

    # Check if Windows 10 or later
    $majorVersion = [int]($version.Split('.')[0])
    if ($majorVersion -ge 10) {
        Write-Success "Windows 10 or later detected"
        $script:DiagnosticResults.Windows = $true
        return $true
    } else {
        Write-Failure "Windows 10 or later required"
        return $false
    }
}

function Test-Python {
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
        Write-Info "Download Python $REQUIRED_PYTHON_VERSION+ from:"
        Write-Info "  https://www.python.org/downloads/"
        Write-Info ""
        Write-Info "Or install via winget:"
        Write-Info "  winget install Python.Python.3.12"
        return $false
    }

    Write-Info "Found: Python $pythonVer (command: $cmd)"
    $script:DiagnosticResults.PythonVersion = $pythonVer

    # Check version meets requirement
    $versionParts = $pythonVer.Split('.')
    $major = [int]$versionParts[0]
    $minor = [int]$versionParts[1]

    $requiredParts = $REQUIRED_PYTHON_VERSION.Split('.')
    $reqMajor = [int]$requiredParts[0]
    $reqMinor = [int]$requiredParts[1]

    if ($major -gt $reqMajor -or ($major -eq $reqMajor -and $minor -ge $reqMinor)) {
        Write-Success "Python version $pythonVer meets requirement (>= $REQUIRED_PYTHON_VERSION)"
        $script:DiagnosticResults.Python = $true
        return $true
    } else {
        Write-Failure "Python $pythonVer is below required version $REQUIRED_PYTHON_VERSION"
        Write-Info "Please upgrade Python:"
        Write-Info "  https://www.python.org/downloads/"
        return $false
    }
}

function Test-UV {
    Write-Header "Doctor's Examination: uv Package Manager"

    try {
        $output = & uv --version 2>&1
        if ($output -match "uv (\d+\.\d+\.\d+)") {
            $uvVersion = $Matches[1]
            Write-Success "uv $uvVersion is installed"
            $script:DiagnosticResults.UV = $true
            return $true
        }
    } catch {
        # uv not found
    }

    Write-Warning "uv is not installed"
    Write-Info "uv is a fast Python package manager (replacement for pip)"
    Write-Info ""
    Write-Info "Install options:"
    Write-Info "  Option 1 (PowerShell):"
    Write-Info "    irm https://astral.sh/uv/install.ps1 | iex"
    Write-Info ""
    Write-Info "  Option 2 (winget):"
    Write-Info "    winget install astral-sh.uv"
    Write-Info ""
    Write-Info "  Option 3 (pip):"
    Write-Info "    pip install uv"
    return $false
}

function Test-Make {
    Write-Header "Doctor's Examination: GNU Make"

    try {
        $output = & make --version 2>&1
        if ($output -match "GNU Make (\d+\.\d+)") {
            $makeVersion = $Matches[1]
            Write-Success "GNU Make $makeVersion is installed"
            $script:DiagnosticResults.Make = $true
            return $true
        }
    } catch {
        # make not found
    }

    Write-Warning "GNU Make is not installed"
    Write-Info "Make is used for build automation"
    Write-Info ""
    Write-Info "Install options:"
    Write-Info "  Option 1 (winget - recommended):"
    Write-Info "    winget install GnuWin32.Make"
    Write-Info ""
    Write-Info "  Option 2 (Chocolatey):"
    Write-Info "    choco install make"
    Write-Info ""
    Write-Info "  Option 3 (Scoop):"
    Write-Info "    scoop install make"
    Write-Info ""
    Write-Info "After installing, restart your terminal"
    return $false
}

function Test-Git {
    Write-Header "Doctor's Examination: Git"

    try {
        $output = & git --version 2>&1
        if ($output -match "git version (\d+\.\d+\.\d+)") {
            $gitVersion = $Matches[1]
            Write-Success "Git $gitVersion is installed"
            $script:DiagnosticResults.Git = $true
            return $true
        }
    } catch {
        # git not found
    }

    Write-Warning "Git is not installed"
    Write-Info "Install options:"
    Write-Info "  Option 1 (winget):"
    Write-Info "    winget install Git.Git"
    Write-Info ""
    Write-Info "  Option 2 (Direct download):"
    Write-Info "    https://git-scm.com/download/win"
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
            Name = "Codex CLI"
            Commands = @("codex")
            CheckType = "command"
        },
        @{
            Name = "Aider"
            Commands = @("aider")
            CheckType = "command"
        },
        @{
            Name = "GitHub Copilot CLI"
            Commands = @("gh copilot", "github-copilot-cli")
            CheckType = "command"
        },
        @{
            Name = "Windsurf"
            Commands = @("windsurf")
            Paths = @(
                "$env:LOCALAPPDATA\Programs\windsurf\Windsurf.exe"
            )
            CheckType = "both"
        },
        @{
            Name = "Zed"
            Paths = @(
                "$env:LOCALAPPDATA\Programs\Zed\zed.exe"
            )
            CheckType = "path"
        }
    )

    $foundTools = @()

    foreach ($tool in $ideTools) {
        $found = $false

        # Check commands
        if ($tool.CheckType -eq "command" -or $tool.CheckType -eq "both") {
            foreach ($cmd in $tool.Commands) {
                try {
                    $cmdParts = $cmd.Split(' ')
                    $result = & $cmdParts[0] --version 2>&1
                    if ($LASTEXITCODE -eq 0 -or $result) {
                        $found = $true
                        break
                    }
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
        $script:DiagnosticResults.IDE = $true
        $script:DiagnosticResults.IDEName = $foundTools -join ", "
        Write-Info "Found AI coding tools: $($script:DiagnosticResults.IDEName)"
        return $true
    } else {
        Write-Failure "No AI coding tools found"
        Show-IDEDownloadOptions
        return $false
    }
}

function Show-IDEDownloadOptions {
    Write-Info ""
    Write-Info "You need at least one AI coding tool for Vibe Coding."
    Write-Info "Choose one of the following:"
    Write-Info ""
    Write-Color "  Claude Code (Anthropic's official CLI):" "Yellow"
    Write-Info "    npm install -g @anthropic-ai/claude-code"
    Write-Info "    https://docs.anthropic.com/en/docs/claude-code"
    Write-Info ""
    Write-Color "  Cursor (AI-first code editor):" "Yellow"
    Write-Info "    https://cursor.sh/download"
    Write-Info ""
    Write-Color "  VS Code (with GitHub Copilot):" "Yellow"
    Write-Info "    https://code.visualstudio.com/download"
    Write-Info "    Then install GitHub Copilot extension"
    Write-Info ""
    Write-Color "  Codex CLI (OpenAI):" "Yellow"
    Write-Info "    npm install -g @openai/codex"
    Write-Info "    https://github.com/openai/codex"
    Write-Info ""
    Write-Color "  Aider (AI pair programming):" "Yellow"
    Write-Info "    pip install aider-chat"
    Write-Info "    https://aider.chat"
    Write-Info ""
    Write-Color "  Windsurf (Codeium IDE):" "Yellow"
    Write-Info "    https://codeium.com/windsurf/download"
    Write-Info ""
    Write-Color "  Zed (fast, multiplayer editor with AI):" "Yellow"
    Write-Info "    https://zed.dev/download"
    Write-Info ""
}

function Test-ProjectRoot {
    Write-Header "Doctor's Examination: Project Directory"

    if (Test-Path $PROJECT_ROOT) {
        Write-Success "Project root exists: $PROJECT_ROOT"

        # Check if we can write to it
        $testFile = Join-Path $PROJECT_ROOT ".write_test_$(Get-Random)"
        try {
            New-Item -Path $testFile -ItemType File -Force | Out-Null
            Remove-Item $testFile -Force
            Write-Success "Write permissions OK"
            $script:DiagnosticResults.ProjectRoot = $true
            return $true
        } catch {
            Write-Failure "Cannot write to project directory"
            Write-Info "Please check folder permissions"
            return $false
        }
    } else {
        Write-Failure "Project root not found: $PROJECT_ROOT"
        return $false
    }
}

function Test-PyProjectToml {
    Write-Header "Doctor's Examination: pyproject.toml"

    $pyprojectPath = Join-Path $PROJECT_ROOT "pyproject.toml"

    if (Test-Path $pyprojectPath) {
        Write-Success "pyproject.toml exists"
        $script:DiagnosticResults.PyProjectToml = $true
        return $true
    } else {
        Write-Warning "pyproject.toml not found"
        Write-Info "Will create pyproject.toml during setup"
        return $false
    }
}

function Test-Makefile {
    Write-Header "Doctor's Examination: Makefile"

    $makefilePath = Join-Path $PROJECT_ROOT "Makefile"

    if (Test-Path $makefilePath) {
        Write-Success "Makefile exists"
        $script:DiagnosticResults.Makefile = $true
        return $true
    } else {
        Write-Warning "Makefile not found"
        Write-Info "Will create Makefile during setup"
        return $false
    }
}

function Test-Venv {
    Write-Header "Doctor's Examination: Virtual Environment"

    $venvPath = Join-Path $PROJECT_ROOT ".venv"
    $activateScript = Join-Path $venvPath "Scripts\Activate.ps1"

    if ((Test-Path $venvPath) -and (Test-Path $activateScript)) {
        Write-Success "Virtual environment exists at .venv"
        $script:DiagnosticResults.Venv = $true
        return $true
    } else {
        Write-Warning "Virtual environment not found"
        Write-Info "Will create .venv during setup"
        return $false
    }
}

# ============================================================================
# Setup Functions
# ============================================================================

function New-PyProjectToml {
    Write-Header "Doctor's Treatment: Creating pyproject.toml"

    $pyprojectPath = Join-Path $PROJECT_ROOT "pyproject.toml"

    $content = @'
[project]
name = "srx-data-science-labs"
version = "0.1.0"
description = "SRX Data Science Labs - Cross-Dataset Correlation Analysis"
readme = "README.md"
requires-python = ">=3.12"
dependencies = [
    "pandas>=2.0.0",
    "numpy>=1.24.0",
    "matplotlib>=3.7.0",
    "seaborn>=0.12.0",
    "scipy>=1.10.0",
    "jupyter>=1.0.0",
    "jupyterlab>=4.0.0",
    "openpyxl>=3.1.0",
    "xlrd>=2.0.0",
    "requests>=2.28.0",
    "python-dotenv>=1.0.0",
    "tqdm>=4.65.0",
    "fuzzywuzzy>=0.18.0",
    "python-Levenshtein>=0.21.0",
    "rapidfuzz>=3.0.0",
    "pyarrow>=12.0.0",
    "fastparquet>=2023.4.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0.0",
    "black>=23.0.0",
    "ruff>=0.0.270",
    "mypy>=1.3.0",
]

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.uv]
dev-dependencies = [
    "pytest>=7.0.0",
    "black>=23.0.0",
    "ruff>=0.0.270",
]
'@

    try {
        $content | Out-File -FilePath $pyprojectPath -Encoding UTF8
        Write-Success "Created pyproject.toml"
        return $true
    } catch {
        Write-Failure "Failed to create pyproject.toml: $_"
        return $false
    }
}

function New-Makefile {
    Write-Header "Doctor's Treatment: Creating Makefile"

    $makefilePath = Join-Path $PROJECT_ROOT "Makefile"

    # Note: Makefile requires tabs, not spaces
    $content = @'
# SRX Data Science Labs - Makefile
# Run 'make help' for available commands

.PHONY: help setup clean jupyter lab test lint format check-env

# Default target
help:
	@echo "SRX Data Science Labs - Available Commands"
	@echo "==========================================="
	@echo ""
	@echo "  make setup      - Create venv and install dependencies"
	@echo "  make jupyter    - Start Jupyter Notebook"
	@echo "  make lab        - Start JupyterLab"
	@echo "  make clean      - Remove venv and cache files"
	@echo "  make test       - Run tests"
	@echo "  make lint       - Run linter (ruff)"
	@echo "  make format     - Format code (black)"
	@echo "  make check-env  - Verify environment setup"
	@echo ""

# Setup virtual environment and install dependencies
setup:
	@echo "Creating virtual environment..."
	uv venv .venv
	@echo "Installing dependencies..."
	uv pip install -e ".[dev]"
	@echo ""
	@echo "Setup complete! Activate with:"
	@echo "  Windows: .venv\Scripts\Activate.ps1"
	@echo "  Unix:    source .venv/bin/activate"

# Start Jupyter Notebook
jupyter:
	@echo "Starting Jupyter Notebook..."
	.venv/Scripts/python -m jupyter notebook

# Start JupyterLab
lab:
	@echo "Starting JupyterLab..."
	.venv/Scripts/python -m jupyter lab

# Clean up
clean:
	@echo "Cleaning up..."
	if exist .venv rmdir /s /q .venv
	if exist __pycache__ rmdir /s /q __pycache__
	if exist .pytest_cache rmdir /s /q .pytest_cache
	if exist .ruff_cache rmdir /s /q .ruff_cache
	for /d /r . %%d in (__pycache__) do @if exist "%%d" rmdir /s /q "%%d"
	@echo "Clean complete!"

# Run tests
test:
	.venv/Scripts/python -m pytest tests/ -v

# Run linter
lint:
	.venv/Scripts/python -m ruff check .

# Format code
format:
	.venv/Scripts/python -m black .

# Check environment
check-env:
	@echo "Checking environment..."
	@python --version
	@uv --version
	@echo "Environment OK!"
'@

    try {
        $content | Out-File -FilePath $makefilePath -Encoding UTF8 -NoNewline
        Write-Success "Created Makefile"
        return $true
    } catch {
        Write-Failure "Failed to create Makefile: $_"
        return $false
    }
}

function New-VirtualEnvironment {
    Write-Header "Doctor's Treatment: Setting Up Virtual Environment"

    $venvPath = Join-Path $PROJECT_ROOT ".venv"

    Push-Location $PROJECT_ROOT

    try {
        Write-Info "Creating .venv with uv..."
        & uv venv .venv

        if ($LASTEXITCODE -eq 0) {
            Write-Success "Virtual environment created"

            Write-Info "Installing dependencies..."
            & uv pip install -e ".[dev]"

            if ($LASTEXITCODE -eq 0) {
                Write-Success "Dependencies installed"
                return $true
            } else {
                Write-Failure "Failed to install dependencies"
                return $false
            }
        } else {
            Write-Failure "Failed to create virtual environment"
            return $false
        }
    } catch {
        Write-Failure "Error creating virtual environment: $_"
        return $false
    } finally {
        Pop-Location
    }
}

# ============================================================================
# Main Execution
# ============================================================================

function Show-DiagnosticSummary {
    Write-Header "Doctor's Diagnosis Summary"

    $allPassed = $true
    $criticalFailed = $false

    # Critical requirements
    $critical = @(
        @{ Name = "Windows 10+"; Passed = $script:DiagnosticResults.Windows },
        @{ Name = "Python $REQUIRED_PYTHON_VERSION+"; Passed = $script:DiagnosticResults.Python },
        @{ Name = "uv Package Manager"; Passed = $script:DiagnosticResults.UV },
        @{ Name = "AI Coding Tool"; Passed = $script:DiagnosticResults.IDE }
    )

    # Optional/can be created
    $optional = @(
        @{ Name = "GNU Make"; Passed = $script:DiagnosticResults.Make },
        @{ Name = "Git"; Passed = $script:DiagnosticResults.Git },
        @{ Name = "pyproject.toml"; Passed = $script:DiagnosticResults.PyProjectToml },
        @{ Name = "Makefile"; Passed = $script:DiagnosticResults.Makefile },
        @{ Name = "Virtual Environment"; Passed = $script:DiagnosticResults.Venv }
    )

    Write-Info ""
    Write-Color "Critical Requirements:" "Yellow"
    foreach ($item in $critical) {
        if ($item.Passed) {
            Write-Success $item.Name
        } else {
            Write-Failure $item.Name
            $allPassed = $false
            $criticalFailed = $true
        }
    }

    Write-Info ""
    Write-Color "Optional/Auto-Created:" "Yellow"
    foreach ($item in $optional) {
        if ($item.Passed) {
            Write-Success $item.Name
        } else {
            Write-Warning "$($item.Name) (will be created)"
            $allPassed = $false
        }
    }

    Write-Info ""

    return @{
        AllPassed = $allPassed
        CriticalFailed = $criticalFailed
    }
}

function Start-Setup {
    Write-Header "Doctor's Treatment Plan"

    $success = $true

    # Create pyproject.toml if missing
    if (-not $script:DiagnosticResults.PyProjectToml) {
        if (-not (New-PyProjectToml)) {
            $success = $false
        }
    }

    # Create Makefile if missing
    if (-not $script:DiagnosticResults.Makefile) {
        if (-not (New-Makefile)) {
            $success = $false
        }
    }

    # Create virtual environment if missing
    if (-not $script:DiagnosticResults.Venv) {
        if (-not (New-VirtualEnvironment)) {
            $success = $false
        }
    }

    return $success
}

function Show-NextSteps {
    Write-Header "Post-Treatment Instructions"

    Write-Info "1. Activate the virtual environment:"
    Write-Color "   .\.venv\Scripts\Activate.ps1" "Green"
    Write-Info ""
    Write-Info "2. Start Jupyter:"
    Write-Color "   make jupyter" "Green"
    Write-Info "   or"
    Write-Color "   make lab" "Green"
    Write-Info ""
    Write-Info "3. Navigate to a lab folder and start working!"
    Write-Info ""
    Write-Info "Lab folders:"
    Write-Info "  - lab-01-nyc-neighborhood-signals"
    Write-Info "  - lab-02-us-safety-driving-conditions"
    Write-Info "  - lab-03-us-hospitality-demand"
    Write-Info "  - lab-04-streaming-catalog-reconciliation"
    Write-Info "  - lab-05-nyc-mobility-externalities"
    Write-Info ""
    Write-Color "Happy Vibe Coding!" "Cyan"
}

# Main script
function Main {
    Write-Host ""
    Write-Color "================================================" "Cyan"
    Write-Color "  SRX DATA SCIENCE LABS - ENVIRONMENT DOCTOR" "Cyan"
    Write-Color "  Like a doctor: diagnose first, then treat" "Cyan"
    Write-Color "================================================" "Cyan"
    Write-Host ""

    # Run diagnostics
    Test-WindowsVersion
    Test-Python
    Test-UV
    Test-Make
    Test-Git
    Test-IDETools
    Test-ProjectRoot
    Test-PyProjectToml
    Test-Makefile
    Test-Venv

    # Show summary
    $summary = Show-DiagnosticSummary

    if ($summary.CriticalFailed) {
        Write-Host ""
        Write-Failure "Critical requirements not met. Please install missing components and run again."
        Write-Host ""
        exit 1
    }

    if ($SkipInstall) {
        Write-Info "Skipping setup (--SkipInstall specified)"
        exit 0
    }

    if (-not $summary.AllPassed) {
        Write-Host ""
        $response = Read-Host "Would you like to proceed with setup? (Y/n)"
        if ($response -eq "" -or $response -match "^[Yy]") {
            if (Start-Setup) {
                Write-Host ""
                Write-Success "Setup completed successfully!"
                Show-NextSteps
            } else {
                Write-Failure "Setup encountered errors. Please check above messages."
                exit 1
            }
        } else {
            Write-Info "Setup cancelled."
            exit 0
        }
    } else {
        Write-Host ""
        Write-Success "All requirements already met!"
        Show-NextSteps
    }
}

# Run main
Main
