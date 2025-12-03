# Exercise 1: High-Volume Data Handling

**[Lab 5 Home](../README.md) > Exercise 1**

## Overview

NYC taxi data is MASSIVE - hundreds of millions of rows. Before you can analyze it, you need to learn strategies for **handling data that doesn't fit in memory**.

**Time**: 45-60 minutes

## The Challenge

NYC Taxi trip data reality:
- Yellow + Green taxi: ~100M+ trips/year
- Each row: pickup/dropoff location, time, fare, etc.
- Full dataset: 10+ GB per year
- Your laptop RAM: probably 8-16 GB

**You cannot load it all at once.** This exercise teaches you how to work around that.

---

## Task 1.1: Assess the Data Size

### What You Want to Achieve
Understand what you're dealing with before trying to load.

### The Vibe Coding Prompt

```
Check the taxi data files without loading them:

1. List all files in data/raw/taxi/:
   - File names
   - File sizes (in MB or GB)
   - File types (CSV, Parquet, etc.)

2. Estimate row counts:
   - For one month's file, how many lines?
   - Don't load the file - just count lines quickly

3. Sample first 5 rows:
   - What columns exist?
   - What's the grain (one row = one trip)

4. Calculate memory needs:
   - Estimated row size
   - Full dataset memory estimate
   - Compare to available RAM

Is this file loadable in memory? What's the plan?
```

### Quick File Size Check
```
For CSV files, you can estimate without loading:
- File size in MB ÷ 50 ≈ rows in thousands (rough rule)
- A 5GB file ≈ 100 million rows

Parquet files are compressed - multiply by 3-5 for CSV equivalent.
```

---

## Task 1.2: Learn Chunking Strategy

### What You Want to Achieve
Understand how to process large files in pieces.

### The Vibe Coding Prompt

```
Explain chunking for large files:

1. What is chunking?
   - Processing file in small batches
   - Each chunk fits in memory
   - Process, aggregate, discard, repeat

2. When to use chunking:
   - File too large for memory
   - Only need aggregated results
   - Can process independently

3. Common chunk operations:
   - Filter (keep only needed rows)
   - Aggregate (sum, count, average)
   - Sample (random subset)

4. Chunk size selection:
   - Too small = slow (many iterations)
   - Too large = memory error
   - Sweet spot: 100K-500K rows typically

Show me how to load just 100,000 rows as a test.
```

---

## Task 1.3: Load a Sample Chunk

### What You Want to Achieve
Successfully load a portion of the taxi data.

### The Vibe Coding Prompt

```
Load a sample of the taxi data:

1. Load only first 100,000 rows from one month's file

2. Profile the sample:
   - How many columns?
   - Column names and types
   - Memory usage of this sample

3. Key columns for our analysis:
   - Pickup datetime
   - Pickup location (latitude/longitude or zone ID)
   - Dropoff location
   - Trip distance
   - Fare amount

4. Data quality in sample:
   - Any missing values?
   - Any obvious outliers?
   - Date range covered

This sample helps us understand the full dataset structure.
```

---

## Task 1.4: Create Filter-While-Loading Strategy

### What You Want to Achieve
Learn to filter data as you load, reducing memory needs.

### The Vibe Coding Prompt

```
Implement filter-during-load strategy:

1. Define filter criteria:
   - Only trips from 2019 (or target year)
   - Only Manhattan pickups (if borough available)
   - Only fares > $0 (real trips)

2. For each chunk:
   - Load chunk
   - Apply filters
   - Keep only matching rows
   - Append to results list

3. Select only needed columns:
   - Don't load passenger_count if we don't need it
   - Reduces memory per row

4. Combine filtered chunks:
   - How many rows after filtering?
   - Memory usage now?

This reduces data volume BEFORE analysis.
```

### Column Selection
```
If we only need 5 columns out of 20:
- Full load: 20 columns × millions of rows = huge
- Selective: 5 columns × millions of rows = manageable

Always specify which columns you need when loading large files.
```

---

## Task 1.5: Implement Aggregation-While-Loading

### What You Want to Achieve
Aggregate data during loading, never storing all raw rows.

### The Vibe Coding Prompt

```
Implement streaming aggregation:

1. Our goal: Borough-hour aggregates
   - Don't need individual trip records
   - Need: borough, hour, trip_count, avg_fare

2. Aggregation approach:
   - Process each chunk
   - Aggregate chunk to borough-hour
   - Combine chunk aggregates

3. For each chunk:
   - Extract borough from pickup location
   - Extract hour from pickup datetime
   - Group by borough + hour
   - Count trips, average fare

4. Combine chunk results:
   - Sum counts across chunks
   - Weighted average for fares
   - Final result: small aggregated dataset

The final result should be thousands of rows, not millions!
```

