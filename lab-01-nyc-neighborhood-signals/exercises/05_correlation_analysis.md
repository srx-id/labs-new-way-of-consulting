# Exercise 5: Correlation Analysis & Visualization

**[Lab 1 Home](../README.md) > Exercise 5**

## Overview

This is the payoff - where you answer the client's actual question! In this exercise, you'll learn how to **calculate correlations, create visualizations, and tell a story** with your data.

**Time**: 90-120 minutes

## The Client's Question

> "What neighborhood characteristics should we consider when pricing and selecting Airbnb investment properties?"

By the end of this exercise, you'll have:
- Correlation analysis showing which factors matter
- Client-ready visualizations
- An executive summary with actionable recommendations

---

## Task 5.1: Calculate Correlation Matrix

### What You Want to Achieve
Find which variables are related to price and review activity.

### The Vibe Coding Prompt

```
Load the final dataset from data/processed/final_dataset.csv

Calculate correlations between these key variables:
- avg_price (what we want to predict)
- median_reviews_per_month (proxy for demand)
- complaint_count
- crime_count
- avg_temp
- total_precip

Create two correlation matrices:
1. Pearson correlation (measures linear relationships)
2. Spearman correlation (measures monotonic relationships - more robust to outliers)

Show me both matrices and highlight:
- The strongest positive correlations
- The strongest negative correlations
- Any big differences between Pearson and Spearman

Save matrices to:
- data/processed/correlation_matrix_pearson.csv
- data/processed/correlation_matrix_spearman.csv
```

### Interpreting Correlations

| Correlation Value | Strength | Meaning |
|-------------------|----------|---------|
| 0.7 to 1.0 | Strong | Variables move together closely |
| 0.4 to 0.7 | Moderate | Clear relationship, but other factors matter |
| 0.1 to 0.4 | Weak | Some relationship, but not reliable |
| -0.1 to 0.1 | None | Variables not related |
| Negative | Inverse | When one goes up, the other goes down |

---

## Task 5.2: Check Statistical Significance

### What You Want to Achieve
Determine which correlations are real (not just random noise).

### The Vibe Coding Prompt

```
For each correlation pair, calculate the p-value.

A correlation is statistically significant if p < 0.05.

Create a table showing:
| Variable 1 | Variable 2 | Pearson r | P-value | Significant? | Strength |

Filter to only show significant correlations (p < 0.05).
Sort by correlation strength (highest absolute value first).

Which relationships can we trust?
Which might just be noise?
```

### Understanding P-Values

- **p < 0.01**: Very confident this is real
- **p < 0.05**: Reasonably confident
- **p > 0.05**: Might be random chance - don't trust it

---

## Task 5.3: Create the Correlation Heatmap

### What You Want to Achieve
A visual showing all correlations at a glance.

### The Vibe Coding Prompt

```
Create a professional correlation heatmap visualization.

Requirements:
1. Side-by-side comparison: Pearson on left, Spearman on right
2. Color scale: Blue for negative, white for zero, red for positive
3. Show correlation values inside each cell
4. Clean, readable labels (no underscores or code names)
5. Title that explains what the chart shows

Make it presentation-ready:
- High resolution (300 DPI)
- Professional color scheme
- Clear legend

Save as visualizations/correlation_heatmap.png
```

### What the Client Wants to See
The heatmap answers: "Which metrics move together?"
- Strong red squares = these increase together
- Strong blue squares = when one goes up, the other goes down

---

## Task 5.4: Create Price vs. Crime Scatter Plot

### What You Want to Achieve
A visual showing the relationship between crime and pricing.

### The Vibe Coding Prompt

```
Create a scatter plot showing how crime relates to Airbnb prices.

Requirements:
1. X-axis: crime_count (number of crime incidents)
2. Y-axis: avg_price (average nightly price)
3. Color each point by borough (5 different colors)
4. Add a trend line showing the overall direction
5. Include the correlation coefficient in the title

The title should be an INSIGHT, not just a description.
Bad: "Crime vs Price Scatter Plot"
Good: "Higher Crime Areas Show 15% Lower Prices (r = -0.52)"

Add an annotation box with the business implication:
"Every X additional crimes/month associated with $Y lower price"

Save as visualizations/price_vs_crime_scatter.png
```

### Business Translation
Don't just show the correlation - translate it to dollars:
- "Every 100 additional crimes per month = $X lower nightly rate"
- "Low-crime neighborhoods command a X% premium"

---

## Task 5.5: Create Seasonality Chart

### What You Want to Achieve
Show how demand patterns change throughout the year.

### The Vibe Coding Prompt

```
Create a line chart showing seasonal patterns across 2019.

Plot these metrics across 12 months:
1. Average price (primary Y-axis)
2. Average reviews per month (secondary Y-axis)
3. Temperature (background reference)

Highlight the "peak season" (June-August) with a shaded region.

Title should reveal the insight:
"Summer Demand Drives 20% Higher Review Activity in NYC"

Add annotations for:
- Peak month
- Lowest month
- The price vs. demand relationship

Save as visualizations/seasonality_trends.png
```

### What This Tells the Client
- When to expect highest demand
- How to adjust pricing by season
- Weather's influence on booking patterns

---

## Task 5.6: Create Borough Comparison Chart

### What You Want to Achieve
Compare metrics across the 5 NYC boroughs.

### The Vibe Coding Prompt

