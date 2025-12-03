# Dataset Download Guide

## Overview

All datasets for the SRX Data Science Labs are sourced from Kaggle, a platform for data science competitions and datasets. This guide will help you set up the Kaggle API and download the required datasets.

## Prerequisites

- Python environment set up (see [Setup Guide](./setup-guide.md))
- Kaggle account (free)
- Terminal/command line access

## Step 1: Create a Kaggle Account

### Register on Kaggle

1. Go to https://www.kaggle.com
2. Click "Register" in the top right corner
3. Sign up using your email or Google account
4. Verify your email address

### Accept Competition and Dataset Rules

Some datasets may require accepting terms of use. When you encounter these, you'll see a prompt on the dataset page to accept the rules before downloading.

## Step 2: Generate Kaggle API Credentials

### Access Your Kaggle Account Settings

1. Log in to Kaggle
2. Click on your profile picture in the top right corner
3. Select "Settings" from the dropdown menu

### Create API Token

1. Scroll down to the "API" section
2. Click the "Create New Token" button
3. A file named `kaggle.json` will download automatically

**Important**: This file contains your credentials. Keep it secure and never share it publicly!

### File Contents

The `kaggle.json` file will look like this:

```json
{
  "username": "your_kaggle_username",
  "key": "your_api_key_here"
}
```

## Step 3: Install and Configure Kaggle CLI

### Install Kaggle Package

With your virtual environment activated:

```bash
pip install kaggle
```

### Configure Credentials

**macOS/Linux:**

```bash
# Create the .kaggle directory in your home folder
mkdir -p ~/.kaggle

# Move the downloaded kaggle.json to this directory
mv ~/Downloads/kaggle.json ~/.kaggle/

# Set proper permissions (important for security)
chmod 600 ~/.kaggle/kaggle.json
```

**Windows:**

```cmd
# Create the .kaggle directory
mkdir %USERPROFILE%\.kaggle

# Move the kaggle.json file
move %USERPROFILE%\Downloads\kaggle.json %USERPROFILE%\.kaggle\

# Windows handles permissions differently - no chmod needed
```

### Verify Configuration

Test that your API credentials are working:

```bash
kaggle datasets list
```

You should see a list of popular Kaggle datasets. If you see an authentication error, double-check that your `kaggle.json` file is in the correct location.

## Step 4: Understanding Kaggle Dataset URLs

### Dataset URL Structure

Kaggle dataset URLs follow this pattern:

```
https://www.kaggle.com/datasets/{owner}/{dataset-name}
```

For example:
- Owner: `dgomonov`
- Dataset: `new-york-city-airbnb-open-data`
- Full URL: https://www.kaggle.com/datasets/dgomonov/new-york-city-airbnb-open-data

### Kaggle CLI Dataset Reference

When using the CLI, you reference datasets as `{owner}/{dataset-name}`:

```bash
kaggle datasets download -d dgomonov/new-york-city-airbnb-open-data
```

## Step 5: Download Datasets

### Option 1: Automated Download (Recommended)

Use the provided download script to fetch all datasets automatically:

```bash
# Navigate to the labs directory
cd /path/to/labs

# Run the download script
python shared/utilities/download_datasets.py
```

This script will:
- Download all required datasets for all 5 labs
- Unzip files automatically
- Organize them into the correct `data/raw/` directories
- Create dataset manifests

**Note**: This process may take 30-60 minutes depending on your internet connection and dataset sizes.

### Option 2: Manual Download Per Lab

If you prefer to download datasets only for specific labs, use these commands:

#### Lab 1: NYC Neighborhood Signals

```bash
cd lab-01-nyc-neighborhood-signals

# NYC Airbnb
kaggle datasets download -d dgomonov/new-york-city-airbnb-open-data -p data/raw/airbnb --unzip

# NY 311 Service Requests (Large: ~10GB)
kaggle datasets download -d new-york-city/ny-311-service-requests -p data/raw/311_requests --unzip

# NYPD Crime Data (Large: ~2GB)
kaggle datasets download -d brunacmendes/nypd-complaint-data-historic-20062019 -p data/raw/nypd_crime --unzip

# NYC Weather
kaggle datasets download -d danbraswell/new-york-city-weather-18692022 -p data/raw/weather --unzip
```

#### Lab 2: US Safety Drivers

