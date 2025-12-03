# Exercise 1: Booking Pattern Analysis

**[Lab 3 Home](../README.md) > Exercise 1**

## Overview

You've been given hotel booking data from a Portuguese resort. Before analyzing cancellations, you need to understand the booking patterns - who books, when, and how.

**Time**: 30-45 minutes

## The Scenario

A hotel revenue manager wants to understand booking patterns to:
- Optimize pricing strategies
- Predict demand
- Reduce cancellation rates

Your first task: profile the booking data and understand the customer base.

---

## Task 1.1: Load and Explore the Booking Data

### What You Want to Achieve
Get a comprehensive overview of the hotel booking dataset.

### The Vibe Coding Prompt

```
Load the hotel booking dataset from data/raw/hotel_bookings.csv

Give me an overview:
1. How many total bookings?
2. What date range is covered?
3. What columns are available (list all with descriptions)?
4. Show me 5 sample rows

Key columns to look for:
- hotel (city hotel vs resort)
- arrival_date_year, arrival_date_month, arrival_date_day_of_month
- stays_in_weekend_nights, stays_in_week_nights
- adults, children, babies
- meal type
- market_segment (how they booked)
- is_canceled (our target for later analysis)
```

### What to Look For
- **Two hotels**: City Hotel and Resort Hotel (different patterns expected)
- **Date construction**: Arrival date is split across multiple columns
- **Guest composition**: Adults, children, babies
- **Cancellation rate**: What % are cancelled?

---

## Task 1.2: Understand Lead Time Distribution

### What You Want to Achieve
Analyze how far in advance guests book.

### The Vibe Coding Prompt

```
Analyze the lead_time column (days between booking and arrival):

1. Basic statistics:
   - Average lead time
   - Median lead time
   - Min and max

2. Distribution:
   - Create a histogram of lead times
   - What's the most common booking window?

3. Segments:
   - Create lead time buckets:
     * Last minute: 0-7 days
     * Short: 8-30 days
     * Medium: 31-90 days
     * Long: 91-180 days
     * Very long: 180+ days
   - What % falls into each bucket?

4. By hotel type:
   - Compare lead times: City vs Resort
   - Which has more last-minute bookings?

Save histogram as visualizations/lead_time_distribution.png
```

### Business Insight
Lead time affects:
- Cancellation probability (longer lead time = higher cancellation risk)
- Pricing strategy (last-minute vs early-bird rates)
- Overbooking strategy

---

## Task 1.3: Analyze Customer Segments

### What You Want to Achieve
Understand who's booking and through what channels.

### The Vibe Coding Prompt

```
Analyze customer segmentation:

1. Market Segment breakdown:
   - What are the unique market segments?
   - Count and percentage for each
   - Which segment is largest?

2. Distribution Channel:
   - What channels are used? (TA = Travel Agent, TO = Tour Operator, Direct, etc.)
   - Which is most common?

3. Customer Type:
   - Contract, Group, Transient, Transient-Party
   - What do these mean? Which is most common?

4. Cross-analysis:
   - Market Segment by Hotel Type
   - Which segments prefer City vs Resort?

Create a bar chart of market segments by hotel type.
Save as visualizations/market_segments.png
```

### Understanding the Segments
- **Direct**: Booked directly with hotel
- **TA/TO**: Travel Agent / Tour Operator
- **Corporate**: Business bookings
- **Online TA**: Expedia, Booking.com, etc.
- **Groups**: Tour groups, events

---

## Task 1.4: Analyze Booking Patterns by Time

### What You Want to Achieve
Find seasonal patterns in booking demand.

### The Vibe Coding Prompt

```
Analyze temporal booking patterns:

1. Create proper arrival date:
   - Combine arrival_date_year, arrival_date_month, arrival_date_day_of_month
   - Create a single date column

2. Monthly patterns:
   - Total bookings by month
   - Separate by hotel type
   - Which months are peak season?

3. Day of week patterns:
   - Which days do guests typically arrive?
   - Weekend vs weekday arrivals?

4. Year-over-year:
   - Booking trends across years
   - Is demand growing or shrinking?

Create a line chart showing monthly bookings by hotel type.
Highlight peak season months.
Save as visualizations/monthly_booking_trends.png
```

### Seasonality Questions
```
Portugal is a summer destination.
- Is peak season June-August as expected?
- Does the City Hotel have different seasonality than the Resort?
- Are there any off-peak surprises?
```

---

## Task 1.5: Analyze Cancellation Rates

### What You Want to Achieve
Get a first look at cancellation patterns (the focus of later exercises).

