# Exercise 3: Holiday Impact Assessment

**[Lab 3 Home](../README.md) > Exercise 3**

## Overview

Holidays drive tourism! In this exercise, you'll learn how to **join a holiday calendar** to your booking data and analyze how holidays affect demand and cancellation patterns.

**Time**: 45-60 minutes

## The Business Question

> "How do holidays impact our booking patterns? Do guests who book for holiday periods behave differently?"

Understanding holiday impact helps with:
- Dynamic pricing during holiday periods
- Staffing and inventory planning
- Marketing campaign timing

---

## Task 3.1: Load and Explore the Holiday Data

### What You Want to Achieve
Understand the structure of the worldwide holiday dataset.

### The Vibe Coding Prompt

```
Load the worldwide holidays dataset from data/raw/

Tell me:
1. What columns exist?
2. How many countries are included?
3. What date range is covered?
4. Sample of 10 rows

For Portugal specifically:
- How many holidays per year?
- What are the major holidays?
- Show me all Portuguese holidays for 2017

Note: This hotel is in Portugal, so we only need Portuguese holidays.
```

### Portuguese Holidays to Expect
- New Year's Day (January 1)
- Carnival (February, date varies)
- Easter (March/April, date varies)
- Freedom Day (April 25)
- Labour Day (May 1)
- Portugal Day (June 10)
- Assumption Day (August 15)
- Republic Day (October 5)
- All Saints' Day (November 1)
- Independence Day (December 1)
- Christmas (December 25)

---

## Task 3.2: Filter and Prepare Holiday Data

### What You Want to Achieve
Create a clean Portugal holiday lookup table.

### The Vibe Coding Prompt

```
Prepare the holiday data for joining:

1. Filter to Portugal only
2. Filter to dates that overlap with booking data
3. Create a clean lookup table:
   - date
   - holiday_name
   - holiday_type (if available)

4. Handle multi-day holidays:
   - Is Christmas Eve included?
   - Easter weekend (Friday through Monday)?
   - For now, just use official dates

5. Show the prepared holiday table
   - How many unique dates?
   - All holidays listed

Save as data/processed/portugal_holidays.csv
```

### Extended Holiday Periods
For tourism analysis, consider:
```
Holidays often affect multiple days:
- Christmas period (Dec 23-26)
- Easter period (Thu-Mon)
- Summer holidays (Aug 1-15)

Should we flag the day before/after holidays too?
```

---

## Task 3.3: Construct and Validate Arrival Dates

### What You Want to Achieve
Create proper date columns in the booking data for joining.

### The Vibe Coding Prompt

```
Prepare booking data for holiday join:

1. Create arrival_date column:
   - Combine arrival_date_year, arrival_date_month, arrival_date_day_of_month
   - Result should be proper date format

2. Calculate stay period:
   - arrival_date (start)
   - departure_date = arrival_date + stays_in_week_nights + stays_in_weekend_nights
   - Total stay duration

3. Validate:
   - Show 5 sample rows with original columns and new dates
   - Check that dates parse correctly
   - Any dates that don't make sense?

4. Date range check:
   - What's the earliest arrival date?
   - What's the latest arrival date?
   - Does this overlap with our holiday data?
```

### Month Name Conversion
The month column is likely text ("July") not number:
```
Convert month names to numbers:
January = 1, February = 2, ..., December = 12

Then combine: year-month-day into a proper date.
```

---

## Task 3.4: Join Holiday Data to Bookings

### What You Want to Achieve
Flag bookings that arrive on or near holidays.

### The Vibe Coding Prompt

```
Join holiday data to booking data:

1. Simple join - arrival on holiday:
   - Left join holidays on arrival_date
   - Create is_holiday_arrival flag
   - Add holiday_name column

2. Extended holiday flags:
   - is_day_before_holiday
   - is_day_after_holiday
   - is_holiday_weekend (arrival within 3 days of holiday)

3. Validate the join:
   - How many bookings arrive on a holiday?
   - What percentage is that?
   - Top holidays by booking count

4. Check for issues:
   - Any holidays with zero bookings? (might be a date mismatch)
   - Any dates with multiple holidays?

Show the join results summary.
```

### Join Logic
```
Be careful with the join:
- Left join from bookings (keep all bookings)
- Null holiday_name means not a holiday arrival
- Create boolean flag from the join result
```

---

## Task 3.5: Analyze Holiday Impact on Demand

### What You Want to Achieve
Quantify how holidays affect booking volume and patterns.

### The Vibe Coding Prompt

```
Analyze holiday impact on demand:

1. Volume comparison:
   - Average daily bookings on holidays vs non-holidays
   - Is there a significant difference?
   - Which direction (more or fewer)?

2. By specific holiday:
   - Booking count for each major holiday
   - Rank holidays by demand
   - Which is the busiest holiday?

3. Lead time for holiday bookings:
   - Average lead time for holiday arrivals
   - Do people book holidays further in advance?

4. ADR for holiday bookings:
   - Average rate for holiday vs non-holiday
   - Do hotels charge more for holidays?
   - Percentage premium

Create a bar chart comparing key metrics: holidays vs non-holidays.
Save as visualizations/holiday_demand_comparison.png
```