```bash
cd lab-02-us-safety-drivers

# US Accidents
kaggle datasets download -d yuvrajdhepe/us-accidents-processed -p data/raw/accidents --unzip

# NOAA Weather (Very Large: ~20GB)
kaggle datasets download -d noaa/noaa-global-surface-summary-of-the-day -p data/raw/weather --unzip

# Zipcode Crosswalk
kaggle datasets download -d danofer/zipcodes-county-fips-crosswalk -p data/raw/geo_crosswalk --unzip

# Public Holidays
kaggle datasets download -d fridrichmrtn/public-holidays -p data/raw/holidays --unzip
```

#### Lab 3: Hospitality Demand

```bash
cd lab-03-hospitality-demand

# Hotel Booking Demand
kaggle datasets download -d jessemostipak/hotel-booking-demand -p data/raw/hotel_bookings --unzip

# Public Holidays (already downloaded in Lab 2, can reuse or download again)
kaggle datasets download -d fridrichmrtn/public-holidays -p data/raw/holidays --unzip

# NOAA Weather (filter to Portugal stations - see lab's data/raw/README.md)
# This will be a subset of Lab 2's weather data
```

#### Lab 4: Streaming Catalog

```bash
cd lab-04-streaming-catalog

# Netflix Shows
kaggle datasets download -d shivamb/netflix-shows -p data/raw/netflix --unzip

# TMDb Movies Dataset
kaggle datasets download -d rounakbanik/the-movies-dataset -p data/raw/tmdb_movies --unzip

# TMDb 5000
kaggle datasets download -d tmdb/tmdb-movie-metadata -p data/raw/tmdb_5000 --unzip
```

#### Lab 5: NYC Mobility Externalities

```bash
cd lab-05-nyc-mobility-externalities

# NYC Taxi Data (Very Large: ~10GB)
kaggle datasets download -d anandaramg/taxi-trip-data-nyc -p data/raw/taxi --unzip

# NY 311 (already downloaded in Lab 1, can create symlink or copy)
# NYC Weather (already downloaded in Lab 1, can create symlink or copy)
```

### Option 3: Manual Browser Download

If the CLI doesn't work for you:

1. Visit each dataset's Kaggle page (URLs listed in each lab's README)
2. Click the "Download" button
3. Unzip the downloaded file
4. Move the contents to the appropriate `data/raw/` subdirectory

## Step 6: Handle Large Datasets

### Storage Requirements

Total storage needed for all datasets: **~50-60 GB**

Individual dataset sizes:
- Small (< 100 MB): Airbnb, Hotel Bookings, Netflix, TMDb
- Medium (100 MB - 1 GB): Zipcode Crosswalk, Public Holidays, US Accidents
- Large (1-10 GB): NYC Weather, NYPD Crime, NYC Taxi, NY 311
- Very Large (> 10 GB): NOAA Weather

### Strategies for Large Files

#### 1. Selective Download

Only download datasets for the lab you're currently working on:

```bash
# Work on Lab 1 first
python shared/utilities/download_datasets.py --lab 1

# Then Lab 2, etc.
python shared/utilities/download_datasets.py --lab 2
```

#### 2. Filtering After Download

For datasets like NY 311 and NOAA Weather, filter to relevant subsets immediately after download to save space. See each lab's `data/raw/README.md` for filtering scripts.

Example for NY 311 (filter to 2019 only):

```python
import pandas as pd

# Read in chunks to avoid memory issues
chunks = pd.read_csv('data/raw/311_requests/311_Service_Requests.csv',
                     chunksize=100000,
                     parse_dates=['Created Date'])

# Filter and save
filtered_chunks = []
for chunk in chunks:
    chunk_2019 = chunk[chunk['Created Date'].dt.year == 2019]
    filtered_chunks.append(chunk_2019)

df_2019 = pd.concat(filtered_chunks, ignore_index=True)
df_2019.to_csv('data/raw/311_requests/311_Service_Requests_2019.csv', index=False)
```

#### 3. Cloud Storage Option

If local storage is limited, consider:
- Using external hard drives
- Cloud storage (Google Drive, Dropbox) with symlinks
- Working directly in cloud notebooks (Google Colab, Kaggle Notebooks)

## Step 7: Verify Downloads

### Check File Integrity

Each lab's `data/raw/README.md` contains expected file counts and sizes. Verify your downloads:

```bash
# Check file sizes
du -sh data/raw/*/

# Count CSV files
find data/raw -name "*.csv" | wc -l
```

### Dataset Manifest

After downloading, the automated script creates a `dataset_manifest.json` in each lab's `data/raw/` directory documenting:
- Download date
- File sizes
- Row counts (for CSV files)
- File checksums

## Troubleshooting

### Issue: "403 Forbidden" Error

**Cause**: You haven't accepted the dataset's terms of use on Kaggle.

