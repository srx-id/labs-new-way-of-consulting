#!/usr/bin/env python3
"""
Dataset Download Automation Script
Downloads all Kaggle datasets for SRX Data Science Labs

Usage:
    python download_datasets.py              # Download all labs
    python download_datasets.py --lab 1      # Download Lab 1 only
    python download_datasets.py --lab 2 3    # Download Labs 2 and 3

Prerequisites:
    - Kaggle API installed: pip install kaggle
    - Kaggle credentials configured: ~/.kaggle/kaggle.json
    - See docs/dataset-download-guide.md for setup instructions
"""

import os
import subprocess
import sys
import argparse
import json
from pathlib import Path
from datetime import datetime

# Base directory - assumes script is in shared/utilities/
BASE_DIR = Path(__file__).parent.parent.parent.absolute()

# Dataset configuration
DATASETS = {
    1: {
        "name": "lab-01-nyc-neighborhood-signals",
        "datasets": [
            {
                "kaggle_ref": "dgomonov/new-york-city-airbnb-open-data",
                "target_dir": "data/raw/airbnb",
                "description": "NYC Airbnb Open Data"
            },
            {
                "kaggle_ref": "new-york-city/ny-311-service-requests",
                "target_dir": "data/raw/311_requests",
                "description": "NY 311 Service Requests (Large: ~10GB)"
            },
            {
                "kaggle_ref": "brunacmendes/nypd-complaint-data-historic-20062019",
                "target_dir": "data/raw/nypd_crime",
                "description": "NYPD Crime Complaint Data Historic"
            },
            {
                "kaggle_ref": "danbraswell/new-york-city-weather-18692022",
                "target_dir": "data/raw/weather",
                "description": "NYC Weather 1869-2022"
            }
        ]
    },
    2: {
        "name": "lab-02-us-safety-drivers",
        "datasets": [
            {
                "kaggle_ref": "yuvrajdhepe/us-accidents-processed",
                "target_dir": "data/raw/accidents",
                "description": "US Accidents Processed"
            },
            {
                "kaggle_ref": "noaa/noaa-global-surface-summary-of-the-day",
                "target_dir": "data/raw/weather",
                "description": "NOAA Weather Data (Very Large: ~20GB)"
            },
            {
                "kaggle_ref": "danofer/zipcodes-county-fips-crosswalk",
                "target_dir": "data/raw/geo_crosswalk",
                "description": "US Zipcode to County/FIPS Crosswalk"
            },
            {
                "kaggle_ref": "fridrichmrtn/public-holidays",
                "target_dir": "data/raw/holidays",
                "description": "Worldwide Public Holidays"
            }
        ]
    },
    3: {
        "name": "lab-03-hospitality-demand",
        "datasets": [
            {
                "kaggle_ref": "jessemostipak/hotel-booking-demand",
                "target_dir": "data/raw/hotel_bookings",
                "description": "Hotel Booking Demand"
            },
            {
                "kaggle_ref": "fridrichmrtn/public-holidays",
                "target_dir": "data/raw/holidays",
                "description": "Worldwide Public Holidays (shared with Lab 2)"
            },
            {
                "kaggle_ref": "noaa/noaa-global-surface-summary-of-the-day",
                "target_dir": "data/raw/weather",
                "description": "NOAA Weather Data (shared with Lab 2)"
            }
        ]
    },
    4: {
        "name": "lab-04-streaming-catalog",
        "datasets": [
            {
                "kaggle_ref": "shivamb/netflix-shows",
                "target_dir": "data/raw/netflix",
                "description": "Netflix Movies and TV Shows"
            },
            {
                "kaggle_ref": "rounakbanik/the-movies-dataset",
                "target_dir": "data/raw/tmdb_movies",
                "description": "The Movies Dataset (TMDb)"
            },
            {
                "kaggle_ref": "tmdb/tmdb-movie-metadata",
                "target_dir": "data/raw/tmdb_5000",
                "description": "TMDb 5000 Movie Dataset"
            }
        ]
    },
    5: {
        "name": "lab-05-nyc-mobility-externalities",
        "datasets": [
            {
                "kaggle_ref": "anandaramg/taxi-trip-data-nyc",
                "target_dir": "data/raw/taxi",
                "description": "NYC Taxi Trip Data (Very Large: ~10GB)"
            },
            {
                "kaggle_ref": "new-york-city/ny-311-service-requests",
                "target_dir": "data/raw/311_requests",
                "description": "NY 311 Service Requests (shared with Lab 1)"
            },
            {
                "kaggle_ref": "danbraswell/new-york-city-weather-18692022",
                "target_dir": "data/raw/weather",
                "description": "NYC Weather (shared with Lab 1)"
            }
        ]
    }
}


def check_kaggle_setup():
    """Verify Kaggle API is installed and configured."""
    print("Checking Kaggle API setup...")

    # Check if kaggle command exists
    try:
        result = subprocess.run(
            ["kaggle", "--version"],
            capture_output=True,
            text=True,
            check=False
        )
        if result.returncode != 0:
            print("❌ Kaggle CLI not found. Install with: pip install kaggle")
            return False
        print(f"✓ Kaggle CLI found: {result.stdout.strip()}")
    except FileNotFoundError:
        print("❌ Kaggle CLI not found. Install with: pip install kaggle")
        return False

    # Check if credentials are configured
    kaggle_config = Path.home() / ".kaggle" / "kaggle.json"
    if not kaggle_config.exists():
        print(f"❌ Kaggle credentials not found at {kaggle_config}")
        print("   See docs/dataset-download-guide.md for setup instructions")
        return False

    print(f"✓ Kaggle credentials found at {kaggle_config}")
    return True


