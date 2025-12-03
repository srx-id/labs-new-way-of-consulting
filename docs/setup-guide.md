# Environment Setup Guide

## Overview

This guide will help you set up your Python environment for the SRX Data Science Labs. Follow these steps carefully to ensure all required packages are installed and configured correctly.

## Step 1: Install Python

### Check if Python is Already Installed

Open your terminal (Command Prompt on Windows, Terminal on Mac/Linux) and run:

```bash
python --version
```

or

```bash
python3 --version
```

You should see Python 3.8 or higher. If not, proceed to install Python.

### Install Python 3.8+

**macOS:**
```bash
# Using Homebrew (recommended)
brew install python@3.11

# Or download from python.org
# Visit: https://www.python.org/downloads/mac-osx/
```

**Windows:**
1. Download Python from https://www.python.org/downloads/windows/
2. Run the installer
3. **Important**: Check "Add Python to PATH" during installation

**Linux (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install python3.11 python3-pip python3-venv
```

## Step 2: Create a Virtual Environment

Virtual environments isolate your project dependencies from system-wide Python packages.

### Navigate to the Labs Directory

```bash
cd /path/to/labs
# Example: cd ~/Documents/srx/codes/POC_ONLY/labs
```

### Create the Virtual Environment

```bash
# Create a virtual environment named 'venv'
python3 -m venv venv
```

### Activate the Virtual Environment

**macOS/Linux:**
```bash
source venv/bin/activate
```

**Windows (Command Prompt):**
```cmd
venv\Scripts\activate.bat
```

**Windows (PowerShell):**
```powershell
venv\Scripts\Activate.ps1
```

You should see `(venv)` appear at the beginning of your terminal prompt, indicating the virtual environment is active.

## Step 3: Install Required Packages

### Core Data Science Libraries

With your virtual environment activated, install the required packages:

```bash
pip install --upgrade pip
pip install pandas numpy scipy matplotlib seaborn streamlit jupyter scikit-learn
```

### Package Breakdown

| Package | Version | Purpose |
|---------|---------|---------|
| pandas | ≥1.5.0 | Data manipulation and analysis |
| numpy | ≥1.23.0 | Numerical computing |
| scipy | ≥1.9.0 | Statistical functions (correlation calculations) |
| matplotlib | ≥3.6.0 | Basic plotting and visualization |
| seaborn | ≥0.12.0 | Statistical data visualization |
| streamlit | ≥1.28.0 | Interactive dashboard creation |
| jupyter | ≥1.0.0 | Jupyter notebook support (optional) |
| scikit-learn | ≥1.2.0 | Machine learning utilities |

### Optional Packages for Advanced Labs

```bash
# For Lab 4 (Fuzzy Matching)
pip install rapidfuzz

# For Lab 5 (Large Dataset Processing)
pip install dask[complete]

# For enhanced data exploration
pip install pandas-profiling
```

### Verify Installation

Create a test script to verify all packages are installed:

```bash
python -c "import pandas; import numpy; import scipy; import matplotlib; import seaborn; import streamlit; print('All packages installed successfully!')"
```

## Step 4: Install Kaggle CLI

The Kaggle CLI is required to download datasets.

```bash
pip install kaggle
```

Verify installation:

```bash
kaggle --version
```

Configuration steps are covered in the [Dataset Download Guide](./dataset-download-guide.md).

## Step 5: Verify Your Setup

### Quick Verification Script

Create a file named `verify_setup.py` in the labs directory:

```python
#!/usr/bin/env python3
"""Verify that all required packages are installed with correct versions."""

import sys

def check_package(package_name, min_version=None):
    try:
        module = __import__(package_name)
        version = getattr(module, '__version__', 'unknown')
        print(f"✓ {package_name}: {version}")
        return True
    except ImportError:
        print(f"✗ {package_name}: NOT INSTALLED")
        return False

def main():
    print("Checking required packages...\n")

    required = [
        'pandas',
        'numpy',
        'scipy',
        'matplotlib',
        'seaborn',
        'streamlit',
        'sklearn',  # scikit-learn imports as sklearn
    ]

    optional = [
        'jupyter',
        'rapidfuzz',
        'dask',
    ]

    print("Required Packages:")
    required_ok = all(check_package(pkg) for pkg in required)

    print("\nOptional Packages:")
    for pkg in optional:
        check_package(pkg)

    print("\n" + "="*50)
    if required_ok:
        print("✓ All required packages installed successfully!")
        print("You're ready to start the labs.")
    else:
        print("✗ Some required packages are missing.")
        print("Please install them using: pip install <package-name>")
        sys.exit(1)

if __name__ == "__main__":
    main()
```

Run the verification script:

```bash
python verify_setup.py
```

## Troubleshooting

### Issue: "command not found: python"

**Solution**: Try `python3` instead of `python`, or ensure Python is added to your PATH.

### Issue: Permission denied when installing packages

**Solution**:
- Don't use `sudo pip install` (can cause permission issues)
- Ensure your virtual environment is activated
- On Windows, run terminal as Administrator if needed

### Issue: "No module named pip"

**Solution**:
```bash
python3 -m ensurepip --upgrade
```

### Issue: Slow package installation

**Solution**: Some packages (like numpy, scipy) compile native code and can take time. Be patient or use pre-compiled wheels:

```bash
pip install --only-binary :all: numpy scipy pandas
```

### Issue: Import errors after installation

**Solution**:
1. Verify virtual environment is activated
2. Restart your terminal
3. Reinstall the package: `pip install --force-reinstall <package-name>`

### Issue: Conflicting package versions

**Solution**: Create a fresh virtual environment:

```bash
deactivate  # Exit current environment
rm -rf venv  # Delete old environment
python3 -m venv venv  # Create new environment
source venv/bin/activate  # Activate new environment
pip install pandas numpy scipy matplotlib seaborn streamlit
```

## IDE Setup (Optional)

### VS Code

1. Install the Python extension
2. Select your virtual environment as the interpreter:
   - Press `Cmd+Shift+P` (Mac) or `Ctrl+Shift+P` (Windows/Linux)
   - Type "Python: Select Interpreter"
   - Choose the interpreter from `./venv/bin/python`

### Jupyter Notebook

If you prefer Jupyter notebooks for exploration:

```bash
# Activate your virtual environment first
pip install jupyter ipykernel
python -m ipykernel install --user --name=srx-labs
jupyter notebook
```

### PyCharm

1. Open the labs directory as a project
2. Go to Settings > Project > Python Interpreter
3. Click the gear icon > Add
4. Select "Existing environment"
5. Navigate to `venv/bin/python` (or `venv\Scripts\python.exe` on Windows)

## Deactivating Your Environment

When you're done working, deactivate your virtual environment:

```bash
deactivate
```

## Next Steps

Once your environment is set up:

1. Configure the Kaggle API: [Dataset Download Guide](./dataset-download-guide.md)
2. Download datasets: Run `python shared/utilities/download_datasets.py`
3. Start learning: [Lab 1 - NYC Neighborhood Signals](../lab-01-nyc-neighborhood-signals/README.md)

## Updating Packages

Periodically update your packages to get bug fixes and new features:

```bash
# Update all packages
pip list --outdated
pip install --upgrade pandas numpy scipy matplotlib seaborn streamlit

# Or update everything (use with caution)
pip install --upgrade --upgrade-strategy eager pandas numpy scipy matplotlib seaborn streamlit
```

## Creating a Requirements File

To share your exact environment with others:

```bash
pip freeze > requirements.txt
```

To recreate the environment on another machine:

```bash
pip install -r requirements.txt
```

## Platform-Specific Notes

### macOS Apple Silicon (M1/M2/M3)

Some packages may require Rosetta or native ARM builds:

```bash
# Install Homebrew for ARM
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Python
brew install python@3.11

# For native ARM performance with data libraries
pip install --upgrade pip
pip install pandas numpy scipy matplotlib seaborn
```

### Windows Subsystem for Linux (WSL)

If using WSL, follow the Linux instructions above. WSL provides better compatibility with Python data science tools.

---

**Questions or Issues?** Refer to the [Teaching Guidelines](./teaching-guidelines.md) or consult with your lab instructor.
