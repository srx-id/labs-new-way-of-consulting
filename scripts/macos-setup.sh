#!/bin/bash
#
# SRX Data Science Labs - macOS Setup Script (Doctor Mode)
# Like a doctor examining a patient - diagnoses your environment health first,
# then prescribes and administers the treatment (installations) as needed.
#
# Usage: ./scripts/macos-setup.sh
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Minimum versions required
REQUIRED_PYTHON_MAJOR=3
REQUIRED_PYTHON_MINOR=12

# Track diagnosis results
DIAGNOSIS_PASSED=true
ITEMS_TO_INSTALL=()
IDE_FOUND=false
IDE_NAME=""

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

print_header() {
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
}

print_check() {
    echo -e "  ${BLUE}[CHECK]${NC} $1"
}

print_pass() {
    echo -e "  ${GREEN}[  ✓  ]${NC} $1"
}

print_fail() {
    echo -e "  ${RED}[  ✗  ]${NC} $1"
    DIAGNOSIS_PASSED=false
}

print_warn() {
    echo -e "  ${YELLOW}[ WARN ]${NC} $1"
}

print_info() {
    echo -e "  ${BLUE}[ INFO ]${NC} $1"
}

print_action() {
    echo -e "  ${YELLOW}[ACTION]${NC} $1"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

app_exists() {
    # Check if macOS app exists
    [[ -d "/Applications/$1.app" ]] || [[ -d "$HOME/Applications/$1.app" ]]
}

version_gte() {
    # Compare versions: returns 0 if $1 >= $2
    printf '%s\n%s\n' "$2" "$1" | sort -V -C
}

# ============================================================================
# DIAGNOSIS PHASE
# ============================================================================

diagnose_system() {
    print_header "PHASE 1: DOCTOR'S EXAMINATION"

    echo "  The doctor is now examining your system..."
    echo ""

    # Check 1: Operating System
    print_check "Operating System"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS_VERSION=$(sw_vers -productVersion)
        print_pass "macOS $OS_VERSION detected"
    else
        print_fail "This script is for macOS only. Detected: $OSTYPE"
        exit 1
    fi

    # Check 2: Homebrew
    print_check "Homebrew package manager"
    if command_exists brew; then
        BREW_VERSION=$(brew --version | head -n1)
        print_pass "$BREW_VERSION"
    else
        print_fail "Homebrew not installed"
        ITEMS_TO_INSTALL+=("homebrew")
    fi

    # Check 3: Python 3.12+
    print_check "Python $REQUIRED_PYTHON_MAJOR.$REQUIRED_PYTHON_MINOR+"
    if command_exists python3; then
        PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
        PYTHON_MAJOR=$(echo "$PYTHON_VERSION" | cut -d. -f1)
        PYTHON_MINOR=$(echo "$PYTHON_VERSION" | cut -d. -f2)

        if [[ "$PYTHON_MAJOR" -ge "$REQUIRED_PYTHON_MAJOR" ]] && [[ "$PYTHON_MINOR" -ge "$REQUIRED_PYTHON_MINOR" ]]; then
            print_pass "Python $PYTHON_VERSION"
        else
            print_fail "Python $PYTHON_VERSION (need $REQUIRED_PYTHON_MAJOR.$REQUIRED_PYTHON_MINOR+)"
            ITEMS_TO_INSTALL+=("python")
        fi
    else
        print_fail "Python not found"
        ITEMS_TO_INSTALL+=("python")
    fi

    # Check 4: uv (fast Python package manager)
    print_check "uv package manager"
    if command_exists uv; then
        UV_VERSION=$(uv --version 2>&1)
        print_pass "$UV_VERSION"
    else
        print_fail "uv not installed"
        ITEMS_TO_INSTALL+=("uv")
    fi

    # Check 5: make
    print_check "GNU Make"
    if command_exists make; then
        MAKE_VERSION=$(make --version | head -n1)
        print_pass "$MAKE_VERSION"
    else
        print_fail "make not installed"
        ITEMS_TO_INSTALL+=("make")
    fi

    # Check 6: git
    print_check "Git version control"
    if command_exists git; then
        GIT_VERSION=$(git --version)
        print_pass "$GIT_VERSION"
    else
        print_fail "git not installed"
        ITEMS_TO_INSTALL+=("git")
    fi

    # Check 7: IDE / AI Coding Tool (at least one required)
    print_check "AI Coding Tool / IDE"
    check_ide_tools

    # Check 8: Directory permissions
    print_check "Directory write permissions"
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    LABS_DIR="$(dirname "$SCRIPT_DIR")"
    if [[ -w "$LABS_DIR" ]]; then
        print_pass "Can write to $LABS_DIR"
    else
        print_fail "Cannot write to $LABS_DIR"
    fi

    # Check 9: pyproject.toml exists
    print_check "pyproject.toml configuration"
    if [[ -f "$LABS_DIR/pyproject.toml" ]]; then
        print_pass "Found pyproject.toml"
    else
        print_warn "pyproject.toml not found (will create template)"
        ITEMS_TO_INSTALL+=("pyproject")
    fi

    # Check 10: Makefile exists
    print_check "Makefile"
    if [[ -f "$LABS_DIR/Makefile" ]]; then
        print_pass "Found Makefile"
    else
        print_warn "Makefile not found (will create template)"
        ITEMS_TO_INSTALL+=("makefile")
    fi
}

check_ide_tools() {
    # Check for various AI coding tools and IDEs

    # 1. Claude Code (CLI)
    if command_exists claude; then
        IDE_FOUND=true
        IDE_NAME="Claude Code"
        print_pass "Claude Code CLI detected"
        return
    fi

    # 2. Cursor
    if app_exists "Cursor" || command_exists cursor; then
        IDE_FOUND=true
        IDE_NAME="Cursor"
        print_pass "Cursor detected"
        return
    fi

    # 3. VS Code
    if app_exists "Visual Studio Code" || command_exists code; then
        IDE_FOUND=true
        IDE_NAME="Visual Studio Code"
        print_pass "Visual Studio Code detected"
        return
    fi

    # 4. Codex CLI (OpenAI)
    if command_exists codex; then
        IDE_FOUND=true
        IDE_NAME="Codex CLI"
        print_pass "Codex CLI detected"
        return
    fi

    # 5. Aider
    if command_exists aider; then
        IDE_FOUND=true
        IDE_NAME="Aider"
        print_pass "Aider detected"
        return
    fi

    # 6. GitHub Copilot CLI
    if command_exists gh && gh extension list 2>/dev/null | grep -q "copilot"; then
        IDE_FOUND=true
        IDE_NAME="GitHub Copilot CLI"
        print_pass "GitHub Copilot CLI detected"
        return
    fi

    # 7. Windsurf
    if app_exists "Windsurf" || command_exists windsurf; then
        IDE_FOUND=true
        IDE_NAME="Windsurf"
        print_pass "Windsurf detected"
        return
    fi

    # 8. Zed
    if app_exists "Zed" || command_exists zed; then
        IDE_FOUND=true
        IDE_NAME="Zed"
        print_pass "Zed detected"
        return
    fi

    # None found
    print_fail "No AI coding tool or IDE found"
    ITEMS_TO_INSTALL+=("ide")
}

# ============================================================================
# DIAGNOSIS SUMMARY
# ============================================================================

print_diagnosis_summary() {
    print_header "DOCTOR'S DIAGNOSIS"

    if [[ ${#ITEMS_TO_INSTALL[@]} -eq 0 ]]; then
        echo -e "  ${GREEN}All prerequisites are installed!${NC}"
        echo ""
        echo "  Your environment is ready for the SRX Data Science Labs."
        echo ""
        return 0
    else
        echo -e "  ${YELLOW}The following items need attention:${NC}"
        echo ""
        for item in "${ITEMS_TO_INSTALL[@]}"; do
            case $item in
                homebrew)
                    echo -e "  ${RED}•${NC} Homebrew - Package manager for macOS"
                    ;;
                python)
                    echo -e "  ${RED}•${NC} Python $REQUIRED_PYTHON_MAJOR.$REQUIRED_PYTHON_MINOR+ - Required for labs"
                    ;;
                uv)
                    echo -e "  ${RED}•${NC} uv - Fast Python package manager"
                    ;;
                make)
                    echo -e "  ${RED}•${NC} make - Build automation tool"
                    ;;
                git)
                    echo -e "  ${RED}•${NC} git - Version control"
                    ;;
                ide)
                    echo -e "  ${RED}•${NC} AI Coding Tool - Required for Vibe Coding"
                    ;;
                pyproject)
                    echo -e "  ${YELLOW}•${NC} pyproject.toml - Will create template"
                    ;;
                makefile)
                    echo -e "  ${YELLOW}•${NC} Makefile - Will create template"
                    ;;
            esac
        done
        echo ""
        return 1
    fi
}