def download_dataset(kaggle_ref, target_path, description):
    """Download a single Kaggle dataset."""
    target_path.mkdir(parents=True, exist_ok=True)

    print(f"\n{'='*70}")
    print(f"Dataset: {description}")
    print(f"Kaggle: {kaggle_ref}")
    print(f"Target: {target_path}")
    print(f"{'='*70}")

    # Check if already downloaded
    if any(target_path.iterdir()):
        print(f"⚠️  Directory not empty. Files already exist.")
        response = input("   Download anyway? This will add/overwrite files. [y/N]: ")
        if response.lower() != 'y':
            print("   Skipped.")
            return False

    cmd = [
        "kaggle", "datasets", "download",
        "-d", kaggle_ref,
        "-p", str(target_path),
        "--unzip"
    ]

    print(f"\nDownloading...")
    try:
        result = subprocess.run(cmd, check=True, capture_output=False, text=True)
        print(f"✓ Downloaded successfully")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Download failed: {e}")
        print(f"\nTroubleshooting:")
        print(f"1. Visit https://www.kaggle.com/datasets/{kaggle_ref}")
        print(f"2. Accept the dataset's terms (if required)")
        print(f"3. Verify your Kaggle credentials")
        print(f"4. Try manual download if issues persist")
        return False


def create_dataset_manifest(lab_path, lab_name):
    """Create a manifest file documenting downloaded datasets."""
    manifest_path = lab_path / "data" / "raw" / "dataset_manifest.json"

    manifest = {
        "lab_name": lab_name,
        "download_date": datetime.now().isoformat(),
        "datasets": []
    }

    raw_path = lab_path / "data" / "raw"
    for item in raw_path.iterdir():
        if item.is_dir() and item.name not in ['samples']:
            dataset_info = {
                "directory": item.name,
                "files": []
            }

            for file in item.iterdir():
                if file.is_file():
                    dataset_info["files"].append({
                        "name": file.name,
                        "size_mb": round(file.stat().st_size / (1024 * 1024), 2)
                    })

            manifest["datasets"].append(dataset_info)

    with open(manifest_path, 'w') as f:
        json.dump(manifest, f, indent=2)

    print(f"\n✓ Created manifest: {manifest_path}")


def download_lab(lab_number):
    """Download all datasets for a specific lab."""
    if lab_number not in DATASETS:
        print(f"❌ Lab {lab_number} not found. Valid labs: 1-5")
        return False

    lab_config = DATASETS[lab_number]
    lab_name = lab_config["name"]
    lab_path = BASE_DIR / lab_name

    if not lab_path.exists():
        print(f"❌ Lab directory not found: {lab_path}")
        return False

    print(f"\n{'#'*70}")
    print(f"# LAB {lab_number}: {lab_name}")
    print(f"{'#'*70}")

    success_count = 0
    for dataset in lab_config["datasets"]:
        target = lab_path / dataset["target_dir"]
        if download_dataset(
            dataset["kaggle_ref"],
            target,
            dataset["description"]
        ):
            success_count += 1

    # Create manifest
    create_dataset_manifest(lab_path, lab_name)

    total = len(lab_config["datasets"])
    print(f"\n{'='*70}")
    print(f"Lab {lab_number} Summary: {success_count}/{total} datasets downloaded successfully")
    print(f"{'='*70}")

    return success_count == total


def main():
    parser = argparse.ArgumentParser(
        description="Download Kaggle datasets for SRX Data Science Labs",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python download_datasets.py              # Download all labs
  python download_datasets.py --lab 1      # Download Lab 1 only
  python download_datasets.py --lab 2 3    # Download Labs 2 and 3
  python download_datasets.py --skip-check # Skip Kaggle setup check

For setup instructions, see: docs/dataset-download-guide.md
        """
    )

    parser.add_argument(
        "--lab",
        type=int,
        nargs='+',
        choices=[1, 2, 3, 4, 5],
        help="Specific lab(s) to download (1-5)"
    )

    parser.add_argument(
        "--skip-check",
        action="store_true",
        help="Skip Kaggle API setup verification"
    )

    args = parser.parse_args()

    print("="*70)
    print(" SRX Data Science Labs - Dataset Download Utility")
    print("="*70)

    # Check Kaggle setup
    if not args.skip_check:
        if not check_kaggle_setup():
            print("\n❌ Kaggle API not properly configured. Exiting.")
            print("   See docs/dataset-download-guide.md for setup instructions")
            sys.exit(1)

    # Determine which labs to download
    if args.lab:
        labs_to_download = args.lab
        print(f"\nDownloading datasets for Lab(s): {', '.join(map(str, labs_to_download))}")
    else:
        labs_to_download = [1, 2, 3, 4, 5]
        print(f"\nDownloading datasets for all labs (1-5)")
        print("⚠️  Warning: Total download size may exceed 50GB")
        print("   Consider downloading one lab at a time with --lab <number>")
        response = input("\nContinue? [y/N]: ")
        if response.lower() != 'y':
            print("Cancelled.")
            sys.exit(0)

    # Download labs
    all_success = True
    for lab_num in labs_to_download:
        if not download_lab(lab_num):
            all_success = False

    # Final summary
    print("\n" + "="*70)
    if all_success:
        print("✓ All downloads completed successfully!")
    else:
        print("⚠️  Some downloads failed. Check output above for details.")
    print("="*70)

    print("\nNext steps:")
    print("1. Review dataset manifests in each lab's data/raw/dataset_manifest.json")
    print("2. For large datasets, see data/raw/README.md for filtering instructions")
    print("3. Start with Lab 1: lab-01-nyc-neighborhood-signals/README.md")


if __name__ == "__main__":
    main()