### The Vibe Coding Prompt

```
Analyze the is_canceled column:

1. Overall cancellation rate:
   - What % of bookings are cancelled?
   - Total cancelled vs not cancelled

2. By hotel type:
   - City Hotel cancellation rate
   - Resort Hotel cancellation rate
   - Which is higher?

3. By market segment:
   - Cancellation rate per segment
   - Which segment cancels most?
   - Which is most reliable?

4. By lead time bucket:
   - Cancellation rate for each lead time bucket
   - Is there a clear pattern?

Create a bar chart of cancellation rates by market segment.
Save as visualizations/cancellation_by_segment.png
```

### Key Metric: Cancellation Rate
```
Cancellation Rate = Cancelled Bookings / Total Bookings × 100%

A "good" rate depends on the industry:
- Luxury hotels: 15-20%
- Business hotels: 20-30%
- Booking.com heavy: 30-40% (free cancellation policies)
```

---

## Task 1.6: Analyze Revenue Indicators

### What You Want to Achieve
Understand the pricing and revenue patterns.

### The Vibe Coding Prompt

```
Analyze revenue-related columns:

1. ADR (Average Daily Rate):
   - What's the average ADR?
   - Distribution of ADR values
   - By hotel type: which charges more?

2. Stay duration:
   - Average nights (weekend + weekday nights)
   - Distribution of stay lengths
   - Weekend vs weekday-heavy stays

3. Special requests:
   - Average number of special requests
   - Does this correlate with anything?

4. Deposit type:
   - What deposit types exist?
   - Which is most common?
   - Any pattern with cancellations?

Create a box plot of ADR by hotel type and month.
Save as visualizations/adr_by_hotel_month.png
```

### ADR = Average Daily Rate
This is the key revenue metric in hospitality:
```
ADR = Total Room Revenue / Number of Rooms Sold

Higher ADR in peak season is expected.
Resort hotels often have more variable ADR than city hotels.
```

---

## Task 1.7: Create Exploration Summary

### What You Want to Achieve
Document your findings for reference in later exercises.

### The Vibe Coding Prompt

```
Create an exploration summary:

1. Dataset Overview:
   - Total bookings
   - Date range
   - Two hotels with X and Y bookings each

2. Key Metrics:
   - Overall cancellation rate
   - Average lead time
   - Average ADR
   - Peak season months

3. Interesting Patterns Found:
   - Differences between City and Resort
   - Segment behavior differences
   - Seasonal patterns

4. Questions for Deeper Analysis:
   - What drives cancellations?
   - How does lead time affect cancellation probability?
   - Which segments should we focus on?

5. Data Quality Notes:
   - Any missing values
   - Any suspicious outliers
   - Columns we might not need

Save as findings/01_exploration_summary.md
```

---

## Deliverables Checklist

After completing this exercise, you should have:

- [ ] Dataset loaded and understood
- [ ] Arrival date column properly constructed
- [ ] Lead time distribution analyzed
- [ ] `visualizations/lead_time_distribution.png`
- [ ] `visualizations/market_segments.png`
- [ ] `visualizations/monthly_booking_trends.png`
- [ ] `visualizations/cancellation_by_segment.png`
- [ ] `visualizations/adr_by_hotel_month.png`
- [ ] `findings/01_exploration_summary.md`

---

## Key Vocabulary for Vibe Coding

When analyzing hospitality data, these keywords help:

| What You Want | Keywords to Use |
|---------------|-----------------|
| Booking metrics | "lead time", "length of stay", "ADR", "occupancy" |
| Customer types | "market segment", "distribution channel", "customer type" |
| Time patterns | "seasonal", "monthly trends", "day of week" |
| Cancellations | "cancellation rate", "is_canceled", "no-show" |

---

## Common Issues and How to Fix Them

**If date columns won't combine:**
```
I need to combine year, month, and day columns into one date.
The month is in text format ("July") not number.
Convert month name to number, then combine into a proper date.
```

**If ADR has weird values:**
```
Some ADR values are 0 or negative.
Are these complimentary stays or data errors?
Show me the bookings with ADR <= 0 and check if they make sense.
```

**If categories are unclear:**
```
What does "TA/TO" mean in market_segment?
Explain all the market segment and distribution channel codes.
```

---

## What's Next?

Now that you understand the booking patterns, Exercise 2 will teach you how to **analyze cancellation drivers** in depth.

---

[Lab 3 Home](../README.md) | [Next: Cancellation Analysis →](./02_cancellation_analysis.md)
