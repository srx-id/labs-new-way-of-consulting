# Exercise 4: 311 Complaint Taxonomy and Filtering

**[Lab 5 Home](../README.md) > Exercise 4**

## Overview

311 data has hundreds of complaint types, but we only care about **nuisance complaints** potentially related to taxi/traffic activity. This exercise teaches you to create a focused complaint taxonomy.

**Time**: 45-60 minutes

## The Question

> "Does high taxi volume in a borough correlate with more noise and traffic complaints?"

We need to filter 311 data to relevant complaint types:
- Noise (traffic, street, vehicles)
- Traffic conditions
- Street/sidewalk obstructions
- Illegal parking

---

## Task 4.1: Load and Profile 311 Data

### What You Want to Achieve
Understand the full scope of 311 complaints.

### The Vibe Coding Prompt

```
Load and profile NYC 311 complaint data:

1. Load the data (may need chunking if large)

2. Basic profile:
   - Total complaints
   - Date range
   - Columns available

3. Key columns:
   - Created Date (when complaint made)
   - Borough
   - Complaint Type (main category)
   - Descriptor (sub-category)

4. Complaint type overview:
   - How many unique Complaint Types?
   - Top 20 most common
   - Show counts

This gives us the universe to filter from.
```

### Expected Scale
```
NYC 311 data typically has:
- 20+ million complaints/year
- 200+ unique complaint types
- Many are NOT related to traffic/noise
```

---

## Task 4.2: Identify Traffic/Mobility Complaint Types

### What You Want to Achieve
Find complaint types related to taxi and traffic activity.

### The Vibe Coding Prompt

```
Search for traffic and mobility-related complaints:

1. Search complaint types containing:
   - "traffic"
   - "noise"
   - "vehicle"
   - "parking"
   - "street"
   - "congestion"

2. For each match, show:
   - Complaint Type
   - Count
   - Sample Descriptors

3. Identify relevant categories:
   - Noise - Street/Sidewalk
   - Noise - Commercial
   - Noise - Vehicle
   - Illegal Parking
   - Traffic Signal Condition
   - Blocked Driveway
   - Street Condition

4. Create initial "nuisance" list:
   - Complaint types likely related to taxi/traffic
   - Exclude unrelated (e.g., noise from construction)

Which complaint types should we include in our "nuisance" category?
```

---

## Task 4.3: Analyze Noise Complaints in Detail

### What You Want to Achieve
Deep dive into noise complaints - the most relevant category.

### The Vibe Coding Prompt

```
Analyze noise complaints specifically:

1. Filter to noise-related complaint types

2. Breakdown by Descriptor:
   - Loud Music/Party
   - Loud Talking
   - Car/Truck Horn
   - Car/Truck Music
   - Engine Idling
   - Traffic noise

3. Traffic-specific noise:
   - Which descriptors are vehicle/traffic related?
   - What % of noise complaints are traffic-related?

4. Time patterns:
   - When do traffic-noise complaints peak?
   - Night? Rush hour? Weekends?

This helps us define "traffic-related noise" precisely.
```

### Noise Categories
```
Relevant to taxi/traffic:
- Car/Truck Horn: Likely traffic-related
- Car/Truck Music: Possibly taxis or Ubers
- Engine Idling: Commercial vehicles

Less relevant:
- Loud Music/Party: Residential, not traffic
- Barking Dog: Not traffic
- Construction: Not traffic (except road work)
```

---

## Task 4.4: Create Nuisance Category Taxonomy

### What You Want to Achieve
Define the final set of "nuisance" complaints for analysis.

### The Vibe Coding Prompt

```
Create the official nuisance complaint taxonomy:

1. Define categories:

   Category: Traffic Noise
   - Complaint Types: "Noise - Street/Sidewalk", "Noise - Vehicle"
   - Descriptors: "Car/Truck Horn", "Car/Truck Music", "Engine Idling"

   Category: Illegal Parking
   - Complaint Types: "Illegal Parking"
   - Descriptors: All

   Category: Blocked Access
   - Complaint Types: "Blocked Driveway"
   - Descriptors: All

   Category: Traffic Issues
   - Complaint Types: "Traffic Signal Condition", "Street Condition"
   - Descriptors: Traffic-related only

2. Create filter criteria:
   - List of included Complaint Types
   - List of included Descriptors (if filtering at that level)

3. Apply filter:
   - How many complaints match our nuisance criteria?
   - What % of total 311 complaints?

4. Validate:
   - Sample 20 filtered complaints
   - Do they look traffic/taxi related?

Save taxonomy as data/processed/nuisance_taxonomy.csv
```

---

## Task 4.5: Aggregate Nuisance Complaints by Borough-Day

### What You Want to Achieve
Create aggregates that match taxi data grain.

### The Vibe Coding Prompt

