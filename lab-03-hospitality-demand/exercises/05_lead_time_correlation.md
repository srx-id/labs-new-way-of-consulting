# Exercise 5: Lead Time Correlation Analysis

**[Lab 3 Home](../README.md) > Exercise 5**

## Overview

This is the capstone exercise where you bring everything together. You'll analyze how **lead time interacts with all other factors** to predict cancellation risk and deliver actionable insights.

**Time**: 90-120 minutes

## The Final Question

> "How can we predict which bookings will cancel, and what should we do about it?"

Your deliverable: A complete cancellation risk analysis with business recommendations.

---

## Task 5.1: Build the Final Analysis Dataset

### What You Want to Achieve
Combine all features into one analysis-ready dataset.

### The Vibe Coding Prompt

```
Create the final analysis dataset:

1. Load the enriched booking data with:
   - Holiday features (from Exercise 3)
   - Seasonality features (from Exercise 4)

2. Ensure these columns are included:
   - Target: is_canceled
   - Lead time: lead_time
   - Guest features: is_repeated_guest, previous_cancellations
   - Booking features: deposit_type, market_segment, distribution_channel
   - Stay features: total_nights, weekend_ratio
   - Seasonal features: is_peak, is_summer, arrival_month
   - Holiday features: is_holiday_arrival
   - Revenue: adr

3. Check for missing values:
   - Which columns have nulls?
   - How should we handle them?

4. Verify dataset ready for analysis:
   - How many bookings total?
   - What's the overall cancellation rate?

Save as data/processed/final_analysis_dataset.csv
```

---

## Task 5.2: Calculate Correlation Matrix

### What You Want to Achieve
Find which features most strongly predict cancellation.

### The Vibe Coding Prompt

```
Calculate correlations between all features and is_canceled:

1. Convert categorical variables to numeric:
   - Deposit type: one-hot encode or ordinal
   - Market segment: one-hot encode
   - Boolean flags are already 0/1

2. Calculate Pearson and Spearman correlations:
   - Each numeric feature vs is_canceled
   - Include p-values for significance

3. Create correlation ranking:
   | Feature | Pearson r | Spearman r | P-value | Significant? |
   Sort by absolute correlation strength

4. Key findings:
   - Top 5 positive predictors (increase cancellation)
   - Top 5 negative predictors (decrease cancellation)

What predicts cancellation most strongly?
```

---

## Task 5.3: Deep Dive into Lead Time Effect

### What You Want to Achieve
Thoroughly analyze lead time as a predictor.

### The Vibe Coding Prompt

```
Analyze lead time's relationship with cancellation:

1. Overall correlation:
   - Pearson correlation with is_canceled
   - Is it statistically significant?

2. Non-linear relationship:
   - Create lead time buckets (0-7, 8-30, 31-60, 61-90, 91-120, 121-180, 180+)
   - Cancellation rate for each bucket
   - Plot the curve - is it linear or does it accelerate?

3. Threshold analysis:
   - At what lead time does cancellation rate exceed 50%?
   - Is there a "danger zone" lead time?

4. Business quantification:
   - For every 30 days of additional lead time, how much does risk increase?
   - Translate to $ impact (lost revenue)

Create visualization showing cancellation rate curve by lead time.
Save as visualizations/lead_time_cancellation_curve.png
```

---

## Task 5.4: Analyze Interactions with Lead Time

### What You Want to Achieve
Find how other factors modify the lead time effect.

### The Vibe Coding Prompt

```
Analyze lead time interactions:

1. Lead Time × Deposit Type:
   - Plot cancellation curve for each deposit type
   - Does deposit requirement reduce the lead time effect?
   - Quantify: "Deposits reduce cancellation risk by X% for long lead time"

2. Lead Time × Market Segment:
   - Which segments have steepest lead time curves?
   - Are some segments immune to lead time effect?

3. Lead Time × Season:
   - Peak season vs off-season lead time patterns
   - Do summer bookings made far in advance cancel more?

4. Lead Time × Repeat Guest:
   - Do repeat guests have flatter curves?
   - Trust factor in loyal customers?

Create multi-panel visualization showing key interactions.
Save as visualizations/lead_time_interactions.png
```

### Interaction Effect
```
An interaction exists when:
The effect of lead time on cancellation
DEPENDS on another variable (like deposit type)

Example: Long lead time + No deposit = 70% cancel
         Long lead time + Non-refundable = 20% cancel
         That's a strong interaction!
```

---

## Task 5.5: Build Cancellation Risk Scores

### What You Want to Achieve
Create a simple scoring system for booking risk.

### The Vibe Coding Prompt

```
Create a cancellation risk scoring system:

1. Select top predictors (based on correlations):
   - lead_time
   - deposit_type
   - is_repeated_guest
   - market_segment
   - [others with significant correlation]

2. Create risk points:
   - Lead time 0-30: 0 points
   - Lead time 31-60: +1 point
   - Lead time 61-120: +2 points
   - Lead time 120+: +3 points
   - No deposit: +2 points
   - First-time guest: +1 point
   - Online TA: +1 point
   - [etc.]

3. Calculate total risk score for each booking

4. Validate the score:
   - Average cancellation rate by risk score
   - Does higher score = higher cancellation?
   - Create risk tiers: Low (0-2), Medium (3-4), High (5+)

Create visualization of cancellation rate by risk score.
Save as visualizations/risk_score_validation.png
```

---

## Task 5.6: Create Segment-Level Recommendations

