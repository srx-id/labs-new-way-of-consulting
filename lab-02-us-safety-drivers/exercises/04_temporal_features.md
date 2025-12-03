# Exercise 4: Temporal Feature Engineering

**[Lab 2 Home](../README.md) > Exercise 4**

## Overview

Time-based features are crucial for understanding accident patterns. In this exercise, you'll learn how to **create powerful temporal features** like rush hour flags, weekend indicators, and holiday markers.

**Time**: 45-60 minutes

## Why Temporal Features Matter

Raw timestamp: "2019-07-04 17:30:00"

What we can extract:
- It's a Thursday (weekday)
- It's 5:30 PM (evening rush hour)
- It's July 4th (major US holiday!)
- It's summer (Q3)

Each of these might affect accident patterns differently.

---

## Task 4.1: Extract Basic Time Components

### What You Want to Achieve
Pull apart the timestamp into useful components.

### The Vibe Coding Prompt

```
From the accident Start_Time column, extract:

1. Basic components:
   - year
   - month (1-12)
   - day_of_month (1-31)
   - day_of_week (Monday=0 to Sunday=6, or use names)
   - hour (0-23)
   - minute

2. Show the first 10 rows with all these new columns

3. Verify:
   - Do the values make sense?
   - Any parsing errors?
   - What date format was the original?
```

### Common Date Format Issues

```
Some dates are parsing wrong.
Show me 5 examples where month > 12 or hour > 23.
These might be format mismatches (MM/DD vs DD/MM).
```

---

## Task 4.2: Create Time-of-Day Categories

### What You Want to Achieve
Convert hour into business-meaningful categories.

### The Vibe Coding Prompt

```
Create time-of-day categories from the hour column:

Categories:
- "Early Morning": 5 AM - 7 AM
- "Morning Rush": 7 AM - 9 AM
- "Midday": 9 AM - 4 PM
- "Evening Rush": 4 PM - 7 PM
- "Evening": 7 PM - 10 PM
- "Night": 10 PM - 5 AM

Also create a binary flag:
- is_rush_hour: True if Morning Rush or Evening Rush

Show the distribution:
- How many accidents in each time category?
- What percentage are during rush hour?
- Average severity by time category?

Create a bar chart of accident counts by time category.
Save as visualizations/accidents_by_time_of_day.png
```

### Business Insight Preview
Rush hour accidents might be:
- More frequent (more cars)
- Less severe (slower speeds in traffic)
- Different causes (rear-end vs single car)

---

## Task 4.3: Create Day-of-Week Features

### What You Want to Achieve
Capture weekly patterns in accident data.

### The Vibe Coding Prompt

```
Create day-of-week features:

1. day_name: Full name (Monday, Tuesday, etc.)
2. is_weekend: True for Saturday/Sunday
3. is_friday: True for Friday (different pattern than other weekdays?)

Show analysis:
- Accident count by day of week
- Average severity by day of week
- Rush hour vs non-rush hour breakdown by day

Create a visualization:
- Grouped bar chart: days on x-axis
- Two bars per day: rush hour accidents vs non-rush hour
Save as visualizations/accidents_by_day_of_week.png

What patterns do you see?
```

### Expected Patterns
- Weekdays: Rush hour spikes
- Weekends: More spread through day
- Friday: Potentially different evening pattern

---

## Task 4.4: Add Holiday Information

### What You Want to Achieve
Flag accidents that occurred on US holidays.

### The Vibe Coding Prompt

```
Load the holiday data from data/raw/ (worldwide holidays or similar)

1. Filter to US holidays only
2. What holidays are included?
3. How many years of data?

Create a holiday lookup and join to accidents:
- is_holiday: True if accident date is a US holiday
- holiday_name: Name of the holiday (if applicable)

Analysis:
- How many accidents happened on holidays vs non-holidays?
- Average severity on holidays vs non-holidays?
- Which specific holidays have the most accidents?
- Which have the highest severity?

Create a bar chart of accident counts by holiday.
Save as visualizations/accidents_by_holiday.png
```

### Major US Holidays to Include
- New Year's Day
- Memorial Day
- Independence Day (July 4th)
- Labor Day
- Thanksgiving
- Christmas

```
If the holiday dataset has too many minor holidays,
filter to only federal holidays or top 10 most observed holidays.
```

---

## Task 4.5: Create Seasonal Features

### What You Want to Achieve
Capture longer-term seasonal patterns.

### The Vibe Coding Prompt