---

## Task 3.6: Analyze Holiday Impact on Cancellations

### What You Want to Achieve
Determine if holiday bookings cancel at different rates.

### The Vibe Coding Prompt

```
Analyze cancellation patterns for holiday bookings:

1. Overall comparison:
   - Cancellation rate for holiday arrivals
   - Cancellation rate for non-holiday arrivals
   - Is the difference significant?

2. By specific holiday:
   - Cancellation rate per holiday
   - Which holidays have highest cancellation?
   - Which are most reliable?

3. Combined factors:
   - Holiday + deposit type
   - Holiday + market segment
   - Any segment particularly risky for holidays?

4. Lead time interaction:
   - For holiday bookings, how does lead time affect cancellation?
   - Is the pattern different from non-holiday?

Create a visualization comparing cancellation rates by holiday.
Save as visualizations/holiday_cancellation_rates.png
```

### Hypothesis
```
Holiday bookings might cancel MORE because:
- Booked very early (longer lead time)
- Plans change

Or they might cancel LESS because:
- Higher commitment to vacation
- Higher deposit requirements

Let the data tell us which is true.
```

---

## Task 3.7: Analyze Holiday Weekend Patterns

### What You Want to Achieve
Look at the broader holiday period, not just the day itself.

### The Vibe Coding Prompt

```
Analyze extended holiday period patterns:

1. Holiday week analysis:
   - For each major holiday, look at the entire week
   - Are adjacent days also high-demand?
   - Create "holiday week" flag

2. Long weekend patterns:
   - When holidays fall on Thu or Mon, create long weekends
   - Booking patterns for long weekends
   - Cancellation patterns

3. Summer holiday analysis:
   - August is peak vacation in Portugal
   - Is the entire month like a holiday?
   - Compare August to other months

4. Christmas-New Year period:
   - Special analysis for Dec 20 - Jan 5
   - This is often treated as one continuous holiday period
   - Booking and cancellation patterns

Create a visualization of demand across the December holiday period.
Save as visualizations/december_holiday_period.png
```

---

## Task 3.8: Create Holiday Strategy Recommendations

### What You Want to Achieve
Translate holiday analysis into actionable recommendations.

### The Vibe Coding Prompt

```
Create holiday strategy recommendations:

1. Pricing Recommendations:
   - Which holidays warrant premium pricing?
   - What premium % is supported by data?
   - When should pricing increase start?

2. Deposit Policy Recommendations:
   - Should holidays require deposits?
   - Which holidays have highest risk?
   - Suggested policy by holiday type

3. Marketing Recommendations:
   - When to run holiday promotions
   - Which segments book holidays?
   - Lead time for holiday marketing

4. Overbooking Recommendations:
   - Holiday-specific cancellation rates
   - Safe overbooking levels by holiday
   - Risk factors to watch

Save enriched dataset as data/processed/bookings_with_holidays.csv
Save recommendations as findings/holiday_strategy.md
```

---

## Deliverables Checklist

After completing this exercise, you should have:

- [ ] Holiday data loaded and filtered to Portugal
- [ ] `data/processed/portugal_holidays.csv`
- [ ] Arrival dates properly constructed
- [ ] Holiday flags joined to booking data
- [ ] Holiday demand impact analyzed
- [ ] Holiday cancellation impact analyzed
- [ ] `visualizations/holiday_demand_comparison.png`
- [ ] `visualizations/holiday_cancellation_rates.png`
- [ ] `visualizations/december_holiday_period.png`
- [ ] `data/processed/bookings_with_holidays.csv`
- [ ] `findings/holiday_strategy.md`

---

## Key Vocabulary for Vibe Coding

When working with calendar/holiday data, these keywords help:

| What You Want | Keywords to Use |
|---------------|-----------------|
| Date joining | "join on date", "match to calendar" |
| Holiday flags | "is_holiday", "flag", "indicator" |
| Extended periods | "holiday week", "holiday period", "adjacent days" |
| Seasonal | "August", "peak season", "summer" |

---

## Common Issues and How to Fix Them

**If holiday join returns no matches:**
```
The holiday join returned 0 matches.
Check the date formats:
- Bookings: What format is arrival_date?
- Holidays: What format is the date column?
Make sure both are the same format before joining.
```

**If too few holidays match:**
```
Only 2 holidays matched to bookings.
Check:
- Are the years overlapping?
- Is the country filter correct?
- Show me sample dates from both tables.
```

**If month parsing fails:**
```
Month "July" is not parsing.
The month is text, not number.
Create a mapping: {"January": 1, "February": 2, ...}
Then apply to create numeric month.
```

---

## What's Next?

Now that you've analyzed holiday impact, Exercise 4 will teach you how to **create seasonal features** for predicting demand patterns.

---

[← Previous: Cancellation Analysis](./02_cancellation_analysis.md) | [Lab 3 Home](../README.md) | [Next: Seasonality Features →](./04_seasonality_features.md)
