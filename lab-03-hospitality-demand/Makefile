# Lab 3: Hospitality Demand - Makefile
# OS-agnostic commands for development workflow

.PHONY: help setup install clean run app test lint format check doctor download pipeline

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
STREAMLIT_PORT := 8503

help:
	@echo ""
	@echo "Lab 3: Hospitality Demand"
	@echo "========================="
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'
	@echo ""

setup: ## Full setup: create venv and install dependencies
	$(UV) venv $(VENV)
	$(UV) pip install -e ".[dev]"
	@echo "Setup complete! Activate: source $(VENV_BIN)/activate"

install: ## Install dependencies only
	$(UV) pip install -e ".[dev]"

run: ## Start Streamlit dashboard
	$(VENV_BIN)$(SEP)streamlit run app.py --server.port $(STREAMLIT_PORT)

app: run

pipeline: ## Run data processing pipeline
	$(VENV_BIN)$(SEP)python scripts/01_load_bookings.py
	$(VENV_BIN)$(SEP)python scripts/02_analyze_cancellations.py
	$(VENV_BIN)$(SEP)python scripts/03_holiday_integration.py
	$(VENV_BIN)$(SEP)python scripts/04_seasonality_features.py
	$(VENV_BIN)$(SEP)python scripts/05_demand_correlation.py
	@echo "Pipeline complete!"

download: ## Download datasets from Kaggle
	$(MKDIR) data$(SEP)raw
	$(VENV_BIN)$(SEP)kaggle datasets download -d jessemostipak/hotel-booking-demand -p data$(SEP)raw --unzip
	@echo "Datasets downloaded to data/raw/"

lint: ## Run linter
	$(VENV_BIN)$(SEP)ruff check .

format: ## Format code
	$(VENV_BIN)$(SEP)ruff format .

test: ## Run tests
	$(VENV_BIN)$(SEP)pytest -v

clean: ## Remove cache files
ifeq ($(OS),Windows_NT)
	@if exist __pycache__ $(RM_RF) __pycache__
	@if exist .pytest_cache $(RM_RF) .pytest_cache
	@if exist .ruff_cache $(RM_RF) .ruff_cache
else
	$(RM_RF) __pycache__ .pytest_cache .ruff_cache .streamlit
endif

clean-all: clean ## Remove venv and all generated files
ifeq ($(OS),Windows_NT)
	@if exist $(VENV) $(RM_RF) $(VENV)
else
	$(RM_RF) $(VENV)
endif

check: ## Check environment status
	@$(PYTHON) --version
	@$(UV) --version

doctor: ## Run environment diagnostic
	@$(VENV_BIN)$(SEP)python -c "import pandas; print(f'pandas: {pandas.__version__}')" || echo "pandas: NOT INSTALLED"
	@$(VENV_BIN)$(SEP)python -c "import streamlit; print(f'streamlit: {streamlit.__version__}')" || echo "streamlit: NOT INSTALLED"
	@$(VENV_BIN)$(SEP)python -c "import holidays; print(f'holidays: {holidays.__version__}')" || echo "holidays: NOT INSTALLED"

quick-start: setup run
