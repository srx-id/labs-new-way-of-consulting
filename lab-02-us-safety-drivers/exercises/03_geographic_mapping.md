# Exercise 3: Geographic Mapping with FIPS Codes

**[Lab 2 Home](../README.md) > Exercise 3**

## Overview

US government data uses FIPS codes for geographic identification. In this exercise, you'll learn how to **use FIPS codes to standardize geography** and create a consistent county-level dataset.

**Time**: 45-60 minutes

## What are FIPS Codes?

**FIPS** = Federal Information Processing Standards

Every US county has a unique 5-digit code:
- First 2 digits = State (e.g., "06" = California)
- Last 3 digits = County (e.g., "037" = Los Angeles)
- Full code: "06037" = Los Angeles County, CA

This is the gold standard for joining US geographic data.

---

## Task 3.1: Understand the Zipcode-to-County Crosswalk

### What You Want to Achieve
Load and explore the geographic crosswalk file.

### The Vibe Coding Prompt

```
Load the zipcode-to-county crosswalk from data/raw/

Show me:
1. What columns does it have?
2. Sample of 10 rows
3. How many unique zipcodes?
4. How many unique counties (FIPS codes)?
5. How many unique states?

Explain how this crosswalk works:
- Does one zipcode always map to one county?
- Or can a zipcode span multiple counties?
```

### Understanding the Crosswalk
Zipcodes don't always align perfectly with counties:
- Some zipcodes span 2-3 counties
- The crosswalk often has a "weight" showing what % is in each county
- For analysis, usually pick the county with highest weight

---

## Task 3.2: Verify FIPS Code Format

### What You Want to Achieve
Ensure all FIPS codes are properly formatted.

### The Vibe Coding Prompt

```
Check the FIPS code format in the crosswalk:

1. What's the data type? (string or number)
2. How many characters are FIPS codes?
3. Are there any with less than 5 characters?

FIPS codes must:
- Be 5 characters long
- Have leading zeros (e.g., "01001" not "1001")

If needed, fix the format:
- Convert to string
- Pad with leading zeros to 5 characters

Show me examples of correctly formatted FIPS codes.
```

### The Leading Zero Problem
This is a common data gotcha:
```
FIPS code "01001" (Alabama) often gets read as number 1001.
When you convert back to string, it becomes "1001" (missing the leading zero).
This will break your joins!

Always ensure FIPS codes are stored as 5-character strings.
```

---

## Task 3.3: Map Accidents to FIPS Codes

### What You Want to Achieve
Add FIPS codes to the accident data for standardized geographic analysis.

### The Vibe Coding Prompt

```
Add FIPS codes to the accident data:

First, check what geographic columns the accident data has:
- Zipcode?
- County name?
- State?
- Latitude/Longitude?

Then, join the crosswalk:
1. If accidents have zipcode → join crosswalk on zipcode
2. If accidents have county name → need different approach

After joining:
- How many accidents got a FIPS code?
- How many didn't match?
- Which states have the lowest match rate?

Save the result with FIPS codes included.
```

### If Accidents Have County Names Instead of Zipcodes

```
The accident data has county NAME but no zipcode.
We need to match on State + County Name to get FIPS code.

Create a lookup from the crosswalk:
- Unique combinations of State, County Name, FIPS
- Handle slight spelling differences

Try matching and report what doesn't match.
```

---

## Task 3.4: Handle Geographic Mismatches

### What You Want to Achieve
Investigate and resolve records that didn't get FIPS codes.

### The Vibe Coding Prompt

```
Analyze the accidents that didn't get FIPS codes:

1. How many total? What percentage?

2. What are the reasons?
   - Missing zipcode in original data?
   - Zipcode not in crosswalk?
   - Invalid zipcode format?

3. Geographic distribution:
   - Which states have the most unmatched?
   - Are certain regions worse than others?

4. Severity distribution:
   - Are severe accidents more or less likely to be unmatched?
   - Could this bias our analysis?

Recommend: Should we drop unmatched records or try to fix them?
```

