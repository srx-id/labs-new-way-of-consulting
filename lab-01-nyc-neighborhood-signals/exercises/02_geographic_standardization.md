# Exercise 2: Geographic Standardization

**[Lab 1 Home](../README.md) > Exercise 2**

## Overview

Different datasets spell borough names differently. In this exercise, you'll learn how to **standardize geography** so all datasets can be joined together.

**Time**: 30-45 minutes

## The Problem

Your datasets have inconsistent borough names:

| Dataset | What They Call It | Examples |
|---------|-------------------|----------|
| Airbnb | `neighbourhood_group` | "Manhattan", "Brooklyn" |
| 311 | `Borough` | "MANHATTAN", "BROOKLYN", sometimes null |
| Crime | `BORO_NM` | "MANHATTAN", "BRONX" |
| Weather | No borough | Single location (Central Park) |

Before you can join these datasets, they all need to use the **same format**.

---

## Task 2.1: Audit Borough Values in Each Dataset

### What You Want to Achieve
See exactly what borough values exist in each dataset and identify mismatches.

### The Vibe Coding Prompt

```
For each of these datasets, show me all unique borough values and their counts:

1. Airbnb data (column: neighbourhood_group)
2. 311 data (column: Borough)
3. Crime data (column: BORO_NM)

Create a comparison table showing how each dataset names the 5 NYC boroughs.
Flag any values that don't match (nulls, misspellings, different cases).
```

### What to Look For
- **Case differences**: "Manhattan" vs "MANHATTAN"
- **Null values**: Some records have missing borough
- **Extra values**: "Unspecified", "Unknown", etc.
- **Spelling variations**: Check for any typos

---

## Task 2.2: Create a Standard Borough Mapping

### What You Want to Achieve
Define the "correct" format and map all variations to it.

### The Vibe Coding Prompt

```
Create a borough standardization mapping.

Use this standard format for the 5 NYC boroughs:
- Manhattan
- Brooklyn
- Queens
- Bronx
- Staten Island

For each dataset, create a mapping that converts their values to the standard:

Example output format:
311 Data Mapping:
  "MANHATTAN" → "Manhattan"
  "BROOKLYN" → "Brooklyn"
  "Unspecified" → null (drop these rows)

Show me how many records will be affected by each mapping.
```

### Key Decision Point
What should we do with records that have **null or unspecified** borough?

Options:
1. **Drop them** (safest - avoids noise)
2. **Use lat/lon to assign** (more work, but saves data)
3. **Create "Unknown" category** (keeps data but may skew results)

Ask AI to help decide:
```
What percentage of 311 records have null borough?
If we drop them, will it significantly change the complaint counts?
```

---

## Task 2.3: Apply the Standardization

### What You Want to Achieve
Clean all three datasets so they use consistent borough names.

### The Vibe Coding Prompt

```
Standardize the borough names in all three datasets:

1. Airbnb: The neighbourhood_group is already clean, but verify it only has the 5 valid boroughs

2. 311 Data:
   - Convert Borough to proper case (Manhattan, Brooklyn, etc.)
   - Remove or flag records with null/unspecified borough
   - Report how many records were removed

3. Crime Data:
   - Convert BORO_NM to proper case
   - Handle any null values
   - Report the cleanup results

After cleaning, show me the borough counts for each dataset to verify they match.
```

---

## Task 2.4: Handle the Weather Data (Special Case)

### What You Want to Achieve
Weather data has no borough column - it's citywide. We need to decide how to handle this.

### The Vibe Coding Prompt

```
The weather dataset only has Central Park measurements - no borough column.

For our analysis, we have two options:
1. Treat weather as citywide (same values apply to all boroughs)
2. Replicate weather data for each borough

Which approach is more appropriate for correlating weather with Airbnb prices?

If we go with option 1, how should we structure the join later?
```

### The Answer (Spoiler)
Weather should be treated as **citywide** - we'll join on month only, not borough. This is reasonable because:
- NYC weather doesn't vary much by borough
- All boroughs experience the same seasonal patterns
- We're looking at monthly averages anyway

---

## Task 2.5: Validate the Standardization

### What You Want to Achieve
Confirm all datasets are now consistent and ready to join.

### The Vibe Coding Prompt

```
Create a validation report for the geographic standardization:

1. Show borough value counts for all 3 datasets side by side
2. Confirm all values match the standard format:
   - Manhattan, Brooklyn, Queens, Bronx, Staten Island
3. Report how many records were dropped from each dataset
4. Calculate the "coverage rate" (what % of original data we kept)

Create a simple bar chart comparing record counts by borough across all datasets.
Save as visualizations/borough_coverage_comparison.png
```

### What Good Looks Like
- All datasets have exactly 5 borough values
- No nulls, no "Unspecified", no case variations
- Coverage rate should be >90% for each dataset
- The bar chart shows similar patterns across datasets

---

## Deliverables Checklist

After completing this exercise, you should have:

- [ ] Audit of original borough values in each dataset
- [ ] Standard borough mapping documented
- [ ] All 3 datasets cleaned with consistent borough names
- [ ] Decision documented for null/missing boroughs
- [ ] Weather data strategy documented (citywide approach)
- [ ] `visualizations/borough_coverage_comparison.png`
- [ ] Coverage report showing data retention rates

---

## Key Vocabulary for Vibe Coding

When standardizing data, these keywords help AI understand:

| What You Want | Keywords to Use |
|---------------|-----------------|
| See all values | "unique values", "distinct values", "value counts" |
| Fix case issues | "proper case", "title case", "uppercase to lowercase" |
| Handle missing | "null values", "drop nulls", "filter out missing" |
| Create mapping | "map values", "replace values", "standardize to" |
| Check results | "validate", "verify", "confirm all values match" |

---

## Common Issues and How to Fix Them

**If borough names still don't match after cleaning:**
```
Show me the exact unique values after cleaning.
Are there any leading/trailing spaces or hidden characters?
Strip whitespace from the borough column.
```

**If too many records are being dropped:**
```
For the records with null borough, check if they have valid latitude/longitude.
Can we use coordinates to assign them to a borough?
```

**If you need to verify the mapping:**
```
Show me 5 example rows before and after the borough standardization
so I can verify the mapping worked correctly.
```

---

## What's Next?

Now that all datasets use the same borough names, Exercise 3 will teach you how to **aggregate to the same time grain** - converting everything to monthly summaries.

---

[← Previous: Data Exploration](./01_data_exploration.md) | [Lab 1 Home](../README.md) | [Next: Temporal Aggregation →](./03_temporal_aggregation.md)
