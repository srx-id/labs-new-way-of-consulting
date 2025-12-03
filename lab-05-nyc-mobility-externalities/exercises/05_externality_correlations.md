# Exercise 5: Externality Correlation Analysis

**[Lab 5 Home](../README.md) > Exercise 5**

## Overview

This is the capstone exercise where you bring everything together. You'll **join taxi and complaint data** and analyze whether higher taxi volume correlates with more nuisance complaints - the "externality" of urban mobility.

**Time**: 90-120 minutes

## The Research Question

> "Do areas with more taxi activity experience more noise and traffic-related complaints?"

This is an important urban planning question:
- If yes: Taxi congestion has measurable quality-of-life costs
- Policy implications for congestion pricing, traffic management

---

## Task 5.1: Join Taxi and Complaint Data

### What You Want to Achieve
Create the final analysis dataset by joining taxi and 311 data.

### The Vibe Coding Prompt

```
Join taxi and complaint data:

1. Load prepared datasets:
   - taxi_for_join.csv (borough + date + trip metrics)
   - nuisance_for_join.csv (borough + date + complaint counts)

2. Join on:
   - borough + date

3. Verify join:
   - How many rows after join?
   - Any borough-dates in taxi but not complaints?
   - Any in complaints but not taxi?

4. Handle mismatches:
   - Left join (keep all taxi days)?
   - Inner join (only matched)?
   - Document decision

5. Final dataset columns:
   - borough, date
   - trip_count, avg_fare, rush_hour_trips
   - nuisance_complaints, traffic_noise_count, parking_complaints

Save as data/processed/taxi_complaints_joined.csv
```

---

## Task 5.2: Calculate Basic Correlations

### What You Want to Achieve
Find the relationship between taxi volume and complaints.

### The Vibe Coding Prompt

```
Calculate correlations between taxi volume and complaints:

1. Overall correlation:
   - Pearson correlation: trip_count vs nuisance_complaints
   - Spearman correlation (robust to outliers)
   - P-values for statistical significance

2. By complaint type:
   - trip_count vs traffic_noise_count
   - trip_count vs parking_complaints
   - Which type correlates most with taxi activity?

3. Different taxi metrics:
   - rush_hour_trips vs complaints
   - night_trips vs night_complaints (if available)
   - avg_fare vs complaints (proxy for trip length?)

4. Create correlation matrix:
   - All taxi metrics vs all complaint types
   - Heatmap visualization

Save heatmap as visualizations/taxi_complaint_correlation.png
```

### Expected Findings
```
Positive correlation expected:
- More taxis → more traffic noise complaints
- More taxis → more parking complaints

Relationship strength:
- Moderate correlation (0.3-0.5) would be meaningful
- Perfect correlation (>0.8) unlikely - many other factors affect complaints
```

---

## Task 5.3: Analyze by Borough

### What You Want to Achieve
Check if the relationship varies by borough.

### The Vibe Coding Prompt

```
Analyze taxi-complaint correlation by borough:

1. Separate analysis for each borough:
   - Manhattan: correlation coefficient
   - Brooklyn: correlation coefficient
   - Queens: correlation coefficient
   - Bronx: correlation coefficient
   - Staten Island: correlation coefficient

2. Compare across boroughs:
   - Which has strongest correlation?
   - Which has weakest or no correlation?
   - Any negative correlations?

3. Interpret differences:
   - High-density Manhattan: stronger effect?
   - Residential Brooklyn: different pattern?
   - Staten Island: too few taxis to see effect?

4. Visualization:
   - Scatter plots for each borough
   - Trip count (x) vs Complaints (y)
   - Add trend lines

Save as visualizations/borough_correlations.png
```

---

## Task 5.4: Control for Confounders

### What You Want to Achieve
Check if the correlation is spurious (caused by something else).

### The Vibe Coding Prompt

```
Check for confounding variables:

1. Day of week effect:
   - Both taxis and complaints might be higher on weekdays
   - Not because taxis cause complaints, but both caused by weekday activity
   - Calculate partial correlation controlling for day of week

2. Seasonal effect:
   - Summer might have more taxis AND more complaints (people outside)
   - Calculate partial correlation controlling for month

3. Population/density proxy:
   - Manhattan has more taxis AND more people to complain
   - Correlation might just reflect population density

4. Analysis:
   - Raw correlation: X
   - Controlling for day of week: Y
   - Controlling for month: Z
   - Does the correlation hold after controls?

Document: Is the relationship real or spurious?
```

### Understanding Confounders
```
A confounder is a third variable that causes BOTH:
- High taxi volume (because it's a weekday)
- High complaints (because more people are awake to complain)

If correlation disappears when controlling for weekday,
the relationship is spurious.
```

---

## Task 5.5: Analyze Lag Effects

### What You Want to Achieve
Check if today's taxis affect today's complaints or tomorrow's.

### The Vibe Coding Prompt

```
Analyze timing relationships:

1. Same-day relationship:
   - Trip count on day T vs complaints on day T
   - This is what we've been measuring

2. Lagged relationships:
   - Trips on day T vs complaints on day T+1
   - Maybe people complain the next day?

3. Lead relationships:
   - Trips on day T vs complaints on day T-1
   - Sanity check - shouldn't have strong relationship

4. Best lag:
   - Test lags of 0, 1, 2, 3 days
   - Which has strongest correlation?
   - Does lag > 0 make sense for nuisance complaints?

Document findings about timing of effects.
```

---

## Task 5.6: Quantify the Externality

### What You Want to Achieve
Translate correlation into business/policy terms.

### The Vibe Coding Prompt

