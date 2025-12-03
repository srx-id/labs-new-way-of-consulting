# SRX Data Science Labs: Cross-Dataset Correlation Analysis

## 🚀 Quick Start (Read This First!)

Before doing anything else, you need to check if your computer has the right tools installed. We have a **"Doctor" script** that checks everything for you.

---

## Step 1: Run the Environment Doctor

### 🍎 For Mac Users

**1. Open Terminal**
- Press `Command + Space` on your keyboard
- Type `Terminal`
- Press `Enter` (a black/white window will open)

**2. Navigate to this folder**

In Finder, locate the `labs` folder, then:
- Right-click on the `labs` folder
- Hold `Option` key → Click **"Copy 'labs' as Pathname"**
- In Terminal, type `cd ` (with a space after it)
- Press `Command + V` to paste the path
- Press `Enter`

Example (your path will be different):
```bash
cd /Users/yourname/Documents/labs
```

**3. Run the Doctor**

Copy and paste this command, then press `Enter`:
```bash
./scripts/macos-setup.sh
```

> If you get "permission denied", run this first, then try again:
> ```bash
> chmod +x ./scripts/macos-setup.sh
> ```

**4. Follow the prompts**
- The Doctor will check your system
- If something is missing, it will tell you what to install
- Say `y` (yes) when asked to install missing items

---

### 🪟 For Windows Users

**1. Open PowerShell**
- Press the `Windows` key on your keyboard
- Type `PowerShell`
- Click on **"Windows PowerShell"** (NOT Command Prompt)

**2. Navigate to this folder**

In File Explorer, locate the `labs` folder, then:
- Click on the address bar at the top (where it shows the folder path)
- The path will be highlighted - press `Ctrl + C` to copy it
- In PowerShell, type `cd ` (with a space after it)
- Right-click to paste the path
- Press `Enter`

Example (your path will be different):
```powershell
cd C:\Users\YourName\Documents\labs
```

**3. Run the Doctor**

Copy and paste this command, then press `Enter`:
```powershell
.\scripts\windows-setup.ps1
```

> If you get a "script execution" error, run this first:
> ```powershell
> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
> ```
> Then try the Doctor command again.

**4. Follow the prompts**
- The Doctor will check your system
- If something is missing, it will tell you what to install
- Say `Y` (yes) when asked to proceed

---

## What the Doctor Checks

The Doctor script examines your computer like a health checkup:

| Check | What It Means |
|-------|---------------|
| ✅ Python 3.12+ | Programming language we use |
| ✅ uv | Fast package installer |
| ✅ make | Build automation tool |
| ✅ git | Version control (already have if you cloned this) |
| ✅ AI Coding Tool | Claude Code, Cursor, VS Code, etc. |

If any check fails, the Doctor will show you exactly how to fix it.

---

## Step 2: Set Up a Lab

Once the Doctor says you're healthy, go into any lab folder and set it up:

**Mac:**
```bash
cd lab-01-nyc-neighborhood-signals
make setup
```

**Windows (PowerShell):**
```powershell
cd lab-01-nyc-neighborhood-signals
make setup
```

This creates a virtual environment and installs all dependencies.

---

## Step 3: Start Working

Each lab has these commands:

| Command | What It Does |
|---------|--------------|
| `make setup` | Install everything (run once) |
| `make run` | Start the Streamlit dashboard |
| `make download` | Download datasets from Kaggle |
| `make pipeline` | Run data processing scripts |
| `make help` | Show all available commands |

---

## Overview

Welcome to the SRX Data Science Labs! This teaching repository helps non-engineer team members master essential data science skills through 5 hands-on labs using real-world datasets.

**What You'll Learn:**
- Data cleansing and quality assessment
- Analytics and exploratory data analysis
- Correlation analysis techniques
- Data visualization with Streamlit and Plotly
- Consultant-level presentation and storytelling

**End Goal**: Every lab produces **visualizations** (charts) and **insights** (executive summary) - not just code.

---

## The 5 Labs

| Lab | Focus Area | What You'll Build |
|-----|-----------|-------------------|
| [Lab 1: NYC Neighborhood Signals](./lab-01-nyc-neighborhood-signals/) | Geographic Joins | Airbnb + Crime + Weather correlation dashboard |
| [Lab 2: US Safety Drivers](./lab-02-us-safety-drivers/) | Time + Location | Accident severity analysis with weather |
| [Lab 3: Hospitality Demand](./lab-03-hospitality-demand/) | Calendar Joins | Hotel booking patterns and cancellation drivers |
| [Lab 4: Streaming Catalog](./lab-04-streaming-catalog/) | Fuzzy Matching | Cross-platform content reconciliation |
| [Lab 5: NYC Mobility](./lab-05-nyc-mobility-externalities/) | High Volume Data | Taxi and 311 complaint correlation |

