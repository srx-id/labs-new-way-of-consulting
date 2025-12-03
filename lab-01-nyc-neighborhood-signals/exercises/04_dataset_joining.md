# Exercise 4: Dataset Joining

**[Lab 1 Home](../README.md) > Exercise 4**

## Overview

Now comes the magic moment - combining all 4 datasets into one analysis-ready table. In this exercise, you'll learn how to **join datasets properly** and validate that the join worked correctly.

**Time**: 45-60 minutes

## The Goal

Start with 4 separate datasets and end with 1 combined dataset:

```
Airbnb (60 rows)  ─┐
                   │
311 (60 rows)     ─┼──→ Final Dataset (60 rows)
                   │
Crime (60 rows)   ─┤
                   │
Weather (12 rows) ─┘
```

**Final Dataset**: 60 rows × ~15 columns (Borough × Month with all metrics)

---

## Task 4.1: Understand Join Types

### What You Want to Achieve
Before joining, understand what type of join you need.

### The Vibe Coding Prompt

```
I have 4 datasets to join:
1. Airbnb (60 rows): borough, year_month, avg_price, median_reviews_per_month...
2. 311 Complaints (60 rows): borough, year_month, complaint_count...
3. Crime (60 rows): borough, year_month, crime_count...
4. Weather (12 rows): year_month, avg_temp, total_precip... (NO borough column)

Explain:
- What join keys should I use for each pair?
- What type of join (left, inner, outer) is appropriate?
- Why is weather joined differently than the others?

Show me a diagram of the join strategy.
```

### The Answer

| Join | Left Table | Right Table | Key(s) | Type |
|------|------------|-------------|--------|------|
| 1 | Airbnb | 311 | borough + year_month | Left |
| 2 | Result | Crime | borough + year_month | Left |
| 3 | Result | Weather | year_month only | Left |

**Why Left Joins?** Airbnb is our "base" table. We keep all 60 rows and add data from other sources. If a match doesn't exist, we get null values (which we handle).

**Why Weather is Different?** Weather has no borough - it's citywide. Each month's weather applies to all 5 boroughs.

---

## Task 4.2: Perform the Joins

### What You Want to Achieve
Combine all 4 datasets step by step.

### The Vibe Coding Prompt

```
Join the 4 aggregated datasets into one final analysis table.

Step 1: Start with Airbnb as the base (60 rows)
Step 2: Left join 311 complaints on borough and year_month
Step 3: Left join Crime on borough and year_month
Step 4: Left join Weather on year_month only (weather applies to all boroughs)

After each join, show me:
- How many rows remain (should stay at 60)
- How many columns we now have
- Any null values introduced

Save the final result as data/processed/final_dataset.csv
```

### Critical Check
After joining, you should still have exactly **60 rows**. If you have more or fewer:
- More rows = duplicate keys in one of the datasets (bad!)
- Fewer rows = mismatched keys (needs investigation)

---

## Task 4.3: Validate Join Quality

### What You Want to Achieve
Confirm the join worked correctly with no data loss or duplication.

### The Vibe Coding Prompt

```
Validate the joined dataset:

1. Row count check:
   - Should be exactly 60 rows
   - If not, explain what went wrong

2. Key validation:
   - Show all unique borough-month combinations
   - Confirm no duplicates

3. Null value check:
   - For each column, how many null values?
   - Which columns have nulls and why?

4. Sample inspection:
   - Show me 5 rows from Manhattan
   - Show me 5 rows from January across all boroughs

Create a join quality report summarizing these checks.
```

