# Lab 1: NYC Neighborhood Signal Extraction - Makefile
# OS-agnostic commands for development workflow
#
# Usage: make <target>
# Run 'make help' to see all available commands

.PHONY: help setup install clean run app test lint format check doctor download

# ============================================================================
# Configuration
# ============================================================================

# Detect OS for cross-platform compatibility
ifeq ($(OS),Windows_NT)
    PYTHON := python
    VENV_BIN := .venv/Scripts
    RM_RF := rmdir /s /q
    MKDIR := mkdir
    SEP := \\
else
    PYTHON := python3
    VENV_BIN := .venv/bin
    RM_RF := rm -rf
    MKDIR := mkdir -p
    SEP := /
endif

UV := uv
VENV := .venv
STREAMLIT_PORT := 8501

# ============================================================================
# Default Target
# ============================================================================

help: ## Show this help message
	@echo ""
	@echo "Lab 1: NYC Neighborhood Signal Extraction"
	@echo "=========================================="
	@echo ""
	@echo "Available commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'
	@echo ""
	@echo "Quick start:"
	@echo "  1. make setup     - Create venv and install dependencies"
	@echo "  2. make run       - Start Streamlit dashboard"
	@echo ""

# ============================================================================
# Environment Setup
# ============================================================================

setup: ## Full setup: create venv and install all dependencies
	@echo "Creating virtual environment..."
	$(UV) venv $(VENV)
	@echo "Installing dependencies..."
	$(UV) pip install -e ".[dev]"
	@echo ""
	@echo "Setup complete!"
	@echo ""
	@echo "Activate the virtual environment:"
ifeq ($(OS),Windows_NT)
	@echo "  $(VENV_BIN)\\activate"
else
	@echo "  source $(VENV_BIN)/activate"
endif
	@echo ""

install: ## Install dependencies only (assumes venv exists)
	@echo "Installing dependencies..."
	$(UV) pip install -e ".[dev]"
	@echo "Dependencies installed!"

sync: ## Sync dependencies with uv
	@echo "Syncing dependencies..."
	$(UV) sync
	@echo "Dependencies synced!"

# ============================================================================
# Application
# ============================================================================

run: ## Start Streamlit dashboard
	@echo "Starting Streamlit dashboard on port $(STREAMLIT_PORT)..."
	$(VENV_BIN)$(SEP)streamlit run app.py --server.port $(STREAMLIT_PORT)

app: run ## Alias for 'make run'

kill-port: ## Kill any process using the Streamlit port
ifeq ($(OS),Windows_NT)
	@FOR /F "tokens=5" %%a IN ('netstat -aon ^| findstr :$(STREAMLIT_PORT)') DO taskkill /F /PID %%a 2>nul || echo "No process on port $(STREAMLIT_PORT)"
else
	@lsof -ti:$(STREAMLIT_PORT) | xargs kill -9 2>/dev/null || echo "No process on port $(STREAMLIT_PORT)"
endif

# ============================================================================
# Data Processing Pipeline
# ============================================================================

pipeline: ## Run full data processing pipeline
	@echo "Running data processing pipeline..."
	$(VENV_BIN)$(SEP)python scripts/01_extract_load.py
	$(VENV_BIN)$(SEP)python scripts/02_clean_standardize.py
	$(VENV_BIN)$(SEP)python scripts/03_aggregate.py
	$(VENV_BIN)$(SEP)python scripts/04_join_datasets.py
	$(VENV_BIN)$(SEP)python scripts/05_correlation_analysis.py
	@echo "Pipeline complete! Check data/processed/ for outputs."

# ============================================================================
# Code Quality
# ============================================================================

lint: ## Run linter (ruff)
	@echo "Running linter..."
	$(VENV_BIN)$(SEP)ruff check .

lint-fix: ## Auto-fix linting issues
	@echo "Auto-fixing linting issues..."
	$(VENV_BIN)$(SEP)ruff check --fix .

format: ## Format code with ruff
	@echo "Formatting code..."
	$(VENV_BIN)$(SEP)ruff format .

format-check: ## Check formatting without changes
	@echo "Checking format..."
	$(VENV_BIN)$(SEP)ruff format --check .

