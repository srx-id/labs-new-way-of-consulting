# Lab 1: NYC Neighborhood Signal Extraction

**[Home](../README.md) > Lab 1**

## Learning Objectives

By completing this lab, you will:

✅ Perform comprehensive data quality profiling and assessment
✅ Execute geographic standardization (latitude/longitude → borough)
✅ Conduct temporal aggregation to consistent monthly grain
✅ Implement multi-dataset joins with validation
✅ Calculate and interpret Pearson vs Spearman correlations
✅ Identify potential confounders in observational data

**Estimated Time**: 4-6 hours

## Business Context

**Client Scenario**: A hospitality investment firm is evaluating NYC neighborhoods for Airbnb property acquisitions. They need data-driven insights on what drives pricing and guest demand.

**Your Role**: Consultant analyzing correlation between neighborhood quality signals and Airbnb performance.

### The "So What" Question

**Client asks**: "What neighborhood characteristics should we consider when pricing and selecting properties?"

**Your deliverable**: Evidence-based answer showing which factors (complaints, crime, weather) correlate with price and review activity, with clear business implications.

### Key Business Questions

1. **Pricing Strategy**: Do neighborhoods with more 311 complaints command lower prices? (Quality of life impact)
2. **Safety Premium**: Is there a "safety premium" where low-crime areas charge more?
3. **Seasonality**: How much does weather drive demand patterns? (Revenue forecasting)
4. **Investment Criteria**: Which metrics should be weighted in neighborhood selection?

### What Good Looks Like (Client Expectation)

- Clear correlation strength: "Crime rate shows moderate negative correlation (r = -0.52) with average price"
- Business translation: "Every 10% increase in crime is associated with ~5% lower nightly rates"
- Actionable insight: "Prioritize neighborhoods with crime rates below 50 incidents/month for premium positioning"
- Confidence level: "Statistically significant (p < 0.01) across all 5 boroughs"

## Datasets

### Primary Dataset: NYC Airbnb Open Data (2019)

