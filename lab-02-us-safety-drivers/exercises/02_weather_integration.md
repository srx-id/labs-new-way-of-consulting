# Exercise 2: Weather Data Integration

**[Lab 2 Home](../README.md) > Exercise 2**

## Overview

The accident dataset has some weather info, but it's often incomplete. In this exercise, you'll learn how to **enrich accident data with detailed weather observations** from NOAA weather stations.

**Time**: 45-60 minutes

## The Challenge

The accident data has weather columns, but:
- Many are missing values
- Limited to conditions at the time
- No historical context

By joining with NOAA weather data, we get:
- Complete daily weather records
- Temperature, precipitation, snow
- Reliable historical data

---

## Task 2.1: Explore the NOAA Weather Data

### What You Want to Achieve
Understand the structure of the weather dataset before joining.

### The Vibe Coding Prompt

```
Load the NOAA weather data from data/raw/noaa_weather.csv (or similar)

Tell me:
1. How many weather stations are included?
2. What columns are available?
3. What date range is covered?
4. What's the geographic coverage (states)?

Show me sample rows and explain:
- STATION column (weather station ID)
- DATE column
- Temperature columns (TMAX, TMIN, TAVG)
- Precipitation (PRCP)
- Snow (SNOW)
```

### Understanding Weather Station Data
- **STATION**: Unique ID for each weather station
- **TMAX/TMIN**: High and low temperature (usually in 10ths of degrees C)
- **PRCP**: Precipitation in 10ths of mm
- **SNOW**: Snowfall (may need conversion)

Ask if units are unclear:
```
What are the units for TMAX and PRCP?
Do I need to convert them to Fahrenheit or inches?
```

---

## Task 2.2: Map Weather Stations to Counties

### What You Want to Achieve
Create a crosswalk between weather stations and US counties.

### The Vibe Coding Prompt

```
I need to join weather data (by station) to accident data (by county).

First, check if the weather data has:
- County information directly?
- State + station name that we can map?
- Latitude/longitude we can use?

If there's a separate crosswalk file (station_to_county.csv or similar):
- Load it and show its structure
- How many stations can we map to counties?

If no crosswalk exists:
- How can we map stations to counties?
- Can we use the zipcode crosswalk from data/raw/?

Show me how many weather stations we can match to each state.
```

### The Geography Challenge
This is the tricky part! Options:
1. **Use a provided crosswalk** (if available)
2. **Use FIPS codes** (Federal standard for counties)
3. **Use lat/lon to nearest county** (more complex)

---

## Task 2.3: Prepare Weather Data for Joining

### What You Want to Achieve
Clean and aggregate weather data to match accident data grain.

### The Vibe Coding Prompt

```
Prepare the weather data for joining to accidents:

1. Filter to dates that overlap with accident data
2. Handle missing values:
   - How many rows have missing TMAX?
   - Should we fill, drop, or flag?

3. Convert units if needed:
   - TMAX/TMIN to Fahrenheit
   - PRCP to inches
   - Document conversions

4. Create useful derived columns:
   - extreme_cold: TMIN below 32°F
   - extreme_heat: TMAX above 95°F
   - rainy_day: PRCP > 0
   - snowy_day: SNOW > 0

5. If one county has multiple stations:
   - How do we handle? (average, nearest, any?)

Show the cleaned weather data structure.
```

### Best Practice: One Row Per County-Day
The goal is to have one weather observation per county per day. If there are multiple stations in a county:

```
Multiple weather stations exist for the same county.
Calculate the average temperature and total precipitation
across all stations in each county for each day.
```

---

## Task 2.4: Create the Join Key

### What You Want to Achieve
Prepare both datasets with matching keys for the join.

### The Vibe Coding Prompt

```
Create join keys in both datasets:

1. For accident data:
   - Extract date from Start_Time (just the date, not time)
   - Create a county identifier (State + County or FIPS code)
   - Call it "county_date_key" = county + date

2. For weather data:
   - Create same county identifier
   - Create same "county_date_key"

3. Validate:
   - How many unique county_date_keys in accidents?
   - How many in weather?
   - How many will match?

Show me sample keys from both datasets to confirm they match.
```

