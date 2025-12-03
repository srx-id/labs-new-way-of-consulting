# Exercise 1: Data Exploration

**[Lab 1 Home](../README.md) > Exercise 1**

## Overview

In this exercise, you'll learn how to explore and understand your datasets using **Vibe Coding** - instructing AI to do the heavy lifting while you focus on asking the right questions.

**Time**: 30-45 minutes

## The Scenario

You just received 4 datasets from the client. Before doing any analysis, you need to understand:
- What's in each dataset?
- How big are they?
- What's the data quality like?
- Do they cover the same time period?

---

## Task 1.1: Load and Profile the Airbnb Dataset

### What You Want to Achieve
Get a quick overview of the NYC Airbnb dataset - how many listings, what columns exist, any missing data.

### The Vibe Coding Prompt

Copy and paste this prompt to your AI assistant:

```
Load the NYC Airbnb dataset from data/raw/AB_NYC_2019.csv

Give me a summary that includes:
1. How many rows and columns
2. What columns are available (list them with their data types)
3. Show me the first 5 rows
4. How many missing values in each column
5. Basic statistics for numeric columns (min, max, mean)
```

### What to Look For in the Output
- **Row count**: Should be around 49,000 listings
- **Key columns**: Look for `price`, `neighbourhood_group`, `latitude`, `longitude`, `reviews_per_month`
- **Missing values**: `reviews_per_month` and `last_review` often have nulls (listings with no reviews)

### Follow-Up Prompts to Try

If something looks off, ask:

```
Show me the unique values in the neighbourhood_group column
```

```
What's the range of prices? Are there any that look like outliers?
```

---

## Task 1.2: Profile the 311 Complaints Dataset

### What You Want to Achieve
Understand the 311 service requests data - this is a big dataset, so we need to scope it.

### The Vibe Coding Prompt

```
Load the 311 service requests data from data/raw/311_Service_Requests.csv

This is a large file, so:
1. First tell me how many rows and columns
2. List all the column names
3. Show me the unique values in the Borough column
4. What date range does the data cover (look at Created Date column)
5. Show me the top 10 most common complaint types
```

### What to Look For
- **Size**: This dataset can have millions of rows
- **Borough values**: Should see Manhattan, Brooklyn, Queens, Bronx, Staten Island (plus some nulls/Unspecified)
- **Date range**: We need to filter to 2019 to match our Airbnb data

### Follow-Up Prompts

```
How many records have null or missing Borough values? What percentage is that?
```

```
Filter the data to only 2019 and tell me how many records remain
```

---

## Task 1.3: Profile the Crime and Weather Datasets

### What You Want to Achieve
Quick profiles of the remaining two datasets to understand their structure.

### The Vibe Coding Prompt for Crime Data

```
Load the NYPD crime data from data/raw/NYPD_Complaint_Data_Historic.csv

Tell me:
1. Row and column counts
2. What columns exist
3. What's in the BORO_NM column (borough names)
4. What date field should I use for filtering
5. Show sample of 5 rows
```

### The Vibe Coding Prompt for Weather Data

```
Load the NYC weather data from data/raw/NYC_Weather.csv

Tell me:
1. How many days of weather data
2. What columns exist (temperature, precipitation, etc.)
3. What date range is covered
4. Any missing values
5. Sample of 5 rows
```

### What to Look For
- **Crime data**: Look for `CMPLNT_FR_DT` (complaint date) and `BORO_NM` (borough)
- **Weather data**: Single location (Central Park), daily grain with TMAX, TMIN, PRCP

---

## Task 1.4: Create a Data Quality Summary

### What You Want to Achieve
A one-page summary of all four datasets for your reference.

### The Vibe Coding Prompt

```
Create a summary table comparing all 4 datasets I just explored:

| Dataset | Rows | Date Range | Geographic Key | Date Key | Key Issues |
|---------|------|------------|----------------|----------|------------|

For each dataset, fill in:
- Airbnb (AB_NYC_2019.csv)
- 311 Complaints (311_Service_Requests.csv)
- Crime (NYPD_Complaint_Data_Historic.csv)
- Weather (NYC_Weather.csv)

Include notes on:
- What fields we'll use to join them
- What needs to be cleaned or filtered
- Any data quality concerns
```

### Key Insight
You're looking for **common keys** to join on:
- **Geographic**: All datasets should have borough or coordinates
- **Temporal**: All need to be filtered to 2019 and aggregated to monthly

---

## Task 1.5: Visualize the Temporal Coverage

### What You Want to Achieve
A simple visual showing what date ranges each dataset covers.

### The Vibe Coding Prompt

```
Create a timeline visualization showing the date coverage of all 4 datasets:
- Airbnb listings (use last_review dates)
- 311 Complaints (use Created Date)
- Crime data (use complaint date)
- Weather data (use DATE column)

Make a horizontal bar chart where:
- X-axis is time (from 2010 to 2022)
- Each bar shows the date range covered by that dataset
- Highlight the 2019 period we'll focus on

Save as visualizations/data_coverage_timeline.png
```

---

## Deliverables Checklist

After completing this exercise, you should have:

- [ ] Understanding of row counts for all 4 datasets
- [ ] List of key columns in each dataset
- [ ] Knowledge of missing values and data quality issues
- [ ] Identified the common join keys (borough, date)
- [ ] Confirmed 2019 data availability across all datasets
- [ ] `visualizations/data_coverage_timeline.png`

---

## Key Vocabulary for Vibe Coding

When exploring data, these keywords help AI understand what you want:

| What You Want | Keywords to Use |
|---------------|-----------------|
| See the data structure | "show me shape", "row and column count", "data types" |
| Find problems | "missing values", "null count", "duplicates" |
| Understand values | "unique values", "value counts", "distribution" |
| Check ranges | "min and max", "date range", "outliers" |
| Quick look | "first 5 rows", "sample", "head" |

---

## Common Issues and How to Ask About Them

**If the file won't load:**
```
The file failed to load. Check if the path is correct and show me what files exist in data/raw/
```

**If you see weird characters:**
```
Try loading the file with different encoding (utf-8, latin-1, cp1252)
```

**If it's taking forever:**
```
Just load the first 10,000 rows as a sample to explore the structure
```

---

## What's Next?

Now that you understand what's in each dataset, Exercise 2 will teach you how to **standardize the geography** - making sure all datasets use the same borough names.

---

[Lab 1 Home](../README.md) | [Next Exercise: Geographic Standardization →](./02_geographic_standardization.md)