# ============================================================================
# SHOW IDE DOWNLOAD OPTIONS
# ============================================================================

show_ide_download_options() {
    print_header "AI CODING TOOL OPTIONS"

    echo "  You need at least ONE of these tools for Vibe Coding:"
    echo ""
    echo -e "  ${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "  ${GREEN}1. Claude Code (Recommended)${NC}"
    echo "     Anthropic's official CLI for Claude"
    echo -e "     ${BLUE}Install:${NC} npm install -g @anthropic-ai/claude-code"
    echo -e "     ${BLUE}Website:${NC} https://claude.ai/claude-code"
    echo ""
    echo -e "  ${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "  ${GREEN}2. Cursor${NC}"
    echo "     AI-powered code editor (VS Code fork)"
    echo -e "     ${BLUE}Download:${NC} https://cursor.sh"
    echo ""
    echo -e "  ${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "  ${GREEN}3. Visual Studio Code + Extensions${NC}"
    echo "     Classic IDE with AI extensions (Copilot, Claude, etc.)"
    echo -e "     ${BLUE}Download:${NC} https://code.visualstudio.com"
    echo -e "     ${BLUE}Extensions:${NC} GitHub Copilot, Claude for VS Code"
    echo ""
    echo -e "  ${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "  ${GREEN}4. Windsurf${NC}"
    echo "     AI-native code editor by Codeium"
    echo -e "     ${BLUE}Download:${NC} https://codeium.com/windsurf"
    echo ""
    echo -e "  ${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "  ${GREEN}5. Aider${NC}"
    echo "     Terminal-based AI pair programming"
    echo -e "     ${BLUE}Install:${NC} pip install aider-chat"
    echo -e "     ${BLUE}Website:${NC} https://aider.chat"
    echo ""
    echo -e "  ${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "  ${GREEN}6. Codex CLI (OpenAI)${NC}"
    echo "     OpenAI's command-line coding assistant"
    echo -e "     ${BLUE}Install:${NC} npm install -g @openai/codex"
    echo -e "     ${BLUE}Website:${NC} https://openai.com/codex"
    echo ""
    echo -e "  ${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    echo -e "  ${YELLOW}Please install one of these tools, then run this script again.${NC}"
    echo ""
}

