# Exercise 3: Temporal Aggregation

**[Lab 1 Home](../README.md) > Exercise 3**

## Overview

Your datasets are at different time grains - some are daily, some are per-event, and Airbnb is a snapshot. In this exercise, you'll learn how to **aggregate everything to monthly** so they can be compared.

**Time**: 45-60 minutes

## The Problem

Each dataset has a different "grain" (level of detail):

| Dataset | Current Grain | Records | Target Grain |
|---------|---------------|---------|--------------|
| Airbnb | Per listing (snapshot) | ~49,000 | Borough × Month |
| 311 | Per complaint | Millions | Borough × Month |
| Crime | Per incident | Millions | Borough × Month |
| Weather | Per day | ~365/year | Month (citywide) |

For correlation analysis, all datasets need to be at the **same grain**: Borough × Month (60 rows = 5 boroughs × 12 months).

---

## Task 3.1: Filter All Datasets to 2019

### What You Want to Achieve
Ensure all datasets cover the same time period before aggregating.

### The Vibe Coding Prompt

```
Filter all datasets to the year 2019 only:

1. Airbnb: Use the last_review column - keep listings with reviews in 2019
   - Note: Listings without reviews may still be valid, decide how to handle

2. 311 Data: Filter where Created Date is in 2019
   - Show me the count before and after filtering

3. Crime Data: Filter where CMPLNT_FR_DT (complaint date) is in 2019
   - Show count before and after

4. Weather: Filter where DATE is in 2019
   - Should result in 365 days

Report how many records we have from each dataset after filtering to 2019.
```

### Decision Point: Airbnb Listings Without Reviews
Some listings don't have a `last_review` date. Ask:

```
How many Airbnb listings have no last_review date?
These might be new listings or inactive listings.
Should we include or exclude them from our 2019 analysis?
```

**Recommendation**: Include listings that have `availability_365 > 0` (they were available in 2019), even if they have no reviews.

---

## Task 3.2: Extract Month from Date Fields

### What You Want to Achieve
Create a consistent `year_month` column in all datasets.

### The Vibe Coding Prompt

```
Create a year_month column in each dataset with format "2019-01", "2019-02", etc.

For each dataset:
1. Airbnb: Extract from last_review date
2. 311: Extract from Created Date
3. Crime: Extract from CMPLNT_FR_DT
4. Weather: Extract from DATE column

Show me sample values from each to confirm the format is consistent.
```

### Common Format Issue
Date columns often have different formats:
- Some: "2019-01-15"
- Some: "01/15/2019"
- Some: "January 15, 2019"

If you get errors:
```
The date parsing failed. Show me the first 5 values in the date column
and what format they're in. Then parse them correctly.
```

---

## Task 3.3: Aggregate Airbnb Data by Borough-Month

### What You Want to Achieve
Summarize Airbnb listings into borough-month statistics.

### The Vibe Coding Prompt

```
Aggregate the Airbnb data by borough and month.

For each borough-month combination, calculate:
- listing_count: Number of listings
- avg_price: Average nightly price
- median_price: Median price (less sensitive to outliers)
- avg_reviews_per_month: Average review velocity
- median_reviews_per_month: Median review velocity
- avg_minimum_nights: Average minimum stay requirement

The result should have 60 rows (5 boroughs × 12 months).

Show me the first 10 rows of the aggregated data.
```

### Watch for Outliers
Ask about extreme values:
```
Before aggregating, show me the price distribution.
Are there any listings priced over $1000/night?
Should we cap extreme prices to avoid skewing the average?
```

**Recommendation**: Consider "winsorizing" - capping prices at the 95th percentile to reduce outlier impact.

---

## Task 3.4: Aggregate 311 Complaints by Borough-Month

### What You Want to Achieve
Count complaints per borough-month.

### The Vibe Coding Prompt

```
Aggregate 311 complaints by borough and month.

For each borough-month combination, calculate:
- complaint_count: Total number of complaints
- noise_complaints: Count where complaint type contains "Noise"
- housing_complaints: Count where complaint type relates to housing/heat
- street_complaints: Count where complaint type relates to streets/sidewalks

The result should have 60 rows (5 boroughs × 12 months).

Show me the borough-month combinations with the highest complaint counts.
```

### Going Deeper with Complaint Types

```
Show me the top 10 complaint types overall.
Which categories should we track separately for our Airbnb analysis?

I'm thinking noise and housing complaints might correlate with Airbnb activity.
```

---

## Task 3.5: Aggregate Crime Data by Borough-Month

### What You Want to Achieve
Count crime incidents per borough-month.

### The Vibe Coding Prompt