---

## Lab Folder Structure

Each lab is a complete Python project:

```
lab-XX-name/
├── README.md           # Lab instructions
├── Makefile            # Commands: make setup, make run, etc.
├── pyproject.toml      # Python dependencies
├── app.py              # Streamlit dashboard (run with: make run)
├── data/
│   ├── raw/            # Downloaded datasets (make download)
│   └── processed/      # Your analysis outputs
├── scripts/            # Data processing pipeline
├── src/                # Reusable Python code
├── exercises/          # Step-by-step exercise guides
├── findings/           # Your executive summaries
└── visualizations/     # Your charts and graphs
```

---

## Vibe Coding Approach

These labs use **"Vibe Coding"** - you describe what you want in plain English, and AI writes the code for you.

**Instead of writing Python yourself, you'll:**
1. Read the exercise prompts in `exercises/` folder
2. Copy the "Vibe Coding Prompt" into your AI tool (Claude Code, Cursor, etc.)
3. Let the AI generate the Python code
4. Review and run the code
5. Iterate until you get the results you need

**The exercises teach you:**
- What to ask for (the right prompts)
- What to look for (validation checks)
- How to interpret results (business insights)

---

## Prerequisites

**Required Tools** (the Doctor checks these):
- Python 3.12 or higher
- uv (Python package manager)
- make (build tool)
- At least one AI coding tool:
  - Claude Code (recommended)
  - Cursor
  - VS Code with GitHub Copilot
  - Aider
  - Windsurf

**Kaggle Account** (for downloading datasets):
- Create account at [kaggle.com](https://www.kaggle.com)
- Get API key from Settings → API → Create New Token
- See [Dataset Download Guide](./docs/dataset-download-guide.md)

---

## Getting Help

### Common Issues

**"command not found: make"**
- Mac: Run `xcode-select --install`
- Windows: Run `winget install GnuWin32.Make`

**"permission denied" on Mac**
```bash
chmod +x ./scripts/macos-setup.sh
```

**"script execution disabled" on Windows**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**"kaggle: command not found"**
- Make sure you ran `make setup` in the lab folder first
- Activate the virtual environment:
  - Mac: `source .venv/bin/activate`
  - Windows: `.venv\Scripts\Activate.ps1`

### Documentation

- [Setup Guide](./docs/setup-guide.md) - Detailed environment setup
- [Dataset Download Guide](./docs/dataset-download-guide.md) - Kaggle API configuration
- [Correlation Primer](./docs/correlation-primer.md) - Statistics concepts explained

---

## Expected Time Investment

| Lab | Estimated Time |
|-----|----------------|
| Lab 1 | 4-6 hours |
| Lab 2 | 4-6 hours |
| Lab 3 | 4-5 hours |
| Lab 4 | 5-7 hours |
| Lab 5 | 5-7 hours |
| **Total** | **22-31 hours** |

---

## Streamlit Ports

Each lab runs on a different port so you can have multiple open:

| Lab | Port | URL |
|-----|------|-----|
| Lab 1 | 8501 | http://localhost:8501 |
| Lab 2 | 8502 | http://localhost:8502 |
| Lab 3 | 8503 | http://localhost:8503 |
| Lab 4 | 8504 | http://localhost:8504 |
| Lab 5 | 8505 | http://localhost:8505 |

---

## Learning Objectives

By completing all 5 labs, you will be able to:

- ✅ Set up Python data science environments
- ✅ Use AI tools for "Vibe Coding" data analysis
- ✅ Perform data quality assessments
- ✅ Execute geographic and temporal joins
- ✅ Calculate and interpret correlations
- ✅ Create interactive Streamlit dashboards
- ✅ Handle large datasets efficiently
- ✅ Write executive summaries with business insights

---

## Dataset Attribution

All datasets are from Kaggle under their respective licenses:
- NYC Airbnb Open Data (CC0)
- NY 311 Service Requests (NYC Open Data)
- US Accidents (CC BY-NC-SA 4.0)
- Hotel Booking Demand (CC0)
- Netflix/Amazon/Disney Catalogs (CC0)
- NYC Taxi Trip Data (NYC Open Data)

---

**Ready to start?** Run the Doctor first, then head to [Lab 1](./lab-01-nyc-neighborhood-signals/)!
