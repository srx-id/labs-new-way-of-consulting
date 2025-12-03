# Exercise 5: Severity Correlation Analysis

**[Lab 2 Home](../README.md) > Exercise 5**

## Overview

This is the capstone exercise where you **analyze what drives accident severity**. You'll use all the features you created to find meaningful correlations and deliver actionable insights.

**Time**: 90-120 minutes

## The Client's Question

> "What factors most strongly influence whether a traffic accident is minor or severe?"

Your answer will help:
- Insurance pricing models
- Safety campaign targeting
- Infrastructure investment decisions

---

## Task 5.1: Prepare Data for Correlation Analysis

### What You Want to Achieve
Select the right variables and prepare them for analysis.

### The Vibe Coding Prompt

```
Load the feature-engineered accident data.

For correlation analysis, we need numeric variables. Convert:
- Boolean flags (is_rush_hour, is_weekend, etc.) → 0/1
- Categorical variables → either drop or encode

Create a clean analysis dataset with:
- Target: Severity (or binary: severe_flag where severity >= 3)
- Weather features: TMAX, PRCP, SNOW, visibility
- Temporal features: hour, is_rush_hour, is_weekend, is_holiday
- Derived features: extreme_cold, extreme_heat, rainy_day

Show the list of variables ready for correlation analysis.
```

### Binary vs Continuous Target
You can analyze severity two ways:

```
Option 1: Treat Severity as continuous (1-4)
- Use Pearson/Spearman correlation
- See which features correlate with higher severity

Option 2: Create binary target (severe vs not severe)
- severe_flag = 1 if Severity >= 3, else 0
- Easier to interpret ("doubles risk of severe accident")

Let's create both and compare insights.
```

---

## Task 5.2: Calculate Feature Correlations with Severity

### What You Want to Achieve
Find which features are most correlated with accident severity.

### The Vibe Coding Prompt

```
Calculate correlations between each feature and severity:

For each feature, calculate:
1. Pearson correlation with Severity
2. Spearman correlation with Severity
3. P-value (is it statistically significant?)

Create a summary table:
| Feature | Pearson r | Spearman r | P-value | Significant? |

Sort by absolute correlation strength (highest first).

Which features have the STRONGEST relationship with severity?
Which have NO relationship (not significant)?
```

### Interpreting Results
- **r > 0**: As feature increases, severity tends to increase
- **r < 0**: As feature increases, severity tends to decrease
- **|r| > 0.3**: Moderately strong relationship
- **p < 0.05**: Statistically significant (not random)

---

## Task 5.3: Analyze Weather Impact on Severity

### What You Want to Achieve
Deep dive into how weather conditions affect severity.

### The Vibe Coding Prompt

```
Analyze the relationship between weather and severity:

1. Temperature analysis:
   - Average severity at different temperature ranges
   - Create buckets: <32°F, 32-50°F, 50-70°F, 70-90°F, >90°F
   - Is there a clear pattern?

2. Precipitation analysis:
   - Average severity on dry vs rainy days
   - For rainy days, does more rain = more severe?
   - Snow vs rain comparison

3. Visibility analysis:
   - If visibility data exists, analyze low visibility impact
   - What visibility threshold matters most?

Create visualizations:
- Line chart: Average severity by temperature bucket
- Bar chart: Severity comparison (dry vs rain vs snow)

Save as visualizations/weather_impact_on_severity.png
```

### Business Translation

```
Convert the statistical findings to business language:

Instead of: "Correlation of -0.15 between temperature and severity"
Say: "Accidents in freezing conditions (<32°F) are 25% more likely to be severe"

Calculate the actual percentage differences for key comparisons.
```

---

## Task 5.4: Analyze Temporal Impact on Severity

### What You Want to Achieve
Understand how time-based factors affect severity.

### The Vibe Coding Prompt

```
Analyze temporal factors and severity:

1. Hour of day:
   - Average severity by hour
   - Which hours have highest severity? (hypothesis: night)
   - Rush hour vs non-rush hour comparison

2. Day of week:
   - Average severity by day
   - Weekend vs weekday comparison
   - Any surprising patterns?

3. Holiday analysis:
   - Severity on holidays vs non-holidays
   - Which specific holidays are most severe?

4. Seasonal analysis:
   - Severity by season
   - Does winter really have more severe accidents?

Create a dashboard-style visualization with 4 panels.
Save as visualizations/temporal_impact_on_severity.png
```

### Key Question to Answer
"When are the MOST DANGEROUS times to drive?"

Rank by severity:
1. Time of day
2. Day of week
3. Season
4. Holiday status

---

## Task 5.5: Create Risk Factor Summary

### What You Want to Achieve
Identify the top risk factors for severe accidents.

### The Vibe Coding Prompt

```
Create a ranked list of risk factors for severe accidents:

For each factor, calculate the "risk multiplier":
- Baseline: Overall severe accident rate
- Factor risk: Severe accident rate when this factor is present
- Risk multiplier: Factor risk / Baseline

Example:
- Baseline severe rate: 15%
- Severe rate during ice/snow: 25%
- Risk multiplier: 25/15 = 1.67x

Rank all factors by risk multiplier.

Create a horizontal bar chart:
- Factors on y-axis
- Risk multiplier on x-axis
- Reference line at 1.0 (baseline)
- Color: green for <1 (safer), red for >1 (more dangerous)

Save as visualizations/risk_factor_ranking.png
```

### Top Risk Factors to Analyze
- Extreme cold (<32°F)
- Snow on ground
- Night driving (10 PM - 5 AM)
- Holiday weekends
- Low visibility
- Rainy conditions

---

## Task 5.6: Handle Confounding Variables

