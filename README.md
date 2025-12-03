# SRX Data Science Labs: Cross-Dataset Correlation Analysis

## 🚀 Quick Start (Read This First!)

Before doing anything else, run the **"Doctor" script** to check and install what you need.

---

## Step 1: Run the Environment Doctor

### 🪟 For Windows Users

**1. Open PowerShell**
- Press the `Windows` key on your keyboard
- Type `PowerShell`
- Click on **"Windows PowerShell"** (the blue icon, NOT Command Prompt)

**2. Navigate to the correct folder**

If you downloaded as ZIP from GitHub:
- Extract the ZIP file first (right-click → "Extract All")
- Open the extracted folder
- You should see folders like `lab-01-nyc-neighborhood-signals`, `scripts`, etc.
- **If you see another folder with the same name inside, go into that one!**

Then copy the path:
- Click on the **address bar** at the top
- Press `Ctrl + C` to copy it
- In PowerShell, type `cd ` (with a space after it)
- Right-click to paste the path
- Press `Enter`

**3. Check you're in the right folder**

Run this command:
```powershell
dir scripts
```

You should see `windows-setup.ps1`. If you see "Cannot find path", you're in the wrong folder - go one level deeper.

**4. Run the Doctor**

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\windows-setup.ps1
```

**5. The Doctor will automatically:**
- Check what's missing (Python, uv, Git)
- Ask you to install each missing item (just press `Enter` or type `Y`)
- Install it for you using winget
- Tell you to restart your terminal if needed

> **Note:** After installations, you need to **close and reopen PowerShell**, then run the Doctor again.

---

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

## What the Doctor Checks

The Doctor script examines your computer like a health checkup:

| Check | Required? | What It Does |
|-------|-----------|--------------|
| ✅ Python 3.12+ | **Yes** | Programming language (auto-installs via winget) |
| ✅ uv | **Yes** | Fast package installer (auto-installs) |
| ⚪ Git | Optional | Version control |
| ⚪ GNU Make | Optional | Build automation (can use `uv` directly instead) |
| ⚪ AI Coding Tool | Recommended | Claude Code, Cursor, VS Code, etc. |

**The Doctor auto-installs** Python and uv when missing. Just press `Y` when prompted!

---

## Step 2: Set Up a Lab

Once the Doctor says you're healthy, go into any lab folder and set it up:

```powershell
cd lab-01-nyc-neighborhood-signals
```

**If you have Make:**
```
make setup
```

**If you don't have Make (Windows without admin):**
```
uv sync
```

This creates a virtual environment and installs all dependencies.

---

## Step 3: Start Working

Each lab has these commands:

| With Make | Without Make (uv directly) | What It Does |
|-----------|---------------------------|--------------|
| `make setup` | `uv sync` | Install everything (run once) |
| `make run` | `uv run streamlit run app.py` | Start the Streamlit dashboard |
| `make download` | `uv run python scripts/download.py` | Download datasets from Kaggle |
| `make pipeline` | `uv run python scripts/pipeline.py` | Run data processing scripts |
| `make help` | - | Show all available commands |

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

**"script not digitally signed" on Windows**

Use the Bypass command (already included in instructions above):
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\windows-setup.ps1
```

**"command not found: make" on Windows**

No worries! Make is optional. Use `uv` commands directly:
```powershell
uv sync                              # instead of: make setup
uv run streamlit run app.py          # instead of: make run
```

**"permission denied" on Mac**
```bash
chmod +x ./scripts/macos-setup.sh
```

**"Python installed but not found" after installation**

Close your terminal completely and reopen it. Then run the Doctor again.

**"kaggle: command not found"**
- Make sure you ran `make setup` (or `uv sync`) in the lab folder first
- Then use: `uv run kaggle ...` instead of just `kaggle ...`

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