```
Create a multi-panel comparison of boroughs.

For each borough, show:
- Average price (bar chart)
- Average crime count (bar chart)
- Average complaint count (bar chart)
- Average reviews per month (bar chart)

Use small multiples (2x2 grid) or a grouped bar chart.

Rank boroughs by price and show whether higher-priced boroughs
have more or fewer quality-of-life issues.

Title: "Manhattan Commands 2x Premium Despite Higher Complaint Volume"

Save as visualizations/borough_comparison.png
```

### Key Insight
The client wants to know: "Which boroughs are best for investment?"
- High price + low crime = premium market
- Low price + high crime = value play (more risk)

---

## Task 5.7: Write the Executive Summary

### What You Want to Achieve
A 1-page brief that answers the client's question with recommendations.

### The Vibe Coding Prompt

```
Create an executive summary for the client.

Structure:
1. Executive Summary (3 sentences max)
   - What's the #1 finding?
   - What's the business implication?
   - What should they do?

2. Key Findings (3-4 bullets)
   For each finding:
   - The correlation (with number)
   - Business translation (in dollars or percentages)
   - Recommended action
   - Supporting chart reference

3. Recommendations (4-5 specific actions)
   - What neighborhoods to target
   - How to price based on our findings
   - Seasonal strategy
   - Risk factors to monitor

4. Methodology Note
   - Data sources used
   - Time period (2019)
   - Key limitations

5. Appendix Reference
   - List of visualizations
   - Data files created

Save as findings/executive_summary.md
```

### Example Finding Format

```
### Finding 1: Crime Significantly Impacts Pricing Power

**Correlation**: Strong negative (r = -0.52, p < 0.01)

**Business Translation**: Neighborhoods with 100 fewer monthly
crime incidents command $12 higher nightly rates on average.

**Recommendation**: Prioritize investments in neighborhoods with
crime counts below the citywide median for premium positioning.

**Evidence**: See visualizations/price_vs_crime_scatter.png
```

---

## Task 5.8: Create Insights Summary Table

### What You Want to Achieve
A client-friendly table summarizing all findings.

### The Vibe Coding Prompt

```
Create a summary table of key correlations for the client.

Columns:
- Relationship (e.g., "Price vs Crime")
- Correlation (e.g., "-0.52")
- Strength (Strong/Moderate/Weak)
- Significance (Yes/No)
- Business Implication (plain English)
- Action (what to do about it)

Only include statistically significant relationships.
Sort by importance to pricing decisions.

Save as data/processed/correlation_insights.csv
```

---

## Deliverables Checklist

After completing this exercise, you should have:

- [ ] `data/processed/correlation_matrix_pearson.csv`
- [ ] `data/processed/correlation_matrix_spearman.csv`
- [ ] `data/processed/correlation_insights.csv`
- [ ] `visualizations/correlation_heatmap.png`
- [ ] `visualizations/price_vs_crime_scatter.png`
- [ ] `visualizations/seasonality_trends.png`
- [ ] `visualizations/borough_comparison.png`
- [ ] `findings/executive_summary.md`

---

## Key Vocabulary for Vibe Coding

When doing correlation analysis, these keywords help:

| What You Want | Keywords to Use |
|---------------|-----------------|
| Measure relationship | "correlation", "relationship between", "how X affects Y" |
| Linear relationship | "Pearson correlation" |
| Ranked relationship | "Spearman correlation" (robust to outliers) |
| Check if real | "p-value", "statistical significance", "confidence" |
| Visual matrix | "heatmap", "correlation matrix visualization" |
| Show relationship | "scatter plot", "trend line", "regression line" |
| Over time | "line chart", "time series", "seasonality" |
| Compare groups | "bar chart", "grouped bars", "small multiples" |

---

## Common Issues and How to Fix Them

**If correlations seem too weak:**
```
The correlations are weaker than expected.
Show me the scatter plots to visually inspect the relationships.
Are there outliers that might be affecting the correlation?
Try removing extreme values and recalculating.
```

**If Pearson and Spearman differ a lot:**
```
Pearson shows 0.3 but Spearman shows 0.6.
This suggests the relationship is non-linear or has outliers.
Show me a scatter plot to understand the pattern.
Which correlation should we report to the client?
```

**If p-values are all high (not significant):**
```
None of my correlations are statistically significant.
This might be because we only have 60 data points.
Should we use a different time grain (weekly instead of monthly)?
Or acknowledge the limitation in our executive summary?
```

**If charts don't look professional:**
```
The chart looks too cluttered.
Remove gridlines, simplify colors, increase font size.
Make sure the title tells the insight, not just describes the chart.
```

---

## The "So What" Test

Before submitting, check every finding against this test:

1. **So what?** → Why does this matter to the client?
2. **Now what?** → What should they do differently?
3. **How much?** → Quantify the impact in dollars or percentages

If you can't answer all three, the finding isn't ready.

---

## Congratulations!

You've completed Lab 1! You now know how to:
- Explore and profile datasets
- Standardize geographic data
- Aggregate to consistent time grains
- Join multiple datasets
- Calculate and interpret correlations
- Create client-ready visualizations
- Write executive summaries

**Next Step**: [Lab 2: US Safety Drivers](../../lab-02-us-safety-drivers/README.md) will teach you how to work with time-based analysis and feature engineering.

---

[← Previous: Dataset Joining](./04_dataset_joining.md) | [Lab 1 Home](../README.md)