# ============================================================================
# INSTALLATION PHASE
# ============================================================================

install_homebrew() {
    print_action "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    fi

    print_pass "Homebrew installed successfully"
}

install_python() {
    print_action "Installing Python $REQUIRED_PYTHON_MAJOR.$REQUIRED_PYTHON_MINOR via Homebrew..."
    brew install python@$REQUIRED_PYTHON_MAJOR.$REQUIRED_PYTHON_MINOR

    # Create symlinks if needed
    brew link python@$REQUIRED_PYTHON_MAJOR.$REQUIRED_PYTHON_MINOR --force --overwrite 2>/dev/null || true

    print_pass "Python $REQUIRED_PYTHON_MAJOR.$REQUIRED_PYTHON_MINOR installed successfully"
}

install_uv() {
    print_action "Installing uv package manager..."
    curl -LsSf https://astral.sh/uv/install.sh | sh

    # Add to PATH
    export PATH="$HOME/.cargo/bin:$PATH"

    # Add to shell profile
    if [[ -f ~/.zshrc ]]; then
        grep -q 'cargo/bin' ~/.zshrc || echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc
    fi
    if [[ -f ~/.bashrc ]]; then
        grep -q 'cargo/bin' ~/.bashrc || echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
    fi

    print_pass "uv installed successfully"
}

