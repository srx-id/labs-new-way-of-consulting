# Lab 2: US Safety Drivers (Time + Location Joins)

**[Home](../README.md) > Lab 2**

## Learning Objectives

✅ Master county-level geographic joins with FIPS codes
✅ Implement temporal feature engineering (day of week, hour bins, holidays)
✅ Handle hierarchical geographic data (county → state)
✅ Integrate weather data with accident patterns
✅ Apply correlation analysis to safety metrics

**Estimated Time**: 5-7 hours | **Difficulty**: ⭐⭐⭐

## Business Context

Analyze the relationship between US traffic accidents and various drivers including weather conditions, holidays, and temporal patterns. This type of analysis is valuable for insurance companies, transportation departments, and public safety agencies.

**Target Grain**: County × Day

## Datasets

1. **US Accidents Processed** - Primary accident records
2. **NOAA Weather (GSOD)** - Daily weather observations
3. **US Zipcode to County/FIPS Crosswalk** - Geographic mapping
4. **Worldwide Public Holidays** - Holiday calendar (filter to US)

See [data/raw/README.md](./data/raw/README.md) for download instructions.

## Exercises

1. **Accident Pattern Analysis** - Profile accident data, identify temporal patterns
2. **Weather Integration** - Join weather data using geographic keys
3. **Geographic Mapping** - Map zipcodes to counties using FIPS
4. **Temporal Feature Engineering** - Create rush hour flags, weekday indicators, holiday features
5. **Severity Correlation Analysis** - Correlate severity with weather, time, and holiday factors

## Key Concepts

- **FIPS Codes**: Federal Information Processing Standards for geographic identification
- **Feature Engineering**: Creating derived variables for analysis
- **Temporal Patterns**: Day of week, hour of day, seasonal effects
- **Weather Variables**: Temperature, precipitation, visibility as predictors

## Common Pitfalls

⚠️ **FIPS Code Padding**: Ensure FIPS codes have leading zeros (e.g., "01001" not "1001")
⚠️ **Time Zones**: Accidents span multiple time zones - standardize or document
⚠️ **Holiday Definitions**: US-specific holidays only from worldwide dataset
⚠️ **Weather Station Matching**: Map counties to nearest weather stations

---

**Download datasets**: `python ../../shared/utilities/download_datasets.py --lab 2`

[Home](../README.md) | [← Lab 1](../lab-01-nyc-neighborhood-signals/README.md) | [Lab 3 →](../lab-03-hospitality-demand/README.md)
