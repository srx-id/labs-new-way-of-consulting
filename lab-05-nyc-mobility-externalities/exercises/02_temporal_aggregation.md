# Exercise 2: Temporal Aggregation at Scale

**[Lab 5 Home](../README.md) > Exercise 2**

## Overview

You've learned to handle the volume - now you'll learn to **aggregate taxi trips to meaningful time grains** for correlation with 311 complaints.

**Time**: 45-60 minutes

## The Goal

Transform raw taxi trips into analyzable aggregates:
- Raw: 100M individual trips
- Target: Borough × Day (or Borough × Hour)

This enables correlation with 311 complaints at matching grain.

---

## Task 2.1: Define Target Grain

### What You Want to Achieve
Decide the right time granularity for analysis.

### The Vibe Coding Prompt

```
Help me decide on the target time grain:

Option 1: Borough × Hour
- Rows: 5 boroughs × 24 hours × 365 days = 43,800/year
- Pros: Captures rush hour patterns
- Cons: 311 complaints might be too sparse hourly

Option 2: Borough × Day
- Rows: 5 boroughs × 365 days = 1,825/year
- Pros: Stable counts, matches 311 well
- Cons: Loses hourly patterns

Option 3: Borough × Day + Hour Flags
- Base: Borough × Day
- Flags: rush_hour_trips, night_trips, etc.
- Pros: Best of both?

Which grain makes most sense for correlating taxi volume with 311 complaints?
Recommend one and explain why.
```

### Grain Selection Principle
```
Match grain to your analysis question:
- "Do more taxis mean more noise complaints?" → Day level is fine
- "Does rush hour traffic cause more complaints?" → Need hour level

Also match to data density:
- Hourly 311 complaints in Staten Island might be too sparse
```

---

## Task 2.2: Extract Time Components

### What You Want to Achieve
Parse pickup datetime into useful components.

### The Vibe Coding Prompt

```
Extract time components from taxi pickup datetime:

1. From pickup_datetime, extract:
   - date (YYYY-MM-DD)
   - hour (0-23)
   - day_of_week (0=Monday to 6=Sunday)
   - month
   - year

2. Create derived flags:
   - is_rush_hour: 7-9 AM or 5-7 PM
   - is_night: 10 PM - 5 AM
   - is_weekend: Saturday or Sunday

3. Apply to sample data:
   - Show 10 rows with all new columns
   - Verify extraction worked correctly

4. Handle edge cases:
   - What if pickup_datetime is null?
   - What if datetime is invalid?
```

---

## Task 2.3: Aggregate Trips by Borough-Day

### What You Want to Achieve
Create daily aggregates for each borough.

### The Vibe Coding Prompt

```
Aggregate taxi trips to borough-day level:

For each borough + date combination, calculate:

Volume metrics:
- trip_count: Number of trips
- unique_trips: Distinct pickups (if duplicates possible)

Time distribution:
- rush_hour_trips: Count of is_rush_hour = True
- night_trips: Count of is_night = True
- pct_rush_hour: rush_hour_trips / trip_count

Fare metrics:
- total_fare: Sum of fare amounts
- avg_fare: Average fare
- median_fare: Median fare (if feasible)

Distance metrics:
- total_distance: Sum of trip distances
- avg_distance: Average trip distance

Process using chunking strategy from Exercise 1.
Save as data/processed/taxi_daily_aggregates.csv
```

---

## Task 2.4: Create Hourly Profile

### What You Want to Achieve
Build hourly patterns even if analyzing at daily level.

### The Vibe Coding Prompt

```
Create hourly trip distribution for each borough:

1. Aggregate by borough + hour (across all days):
   - Average trips per hour
   - Peak hours by borough
   - Quiet hours by borough

2. Create hourly heatmap:
   - Rows: Hours (0-23)
   - Columns: Boroughs (5)
   - Values: Average trips

3. Identify patterns:
   - Manhattan: Rush hours dominant?
   - Brooklyn: Different peak times?
   - Airport traffic (Queens)?

Save hourly profile as data/processed/taxi_hourly_profile.csv
Create heatmap as visualizations/hourly_heatmap.png
```

### Expected Patterns
```
Manhattan: Strong morning and evening peaks
Queens: Airport traffic creates different patterns (JFK, LaGuardia)
Brooklyn/Bronx: Later evening peaks (residential → Manhattan commute)
Staten Island: Much lower volume overall
```

---

## Task 2.5: Validate Aggregations

### What You Want to Achieve
Confirm the aggregated data is correct.

### The Vibe Coding Prompt