install_make() {
    print_action "Installing make via Xcode Command Line Tools..."
    xcode-select --install 2>/dev/null || true
    print_pass "make installed (via Xcode CLT)"
}

install_git() {
    print_action "Installing git via Homebrew..."
    brew install git
    print_pass "git installed successfully"
}

create_pyproject() {
    print_action "Creating pyproject.toml..."

    LABS_DIR="$(dirname "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)")"

    cat > "$LABS_DIR/pyproject.toml" << 'PYPROJECT'
[project]
name = "srx-data-science-labs"
version = "1.0.0"
description = "SRX Data Science Labs - Cross-Dataset Correlation Analysis"
readme = "README.md"
requires-python = ">=3.12"

dependencies = [
    "pandas>=2.0.0",
    "numpy>=1.24.0",
    "scipy>=1.10.0",
    "matplotlib>=3.7.0",
    "seaborn>=0.12.0",
    "streamlit>=1.28.0",
    "jupyter>=1.0.0",
    "openpyxl>=3.1.0",
    "xlrd>=2.0.0",
    "rapidfuzz>=3.0.0",
    "kaggle>=1.5.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0.0",
    "black>=23.0.0",
    "ruff>=0.1.0",
    "ipykernel>=6.0.0",
]

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.uv]
dev-dependencies = [
    "pytest>=7.0.0",
    "black>=23.0.0",
    "ruff>=0.1.0",
]
PYPROJECT

    print_pass "pyproject.toml created"
}

create_makefile() {
    print_action "Creating Makefile..."

    LABS_DIR="$(dirname "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)")"

    cat > "$LABS_DIR/Makefile" << 'MAKEFILE'
# SRX Data Science Labs - Makefile
# Usage: make <target>

.PHONY: help setup install clean run jupyter lab test lint format

# Default Python and uv
PYTHON := python3
UV := uv
VENV := .venv

