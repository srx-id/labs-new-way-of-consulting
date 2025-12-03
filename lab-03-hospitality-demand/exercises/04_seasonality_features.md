# Exercise 4: Seasonality Feature Engineering

**[Lab 3 Home](../README.md) > Exercise 4**

## Overview

Tourism is highly seasonal. In this exercise, you'll learn how to **create seasonal features** that capture recurring patterns in booking behavior throughout the year.

**Time**: 45-60 minutes

## Why Seasonality Matters

Portugal tourism patterns:
- **Peak**: Summer (Jun-Aug) - Beach tourism
- **Shoulder**: Spring (Apr-May) and Fall (Sep-Oct) - Mild weather, lower prices
- **Low**: Winter (Nov-Mar) - Except holiday periods

Understanding seasonality helps with:
- Demand forecasting
- Dynamic pricing
- Staff scheduling
- Inventory management

---

## Task 4.1: Analyze Monthly Demand Patterns

### What You Want to Achieve
Establish baseline seasonal patterns in the data.

### The Vibe Coding Prompt

```
Analyze monthly booking patterns:

1. Monthly totals:
   - Total bookings per month (across all years)
   - Average daily bookings per month
   - Which months are peak vs low?

2. By hotel type:
   - Resort monthly pattern
   - City Hotel monthly pattern
   - Are they different?

3. Occupancy proxy:
   - Total room-nights per month
   - (stays_in_week_nights + stays_in_weekend_nights) * booking count
   - Peak capacity utilization months

4. Create visualization:
   - 12-month demand pattern
   - Dual lines for City vs Resort
   - Highlight peak season

Save as visualizations/monthly_demand_pattern.png
```

### Expected Pattern for Portugal
```
Resort Hotel: Strong summer peak (beach tourism)
City Hotel: More balanced (business travel year-round)

Both should dip in winter except around Christmas/New Year.
```

---

## Task 4.2: Create Season Categories

### What You Want to Achieve
Bin months into meaningful seasonal categories.

### The Vibe Coding Prompt

```
Create seasonal categories:

1. Basic seasons:
   - Winter: Dec, Jan, Feb
   - Spring: Mar, Apr, May
   - Summer: Jun, Jul, Aug
   - Fall: Sep, Oct, Nov

2. Tourism seasons (Portugal-specific):
   - Peak: Jul, Aug
   - High: Jun, Sep
   - Shoulder: Apr, May, Oct
   - Low: Nov, Dec, Jan, Feb, Mar

3. Calculate metrics by season:
   - Average bookings
   - Average ADR
   - Cancellation rate
   - Average lead time

4. Create comparison table:
   | Season | Bookings | ADR | Cancel Rate | Lead Time |

Save visualizations/seasonal_comparison.png
```

### Business Interpretation
```
What patterns emerge?
- Peak season: Higher ADR but also higher cancellations?
- Low season: Lower rates, shorter lead times?
- Are there opportunities in shoulder seasons?
```

---

## Task 4.3: Create Month-Level Features

### What You Want to Achieve
Build numerical features that capture seasonal position.

### The Vibe Coding Prompt

```
Create month-based features:

1. Basic month features:
   - month_number (1-12)
   - day_of_month (1-31)
   - week_of_year (1-52)

2. Cyclic encoding (for ML models):
   - month_sin = sin(2π × month/12)
   - month_cos = cos(2π × month/12)
   - This captures that December is close to January

3. Binary season flags:
   - is_summer (Jun-Aug)
   - is_peak (Jul-Aug)
   - is_shoulder (Apr-May or Sep-Oct)
   - is_winter (Nov-Feb)

4. Relative position:
   - days_until_summer
   - days_since_new_year
   - quarter (Q1-Q4)

Show sample data with all new features.
```

### Why Cyclic Encoding?
```
Regular month numbers (1-12) don't capture that:
December (12) is very close to January (1)

Sin/cos encoding makes this relationship clear:
- Month 12 has similar values to Month 1
- Month 6 is opposite to Month 12
```

---

## Task 4.4: Analyze Weekend vs Weekday Patterns

### What You Want to Achieve
Capture day-of-week seasonality.

### The Vibe Coding Prompt

```
Analyze day-of-week patterns:

1. Arrival day distribution:
   - Which days do guests arrive most?
   - Breakdown by hotel type
   - Is it different for City vs Resort?

2. Stay composition:
   - stays_in_weekend_nights vs stays_in_week_nights
   - Ratio of weekend to weekday nights
   - By segment and hotel type

3. Create day features:
   - arrival_day_of_week (Mon-Sun)
   - is_weekend_arrival (Fri/Sat/Sun)
   - is_business_arrival (Mon-Wed)

4. ADR by arrival day:
   - Do weekend arrivals pay more/less?
   - Different by hotel type?

Create visualization of arrivals by day of week.
Save as visualizations/arrival_day_patterns.png
```

### City vs Resort Hypothesis
```
City Hotel: More Monday arrivals (business travelers)
Resort Hotel: More Friday/Saturday arrivals (leisure travelers)

Does the data support this?
```

---

## Task 4.5: Create Stay Pattern Features

### What You Want to Achieve
Capture patterns in how long guests stay.

