# Exercise 3: Spatial Bucketing and Borough Mapping

**[Lab 5 Home](../README.md) > Exercise 3**

## Overview

Taxi data uses "Location IDs" - numeric zone codes. To correlate with 311 complaints (which use borough names), you need to **map zones to boroughs**.

**Time**: 45-60 minutes

## The Mapping Challenge

Taxi data: `PULocationID = 161`
311 data: `Borough = "Manhattan"`

You need: Zone 161 → Manhattan (Midtown Center)

---

## Task 3.1: Load and Explore Taxi Zone Lookup

### What You Want to Achieve
Understand the taxi zone reference table.

### The Vibe Coding Prompt

```
Load the taxi zone lookup table:

1. Find and load the file:
   - taxi_zone_lookup.csv or similar
   - May be in data/raw/ or a reference folder

2. Explore the structure:
   - How many zones total?
   - What columns exist?
   - Sample of 10 rows

3. Key columns:
   - LocationID: The numeric ID used in trip data
   - Borough: Manhattan, Brooklyn, Queens, Bronx, Staten Island
   - Zone: Specific neighborhood name

4. Special cases:
   - Are there zones outside NYC?
   - Unknown or null zones?
   - Airport zones?

Show the full list of boroughs and zone counts per borough.
```

### Expected Structure
```
LocationID | Borough    | Zone                | service_zone
-----------|------------|---------------------|-------------
1          | EWR        | Newark Airport      | EWR
2          | Queens     | Jamaica Bay         | Boro Zone
...        | ...        | ...                 | ...
161        | Manhattan  | Midtown Center      | Yellow Zone
```

---

## Task 3.2: Analyze Location ID Distribution

### What You Want to Achieve
See which zones have the most taxi activity.

### The Vibe Coding Prompt

```
Analyze LocationID distribution in taxi data:

1. Load a sample of taxi trips (1M rows)

2. Count trips by PULocationID (pickup):
   - Top 20 pickup zones
   - Bottom 20 (least activity)

3. Count trips by DOLocationID (dropoff):
   - Top 20 dropoff zones
   - Any difference from pickups?

4. Identify problem zones:
   - LocationID = 264, 265 are "Unknown"
   - How many trips have unknown pickup/dropoff?
   - What % of data?

Create bar chart of top 20 pickup zones.
Save as visualizations/top_pickup_zones.png
```

---

## Task 3.3: Create Borough Mapping

### What You Want to Achieve
Map each LocationID to its borough.

### The Vibe Coding Prompt

```
Create LocationID → Borough mapping:

1. From taxi zone lookup, create simple mapping:
   - Dictionary: {LocationID: Borough}
   - Handle all 265 zones

2. Special handling:
   - EWR (Newark Airport) → Mark as "Outside NYC"
   - Unknown zones (264, 265) → Mark as "Unknown"
   - Any other non-NYC zones?

3. Apply to taxi sample:
   - Add pickup_borough column
   - Add dropoff_borough column

4. Validate:
   - All trips now have borough assigned?
   - Distribution matches expectations?
   - Manhattan should dominate

Show borough distribution after mapping.
```

---

## Task 3.4: Handle Multi-Borough Trips

### What You Want to Achieve
Decide how to handle trips spanning boroughs.

### The Vibe Coding Prompt

```
Analyze cross-borough trips:

1. Create trip type categories:
   - Same borough (pickup = dropoff borough)
   - Cross-borough (different boroughs)
   - Airport trips (EWR, JFK, LGA involved)
   - Unknown (either end unknown)

2. Distribution:
   - What % are same-borough?
   - What % cross-borough?
   - What % involve airports?

3. For our analysis:
   - Use pickup_borough for aggregation (where trip started)
   - Or should we count both ends?

4. Decision:
   - Recommend approach for borough-level aggregation
   - Document reasoning

Pickup borough is typically used for "demand" analysis.
```

---

## Task 3.5: Aggregate by Borough

### What You Want to Achieve
Create clean borough-level aggregates.

### The Vibe Coding Prompt

```
Create final borough aggregation:

1. Filter out non-NYC:
   - Remove EWR zone trips
   - Remove Unknown zone trips
   - Document how many removed

2. Aggregate by borough + date:
   - Trip count
   - Average fare
   - Total distance
   - Rush hour trips

3. Verify 5 boroughs:
   - Manhattan
   - Brooklyn
   - Queens
   - Bronx
   - Staten Island

4. Borough comparison:
   - Rank by trip volume
   - Average trips per day per borough
   - % distribution

Save as data/processed/taxi_borough_daily.csv
```

---

## Task 3.6: Analyze Spatial Patterns