# Colors
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[1;33m
NC := \033[0m

help: ## Show this help message
	@echo ""
	@echo "$(BLUE)SRX Data Science Labs$(NC)"
	@echo "$(BLUE)=====================$(NC)"
	@echo ""
	@echo "Available commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2}'
	@echo ""

setup: ## Full setup: create venv and install dependencies
	@echo "$(BLUE)Setting up development environment...$(NC)"
	$(UV) venv $(VENV)
	$(UV) pip install -e ".[dev]"
	@echo "$(GREEN)Setup complete!$(NC)"
	@echo ""
	@echo "Activate the virtual environment with:"
	@echo "  source $(VENV)/bin/activate"

install: ## Install dependencies only (assumes venv exists)
	@echo "$(BLUE)Installing dependencies...$(NC)"
	$(UV) pip install -e ".[dev]"
	@echo "$(GREEN)Dependencies installed!$(NC)"

sync: ## Sync dependencies with uv
	@echo "$(BLUE)Syncing dependencies...$(NC)"
	$(UV) sync
	@echo "$(GREEN)Dependencies synced!$(NC)"

clean: ## Remove virtual environment and cache files
	@echo "$(YELLOW)Cleaning up...$(NC)"
	rm -rf $(VENV)
	rm -rf .pytest_cache
	rm -rf __pycache__
	rm -rf .ruff_cache
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete 2>/dev/null || true
	@echo "$(GREEN)Cleaned!$(NC)"

run: ## Run the main application (Streamlit)
	@echo "$(BLUE)Starting Streamlit app...$(NC)"
	$(VENV)/bin/streamlit run app.py

jupyter: ## Start Jupyter Notebook
	@echo "$(BLUE)Starting Jupyter Notebook...$(NC)"
	$(VENV)/bin/jupyter notebook

lab: ## Start JupyterLab
	@echo "$(BLUE)Starting JupyterLab...$(NC)"
	$(VENV)/bin/jupyter lab

test: ## Run tests with pytest
	@echo "$(BLUE)Running tests...$(NC)"
	$(VENV)/bin/pytest -v

lint: ## Run linter (ruff)
	@echo "$(BLUE)Running linter...$(NC)"
	$(VENV)/bin/ruff check .

format: ## Format code with black
	@echo "$(BLUE)Formatting code...$(NC)"
	$(VENV)/bin/black .

check: ## Check environment status
	@echo "$(BLUE)Environment Check$(NC)"
	@echo "=================="
	@echo ""
	@echo "Python: $$($(PYTHON) --version 2>&1)"
	@echo "uv: $$($(UV) --version 2>&1)"
	@echo "Virtual env: $(VENV)"
	@[ -d "$(VENV)" ] && echo "  Status: $(GREEN)exists$(NC)" || echo "  Status: $(YELLOW)not created$(NC)"
	@echo ""
MAKEFILE

    print_pass "Makefile created"
}

run_installation() {
    print_header "PHASE 2: DOCTOR'S TREATMENT"

    for item in "${ITEMS_TO_INSTALL[@]}"; do
        case $item in
            homebrew)
                install_homebrew
                ;;
            python)
                if ! command_exists brew; then
                    install_homebrew
                fi
                install_python
                ;;
            uv)
                install_uv
                ;;
            make)
                install_make
                ;;
            git)
                if ! command_exists brew; then
                    install_homebrew
                fi
                install_git
                ;;
            ide)
                show_ide_download_options
                ;;
            pyproject)
                create_pyproject
                ;;
            makefile)
                create_makefile
                ;;
        esac
    done
}

# ============================================================================
# VIRTUAL ENVIRONMENT SETUP
# ============================================================================

setup_venv() {
    print_header "PHASE 3: PREPARING THE PATIENT (VENV SETUP)"

    LABS_DIR="$(dirname "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)")"
    cd "$LABS_DIR"

    print_action "Creating virtual environment with uv..."
    uv venv .venv

    print_action "Installing dependencies..."
    uv pip install -e ".[dev]"

    print_pass "Virtual environment created and dependencies installed"

    echo ""
    echo -e "  ${GREEN}To activate the virtual environment:${NC}"
    echo ""
    echo "    source .venv/bin/activate"
    echo ""
}

# ============================================================================
# FINAL VERIFICATION
# ============================================================================