```
Aggregate crime data by borough and month.

For each borough-month combination, calculate:
- crime_count: Total incidents
- felony_count: Where LAW_CAT_CD is "FELONY"
- misdemeanor_count: Where LAW_CAT_CD is "MISDEMEANOR"
- violation_count: Where LAW_CAT_CD is "VIOLATION"

The result should have 60 rows (5 boroughs × 12 months).

Show me which borough-months have the highest crime counts.
```

### Exploring Crime Categories

```
What are the most common offense descriptions (OFNS_DESC)?
Are there specific crime types that might affect Airbnb guests,
like theft or assault?
```

---

## Task 3.6: Aggregate Weather to Monthly

### What You Want to Achieve
Summarize daily weather into monthly citywide averages.

### The Vibe Coding Prompt

```
Aggregate weather data to monthly level (citywide, not by borough).

For each month, calculate:
- avg_temp: Average of TMAX (daily high temperature)
- min_temp: Minimum of TMIN (coldest day)
- max_temp: Maximum of TMAX (hottest day)
- total_precip: Sum of PRCP (total precipitation)
- rainy_days: Count of days where PRCP > 0
- snow_days: Count of days where SNOW > 0

The result should have 12 rows (one per month).

Show me the monthly weather summary.
```

### No Borough for Weather!
Remember: Weather is citywide. When we join later, we'll join on month only.

---

## Task 3.7: Validate the Aggregations

### What You Want to Achieve
Confirm all aggregated datasets have the expected structure.

### The Vibe Coding Prompt

```
Validate all aggregated datasets:

1. Airbnb aggregated:
   - Should have 60 rows (5 boroughs × 12 months)
   - Show unique borough-month combinations
   - Check for any missing combinations

2. 311 aggregated:
   - Should have 60 rows
   - Verify all 5 boroughs present

3. Crime aggregated:
   - Should have 60 rows
   - Verify all 5 boroughs present

4. Weather aggregated:
   - Should have 12 rows
   - Verify all 12 months present

Create a validation summary table showing:
| Dataset | Expected Rows | Actual Rows | Missing Combinations |
```

### If Rows Are Missing

```
The aggregated data has fewer than expected rows.
Which borough-month combinations are missing?
Should we fill them with zeros or null?
```

---

## Task 3.8: Save Aggregated Datasets

### What You Want to Achieve
Export clean, aggregated data for the next exercise.

### The Vibe Coding Prompt

```
Save all aggregated datasets to the data/processed folder:

1. data/processed/airbnb_borough_month.csv
2. data/processed/complaints_borough_month.csv
3. data/processed/crime_borough_month.csv
4. data/processed/weather_month.csv

For each file:
- Confirm it was saved successfully
- Show the file size
- Show the column names

Create a summary showing all 4 files are ready for joining.
```

---

## Deliverables Checklist

After completing this exercise, you should have:

- [ ] All datasets filtered to 2019
- [ ] Consistent `year_month` format across datasets
- [ ] `data/processed/airbnb_borough_month.csv` (60 rows)
- [ ] `data/processed/complaints_borough_month.csv` (60 rows)
- [ ] `data/processed/crime_borough_month.csv` (60 rows)
- [ ] `data/processed/weather_month.csv` (12 rows)
- [ ] Validation report confirming row counts

---

## Key Vocabulary for Vibe Coding

When aggregating data, these keywords help AI understand:

| What You Want | Keywords to Use |
|---------------|-----------------|
| Group data | "group by", "aggregate by", "summarize by" |
| Count records | "count", "number of", "how many" |
| Calculate average | "mean", "average" |
| Handle extremes | "median", "winsorize", "cap outliers" |
| Sum values | "total", "sum" |
| Extract date parts | "extract month", "get year from date" |
| Filter dates | "filter to 2019", "where date is in" |

---

## Common Issues and How to Fix Them

**If aggregation gives wrong row count:**
```
Show me the unique combinations of borough and year_month.
Are there any duplicates or unexpected values?
```

**If dates won't parse:**
```
Show me the raw date values that failed to parse.
What format are they in? Try parsing with that specific format.
```

**If some months are missing:**
```
Which months are missing from the aggregated data?
Were there really zero records in those months,
or did something go wrong in the filtering?
```

**If numbers seem too high or low:**
```
Show me the top 5 and bottom 5 borough-months by complaint_count.
Do these numbers make sense based on what we saw in the raw data?
```

---

## What's Next?

Now that all datasets are at the same grain (Borough × Month), Exercise 4 will teach you how to **join them together** into a single analysis dataset.

---

[← Previous: Geographic Standardization](./02_geographic_standardization.md) | [Lab 1 Home](../README.md) | [Next: Dataset Joining →](./04_dataset_joining.md)