```
Quantify the taxi-complaint relationship:

1. Regression coefficient:
   - For every 1000 additional taxi trips...
   - How many additional nuisance complaints?

2. By borough:
   - Manhattan: 1000 trips = X additional complaints
   - Brooklyn: 1000 trips = Y additional complaints
   - etc.

3. Daily impact:
   - On high taxi days (90th percentile)
   - vs low taxi days (10th percentile)
   - Difference in complaints

4. Policy translation:
   - If congestion pricing reduces taxis by 10%
   - Expected reduction in complaints?

Create summary table of externality coefficients by borough.
```

---

## Task 5.7: Create Visualization Dashboard

### What You Want to Achieve
Visual summary of findings for presentation.

### The Vibe Coding Prompt

```
Create an externality analysis dashboard:

Panel 1: Overall Relationship
- Scatter plot: Daily trips vs complaints (all data)
- Trend line and correlation coefficient
- Title: "More Taxis, More Complaints (r = X.XX)"

Panel 2: Borough Comparison
- Bar chart: Correlation by borough
- Highlight strongest and weakest

Panel 3: Time Pattern
- Line chart: Average daily trips and complaints by month
- Dual axis or normalized
- Show both move together

Panel 4: Impact Summary
- Table or callout boxes
- "1000 extra trips = X extra complaints"
- Policy implications

Save as visualizations/externality_dashboard.png
```

---

## Task 5.8: Write Executive Summary

### What You Want to Achieve
Deliver actionable insights for urban planning.

### The Vibe Coding Prompt

```
Create executive summary:

1. Research Question:
   "Does taxi volume correlate with nuisance complaints in NYC?"

2. Key Finding (one sentence):
   "We found a [weak/moderate/strong] [positive/negative] correlation (r = X.XX)..."

3. Details by Borough:
   - Manhattan: [finding]
   - Brooklyn: [finding]
   - Other boroughs: [summary]

4. Robustness:
   - Does finding hold after controlling for day/season?
   - Is same-day relationship or lagged?
   - How confident are we?

5. Quantification:
   - For every 1000 trips, approximately X additional complaints
   - On high-traffic days, Y% more complaints than average

6. Policy Implications:
   - If relationship is causal, congestion pricing could reduce complaints
   - Areas for traffic management priority
   - Limitations of this analysis

7. Recommendations:
   - For city transportation department
   - For urban planners
   - For further research

Save as findings/executive_summary.md
```

---

## Task 5.9: Create Final Deliverables

### What You Want to Achieve
Package all Lab 5 outputs.

### The Vibe Coding Prompt

```
Finalize all Lab 5 deliverables:

1. Data files (in data/processed/):
   - taxi_daily_aggregates.csv
   - nuisance_borough_daily.csv
   - taxi_complaints_joined.csv
   - correlation_results.csv

2. Visualizations (in visualizations/):
   - hourly_heatmap.png
   - weekly_trends.png
   - top_pickup_zones.png
   - spatial_patterns.png
   - taxi_complaint_correlation.png
   - borough_correlations.png
   - externality_dashboard.png

3. Findings (in findings/):
   - volume_handling_strategy.md
   - nuisance_taxonomy.csv
   - executive_summary.md

Create final checklist confirming completion.
```

---

## Deliverables Checklist

After completing this exercise, you should have:

- [ ] Taxi and complaint data joined
- [ ] Basic correlations calculated
- [ ] Borough-level analysis completed
- [ ] Confounders checked
- [ ] Lag effects analyzed
- [ ] Externality quantified
- [ ] `visualizations/taxi_complaint_correlation.png`
- [ ] `visualizations/borough_correlations.png`
- [ ] `visualizations/externality_dashboard.png`
- [ ] `data/processed/taxi_complaints_joined.csv`
- [ ] `data/processed/correlation_results.csv`
- [ ] `findings/executive_summary.md`

---

## Key Vocabulary for Vibe Coding

When doing externality analysis, these keywords help:

| What You Want | Keywords to Use |
|---------------|-----------------|
| Measure relationship | "correlation", "regression", "relationship" |
| Check robustness | "control for", "partial correlation", "confounder" |
| Time dynamics | "lagged correlation", "same-day effect" |
| Quantify impact | "coefficient", "for every X, how much Y" |
| Policy context | "externality", "social cost", "impact" |

---

## Common Issues and How to Fix Them

**If correlation is very weak:**
```
Correlation is only 0.08 and not significant.
This could mean:
- No real relationship exists
- Too much noise in data
- Need finer grain (hourly instead of daily)
- Relationship varies by borough - analyze separately
```

**If correlation is suspiciously high:**
```
Correlation is 0.95 - seems too perfect.
Check:
- Are both variables measuring the same thing?
- Is there data leakage?
- Verify with scatter plot - should see variance
```

**If controlling for confounders eliminates correlation:**
```
Raw correlation: 0.4
After controlling for weekday: 0.05
This suggests the relationship was spurious.
Both taxis and complaints are just higher on weekdays.
This is an important (negative) finding!
```

---

## Congratulations!

You've completed all 5 labs! You now know how to:
- Profile and explore datasets (Lab 1)
- Join geographic data (Lab 1, Lab 2)
- Handle large volumes with chunking (Lab 5)
- Create temporal aggregations (Lab 2, Lab 3, Lab 5)
- Implement fuzzy matching (Lab 4)
- Analyze correlations critically (All labs)
- Control for confounders (Lab 5)
- Create executive summaries (All labs)

**You're ready to apply these skills to real consulting work!**

---

[← Previous: Complaint Taxonomy](./04_complaint_taxonomy.md) | [Lab 5 Home](../README.md)
