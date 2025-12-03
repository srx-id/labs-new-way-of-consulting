# Lab 4: Streaming Catalog Enrichment (Fuzzy Matching)

**[Home](../README.md) > Lab 4**

## Learning Objectives

✅ Implement fuzzy string matching for entity resolution
✅ Perform title normalization and cleaning
✅ Evaluate join quality with multiple data sources
✅ Enrich datasets with external metadata
✅ Handle many-to-many relationships

**Estimated Time**: 6-8 hours | **Difficulty**: ⭐⭐⭐⭐

## Business Context

Enrich Netflix catalog data with detailed movie metadata from TMDb to analyze content characteristics, popularity patterns, and recommendation opportunities. This type of data enrichment is common in content platforms, e-commerce, and media analytics.

**Target Grain**: Title (with potential duplicates from fuzzy matching)

## Datasets

1. **Netflix Movies and TV Shows** - Netflix catalog
2. **The Movies Dataset (TMDb)** - Comprehensive movie metadata
3. **TMDb 5000 Movie Metadata** - Curated movie subset

See [data/raw/README.md](./data/raw/README.md) for download instructions.

## Exercises

1. **Catalog Profiling** - Understand Netflix content distribution
2. **Fuzzy Matching Implementation** - Match titles using RapidFuzz library
3. **Entity Resolution** - Resolve conflicts and choose best matches
4. **Enrichment Validation** - Assess join quality and coverage
5. **Metadata Correlation** - Correlate TMDb metrics with Netflix patterns

## Key Concepts

- **Fuzzy Matching**: Approximate string matching using similarity algorithms
- **Levenshtein Distance**: Edit distance between strings
- **Entity Resolution**: Identifying when records refer to the same entity
- **Match Threshold**: Minimum similarity score to accept a match
- **Join Quality Metrics**: Precision, recall, coverage

## Required Library

```bash
pip install rapidfuzz
```

## Common Pitfalls

⚠️ **Title Normalization**: Remove "The", punctuation, case differences before matching
⚠️ **Release Year**: Use as secondary key to disambiguate title matches
⚠️ **Threshold Selection**: Too low = false positives, too high = missed matches
⚠️ **Many-to-Many**: One Netflix title may match multiple TMDb entries
⚠️ **Runtime Formats**: Different unit conventions (minutes vs. hours)

---

**Download datasets**: `python ../../shared/utilities/download_datasets.py --lab 4`

[Home](../README.md) | [← Lab 3](../lab-03-hospitality-demand/README.md) | [Lab 5 →](../lab-05-nyc-mobility-externalities/README.md)