### What You Want to Achieve
Check if apparent correlations are actually caused by something else.

### The Vibe Coding Prompt

```
Check for confounding in our key findings:

1. Night driving appears more severe. But:
   - Is night also when more drunk driving happens?
   - Is it just weekends at night that are severe?
   - Control for weekend status and recheck

2. Winter appears more severe. But:
   - Is it the cold, or the snow, or both?
   - Separate: cold+dry vs cold+snow vs warm+rain
   - Which specific condition drives severity?

3. Holiday severity:
   - Holidays overlap with vacation travel (more miles)
   - Holidays may have more impaired driving
   - Can we separate these effects?

Document which relationships are:
- Likely causal
- Potentially confounded
- Need more data to understand
```

---

## Task 5.7: Create Correlation Heatmap

### What You Want to Achieve
Visualize all correlations at once.

### The Vibe Coding Prompt

```
Create a correlation heatmap for all analysis variables:

Include:
- Severity (target)
- All weather variables
- All temporal flags
- Derived risk factors

Requirements:
- Blue-white-red color scale
- Values displayed in each cell
- Clustered to group related variables
- Title explaining what it shows

Point out:
- Which features are highly correlated with each other (potential redundancy)
- Which features are most correlated with severity
- Any surprising correlations

Save as visualizations/full_correlation_heatmap.png
```

---

## Task 5.8: Write Executive Summary

### What You Want to Achieve
Deliver actionable insights to the client.

### The Vibe Coding Prompt

```
Create an executive summary for the insurance company:

Structure:
1. Key Finding (one sentence answer to their question)

2. Top 5 Risk Factors (ranked by impact):
   For each:
   - The factor
   - The risk multiplier
   - Business implication
   - Data evidence

3. Recommendations:
   - Pricing adjustments to consider
   - Safety campaign targets
   - Further research needs

4. Methodology:
   - Data sources
   - Time period
   - Geographic coverage
   - Limitations

5. Visualization References

Save as findings/executive_summary.md
```

### Example Finding Format

```
### Finding 1: Night Driving is the Highest Risk Factor

**Risk Multiplier**: 1.8x (80% higher severe accident rate)

**Business Implication**: Drivers who primarily commute at night
should be rated 15-20% higher than daytime commuters.

**Evidence**: Accidents between 10 PM and 5 AM have 28% severity
rate vs 15% baseline. Correlation holds after controlling for
weekend effects (r = 0.21, p < 0.001).

**Recommendation**: Consider time-of-day as a rating factor for
commercial policies. Target safety messaging at night shift workers.
```

---

## Task 5.9: Create Client-Ready Deliverables

### What You Want to Achieve
Package everything for presentation.

### The Vibe Coding Prompt

```
Finalize all deliverables:

1. Data files:
   - data/processed/final_analysis_dataset.csv
   - data/processed/correlation_summary.csv
   - data/processed/risk_factor_rankings.csv

2. Visualizations (all in visualizations/):
   - weather_impact_on_severity.png
   - temporal_impact_on_severity.png
   - risk_factor_ranking.png
   - full_correlation_heatmap.png

3. Documentation:
   - findings/executive_summary.md
   - data/processed/feature_dictionary.md

Create a final checklist confirming all files exist.
```

---

## Deliverables Checklist

After completing this exercise, you should have:

- [ ] Correlation analysis for all features vs severity
- [ ] Weather impact analysis and visualization
- [ ] Temporal impact analysis and visualization
- [ ] Risk factor rankings with multipliers
- [ ] Confounding analysis documented
- [ ] `visualizations/weather_impact_on_severity.png`
- [ ] `visualizations/temporal_impact_on_severity.png`
- [ ] `visualizations/risk_factor_ranking.png`
- [ ] `visualizations/full_correlation_heatmap.png`
- [ ] `findings/executive_summary.md`
- [ ] `data/processed/final_analysis_dataset.csv`

---

## Key Vocabulary for Vibe Coding

When analyzing correlations and risk, these keywords help:

| What You Want | Keywords to Use |
|---------------|-----------------|
| Measure relationship | "correlation", "association", "relationship" |
| Compare groups | "vs", "comparison", "difference between" |
| Risk measurement | "risk multiplier", "odds ratio", "relative risk" |
| Control for confounders | "controlling for", "holding constant", "stratify by" |
| Statistical validity | "p-value", "significant", "confidence interval" |

---

## Common Issues and How to Fix Them

**If no correlations are significant:**
```
None of the p-values are below 0.05.
With large datasets, try focusing on effect SIZE not just significance.
A correlation of 0.1 might be significant with 1M rows but not meaningful.
Look for correlations > 0.1 regardless of p-value for this dataset size.
```

**If everything seems correlated:**
```
Multiple features are highly correlated with each other.
This is multicollinearity - they're measuring the same thing.
Pick one representative from each group (e.g., just use is_rush_hour, drop hour).
```

**If results seem counterintuitive:**
```
The data shows rainy days have LOWER severity.
This might be because:
- People drive more carefully in rain
- They don't drive as far
- Fewer accidents but not more severe
Check if this makes logical sense before reporting.
```

---

## Congratulations!

You've completed Lab 2! You now know how to:
- Profile and explore large accident datasets
- Integrate external weather data
- Use FIPS codes for geographic standardization
- Create temporal feature engineering
- Analyze correlations and identify risk factors
- Present findings for business decisions

**Next Step**: [Lab 3: Hospitality Demand](../../lab-03-hospitality-demand/README.md) will teach you calendar-based joins and cancellation analysis.

---

[← Previous: Temporal Features](./04_temporal_features.md) | [Lab 2 Home](../README.md)