- **Source**: [Kaggle - NYC Airbnb Open Data](https://www.kaggle.com/datasets/dgomonov/new-york-city-airbnb-open-data)
- **Grain**: One row per listing
- **Size**: ~49,000 rows, 16 columns, ~1.5 MB
- **Key Fields**:
  - `id`: Unique listing identifier
  - `name`: Listing name
  - `host_id`: Host identifier
  - `neighbourhood_group`: Borough (Manhattan, Brooklyn, Queens, Bronx, Staten Island)
  - `neighbourhood`: Specific neighborhood
  - `latitude`, `longitude`: Location coordinates
  - `price`: Nightly price in USD
  - `minimum_nights`: Minimum stay requirement
  - `number_of_reviews`: Total review count
  - `last_review`: Date of most recent review
  - `reviews_per_month`: Average monthly review rate
  - `availability_365`: Days available per year

### Add-on Dataset 1: NY 311 Service Requests

- **Source**: [Kaggle - NY 311 Service Requests](https://www.kaggle.com/datasets/new-york-city/ny-311-service-requests)
- **Grain**: One row per service request
- **Size**: ~23 million rows (filter to 2019), ~10 GB
- **Key Fields**:
  - `Created Date`: Request timestamp
  - `Borough`: NYC borough
  - `Complaint Type`: Category (noise, heat/hot water, street condition, etc.)
  - `Descriptor`: Specific complaint detail
  - `Location Type`: Where complaint occurred
- **Use Case**: Proxy for neighborhood quality of life issues

### Add-on Dataset 2: NYPD Crime Complaint Data Historic

- **Source**: [Kaggle - NYPD Complaint Data Historic](https://www.kaggle.com/datasets/brunacmendes/nypd-complaint-data-historic-20062019)
- **Grain**: One row per crime complaint
- **Size**: ~5 million rows (full history), ~2 GB
- **Key Fields**:
  - `CMPLNT_FR_DT`: Complaint date
  - `BORO_NM`: Borough name
  - `LAW_CAT_CD`: Law category (felony, misdemeanor, violation)
  - `OFNS_DESC`: Offense description
  - `Latitude`, `Longitude`: Location (some records)
- **Use Case**: Safety metrics and crime rate correlation

### Add-on Dataset 3: NYC Central Park Weather (1869-2022)

- **Source**: [Kaggle - NYC Weather 1869-2022](https://www.kaggle.com/datasets/danbraswell/new-york-city-weather-18692022)
- **Grain**: Daily weather observations
- **Size**: ~56,000 rows (use 2019 only), ~5 MB
- **Key Fields**:
  - `DATE`: Observation date
  - `TMAX`: Maximum temperature (°F)
  - `TMIN`: Minimum temperature (°F)
  - `PRCP`: Precipitation (inches)
  - `SNOW`: Snowfall (inches)
- **Use Case**: Seasonal tourism patterns and weather impact

## Data Dictionary: Standardized Grain

**Target Grain**: Borough × Month

**Aggregated Metrics**:

| Field | Data Type | Description | Calculation |
|-------|-----------|-------------|-------------|
| `borough` | String | NYC borough (5 values) | Standardized from source data |
| `year_month` | String | YYYY-MM format | Extracted from date fields |
| `avg_price` | Float | Mean Airbnb listing price | `df.groupby(...).agg({'price': 'mean'})` |
| `median_reviews_per_month` | Float | Median review velocity | `df.groupby(...).agg({'reviews_per_month': 'median'})` |
| `listing_count` | Integer | Number of active listings | `df.groupby(...).size()` |
| `complaint_count` | Integer | Total 311 requests | Count of records |
| `crime_count` | Integer | Total crime complaints | Count of records |
| `avg_temp` | Float | Average max temperature | `df.groupby(...).agg({'TMAX': 'mean'})` |
| `total_precip` | Float | Sum of precipitation | `df.groupby(...).agg({'PRCP': 'sum'})` |

**Expected Output**: 60 rows (5 boroughs × 12 months)

## Deliverables

Your final deliverable package for the client includes:

### 1. Data Outputs (CSV)
- `data/processed/final_dataset.csv` - Clean, joined dataset (60 rows)
- `data/processed/correlation_insights.csv` - Key findings with business interpretation

### 2. Visualizations (PNG/PDF)
- `visualizations/correlation_heatmap.png` - Pearson & Spearman comparison
- `visualizations/price_vs_crime_scatter.png` - Borough-colored scatter plot
- `visualizations/seasonality_trends.png` - Monthly patterns by metric
- `visualizations/borough_comparison.png` - Small multiples by borough

### 3. Consultant Brief (Markdown)
- `findings/executive_summary.md` - 1-page brief answering "So What"

**Visualization Principle** (from playbook): Every chart must answer a business question. No chart for chart's sake.

## Exercises

### Exercise 1: Data Exploration (30 min)

**File**: [exercises/01_data_exploration.md](./exercises/01_data_exploration.md)

**Objectives**:
- Load all four datasets
- Profile basic statistics (shape, data types, missing values)
- Identify data quality issues
- Document the grain of each dataset
- Explore temporal coverage

**Deliverables**:
- Summary statistics table for each dataset
- Data quality report (missing values, duplicates, outliers)
- Temporal coverage visualization

### Exercise 2: Geographic Standardization (45 min)

**File**: [exercises/02_geo_standardization.md](./exercises/02_geo_standardization.md)

**Objectives**:
- Validate Airbnb `neighbourhood_group` field
- Standardize 311 `Borough` field (handle nulls, inconsistent naming)
- Map NYPD `BORO_NM` to standard borough names
- Create borough crosswalk table
- Validate mapping coverage

**Deliverables**:
- Borough standardization code
- Coverage report (% of records successfully mapped)
- Documentation of unmapped records

**Hint**: See [hints/grain_definitions.md](./hints/grain_definitions.md)

### Exercise 3: Temporal Aggregation (45 min)

**File**: [exercises/03_temporal_aggregation.md](./exercises/03_temporal_aggregation.md)

**Objectives**:
- Extract year-month from all date fields
- Filter all datasets to 2019
- Aggregate Airbnb metrics by borough-month
- Aggregate 311/crime counts by borough-month
- Aggregate weather to monthly values
- Validate grain consistency (expect 60 rows per dataset)

**Deliverables**:
- 4 aggregated datasets at borough-month grain
- Grain validation report (row counts, unique keys)

**Hint**: See [hints/join_strategy.md](./hints/join_strategy.md)

### Exercise 4: Dataset Joining (60 min)

**File**: [exercises/04_dataset_joining.md](./exercises/04_dataset_joining.md)

**Objectives**:
- Perform left joins from Airbnb (base) → 311, crime, weather
- Validate join cardinality (expect 1:1 for all joins at this grain)
- Handle missing values post-join
- Create consolidated analysis dataset
- Export final dataset for correlation analysis

**Deliverables**:
- Consolidated dataset (60 rows × 10+ columns)
- Join validation report (merge indicators, row counts)
- Missing value analysis and handling documentation

**Hint**: See [hints/join_strategy.md](./hints/join_strategy.md)

### Exercise 5: Correlation Analysis (90 min)

**File**: [exercises/05_correlation_analysis.md](./exercises/05_correlation_analysis.md)

**Objectives**:
1. Calculate Pearson correlations:
   - `avg_price` vs `complaint_count`, `crime_count`, `avg_temp`, `total_precip`
   - `median_reviews_per_month` vs same variables
2. Calculate Spearman correlations for same pairs
3. Create correlation heatmap
4. Interpret differences between Pearson vs Spearman
5. Identify potential confounders (e.g., borough effects, seasonality)
6. Document findings with statistical significance (p-values)

**Deliverables**:
- Correlation matrix (Pearson and Spearman)
- Heatmap visualizations
- Written interpretation (500-750 words) addressing:
  - Which correlations are statistically significant?
  - Do Pearson and Spearman agree? If not, why?
  - What might explain observed relationships?
  - What are potential confounders?
  - Can we infer causation? Why or why not?

**Hint**: See [hints/expected_correlations.md](./hints/expected_correlations.md) and [Correlation Primer](../docs/correlation-primer.md)

## Common Pitfalls

⚠️ **Grain Mismatch**: Ensure ALL datasets are aggregated to borough-month level before joining. Joining datasets at different grains leads to incorrect row counts and duplicated data.

⚠️ **Date Parsing**: Handle various date formats across datasets:
- Airbnb: `YYYY-MM-DD`
- 311: `MM/DD/YYYY HH:MM:SS AM/PM`
- NYPD: `MM/DD/YYYY`
- Weather: `YYYY-MM-DD`

⚠️ **Borough Nulls**: NY 311 data has ~10% null boroughs. Document your handling decision:
- Exclude (safest for clean analysis)
- Impute using lat/lon (advanced)
- Allocate to "Unknown" category (biases results)

⚠️ **Weather Replication**: Central Park weather is a single point location. Consider:
- Replicate same monthly values across all boroughs (simple approach)
- Treat as citywide variable (don't join on borough, join on month only)
- Acknowledge limitation in interpretation

⚠️ **Outlier Sensitivity**: Pearson correlation is sensitive to price outliers. Consider:
- Winsorizing (cap at 95th/99th percentile)
- Log transformation
- Using Spearman as primary method
- Documenting outlier handling in analysis

⚠️ **Temporal Gaps**: Not all listings have reviews in every month. This affects:
- `reviews_per_month` calculation (may be null)
- Listing count (inactive listings may not appear)
- Solution: Define "active" criteria clearly

## Validation Checklist

Before proceeding to interpretation, verify:

- [ ] **Structure**: Final dataset has exactly 60 rows (5 boroughs × 12 months)
- [ ] **No Duplicates**: No duplicate borough-month combinations
- [ ] **Valid Correlations**: All correlation coefficients are between -1 and +1
- [ ] **Significance**: P-values calculated for all correlations
- [ ] **Comparison**: Both Pearson and Spearman calculated
- [ ] **Missing Values**: Documented and handled (not silently dropped)
- [ ] **Outliers**: Identified and decision documented
- [ ] **Grain Validation**: Each source dataset aggregated correctly
- [ ] **Join Quality**: Merge indicators show expected patterns (all "both" or documented "left_only")

## Interpretation Framework

When writing your correlation interpretation, use this structure:

### 1. Observation
"We observe a [strength] [direction] [Pearson/Spearman] correlation (r/ρ = X.XX, p = X.XXX) between [variable 1] and [variable 2]."

### 2. Statistical Assessment
"This relationship is [statistically significant / not statistically significant] at the 0.05 level. The Pearson and Spearman correlations [agree / diverge by X.XX], suggesting [linearity / non-linearity / outlier influence]."

### 3. Potential Explanation
"This association could be explained by [mechanism]. For example, [concrete example]."

### 4. Confounders
"However, potential confounding variables include [list]. We cannot rule out that [alternative explanation]."

### 5. Causation Caveat
"This correlation does not establish causation because [reasons]. To strengthen causal inference, we would need [additional evidence]."

## Next Steps

After completing Lab 1:

1. **Review**: Compare your findings with lab hints
2. **Reflect**: What surprised you? What patterns emerged?
3. **Apply**: Consider how these techniques apply to SRX consulting work
4. **Advance**: Proceed to [Lab 2: US Safety Drivers](../lab-02-us-safety-drivers/README.md)

## Additional Resources

- [Teaching Guidelines](../docs/teaching-guidelines.md) - Pedagogical approach
- [Correlation Primer](../docs/correlation-primer.md) - Statistical foundations
- [Setup Guide](../docs/setup-guide.md) - Technical environment
- [Dataset Download Guide](../docs/dataset-download-guide.md) - Kaggle API

## Dataset Licenses

All datasets are used under their respective Kaggle licenses for educational purposes. Review each dataset's license page before any commercial or publication use:

- NYC Airbnb: CC0 Public Domain
- NY 311: NYC Open Data License
- NYPD Crime: NYC Open Data License
- NYC Weather: Public Domain

---

**Ready to start?** Head to [Exercise 1: Data Exploration](./exercises/01_data_exploration.md) and begin your analysis!

[Home](../README.md) | [Next Lab: US Safety Drivers →](../lab-02-us-safety-drivers/README.md)