**Solution**:
1. Visit the dataset's page on Kaggle
2. Click "Download" (you may see a prompt to accept rules)
3. Accept the terms
4. Try the download command again

### Issue: "401 Unauthorized" Error

**Cause**: API credentials not configured correctly.

**Solution**:
1. Verify `kaggle.json` is in `~/.kaggle/` (or `%USERPROFILE%\.kaggle\` on Windows)
2. Check file permissions: `chmod 600 ~/.kaggle/kaggle.json`
3. Verify the file contains valid JSON
4. Try regenerating your API token on Kaggle

### Issue: Download Interrupted or Incomplete

**Solution**:
```bash
# Remove incomplete download
rm -rf data/raw/dataset_name/*

# Try download again
kaggle datasets download -d owner/dataset-name -p data/raw/dataset_name --unzip
```

### Issue: "Not enough disk space"

**Solution**:
1. Check available space: `df -h`
2. Use selective download strategy (download one lab at a time)
3. Filter large datasets immediately after download
4. Use external storage or cloud options

### Issue: Very Slow Download Speed

**Solution**:
- Use a wired internet connection instead of WiFi
- Download during off-peak hours
- Consider downloading in cloud environment (Colab, Kaggle Notebooks) and syncing

### Issue: Unzip Fails with "Corrupt Archive"

**Solution**:
```bash
# Download without auto-unzip
kaggle datasets download -d owner/dataset-name -p data/raw/dataset_name

# Manually unzip
cd data/raw/dataset_name
unzip *.zip

# If still corrupted, re-download
```

## Dataset License Information

All datasets have their own licenses. Common license types on Kaggle:

- **CC0: Public Domain** - No restrictions
- **CC BY-SA 4.0** - Attribution required, share-alike
- **Database Contents License (DbCL)** - Specific to that dataset
- **Competition/Dataset-specific** - Review on Kaggle page

**For SRX Labs**: All datasets are used for educational purposes only. Do not redistribute or use in production without reviewing the specific dataset's license.

## Rate Limits and Fair Use

Kaggle API has rate limits:
- Hourly download limit: Typically generous for educational use
- If you hit rate limits, wait an hour and try again
- Avoid scripting excessive download attempts

## Alternative: Using Kaggle Notebooks

If you have limited local storage or bandwidth, consider:

1. Create a Kaggle Notebook
2. Add the datasets to your notebook (click "Add Data")
3. Run your analysis in the Kaggle cloud environment
4. Download only the processed results

This is especially useful for Labs 2 and 5 with very large datasets.

## Next Steps

Once datasets are downloaded:

1. Verify file integrity using the manifest
2. Review each lab's `data/raw/README.md` for dataset-specific information
3. Start with [Lab 1 - NYC Neighborhood Signals](../lab-01-nyc-neighborhood-signals/README.md)

## Quick Reference: All Dataset URLs

**Lab 1:**
- https://www.kaggle.com/datasets/dgomonov/new-york-city-airbnb-open-data
- https://www.kaggle.com/datasets/new-york-city/ny-311-service-requests
- https://www.kaggle.com/datasets/brunacmendes/nypd-complaint-data-historic-20062019
- https://www.kaggle.com/datasets/danbraswell/new-york-city-weather-18692022

**Lab 2:**
- https://www.kaggle.com/datasets/yuvrajdhepe/us-accidents-processed
- https://www.kaggle.com/datasets/noaa/noaa-global-surface-summary-of-the-day
- https://www.kaggle.com/datasets/danofer/zipcodes-county-fips-crosswalk
- https://www.kaggle.com/datasets/fridrichmrtn/public-holidays

**Lab 3:**
- https://www.kaggle.com/datasets/jessemostipak/hotel-booking-demand
- https://www.kaggle.com/datasets/fridrichmrtn/public-holidays
- https://www.kaggle.com/datasets/noaa/noaa-global-surface-summary-of-the-day

**Lab 4:**
- https://www.kaggle.com/datasets/shivamb/netflix-shows
- https://www.kaggle.com/datasets/rounakbanik/the-movies-dataset
- https://www.kaggle.com/datasets/tmdb/tmdb-movie-metadata

**Lab 5:**
- https://www.kaggle.com/datasets/anandaramg/taxi-trip-data-nyc
- https://www.kaggle.com/datasets/new-york-city/ny-311-service-requests
- https://www.kaggle.com/datasets/danbraswell/new-york-city-weather-18692022

---

**Ready to download?** Run the automated script or use the manual commands above, then proceed to the labs!