### FIPS Code Padding
FIPS codes need leading zeros:
```
FIPS code 1001 should be "01001" (Alabama, Autauga County)
Make sure all FIPS codes are 5 characters with leading zeros.
```

---

## Task 2.5: Perform the Weather Join

### What You Want to Achieve
Merge weather data into the accident dataset.

### The Vibe Coding Prompt

```
Join weather data to accident data:

1. Start with accidents as the base table
2. Left join weather on county_date_key
3. After the join:
   - How many accidents now have weather data?
   - How many don't have weather (null)?
   - What percentage got matched?

4. Investigate unmatched records:
   - Which counties have no weather data?
   - Which dates are missing weather?
   - Is there a pattern?

Save the enriched dataset as data/processed/accidents_with_weather.csv
```

### Acceptable Match Rates
- **>80% matched**: Good!
- **50-80% matched**: Investigate gaps
- **<50% matched**: Something's wrong with the join key

---

## Task 2.6: Validate the Weather Join

### What You Want to Achieve
Confirm the weather data makes sense for the accidents.

### The Vibe Coding Prompt

```
Validate the weather join quality:

1. Spot check:
   - For 5 random accidents, show the accident date/location and joined weather
   - Does it make sense? (Summer accident shouldn't have snow)

2. Logical checks:
   - Accidents in Florida shouldn't have temperatures below 0°F
   - Snowy day accidents should mostly be in winter months
   - Rain flag should correlate with precipitation

3. Compare to original weather data in accidents:
   - Does our joined TMAX correlate with the original Temperature(F) column?
   - Are they close, or very different?

Document any concerns about data quality.
```

---

## Task 2.7: Create Weather Summary Statistics

### What You Want to Achieve
Understand weather conditions across the accident dataset.

### The Vibe Coding Prompt

```
Create a summary of weather conditions in the enriched dataset:

1. Temperature distribution:
   - Average TMAX for all accidents
   - Breakdown by severity level

2. Precipitation patterns:
   - What % of accidents happened on rainy days?
   - What % on snowy days?
   - Severity breakdown for rain vs no-rain

3. Extreme weather:
   - How many accidents during extreme cold?
   - How many during extreme heat?
   - Severity for extreme vs normal conditions

Create a visualization:
- Box plot of temperature by severity level
Save as visualizations/temperature_by_severity.png
```

---

## Deliverables Checklist

After completing this exercise, you should have:

- [ ] Weather data explored and understood
- [ ] Station-to-county mapping completed
- [ ] Weather data cleaned with units converted
- [ ] Join keys created in both datasets
- [ ] `data/processed/accidents_with_weather.csv`
- [ ] Join validation completed (match rate documented)
- [ ] `visualizations/temperature_by_severity.png`
- [ ] Weather summary statistics documented

---

## Key Vocabulary for Vibe Coding

When working with weather data joins, these keywords help:

| What You Want | Keywords to Use |
|---------------|-----------------|
| Connect datasets | "join on", "merge by", "match using" |
| Geographic linking | "FIPS code", "county mapping", "crosswalk" |
| Handle multiple | "aggregate by", "average across stations" |
| Unit conversion | "convert to Fahrenheit", "10ths of degree" |
| Missing data | "match rate", "unmatched records", "null after join" |

---

## Common Issues and How to Fix Them

**If match rate is low:**
```
Only 30% of accidents matched to weather data.
Show me the counties with the most unmatched accidents.
Are we missing weather data for major metro areas?
Check if the FIPS code format matches between datasets.
```

**If temperature values seem wrong:**
```
The joined temperature is showing 300°F.
Check if the weather data uses 10ths of degrees Celsius.
Convert: (value/10 * 9/5) + 32 for Fahrenheit
```

**If dates don't match:**
```
The date formats don't match between datasets.
Weather uses YYYY-MM-DD but accidents use MM/DD/YYYY.
Standardize both to the same format before joining.
```

---

## What's Next?

Now that you have weather-enriched accident data, Exercise 3 will teach you how to **map accidents to counties** using geographic codes and create the final analysis dataset.

---

[← Previous: Accident Patterns](./01_accident_pattern_analysis.md) | [Lab 2 Home](../README.md) | [Next: Geographic Mapping →](./03_geographic_mapping.md)