### What You Want to Achieve
Develop specific strategies for each customer segment.

### The Vibe Coding Prompt

```
Create segment-specific recommendations:

For each major market segment, analyze:
1. Cancellation rate
2. Average lead time
3. Deposit type distribution
4. ADR (revenue value)
5. Repeat guest percentage

Then recommend for each segment:
- Deposit policy
- Confirmation email timing
- Overbooking strategy
- VIP treatment thresholds

Format as a strategy table:
| Segment | Cancel Rate | Strategy | Expected Impact |

Save as findings/segment_strategies.md
```

---

## Task 5.7: Calculate Business Impact

### What You Want to Achieve
Translate statistical findings into dollar impact.

### The Vibe Coding Prompt

```
Calculate the business impact of cancellations:

1. Revenue at risk:
   - Average ADR × Average stay × Cancelled bookings
   - Total revenue lost to cancellations

2. Recoverable revenue:
   - If we reduce cancellations by 10%, 20%, 30%
   - What's the revenue gain?

3. Overbooking analysis:
   - Current cancellation rate allows X% overbooking
   - What's the optimal overbooking level?
   - Risk of overbooking (walking guests)

4. Deposit impact:
   - If we required deposits for high-risk bookings
   - Expected reduction in cancellations
   - Potential reduction in bookings (trade-off)

Create a summary of financial impact and recommendations.
```

---

## Task 5.8: Create Executive Summary

### What You Want to Achieve
Deliver final insights to the revenue manager.

### The Vibe Coding Prompt

```
Create an executive summary for hotel revenue management:

Structure:

1. Executive Summary (3 sentences):
   - Main finding
   - Business impact
   - Recommended action

2. Key Findings (5 bullet points):
   - Lead time is the #1 predictor (with numbers)
   - Deposit effect (with numbers)
   - Segment differences
   - Seasonal patterns
   - Repeat guest value

3. Risk Scoring Model:
   - Simple explanation of scoring
   - How to use it operationally
   - Expected improvement

4. Recommendations:
   - Deposit policy changes
   - Confirmation timing
   - Overbooking guidelines
   - Segment-specific strategies

5. Financial Impact:
   - Current cancellation cost
   - Expected savings from recommendations
   - ROI of implementing changes

6. Next Steps:
   - What additional data would help?
   - Monitoring recommendations
   - Success metrics

Save as findings/executive_summary.md
```

---

## Task 5.9: Create Final Deliverables

### What You Want to Achieve
Package everything for the client.

### The Vibe Coding Prompt

```
Finalize all deliverables:

1. Data files (in data/processed/):
   - final_analysis_dataset.csv
   - risk_score_lookup.csv
   - segment_recommendations.csv

2. Visualizations (in visualizations/):
   - lead_time_cancellation_curve.png
   - lead_time_interactions.png
   - risk_score_validation.png
   - [Add correlation heatmap]
   - [Add segment comparison chart]

3. Findings (in findings/):
   - executive_summary.md
   - segment_strategies.md
   - [Add technical appendix if needed]

Create a final checklist confirming all files are complete.
```

---

## Deliverables Checklist

After completing this exercise, you should have:

- [ ] Final analysis dataset with all features
- [ ] Correlation matrix and feature rankings
- [ ] Lead time analysis with threshold identification
- [ ] Interaction effects analyzed
- [ ] Risk scoring system created and validated
- [ ] Segment strategies documented
- [ ] Business impact quantified
- [ ] `visualizations/lead_time_cancellation_curve.png`
- [ ] `visualizations/lead_time_interactions.png`
- [ ] `visualizations/risk_score_validation.png`
- [ ] `data/processed/final_analysis_dataset.csv`
- [ ] `findings/executive_summary.md`
- [ ] `findings/segment_strategies.md`

---

## Key Vocabulary for Vibe Coding

When doing final correlation analysis, these keywords help:

| What You Want | Keywords to Use |
|---------------|-----------------|
| Prediction strength | "correlation", "predictive power", "explains" |
| Interactions | "interaction effect", "depends on", "moderated by" |
| Risk scoring | "risk points", "scoring model", "risk tier" |
| Business impact | "revenue at risk", "dollar impact", "ROI" |
| Recommendations | "strategy", "policy", "action item" |

---

## Common Issues and How to Fix Them

**If correlations are all weak:**
```
All correlations are below 0.2.
For binary outcomes (cancelled yes/no), try:
- Point-biserial correlation
- Compare mean lead time for cancelled vs not
- Look at odds ratios instead of correlations
```

**If risk score doesn't validate:**
```
Higher risk scores don't show higher cancellation rates.
The scoring weights might be wrong.
Try:
- Using actual cancellation rates to weight factors
- Logistic regression coefficients as weights
- Simpler model with fewer factors
```

**If segments are too small:**
```
Some segments have only 50 bookings.
Combine similar segments for analysis.
Or note that findings for small segments are less reliable.
```

---

## Congratulations!

You've completed Lab 3! You now know how to:
- Analyze hotel booking patterns
- Identify cancellation drivers
- Join calendar/holiday data
- Create seasonal features
- Analyze lead time correlations
- Build risk scoring models
- Quantify business impact
- Deliver executive recommendations

**Next Step**: [Lab 4: Streaming Catalog](../../lab-04-streaming-catalog/README.md) will teach you fuzzy matching for entity resolution.

---

[← Previous: Seasonality Features](./04_seasonality_features.md) | [Lab 3 Home](../README.md)