### Key Insight
```
Raw data: 100,000,000 rows (taxi trips)
After aggregation: ~43,800 rows (5 boroughs × 24 hours × 365 days)

We reduced data by 99.95% while keeping what we need!
```

---

## Task 1.6: Handle Location Mapping

### What You Want to Achieve
Map taxi pickup coordinates to NYC boroughs.

### The Vibe Coding Prompt

```
Map taxi locations to boroughs:

1. Check location format:
   - Does data have lat/lon coordinates?
   - Or does it have zone IDs?
   - NYC taxi often uses "LocationID" zones

2. If using Zone IDs:
   - Load taxi zone lookup table
   - Zone ID → Borough mapping
   - Show sample: Zone 161 = "Midtown Center" = Manhattan

3. If using coordinates:
   - Need geographic boundaries
   - Map (lat, lon) → borough
   - This is more complex

4. Apply mapping to sample:
   - Add borough column
   - Verify coverage (what % mapped successfully?)

Document the location mapping approach.
```

### Taxi Zone Lookup
```
NYC taxi data usually uses "LocationID" which maps to zones.
A lookup file (taxi_zones.csv) provides:
- LocationID: 1-265
- Borough: Manhattan, Brooklyn, Queens, Bronx, Staten Island
- Zone: Specific neighborhood name
```

---

## Task 1.7: Process Full Dataset (One Month)

### What You Want to Achieve
Successfully process an entire month of data using chunking.

### The Vibe Coding Prompt

```
Process one complete month of taxi data:

1. Choose one month (e.g., January 2019)

2. Process in chunks:
   - Chunk size: 500,000 rows
   - Show progress (which chunk number)
   - Filter while loading
   - Aggregate while loading

3. Final aggregated result:
   - Rows: borough × day × hour (should be manageable)
   - Columns: borough, date, hour, trip_count, avg_fare, total_distance

4. Validation:
   - Total trips processed: X million
   - Final aggregated rows: Y thousand
   - Memory used: Z MB

Save aggregated result as data/processed/taxi_january_aggregated.csv
```

---

## Task 1.8: Document Volume Handling Strategy

### What You Want to Achieve
Create a reference for handling large data.

### The Vibe Coding Prompt

```
Document the volume handling strategy:

1. Data Profile:
   - Raw file size: X GB
   - Estimated rows: X million
   - Memory needed for full load: X GB (unworkable)

2. Strategy Used:
   - Chunking with X row chunks
   - Filter during load (criteria: ...)
   - Column selection (kept X of Y columns)
   - Aggregation during load (grain: ...)

3. Results:
   - Processing time: X minutes
   - Final dataset size: X rows, X MB
   - Data reduction: 99.X%

4. Lessons Learned:
   - Optimal chunk size for this data
   - Memory monitoring tips
   - What to do if you hit memory limits

Save as findings/volume_handling_strategy.md
```

---

## Deliverables Checklist

After completing this exercise, you should have:

- [ ] Data size assessed without loading
- [ ] Chunking strategy understood
- [ ] Sample successfully loaded
- [ ] Filter-while-loading implemented
- [ ] Aggregation-while-loading implemented
- [ ] Location mapping completed
- [ ] One month fully processed
- [ ] `data/processed/taxi_january_aggregated.csv`
- [ ] `findings/volume_handling_strategy.md`

---

## Key Vocabulary for Vibe Coding

When handling large data, these keywords help:

| What You Want | Keywords to Use |
|---------------|-----------------|
| Partial load | "load first N rows", "sample", "head" |
| Batch processing | "chunk", "iterate in chunks", "batch size" |
| Reduce size | "filter during load", "select columns" |
| Aggregate on fly | "aggregate while reading", "streaming aggregation" |
| Memory aware | "memory usage", "don't store all rows" |

---

## Common Issues and How to Fix Them

**If you run out of memory:**
```
Python kernel crashed or froze.
Reduce chunk size from 500K to 100K.
Make sure you're not storing all chunks - aggregate and discard.
Restart kernel and try again with smaller chunks.
```

**If processing is too slow:**
```
Processing 100M rows takes forever.
Options:
- Use a sample (10%) for development
- Only process one month first
- Consider Parquet format (faster than CSV)
- Process overnight if needed
```

**If location IDs don't map:**
```
30% of trips have LocationID = 264 or 265 (unknown zones).
These are trips outside NYC proper.
Filter them out or assign to "Unknown" borough.
```

---

## What's Next?

Now that you can handle the data volume, Exercise 2 will teach you how to **aggregate to borough-hour grain** for correlation analysis.

---

[Lab 5 Home](../README.md) | [Next: Temporal Aggregation →](./02_temporal_aggregation.md)