### What You Want to Achieve
Understand geographic patterns in taxi usage.

### The Vibe Coding Prompt

```
Analyze spatial patterns:

1. Borough rankings:
   - By trip volume
   - By average fare
   - By average distance

2. Inter-borough flow:
   - Most common pickup-dropoff borough pairs
   - Manhattan → Brooklyn common?
   - Create flow matrix

3. Time-of-day by borough:
   - Rush hour % by borough
   - Night trips % by borough
   - Different patterns?

4. Visualizations:
   - Borough bar chart (volume)
   - Heatmap of borough-to-borough flows

Save as visualizations/spatial_patterns.png
```

### Expected Findings
```
Manhattan: Highest volume, short trips, high fare/mile
Brooklyn: Growing, longer trips to Manhattan
Queens: Airport traffic significant
Bronx: Lowest volume in core boroughs
Staten Island: Minimal taxi activity
```

---

## Task 3.7: Create Zone-Level Analysis (Optional)

### What You Want to Achieve
More granular spatial analysis at zone level.

### The Vibe Coding Prompt

```
Create zone-level analysis for deeper insights:

1. Top zones by borough:
   - Top 5 zones in Manhattan
   - Top 5 zones in Brooklyn
   - etc.

2. Zone characteristics:
   - Business districts (high weekday volume)
   - Residential areas (evening/weekend volume)
   - Entertainment districts (night activity)

3. Zone anomalies:
   - Zones with unusual patterns
   - Airport zones (JFK, LGA)
   - Special locations (stadiums, etc.)

4. Create zone profile table:
   | Zone | Borough | Avg Daily Trips | Peak Hour | Type |

Save as data/processed/zone_profiles.csv
```

---

## Task 3.8: Prepare Spatial Data for Join

### What You Want to Achieve
Ensure geographic data aligns with 311 data.

### The Vibe Coding Prompt

```
Finalize spatial data for 311 join:

1. Verify borough name consistency:
   - Taxi boroughs: [list them]
   - 311 boroughs: Manhattan, Brooklyn, Queens, Bronx, Staten Island
   - Any mismatches?

2. Standardize if needed:
   - Case sensitivity?
   - "The Bronx" vs "Bronx"?
   - Staten Island spelling?

3. Create final join-ready file:
   - borough (standardized)
   - date
   - trip_count
   - [other metrics]

4. Coverage check:
   - All 5 boroughs present?
   - All dates present?
   - Any gaps?

Save as data/processed/taxi_spatial_ready.csv
```

---

## Deliverables Checklist

After completing this exercise, you should have:

- [ ] Taxi zone lookup loaded and understood
- [ ] LocationID distribution analyzed
- [ ] Borough mapping created and applied
- [ ] Cross-borough trips analyzed
- [ ] Borough-level aggregates created
- [ ] Spatial patterns analyzed
- [ ] `visualizations/top_pickup_zones.png`
- [ ] `visualizations/spatial_patterns.png`
- [ ] `data/processed/taxi_borough_daily.csv`
- [ ] `data/processed/taxi_spatial_ready.csv`

---

## Key Vocabulary for Vibe Coding

When doing spatial bucketing, these keywords help:

| What You Want | Keywords to Use |
|---------------|-----------------|
| Map IDs | "lookup", "mapping table", "zone to borough" |
| Handle unknowns | "filter out", "unknown zones", "outside NYC" |
| Aggregate by location | "group by borough", "spatial aggregation" |
| Cross-location | "origin-destination", "pickup-dropoff" |
| Standardize names | "consistent naming", "match format" |

---

## Common Issues and How to Fix Them

**If zones don't map to known boroughs:**
```
Some LocationIDs don't have borough in the lookup.
Check:
- Are IDs 264, 265 (unknown)?
- Is there an EWR (Newark) zone?
- Missing zones in lookup table?
Handle appropriately: filter or assign "Unknown".
```

**If borough distribution seems wrong:**
```
Brooklyn has more trips than Manhattan?
Check:
- Are you including airport zones correctly?
- Is the sample representative?
- Verify with known NYC taxi stats
```

**If too many trips are "Unknown":**
```
30% of trips have unknown pickup location.
This is too high - check:
- Are you using the right LocationID column?
- Is the zone lookup complete?
- Different year zones might not match
```

---

## What's Next?

Now that you have spatially-aggregated taxi data, Exercise 4 will teach you how to **filter 311 complaints** to nuisance types and join with taxi data.

---

[← Previous: Temporal Aggregation](./02_temporal_aggregation.md) | [Lab 5 Home](../README.md) | [Next: Complaint Taxonomy →](./04_complaint_taxonomy.md)