test: ## Run tests with pytest
	@echo "Running tests..."
	$(VENV_BIN)$(SEP)pytest -v

# ============================================================================
# Data Management
# ============================================================================

download: ## Download datasets from Kaggle (requires kaggle.json)
	@echo "Downloading datasets..."
	@echo "Ensure you have ~/.kaggle/kaggle.json configured"
	$(MKDIR) data$(SEP)raw
	$(VENV_BIN)$(SEP)kaggle datasets download -d dgomonov/new-york-city-airbnb-open-data -p data$(SEP)raw --unzip
	$(VENV_BIN)$(SEP)kaggle datasets download -d new-york-city/ny-311-service-requests -p data$(SEP)raw --unzip
	$(VENV_BIN)$(SEP)kaggle datasets download -d brunacmendes/nypd-complaint-data-historic-20062019 -p data$(SEP)raw --unzip
	$(VENV_BIN)$(SEP)kaggle datasets download -d danbraswell/new-york-city-weather-18692022 -p data$(SEP)raw --unzip
	@echo "Datasets downloaded to data/raw/"

# ============================================================================
# Cleanup
# ============================================================================

clean: ## Remove cache files and temporary data
	@echo "Cleaning cache files..."
ifeq ($(OS),Windows_NT)
	@if exist __pycache__ $(RM_RF) __pycache__
	@if exist .pytest_cache $(RM_RF) .pytest_cache
	@if exist .ruff_cache $(RM_RF) .ruff_cache
	@for /d /r . %%d in (__pycache__) do @if exist "%%d" $(RM_RF) "%%d"
else
	$(RM_RF) __pycache__ .pytest_cache .ruff_cache .streamlit
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete 2>/dev/null || true
endif
	@echo "Cleaned!"

clean-all: clean ## Remove venv and all generated files
	@echo "Removing virtual environment..."
ifeq ($(OS),Windows_NT)
	@if exist $(VENV) $(RM_RF) $(VENV)
else
	$(RM_RF) $(VENV)
endif
	@echo "Full cleanup complete!"

# ============================================================================
# Status & Diagnostics
# ============================================================================

check: ## Check environment status
	@echo "Environment Check"
	@echo "================="
	@echo ""
	@echo "Python: $$($(PYTHON) --version 2>&1)"
	@echo "uv: $$($(UV) --version 2>&1)"
	@echo ""
	@echo "Virtual environment: $(VENV)"
ifeq ($(OS),Windows_NT)
	@if exist $(VENV) (echo   Status: exists) else (echo   Status: not created)
else
	@[ -d "$(VENV)" ] && echo "  Status: exists" || echo "  Status: not created"
endif
	@echo ""
	@echo "Data directories:"
ifeq ($(OS),Windows_NT)
	@if exist data\raw (echo   data/raw: exists) else (echo   data/raw: missing)
	@if exist data\processed (echo   data/processed: exists) else (echo   data/processed: missing)
else
	@[ -d "data/raw" ] && echo "  data/raw: exists" || echo "  data/raw: missing"
	@[ -d "data/processed" ] && echo "  data/processed: exists" || echo "  data/processed: missing"
endif
	@echo ""

doctor: ## Run full environment diagnostic
	@echo "Running environment diagnostic..."
	@echo ""
	@$(PYTHON) --version
	@$(UV) --version
	@echo ""
	@echo "Checking dependencies..."
	@$(VENV_BIN)$(SEP)python -c "import pandas; print(f'pandas: {pandas.__version__}')" 2>/dev/null || echo "pandas: NOT INSTALLED"
	@$(VENV_BIN)$(SEP)python -c "import streamlit; print(f'streamlit: {streamlit.__version__}')" 2>/dev/null || echo "streamlit: NOT INSTALLED"
	@$(VENV_BIN)$(SEP)python -c "import plotly; print(f'plotly: {plotly.__version__}')" 2>/dev/null || echo "plotly: NOT INSTALLED"
	@echo ""
	@echo "Diagnostic complete!"

# ============================================================================
# Quick Start
# ============================================================================

quick-start: setup run ## Setup and start Streamlit in one command

all: format lint check ## Format, lint, and check environment