```
Validate the daily aggregations:

1. Total check:
   - Sum of daily trip_counts should equal raw trip count
   - Pick one day, manually count raw trips, compare

2. Borough distribution:
   - % of trips by borough
   - Manhattan should have most (50%+?)
   - Staten Island should have least

3. Date coverage:
   - Are all days represented?
   - Any days with suspiciously low counts? (holidays?)
   - Any days with zero trips? (data gap?)

4. Metric sanity:
   - Average fare: $5-50 reasonable for NYC
   - Average distance: 2-5 miles typical
   - Rush hour %: ~25-35% expected

Document validation results and any issues found.
```

---

## Task 2.6: Handle Holidays and Special Days

### What You Want to Achieve
Flag unusual days that might affect patterns.

### The Vibe Coding Prompt

```
Identify and flag special days:

1. Major holidays:
   - Load US holiday calendar
   - Flag holidays in the aggregated data
   - Thanksgiving, Christmas, New Year, etc.

2. Extreme weather events:
   - If weather data available, flag snow days
   - Days with unusual drop in trips

3. Major events:
   - New Year's Eve has unique patterns
   - Thanksgiving Eve (high travel)
   - Super Bowl Sunday

4. Create flags:
   - is_holiday
   - is_weekend
   - is_unusual (trips < 50% of typical)

Add flags to daily aggregates.
```

---

## Task 2.7: Create Week-Level Summary

### What You Want to Achieve
Build higher-level temporal view for patterns.

### The Vibe Coding Prompt

```
Aggregate to weekly level for pattern analysis:

1. Borough × Week aggregation:
   - Sum of trips
   - Average daily trips
   - Peak day of week

2. Week-over-week trends:
   - Is taxi volume growing or declining?
   - Seasonal patterns (summer vs winter)

3. Day-of-week patterns:
   - Average trips by day of week
   - Busiest days
   - Slowest days

4. Create visualization:
   - Line chart of weekly trips by borough
   - Highlight any anomalies

Save as data/processed/taxi_weekly_summary.csv
Save visualization as visualizations/weekly_trends.png
```

---

## Task 2.8: Prepare for 311 Join

### What You Want to Achieve
Ensure taxi data is ready to join with 311 complaints.

### The Vibe Coding Prompt

```
Prepare taxi aggregates for joining with 311 data:

1. Verify grain matches:
   - Taxi: borough + date
   - 311: borough + date
   - Keys should align

2. Verify borough names match:
   - Taxi uses: [show values]
   - 311 uses: [check Lab 1 for 311 format]
   - Standardize if needed

3. Verify date format:
   - Taxi dates: YYYY-MM-DD
   - 311 dates: [same?]

4. Create final join-ready file:
   - data/processed/taxi_for_join.csv
   - Columns: borough, date, trip_count, [other metrics]

Confirm data is ready for Exercise 4 joining.
```

---

## Deliverables Checklist

After completing this exercise, you should have:

- [ ] Target grain decided and documented
- [ ] Time components extracted
- [ ] Daily borough aggregates created
- [ ] Hourly profile analyzed
- [ ] Aggregations validated
- [ ] Special days flagged
- [ ] `data/processed/taxi_daily_aggregates.csv`
- [ ] `data/processed/taxi_hourly_profile.csv`
- [ ] `data/processed/taxi_weekly_summary.csv`
- [ ] `visualizations/hourly_heatmap.png`
- [ ] `visualizations/weekly_trends.png`
- [ ] `data/processed/taxi_for_join.csv`

---

## Key Vocabulary for Vibe Coding

When doing temporal aggregation, these keywords help:

| What You Want | Keywords to Use |
|---------------|-----------------|
| Extract date parts | "extract hour", "get day of week", "parse date" |
| Group by time | "aggregate by day", "group by hour" |
| Multiple aggregations | "count, sum, average", "multiple metrics" |
| Time patterns | "hourly distribution", "day-of-week pattern" |
| Handle outliers | "flag holidays", "unusual days" |

---

## Common Issues and How to Fix Them

**If borough aggregation is unbalanced:**
```
Manhattan has 80% of trips, Staten Island has 0.1%.
This is normal - Manhattan is the taxi hub.
For correlation analysis, we might need to analyze boroughs separately
to avoid Manhattan dominating the signal.
```

**If date extraction fails:**
```
Can't extract date from pickup_datetime.
Show me 5 sample values of pickup_datetime.
What format is it in? Parse with correct format string.
```

**If aggregation takes too long:**
```
Processing is stuck on aggregation step.
Are you aggregating THEN chunking (wrong) or
chunking THEN aggregating (right)?
Aggregate each chunk, then combine chunk results.
```

---

## What's Next?

Now that you have temporal aggregates, Exercise 3 will teach you how to **map trips to boroughs** using taxi zone data.

---

[← Previous: Volume Handling](./01_volume_handling.md) | [Lab 5 Home](../README.md) | [Next: Spatial Bucketing →](./03_spatial_bucketing.md)