### Understanding Nulls
Some nulls are expected:
- Weather columns should have NO nulls (weather covers all months)
- Crime/311 might have nulls if a borough-month had zero incidents (unlikely but possible)
- Airbnb metrics should have no nulls (it's the base table)

If you see unexpected nulls:
```
I see null values in columns that shouldn't have them.
Show me which borough-month combinations have nulls.
Check if the join keys matched correctly.
```

---

## Task 4.4: Handle Missing Values

### What You Want to Achieve
Decide what to do with any null values in the final dataset.

### The Vibe Coding Prompt

```
For the final joined dataset, handle missing values:

1. First, show me which columns have nulls and how many.

2. For each column with nulls, recommend a strategy:
   - Fill with 0 (if null means "zero occurrences")
   - Fill with column mean (if null is a data gap)
   - Leave as null (if we want to exclude from analysis)

3. Apply the recommended handling.

4. Confirm no unexpected nulls remain.

Document what was done for each column.
```

### Common Scenarios

| Column | If Null | Action |
|--------|---------|--------|
| crime_count | Means no crimes recorded | Fill with 0 |
| complaint_count | Means no complaints | Fill with 0 |
| avg_price | Shouldn't be null | Investigate! |
| weather metrics | Shouldn't be null | Investigate! |

---

## Task 4.5: Add Derived Metrics

### What You Want to Achieve
Create additional useful columns for analysis.

### The Vibe Coding Prompt

```
Add some derived metrics to the final dataset:

1. complaint_rate: complaints per listing (complaint_count / listing_count)
2. crime_rate: crimes per listing (crime_count / listing_count)
3. season: Categorize months as "Winter", "Spring", "Summer", "Fall"
4. is_peak_season: Flag for June-August (summer tourist season)

Show me the first 10 rows with these new columns.
```

### Business Context
These derived metrics help answer client questions:
- "Is there more noise per listing in Manhattan?"
- "Do summer months have different patterns?"

---

## Task 4.6: Create Join Documentation

### What You Want to Achieve
Document the join process for future reference.

### The Vibe Coding Prompt

```
Create a data dictionary for the final dataset:

For each column, document:
- Column name
- Data type
- Source dataset (Airbnb, 311, Crime, Weather, or Derived)
- Description
- Sample values

Format as a markdown table and save as data/processed/data_dictionary.md
```

### Example Output

| Column | Type | Source | Description |
|--------|------|--------|-------------|
| borough | string | Airbnb | NYC borough name |
| year_month | string | Airbnb | Month in YYYY-MM format |
| avg_price | float | Airbnb | Mean nightly listing price |
| complaint_count | int | 311 | Total complaints in borough-month |
| crime_count | int | Crime | Total incidents in borough-month |
| avg_temp | float | Weather | Mean daily high temperature (°F) |

---

## Task 4.7: Final Dataset Preview

### What You Want to Achieve
A complete view of what you've built.

### The Vibe Coding Prompt

```
Give me a final summary of the analysis dataset:

1. Shape: How many rows and columns?
2. Columns: List all with data types
3. Preview: Show first 10 rows
4. Statistics: Summary stats for all numeric columns
5. Completeness: Confirm 0 null values (or document remaining nulls)

Create a visualization showing the data coverage:
- Heatmap with boroughs as rows, months as columns
- Color intensity based on listing count or avg price

Save as visualizations/data_coverage_heatmap.png
```

---

## Deliverables Checklist

After completing this exercise, you should have:

- [ ] Understanding of join types (left, inner, outer)
- [ ] All 4 datasets joined correctly
- [ ] `data/processed/final_dataset.csv` (60 rows)
- [ ] Join quality validation passed
- [ ] Missing values handled and documented
- [ ] Derived metrics added
- [ ] `data/processed/data_dictionary.md`
- [ ] `visualizations/data_coverage_heatmap.png`

---

## Key Vocabulary for Vibe Coding

When joining datasets, these keywords help AI understand:

| What You Want | Keywords to Use |
|---------------|-----------------|
| Combine tables | "join", "merge", "combine datasets" |
| Keep all left rows | "left join", "keep all from first table" |
| Only matching rows | "inner join", "only where both match" |
| Check for issues | "validate join", "check for duplicates" |
| Handle missing | "fill nulls", "handle missing values" |
| Count matches | "merge indicator", "how many matched" |

---

## Common Issues and How to Fix Them

**If row count increases after join:**
```
The join created more rows than expected.
This means there are duplicate keys in one of the datasets.
Show me duplicate borough-month combinations in the 311 data.
```

**If row count decreases after join:**
```
The join dropped some rows.
Which borough-month combinations from Airbnb didn't have matches?
Should we use left join instead of inner join?
```

**If columns have wrong names after join:**
```
After joining, some columns have _x and _y suffixes.
Rename them to be clearer, like complaint_count instead of count_y.
```

**If you can't join on month:**
```
The year_month formats don't match between datasets.
Show me sample values from both.
Convert them to the same format before joining.
```

---

## What's Next?

You now have a clean, joined dataset ready for analysis! Exercise 5 will teach you how to **calculate correlations and create visualizations** to answer the client's questions.

---

[← Previous: Temporal Aggregation](./03_temporal_aggregation.md) | [Lab 1 Home](../README.md) | [Next: Correlation Analysis →](./05_correlation_analysis.md)
