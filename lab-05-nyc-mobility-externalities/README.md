# Lab 5: NYC Mobility and Nuisance Externalities

**[Home](../README.md) > Lab 5**

## Learning Objectives

✅ Handle high-volume datasets (>10M rows) efficiently
✅ Implement chunking strategies for memory management
✅ Aggregate to hourly/daily temporal grain
✅ Analyze spatial-temporal patterns
✅ Apply correlation analysis to mobility and quality of life data

**Estimated Time**: 6-8 hours | **Difficulty**: ⭐⭐⭐⭐

## Business Context

Analyze the relationship between NYC taxi demand and nuisance complaints (noise, traffic, street conditions) to understand how mobility patterns affect urban quality of life. This analysis is valuable for urban planning, transportation policy, and civic tech applications.

**Target Grain**: Borough × Day (or Borough × Hour for advanced analysis)

## Datasets

1. **NYC Taxi Trip Data** - Trip records (~100M rows, use sample or filter)
2. **NY 311 Service Requests** - Quality of life complaints (shared with Lab 1)
3. **NYC Weather** - Weather data (shared with Lab 1)

See [data/raw/README.md](./data/raw/README.md) for download instructions.

## Exercises

1. **Volume Handling** - Implement chunking and sampling strategies
2. **Temporal Aggregation** - Aggregate trips to borough-hour or borough-day
3. **Spatial Bucketing** - Map pickup/dropoff locations to boroughs
4. **Complaint Taxonomy** - Filter 311 data to nuisance-related complaints
5. **Externality Correlations** - Correlate trip volume with complaint patterns

## Key Concepts

- **Chunking**: Process large files in manageable pieces
- **Sampling**: Work with representative subsets for development
- **Dask**: Parallel computing library for out-of-core processing
- **Spatial Aggregation**: Borough-level vs. neighborhood-level analysis
- **Temporal Granularity**: Hour vs. day vs. week trade-offs

## Performance Optimization

```python
# Use chunking for large files
chunks = []
for chunk in pd.read_csv('taxi/trip_data.csv', chunksize=100000):
    # Process chunk
    filtered = chunk[chunk['borough'].isin(['Manhattan', 'Brooklyn'])]
    chunks.append(filtered)

df = pd.concat(chunks)
```

## Optional: Dask for Very Large Data

```bash
pip install dask[complete]
```

## Common Pitfalls

⚠️ **Memory Overflow**: Don't load full taxi dataset into memory at once
⚠️ **Lat/Lon Precision**: Define clear borough boundaries
⚠️ **Temporal Alignment**: Align taxi trips and 311 complaints to same time window
⚠️ **Complaint Categories**: Define "nuisance" categories consistently
⚠️ **Rush Hour Definition**: Document peak vs. off-peak hour buckets

---

**Download datasets**: `python ../../shared/utilities/download_datasets.py --lab 5`

[Home](../README.md) | [← Lab 4](../lab-04-streaming-catalog/README.md)
