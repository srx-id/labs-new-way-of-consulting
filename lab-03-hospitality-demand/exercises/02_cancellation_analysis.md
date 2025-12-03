# Exercise 2: Cancellation Driver Analysis

**[Lab 3 Home](../README.md) > Exercise 2**

## Overview

Cancellations hurt hotel revenue. In this exercise, you'll deep-dive into **what factors predict whether a booking will be cancelled** - the foundation for building a cancellation prediction model.

**Time**: 45-60 minutes

## The Business Problem

> "We're losing revenue to cancellations. What types of bookings are most likely to cancel, and what can we do about it?"

Understanding cancellation drivers helps with:
- Overbooking strategy (how many rooms to overbook)
- Deposit policy optimization
- Targeted confirmation campaigns
- Segment-specific strategies

---

## Task 2.1: Calculate Cancellation Rates by Segment

### What You Want to Achieve
Find which customer segments have the highest cancellation rates.

### The Vibe Coding Prompt

```
Calculate cancellation rates for different segments:

1. By Market Segment:
   - Cancellation rate for each segment
   - Rank from highest to lowest
   - Which segment is most/least reliable?

2. By Distribution Channel:
   - Cancellation rate per channel
   - Direct bookings vs Online TA vs Corporate

3. By Customer Type:
   - Transient vs Contract vs Group
   - Which type cancels most?

4. By Hotel Type:
   - City Hotel cancellation rate
   - Resort Hotel cancellation rate

Create a comparison visualization showing all dimensions.
Save as visualizations/cancellation_rates_by_segment.png
```

### Key Insight
Online Travel Agencies (OTAs) often have higher cancellation rates because:
- Free cancellation policies
- Comparison shopping behavior
- Less commitment than direct bookings

---

## Task 2.2: Analyze Lead Time vs Cancellation

### What You Want to Achieve
Prove that longer lead times correlate with higher cancellation probability.

### The Vibe Coding Prompt

```
Analyze the relationship between lead time and cancellation:

1. Compare distributions:
   - Average lead time for cancelled vs not-cancelled bookings
   - Is the difference significant?

2. Cancellation rate by lead time bucket:
   - Last minute (0-7 days)
   - Short (8-30 days)
   - Medium (31-90 days)
   - Long (91-180 days)
   - Very long (180+ days)

3. Trend analysis:
   - Create bins every 30 days
   - Plot cancellation rate vs lead time
   - Is there a threshold where risk jumps?

4. Calculate correlation:
   - Pearson correlation between lead time and is_canceled
   - Is it statistically significant?

Create a line chart showing cancellation rate by lead time (30-day bins).
Mark the "danger zone" where cancellation rate exceeds 50%.
Save as visualizations/cancellation_vs_lead_time.png
```

### Business Application
```
If bookings with >120 days lead time have 50% cancellation rate,
the hotel should:
- Require deposits for long lead time bookings
- Send confirmation reminders
- Plan for overbooking
```

---

## Task 2.3: Analyze Deposit Type Impact

### What You Want to Achieve
Determine if requiring deposits reduces cancellations.

### The Vibe Coding Prompt

```
Analyze the relationship between deposit type and cancellation:

1. Deposit type breakdown:
   - What deposit types exist? (No Deposit, Non Refund, Refundable)
   - How many bookings in each category?

2. Cancellation rate by deposit type:
   - Which deposit type has lowest cancellation rate?
   - Quantify the difference

3. Combined analysis:
   - Deposit type x Market Segment
   - Deposit type x Lead Time bucket
   - Does deposit impact vary by segment?

Create a bar chart comparing cancellation rates by deposit type.
Add annotation showing the "deposit effect" (% reduction in cancellations).
Save as visualizations/cancellation_by_deposit.png
```

### Expected Finding
Non-refundable deposits should dramatically reduce cancellations. But:
- They might also reduce bookings
- Trade-off between flexibility and reliability

---

## Task 2.4: Analyze Repeat Guest Behavior

### What You Want to Achieve
Check if repeat guests are more reliable (lower cancellation rate).

### The Vibe Coding Prompt

```
Analyze repeat guest patterns:

1. Repeat guest breakdown:
   - How many repeat guests vs first-time?
   - What percentage are repeat customers?

2. Cancellation comparison:
   - Cancellation rate for repeat vs first-time guests
   - How much lower is the repeat guest cancellation rate?

3. Previous cancellation history:
   - Look at previous_cancellations column
   - Do guests with past cancellations cancel more often?
   - Is it predictive of future cancellation?

4. Previous bookings not canceled:
   - Guests with good history (previous_bookings_not_canceled > 0)
   - Are they more reliable?

Create a visualization comparing first-time vs repeat guest cancellation rates.
Save as visualizations/repeat_guest_cancellation.png
```

### Customer Loyalty Insight
```
If repeat guests cancel 50% less often:
- Invest in loyalty programs
- Give repeat guests better cancellation terms
- Track and reward consistent bookers
```

---

## Task 2.5: Analyze Special Requests and Modifications

