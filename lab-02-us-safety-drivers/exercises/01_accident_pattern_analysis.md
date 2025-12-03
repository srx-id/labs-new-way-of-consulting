# Exercise 1: Accident Pattern Analysis

**[Lab 2 Home](../README.md) > Exercise 1**

## Overview

You've been given a massive dataset of US traffic accidents. Before diving into analysis, you need to understand what you're working with and discover patterns that will guide your investigation.

**Time**: 45-60 minutes

## The Scenario

An insurance company wants to understand what drives accident severity. Your first task: profile the accident data and identify initial patterns that will guide deeper analysis.

---

## Task 1.1: Load and Profile the Accident Data

### What You Want to Achieve
Get a comprehensive overview of the US Accidents dataset - it's big, so you need to be strategic.

### The Vibe Coding Prompt

```
Load the US Accidents dataset from data/raw/US_Accidents_Processed.csv

This is a large file, so first:
1. How many rows and columns?
2. What's the date range of the data?
3. List all columns with their data types
4. Show me sample of 5 rows

Focus on key columns:
- Severity (1-4 scale)
- Start_Time (when accident happened)
- State, County, City (location)
- Weather-related columns
- Time of day patterns
```

### What to Look For
- **Size**: This dataset often has millions of rows
- **Severity distribution**: Are most accidents minor (1-2) or major (3-4)?
- **Geographic spread**: Which states have the most data?
- **Date range**: What years are covered?

---

## Task 1.2: Explore Severity Distribution

### What You Want to Achieve
Understand what "severity" means in this dataset and how it's distributed.

### The Vibe Coding Prompt

```
Analyze the Severity column:

1. What are the unique values? (should be 1, 2, 3, 4)
2. Show counts and percentages for each level
3. Create a bar chart of severity distribution
4. What does each level mean? (look for documentation or infer from patterns)

Save chart as visualizations/severity_distribution.png
```

### Business Context
Severity levels typically mean:
- **1**: Minor impact on traffic
- **2**: Moderate impact
- **3**: Significant impact
- **4**: Major impact, potential road closure

Ask the AI if you're unsure:
```
What does severity mean in this dataset?
How long were roads impacted for each severity level?
```

---

## Task 1.3: Discover Temporal Patterns

### What You Want to Achieve
Find when accidents happen most - by hour, day of week, and month.

### The Vibe Coding Prompt

```
Analyze temporal patterns in the accident data:

1. Extract from Start_Time:
   - Hour of day (0-23)
   - Day of week (Monday-Sunday)
   - Month (1-12)
   - Year

2. Create visualizations:
   - Accidents by hour of day (bar chart)
   - Accidents by day of week (bar chart)
   - Accidents by month (line chart)

3. For each, break down by Severity level

Key questions to answer:
- What's the most dangerous hour?
- Which day has the most accidents?
- Is there seasonality?

Save charts to visualizations/ folder
```

### Expected Patterns
You'll likely find:
- **Rush hours**: Spikes at 7-9 AM and 4-6 PM
- **Weekdays vs weekends**: Different patterns
- **Winter months**: Potentially more severe accidents

---

## Task 1.4: Identify Geographic Hotspots

### What You Want to Achieve
Find which states and cities have the most accidents.

### The Vibe Coding Prompt

```
Analyze geographic distribution of accidents:

1. Top 10 states by accident count
2. Top 10 cities by accident count
3. For the top 5 states:
   - Average severity
   - Most common hours
   - Most common weather conditions

Create a bar chart of top 10 states by accident count.
Color-code by average severity if possible.

Save as visualizations/state_accident_counts.png
```

### Follow-Up Questions

```
California and Texas have the most accidents.
Is this just because they have the most drivers?
How would we normalize by population or miles driven?
```

---

## Task 1.5: Explore Weather Conditions

### What You Want to Achieve
Understand what weather conditions are present when accidents occur.

### The Vibe Coding Prompt

```
Analyze weather-related columns in the accident data:

1. List all weather-related columns (Temperature, Humidity, Visibility, Weather_Condition, etc.)

2. For each weather column:
   - How many missing values?
   - What's the distribution?

3. For Weather_Condition column:
   - What are the top 10 most common conditions?
   - Which conditions have the highest average severity?

4. Create a chart showing:
   - Average severity by weather condition (top 10 conditions only)

Save as visualizations/severity_by_weather.png
```

### Key Insight Preview
This analysis will help answer: "Does bad weather cause more severe accidents?"

---

## Task 1.6: Check Data Quality

### What You Want to Achieve
Identify data quality issues before proceeding with analysis.

### The Vibe Coding Prompt

```
Create a data quality report for the accidents dataset:

1. Missing values:
   - For each column, what percentage is missing?
   - Which columns have >20% missing?

2. Potential outliers:
   - Temperature values that seem wrong
   - Dates in the future or too far in the past
   - Severity values outside 1-4

3. Geographic coverage:
   - Any states with very few records?
   - Any counties with suspicious patterns?

4. Duplicates:
   - Are there exact duplicate rows?
   - Could the same accident be recorded twice?

Summarize: What issues need to be addressed before analysis?
```

---

## Task 1.7: Create Initial Findings Summary

### What You Want to Achieve
Document your exploration findings for reference.

### The Vibe Coding Prompt

```
Create a summary of exploration findings:

1. Dataset Overview:
   - Total records
   - Date range
   - Geographic coverage
   - Key columns for analysis

2. Initial Patterns Discovered:
   - Temporal patterns (most dangerous times)
   - Geographic patterns (hotspot states/cities)
   - Severity distribution
   - Weather patterns

3. Data Quality Issues:
   - Missing data challenges
   - Columns to drop or clean
   - Filtering decisions

4. Questions for Deeper Analysis:
   - What should we investigate next?
   - What correlations should we test?

Save as findings/01_exploration_summary.md
```

---

## Deliverables Checklist

After completing this exercise, you should have:

- [ ] Understanding of dataset size and structure
- [ ] Severity distribution documented
- [ ] `visualizations/severity_distribution.png`
- [ ] `visualizations/state_accident_counts.png`
- [ ] `visualizations/severity_by_weather.png`
- [ ] Temporal patterns identified (hour, day, month)
- [ ] Data quality issues documented
- [ ] `findings/01_exploration_summary.md`

---

## Key Vocabulary for Vibe Coding

When exploring accident data, these keywords help:

| What You Want | Keywords to Use |
|---------------|-----------------|
| Time patterns | "by hour", "by day of week", "by month", "extract time" |
| Location analysis | "by state", "by county", "geographic distribution" |
| Distribution | "value counts", "frequency", "histogram" |
| Quality check | "missing values", "nulls", "outliers", "duplicates" |
| Severity | "average severity", "severity breakdown", "by severity level" |

---

## Common Issues and How to Fix Them

**If the file takes forever to load:**
```
The file is very large. Load just the first 100,000 rows as a sample.
Or load only the columns we need: Severity, Start_Time, State, County, Weather_Condition
```

**If dates won't parse:**
```
Show me the format of Start_Time column.
What does a typical value look like?
Parse it as the correct format.
```

**If you see weird weather values:**
```
I see temperature values of -99 or 999.
These are probably placeholder values for missing data.
Replace them with null and note how many we lost.
```

---

## What's Next?

Now that you understand the accident patterns, Exercise 2 will teach you how to **integrate weather data** to analyze weather's impact on accident severity.

---

[Lab 2 Home](../README.md) | [Next: Weather Integration →](./02_weather_integration.md)