```
Create seasonal features:

1. season: Based on month
   - Winter: Dec, Jan, Feb
   - Spring: Mar, Apr, May
   - Summer: Jun, Jul, Aug
   - Fall: Sep, Oct, Nov

2. quarter: Q1, Q2, Q3, Q4

3. is_winter: True for Dec-Feb (potentially worse driving conditions)

4. school_in_session: Approximate based on month
   - False for Jun, Jul, Aug (summer break)
   - True for other months

Show analysis:
- Accident counts by season
- Severity by season
- Does winter really have more severe accidents?

Create a line chart showing:
- Monthly accident trends across a year
- Overlay with average severity
Save as visualizations/monthly_accident_trends.png
```

---

## Task 4.6: Create Combined Temporal Flags

### What You Want to Achieve
Build composite features that capture multiple time dimensions.

### The Vibe Coding Prompt

```
Create combination features:

1. weekday_rush: Weekday AND rush hour (typical commute)
2. weekend_night: Weekend AND night (potential impaired driving)
3. holiday_weekend: Holiday OR weekend (leisure travel)
4. winter_rush: Winter AND rush hour (worst conditions)

For each combination:
- How many accidents?
- What percentage of total?
- Average severity?
- Is severity higher than baseline?

Create a summary table:
| Feature | Accidents | % of Total | Avg Severity | vs Baseline |
```

### Business Value
These combinations answer questions like:
- "Are weekday commute accidents different from weekend driving?"
- "Is winter rush hour particularly dangerous?"

---

## Task 4.7: Validate Temporal Features

### What You Want to Achieve
Confirm all temporal features are correctly calculated.

### The Vibe Coding Prompt

```
Validate the temporal feature engineering:

1. Spot check 10 random records:
   - Show original Start_Time
   - Show all derived features
   - Manually verify they're correct

2. Cross-check holidays:
   - All July 4th accidents should have is_holiday = True
   - All December 25th accidents should be holidays
   - Verify a few specific dates

3. Logic check:
   - No hour > 23 or < 0
   - No month > 12 or < 1
   - Weekend flags match day_of_week

4. Distribution check:
   - Roughly 28-29% should be weekend (2/7 days)
   - Rush hours should be ~4/24 = ~17% of hours

Document any issues found.
```

---

## Task 4.8: Save Enriched Dataset

### What You Want to Achieve
Export the dataset with all temporal features.

### The Vibe Coding Prompt

```
Save the fully feature-engineered dataset:

File: data/processed/accidents_with_features.csv

Columns to include:
- Original key columns (ID, FIPS, date, time, severity)
- Weather features (from Exercise 2)
- All temporal features created in this exercise

Summarize:
- Total rows
- Total columns
- List all feature columns with descriptions

Create a feature dictionary as data/processed/feature_dictionary.md
```

---

## Deliverables Checklist

After completing this exercise, you should have:

- [ ] Basic time components extracted (year, month, day, hour)
- [ ] Time-of-day categories and rush hour flag
- [ ] Day-of-week features and weekend flag
- [ ] Holiday flags joined from external data
- [ ] Seasonal and school session features
- [ ] Combined temporal flags
- [ ] `visualizations/accidents_by_time_of_day.png`
- [ ] `visualizations/accidents_by_day_of_week.png`
- [ ] `visualizations/accidents_by_holiday.png`
- [ ] `visualizations/monthly_accident_trends.png`
- [ ] `data/processed/accidents_with_features.csv`
- [ ] `data/processed/feature_dictionary.md`

---

## Key Vocabulary for Vibe Coding

When creating temporal features, these keywords help:

| What You Want | Keywords to Use |
|---------------|-----------------|
| Extract date parts | "extract hour", "get day of week", "parse date" |
| Create categories | "categorize", "bucket", "bin by time" |
| Boolean flags | "flag", "is_", "True if", "binary indicator" |
| Time ranges | "between 7 and 9 AM", "rush hour", "night hours" |
| Combine features | "AND", "OR", "both conditions", "combination" |

---

## Common Issues and How to Fix Them

**If hour extraction gives wrong values:**
```
The hour shows 17 but the time looks like 5 PM.
That's correct - hour 17 in 24-hour format IS 5 PM.
If you need 12-hour format, convert: hour % 12 with AM/PM flag
```

**If holidays aren't matching:**
```
July 4th accidents aren't flagged as holidays.
Check the date format in both datasets.
Is holiday date "2019-07-04" or "07/04/2019"?
Standardize before joining.
```

**If weekend percentage seems wrong:**
```
Only 10% of accidents are flagged as weekend.
Check how day_of_week is coded.
Is Sunday=0 or Sunday=6? Confirm and adjust the is_weekend logic.
```

---

## What's Next?

Now that you have a fully feature-engineered dataset, Exercise 5 will teach you how to **analyze correlations between severity and your features** to answer the client's questions.

---

[← Previous: Geographic Mapping](./03_geographic_mapping.md) | [Lab 2 Home](../README.md) | [Next: Severity Correlation →](./05_severity_correlation.md)