### What You Want to Achieve
Check if "engaged" customers (who make requests) are less likely to cancel.

### The Vibe Coding Prompt

```
Analyze booking engagement indicators:

1. Special Requests:
   - Distribution of total_of_special_requests
   - Cancellation rate by number of requests
   - Do engaged guests cancel less?

2. Booking Changes:
   - Look at booking_changes column
   - Do guests who modify bookings cancel less?
   - Or does modification signal potential cancellation?

3. Required Parking:
   - Do guests requesting parking cancel less?
   - (Parking = more commitment to arriving)

4. Combined "engagement score":
   - Special requests + booking changes + parking
   - Does higher engagement = lower cancellation?

Create a chart showing cancellation rate by number of special requests.
Save as visualizations/engagement_vs_cancellation.png
```

### Hypothesis Testing
```
Intuition says: More special requests = more invested = lower cancellation
Let's test if the data supports this.
```

---

## Task 2.6: Create Cancellation Risk Profile

### What You Want to Achieve
Build a profile of "high risk" vs "low risk" bookings.

### The Vibe Coding Prompt

```
Create cancellation risk profiles:

1. High Risk Profile:
   - What combination of factors predicts high cancellation?
   - Example: Online TA + No Deposit + Long Lead Time + First-time guest
   - Calculate cancellation rate for this profile

2. Low Risk Profile:
   - What combination predicts reliable bookings?
   - Example: Direct + Non-refundable + Short Lead Time + Repeat guest
   - Calculate cancellation rate for this profile

3. Risk Multipliers:
   - For each factor, calculate how much it increases/decreases risk
   - Rank factors by impact

4. Create risk segments:
   - Low risk: <20% cancellation probability
   - Medium risk: 20-40%
   - High risk: >40%
   - How many bookings in each?

Create a summary table of risk factors and their impact.
Save as data/processed/cancellation_risk_factors.csv
```

### Risk Factor Ranking Example
| Factor | Risk Multiplier | Impact |
|--------|----------------|--------|
| No Deposit | 2.5x | Highest |
| Lead Time >120 days | 2.0x | High |
| Online TA | 1.8x | High |
| First-time guest | 1.3x | Medium |

---

## Task 2.7: Create Actionable Recommendations

### What You Want to Achieve
Translate analysis into business recommendations.

### The Vibe Coding Prompt

```
Create recommendations based on cancellation analysis:

For each high-risk segment, suggest an intervention:

1. Online TA + No Deposit:
   - What's the cancellation rate?
   - Recommended action?
   - Expected improvement?

2. Long Lead Time bookings:
   - What lead time threshold is critical?
   - What policy should apply?
   - Expected improvement?

3. First-time guests:
   - How to improve their reliability?
   - Engagement strategies?
   - Expected improvement?

4. Overall overbooking recommendation:
   - Based on historical cancellation rates by segment
   - What overbooking % is safe?
   - By hotel type

Create summary document with recommendations.
Save as findings/cancellation_recommendations.md
```

---

## Deliverables Checklist

After completing this exercise, you should have:

- [ ] Cancellation rates calculated by all key segments
- [ ] Lead time vs cancellation relationship quantified
- [ ] Deposit type impact analyzed
- [ ] Repeat guest loyalty effect measured
- [ ] `visualizations/cancellation_rates_by_segment.png`
- [ ] `visualizations/cancellation_vs_lead_time.png`
- [ ] `visualizations/cancellation_by_deposit.png`
- [ ] `visualizations/repeat_guest_cancellation.png`
- [ ] `visualizations/engagement_vs_cancellation.png`
- [ ] `data/processed/cancellation_risk_factors.csv`
- [ ] `findings/cancellation_recommendations.md`

---

## Key Vocabulary for Vibe Coding

When analyzing cancellation drivers, these keywords help:

| What You Want | Keywords to Use |
|---------------|-----------------|
| Segment comparison | "cancellation rate by", "group by and calculate" |
| Risk factors | "risk multiplier", "relative risk", "probability" |
| Relationship | "correlation between", "impact of X on Y" |
| Thresholds | "cutoff", "where rate exceeds", "danger zone" |

---

## Common Issues and How to Fix Them

**If cancellation rates seem too high:**
```
The overall cancellation rate is 65%.
This seems high - verify by checking:
- Is the is_canceled column correct (1=cancelled)?
- Are there data quality issues?
- Is this a booking platform with free cancellation?
```

**If deposit analysis seems off:**
```
Non-refundable deposits have HIGHER cancellation rate?
This might be because:
- Non-refundable bookings might show as "cancelled" when guest is a no-show
- Check how cancellation vs no-show is coded
- Verify the deposit type definitions
```

---

## What's Next?

Now that you understand cancellation drivers, Exercise 3 will teach you how to **join holiday calendar data** to analyze holiday impact on bookings and cancellations.

---

[← Previous: Booking Patterns](./01_booking_pattern_analysis.md) | [Lab 3 Home](../README.md) | [Next: Holiday Impact →](./03_holiday_impact.md)