```
Aggregate nuisance complaints to borough-day level:

1. Filter 311 to nuisance complaints only

2. Aggregate by borough + date:
   - total_nuisance_complaints: Count of all filtered complaints
   - traffic_noise_count: Traffic noise category
   - illegal_parking_count: Parking category
   - blocked_access_count: Blocked access category

3. Create time features:
   - rush_hour_complaints: 7-9 AM or 5-7 PM
   - night_complaints: 10 PM - 5 AM

4. Validate:
   - How many borough-days?
   - Average complaints per borough-day?
   - Borough with most complaints?

Save as data/processed/nuisance_borough_daily.csv
```

---

## Task 4.6: Explore Complaint Patterns

### What You Want to Achieve
Understand when and where nuisance complaints occur.

### The Vibe Coding Prompt

```
Analyze nuisance complaint patterns:

1. Time patterns:
   - Complaints by hour (when are they made?)
   - Complaints by day of week
   - Complaints by month (seasonal?)

2. Borough patterns:
   - Which borough has most nuisance complaints?
   - Normalize by population or area?
   - Complaint rate per capita

3. Complaint type patterns:
   - Which nuisance type is most common?
   - Does it vary by borough?

4. Visualizations:
   - Bar chart: Complaints by borough
   - Line chart: Monthly trends
   - Heatmap: Hour × Day of week

Save visualizations to visualizations/ folder
```

---

## Task 4.7: Compare with All 311 Complaints

### What You Want to Achieve
Validate that nuisance complaints behave differently.

### The Vibe Coding Prompt

```
Compare nuisance vs all 311 complaints:

1. Volume comparison:
   - Nuisance complaints: X per day average
   - All 311 complaints: Y per day average
   - Nuisance is Z% of total

2. Pattern comparison:
   - Do nuisance complaints have same time pattern?
   - Or different (more evening, more weekday)?

3. Borough comparison:
   - Nuisance concentrated in same boroughs as all complaints?
   - Or different distribution?

4. Hypothesis:
   - Nuisance complaints should peak during high-traffic times
   - All 311 complaints peak during daytime (reporting convenience)

Does the data support our hypothesis?
```

---

## Task 4.8: Prepare Complaints for Join with Taxi Data

### What You Want to Achieve
Final preparation for the correlation analysis.

### The Vibe Coding Prompt

```
Prepare nuisance complaints for joining with taxi data:

1. Verify grain matches taxi data:
   - Complaints: borough + date
   - Taxi: borough + date
   - ✓ Same grain

2. Verify borough names match:
   - Complaints boroughs: [list]
   - Taxi boroughs: [list]
   - Standardize if needed

3. Verify date range overlaps:
   - Complaints date range: [range]
   - Taxi date range: [range]
   - Overlapping period: [range]

4. Create join-ready file:
   - borough (standardized)
   - date
   - total_nuisance_complaints
   - traffic_noise_count
   - illegal_parking_count
   - [other metrics]

Save as data/processed/nuisance_for_join.csv
```

---

## Deliverables Checklist

After completing this exercise, you should have:

- [ ] 311 data profiled
- [ ] Traffic/mobility complaints identified
- [ ] Noise complaints analyzed in detail
- [ ] Nuisance taxonomy created
- [ ] Borough-day aggregates created
- [ ] Complaint patterns analyzed
- [ ] Comparison with all 311 completed
- [ ] `data/processed/nuisance_taxonomy.csv`
- [ ] `data/processed/nuisance_borough_daily.csv`
- [ ] `data/processed/nuisance_for_join.csv`
- [ ] Visualizations in visualizations/ folder

---

## Key Vocabulary for Vibe Coding

When creating complaint taxonomy, these keywords help:

| What You Want | Keywords to Use |
|---------------|-----------------|
| Find categories | "search for", "complaint types containing" |
| Filter data | "filter to", "include only", "where type in" |
| Create taxonomy | "category", "subcategory", "classification" |
| Validate selection | "sample", "spot check", "verify relevance" |

---

## Common Issues and How to Fix Them

**If too many complaint types match:**
```
100 different complaint types contain "noise".
Be more specific:
- Use exact matches for key types
- Filter by Descriptor to narrow down
- Focus on vehicle/traffic related only
```

**If counts seem low:**
```
Only 1000 nuisance complaints in a year for Manhattan?
Check:
- Did the filter work correctly?
- Are you filtering too aggressively?
- Try broader criteria and validate sample
```

**If categories overlap:**
```
Same complaint appears in multiple categories.
That's OK for raw data, but for aggregates:
- Either assign to primary category only
- Or allow double-counting but note it
```

---

## What's Next?

Now that you have filtered nuisance complaints, Exercise 5 will teach you how to **correlate taxi volume with complaint counts** and find the externality relationship.

---

[← Previous: Spatial Bucketing](./03_spatial_bucketing.md) | [Lab 5 Home](../README.md) | [Next: Externality Correlations →](./05_externality_correlations.md)