### Decision Framework
- **<5% unmatched**: Usually safe to drop
- **5-15% unmatched**: Investigate patterns before dropping
- **>15% unmatched**: Need to fix the mapping

---

## Task 3.5: Create County-Level Aggregation

### What You Want to Achieve
Aggregate accident data to county level for analysis.

### The Vibe Coding Prompt

```
Aggregate accidents to the county-day level:

For each county-day combination, calculate:
- total_accidents: Count of accidents
- avg_severity: Average severity (1-4)
- severe_accidents: Count where severity >= 3
- pct_severe: Percentage that are severe

The result should have:
- FIPS code
- Date
- Aggregated metrics

How many county-days are in the aggregated data?
What's the average accidents per county-day?

Save as data/processed/accidents_county_day.csv
```

### Why County-Day?
This is our target "grain" for joining with:
- Weather data (daily by location)
- Holiday data (daily)
- Other external data

---

## Task 3.6: Validate County-Level Data

### What You Want to Achieve
Confirm the aggregation is correct and sensible.

### The Vibe Coding Prompt

```
Validate the county-day aggregation:

1. Spot check:
   - Pick 5 random county-days
   - Go back to original data and manually count accidents
   - Do the counts match?

2. Sanity checks:
   - Which counties have the most total accidents?
   - Are they major metro areas? (makes sense)
   - Which have the highest severity? (look for patterns)

3. Time check:
   - Do accident counts make sense across months?
   - Higher in winter? (weather)
   - Higher on weekends? (check)

4. Coverage:
   - How many unique counties represented?
   - How many US counties are NOT represented?
   - Is this a sample or comprehensive data?
```

---

## Task 3.7: Create FIPS Code Reference

### What You Want to Achieve
Build a reference table for interpreting FIPS codes.

### The Vibe Coding Prompt

```
Create a county reference table:

For each unique FIPS code in our data, show:
- FIPS code
- State name
- County name
- Total accidents in dataset
- Average severity

Save as data/processed/county_reference.csv

Also create a summary:
- How many states are represented?
- How many counties?
- Which states have the most counties with data?

This will help us interpret results later.
```

---

## Deliverables Checklist

After completing this exercise, you should have:

- [ ] Crosswalk loaded and understood
- [ ] FIPS codes properly formatted (5-character strings)
- [ ] Accidents mapped to FIPS codes
- [ ] Unmapped records analyzed and documented
- [ ] `data/processed/accidents_county_day.csv`
- [ ] Aggregation validated with spot checks
- [ ] `data/processed/county_reference.csv`

---

## Key Vocabulary for Vibe Coding

When working with FIPS codes, these keywords help:

| What You Want | Keywords to Use |
|---------------|-----------------|
| Standard format | "FIPS code", "5-digit code", "leading zeros" |
| Geographic linking | "crosswalk", "zipcode to county", "mapping table" |
| Format issues | "pad with zeros", "convert to string", "zfill" |
| Aggregate | "county level", "group by FIPS", "county-day grain" |
| Validate | "spot check", "coverage", "match rate" |

---

## Common Issues and How to Fix Them

**If FIPS codes don't match:**
```
The join gave 0 matches.
Show me sample FIPS codes from both tables.
Are they the same format? (string vs number, with/without leading zeros)
```

**If county names have variations:**
```
"St. Louis County" doesn't match "Saint Louis County"
Create a standardization that handles:
- St. vs Saint
- County vs missing suffix
- Spaces and punctuation differences
```

**If zipcodes span multiple counties:**
```
Zipcode 12345 appears in 3 counties.
For this zipcode, which county has the highest population?
Use that county as the primary mapping.
```

---

## What's Next?

Now that you have geographically standardized data, Exercise 4 will teach you how to **add temporal features** like rush hour flags, weekday indicators, and holiday markers.

---

[← Previous: Weather Integration](./02_weather_integration.md) | [Lab 2 Home](../README.md) | [Next: Temporal Features →](./04_temporal_features.md)