### The Vibe Coding Prompt

```
Analyze and feature-engineer stay patterns:

1. Total stay calculation:
   - total_nights = stays_in_weekend_nights + stays_in_week_nights
   - Distribution of stay lengths

2. Stay categories:
   - short_stay: 1-2 nights
   - weekend_getaway: 2-3 nights, primarily weekend
   - week_stay: 4-6 nights
   - extended_stay: 7+ nights

3. Weekend ratio:
   - weekend_ratio = weekend_nights / total_nights
   - High ratio = leisure traveler
   - Low ratio = business traveler

4. Seasonal stay patterns:
   - Average stay length by month
   - Do summer stays last longer?
   - Any correlation with cancellation?

Create visualization of stay length distribution by season.
Save as visualizations/stay_patterns_by_season.png
```

---

## Task 4.6: Analyze Year-over-Year Trends

### What You Want to Achieve
Identify growth trends and year-specific patterns.

### The Vibe Coding Prompt

```
Analyze year-over-year patterns:

1. Annual totals:
   - Total bookings per year
   - Is demand growing or shrinking?
   - Growth rate %

2. Same month comparison:
   - July 2016 vs July 2017
   - Has summer peak grown?
   - Which months show most growth?

3. ADR trends:
   - Average ADR by year
   - Are prices increasing?
   - By hotel type and season

4. Cancellation trend:
   - Cancellation rate by year
   - Is it getting better or worse?
   - Any seasonal differences?

Create visualization showing year-over-year comparison.
Save as visualizations/yoy_trends.png
```

---

## Task 4.7: Create Final Seasonal Feature Set

### What You Want to Achieve
Consolidate all seasonal features into the analysis dataset.

### The Vibe Coding Prompt

```
Create the final seasonality-enriched dataset:

1. Compile all seasonal features:
   - Month and season categories
   - Cyclic encodings
   - Day-of-week features
   - Stay pattern features
   - Year trends

2. Feature summary table:
   | Feature | Type | Description | Example Values |

3. Correlation check:
   - Which seasonal features correlate with cancellation?
   - Which correlate with ADR?
   - Any redundant features?

4. Save enriched dataset:
   - data/processed/bookings_with_seasonality.csv
   - Include all original columns plus new features

Create feature dictionary as data/processed/seasonality_features.md
```

---

## Task 4.8: Create Seasonal Insights Summary

### What You Want to Achieve
Document key seasonal patterns for business decisions.

### The Vibe Coding Prompt

```
Create a seasonal insights summary:

1. Peak Season Findings:
   - When exactly is peak? (which weeks)
   - How much higher is ADR?
   - Cancellation risk in peak?
   - Staffing implications

2. Low Season Findings:
   - Opportunities in low season?
   - Which segments book during low?
   - Pricing strategies

3. Transition Patterns:
   - How quickly does demand shift?
   - Early booking patterns for peak season
   - When do people book for summer?

4. Recommendations:
   - Pricing calendar suggestions
   - Marketing timing
   - Overbooking by season

Save as findings/seasonal_insights.md
```

---

## Deliverables Checklist

After completing this exercise, you should have:

- [ ] Monthly demand patterns analyzed
- [ ] Season categories created
- [ ] Cyclic month encodings added
- [ ] Weekend/weekday patterns analyzed
- [ ] Stay pattern features created
- [ ] Year-over-year trends analyzed
- [ ] `visualizations/monthly_demand_pattern.png`
- [ ] `visualizations/seasonal_comparison.png`
- [ ] `visualizations/arrival_day_patterns.png`
- [ ] `visualizations/stay_patterns_by_season.png`
- [ ] `visualizations/yoy_trends.png`
- [ ] `data/processed/bookings_with_seasonality.csv`
- [ ] `data/processed/seasonality_features.md`
- [ ] `findings/seasonal_insights.md`

---

## Key Vocabulary for Vibe Coding

When creating seasonal features, these keywords help:

| What You Want | Keywords to Use |
|---------------|-----------------|
| Time buckets | "by month", "by season", "quarterly" |
| Cyclic features | "sin/cos encoding", "cyclic", "circular" |
| Categories | "bucket into", "categorize", "segment by" |
| Trends | "year over year", "growth rate", "trend" |
| Binary flags | "is_summer", "peak season flag" |

---

## Common Issues and How to Fix Them

**If month numbers seem wrong:**
```
Month shows as text "August" not number 8.
Convert month names to numbers before creating features.
Then the cyclic encoding will work correctly.
```

**If year-over-year comparison seems off:**
```
2017 has way more bookings than 2015.
Check: Is all of 2015 in the data, or just partial year?
Filter to complete years only for fair comparison.
```

**If stay patterns don't make sense:**
```
Some stays show 0 nights total.
These might be same-day bookings or data errors.
Filter out or investigate stays < 1 night.
```

---

## What's Next?

Now that you've created seasonal features, Exercise 5 will teach you how to **correlate all features with cancellation** to build a complete risk model.

---

[← Previous: Holiday Impact](./03_holiday_impact.md) | [Lab 3 Home](../README.md) | [Next: Lead Time Correlation →](./05_lead_time_correlation.md)