final_verification() {
    print_header "PHASE 4: POST-TREATMENT CHECKUP"

    LABS_DIR="$(dirname "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)")"
    cd "$LABS_DIR"

    echo "  Doctor is verifying the treatment was successful..."
    echo ""

    # Check all tools again
    ALL_GOOD=true

    if command_exists python3; then
        PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
        print_pass "Python $PYTHON_VERSION"
    else
        print_fail "Python not found"
        ALL_GOOD=false
    fi

    if command_exists uv; then
        UV_VERSION=$(uv --version 2>&1)
        print_pass "$UV_VERSION"
    else
        print_fail "uv not found"
        ALL_GOOD=false
    fi

    if command_exists make; then
        print_pass "make available"
    else
        print_fail "make not found"
        ALL_GOOD=false
    fi

    if [[ -f "$LABS_DIR/pyproject.toml" ]]; then
        print_pass "pyproject.toml exists"
    else
        print_fail "pyproject.toml missing"
        ALL_GOOD=false
    fi

    if [[ -f "$LABS_DIR/Makefile" ]]; then
        print_pass "Makefile exists"
    else
        print_fail "Makefile missing"
        ALL_GOOD=false
    fi

    if [[ -d "$LABS_DIR/.venv" ]]; then
        print_pass ".venv directory exists"
    else
        print_warn ".venv not created yet"
    fi

    # Check IDE again
    if $IDE_FOUND; then
        print_pass "AI Coding Tool: $IDE_NAME"
    else
        print_warn "No AI Coding Tool detected (see options above)"
    fi

    echo ""

    if $ALL_GOOD && $IDE_FOUND; then
        echo -e "  ${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
        echo -e "  ${GREEN}║                                                           ║${NC}"
        echo -e "  ${GREEN}║   🎉  SETUP COMPLETE - ALL PREREQUISITES INSTALLED!  🎉   ║${NC}"
        echo -e "  ${GREEN}║                                                           ║${NC}"
        echo -e "  ${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo "  Next steps:"
        echo ""
        echo "    1. Activate virtual environment:"
        echo "       ${BLUE}source .venv/bin/activate${NC}"
        echo ""
        echo "    2. Verify with make:"
        echo "       ${BLUE}make check${NC}"
        echo ""
        echo "    3. Start Jupyter:"
        echo "       ${BLUE}make jupyter${NC}"
        echo ""
        echo "    4. See all commands:"
        echo "       ${BLUE}make help${NC}"
        echo ""
    elif $ALL_GOOD && ! $IDE_FOUND; then
        echo -e "  ${YELLOW}╔═══════════════════════════════════════════════════════════╗${NC}"
        echo -e "  ${YELLOW}║                                                           ║${NC}"
        echo -e "  ${YELLOW}║   ⚠️   ALMOST DONE - INSTALL AN AI CODING TOOL           ║${NC}"
        echo -e "  ${YELLOW}║                                                           ║${NC}"
        echo -e "  ${YELLOW}╚═══════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo "  Core tools are installed, but you need an AI coding tool."
        echo "  See the options listed above and install one, then run:"
        echo ""
        echo "    ${BLUE}./scripts/macos-setup.sh${NC}"
        echo ""
    else
        echo -e "  ${YELLOW}Some issues remain. Please check the messages above.${NC}"
    fi
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

main() {
    clear
    echo ""
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                                                                   ║${NC}"
    echo -e "${BLUE}║        SRX DATA SCIENCE LABS - ENVIRONMENT DOCTOR                 ║${NC}"
    echo -e "${BLUE}║                                                                   ║${NC}"
    echo -e "${BLUE}║   Like a doctor: diagnose first, then prescribe treatment         ║${NC}"
    echo -e "${BLUE}║                                                                   ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    # Phase 1: Diagnosis
    diagnose_system

    # Show summary
    if print_diagnosis_summary; then
        # All good - ask about venv setup
        echo ""
        read -p "  Would you like to set up the virtual environment now? (y/n) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            setup_venv
        fi
    else
        # Need installations
        echo ""
        read -p "  Would you like to install missing prerequisites? (y/n) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            run_installation

            # Check if only IDE was missing
            if [[ " ${ITEMS_TO_INSTALL[*]} " =~ " ide " ]] && [[ ${#ITEMS_TO_INSTALL[@]} -eq 1 ]]; then
                echo ""
                echo "  Please install an AI coding tool from the list above."
                echo "  Then run this script again to complete setup."
                exit 0
            fi

            echo ""
            read -p "  Would you like to set up the virtual environment now? (y/n) " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                setup_venv
            fi
        else
            echo ""
            echo "  Installation skipped. Run this script again when ready."
            exit 0
        fi
    fi

    # Final verification
    final_verification
}

# Run main function
main "$@"
