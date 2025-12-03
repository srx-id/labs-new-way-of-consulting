# SRX Data Science Labs: Cross-Dataset Correlation Analysis

## Overview

Welcome to the SRX Data Science Labs repository! This teaching repository helps non-engineer team members master essential data science skills through 5 hands-on labs using real-world datasets.

**Skills You'll Learn:**
- Data cleansing and quality assessment
- Analytics and exploratory data analysis
- Machine learning correlation techniques
- **Data visualization** with matplotlib and seaborn
- Consultant-level presentation and storytelling

**End Goal**: Every lab produces **visualizations** (charts) and **insights** (executive summary) - not just code.

## Learning Path

| Lab | Focus Area | Datasets | Join Type | Difficulty |
|-----|-----------|----------|-----------|-----------|
| [Lab 1: NYC Neighborhood Signals](./lab-01-nyc-neighborhood-signals/) | Geographic Joins | 4 datasets | Borough/Zip | ⭐⭐ |
| [Lab 2: US Safety Drivers](./lab-02-us-safety-drivers/) | Time + Location | 4 datasets | County/Day | ⭐⭐⭐ |
| [Lab 3: Hospitality Demand](./lab-03-hospitality-demand/) | Calendar Joins | 3 datasets | Arrival Date | ⭐⭐ |
| [Lab 4: Streaming Catalog](./lab-04-streaming-catalog/) | Fuzzy Matching | 3 datasets | Title/Year | ⭐⭐⭐⭐ |
| [Lab 5: NYC Mobility Externalities](./lab-05-nyc-mobility-externalities/) | High Volume | 3 datasets | Borough/Hour | ⭐⭐⭐⭐ |

## Prerequisites

**Technical Requirements:**
- Python 3.8 or higher
- Required packages: pandas, numpy, scipy, matplotlib, seaborn, streamlit
- Kaggle API credentials (for dataset downloads)
- Basic understanding of DataFrames and aggregations

**Recommended Background:**
- Familiarity with Python syntax
- Basic statistics knowledge (mean, median, standard deviation)
- Understanding of tabular data structures

## Repository Structure

```
labs/
├── README.md                          # This file
├── .gitignore                         # Git ignore patterns
├── docs/                              # Shared documentation
│   ├── setup-guide.md                # Environment setup instructions
│   ├── dataset-download-guide.md     # Kaggle API configuration
│   ├── teaching-guidelines.md        # Pedagogical approach
│   └── correlation-primer.md         # Correlation concepts reference
│
├── lab-01-nyc-neighborhood-signals/  # Lab 1 materials
│   ├── README.md                     # Lab overview and exercises
│   ├── data/raw/                     # Downloaded datasets
│   ├── exercises/                    # 5 exercise markdown files
│   └── hints/                        # Strategic guidance
│
├── lab-02-us-safety-drivers/         # Lab 2 materials
│   └── ... (same structure)
│
├── lab-03-hospitality-demand/        # Lab 3 materials
│   └── ... (same structure)
│
├── lab-04-streaming-catalog/         # Lab 4 materials
│   └── ... (same structure)
│
├── lab-05-nyc-mobility-externalities/ # Lab 5 materials
│   └── ... (same structure)
│
└── shared/
    └── utilities/
        └── download_datasets.py      # Dataset download automation
```

## Getting Started

### Step 1: Set Up Your Environment

Follow the [Setup Guide](./docs/setup-guide.md) to:
- Install Python and required packages
- Set up a virtual environment
- Verify your installation

### Step 2: Configure Kaggle API

All datasets come from Kaggle. Follow the [Dataset Download Guide](./docs/dataset-download-guide.md) to:
- Create a Kaggle account
- Generate API credentials
- Configure the Kaggle CLI

### Step 3: Download Datasets

Use the provided utility script or follow manual download instructions:

```bash
# Automated approach (recommended)
python shared/utilities/download_datasets.py

# Manual approach
# Follow instructions in each lab's data/raw/README.md
```

### Step 4: Start Learning

Begin with [Lab 1: NYC Neighborhood Signals](./lab-01-nyc-neighborhood-signals/README.md) and progress sequentially through the labs.

## Core Concepts Covered

### Data Cleansing
- Handling missing values and outliers
- Standardizing data formats (dates, text, geographic)
- Deduplication and validation
- Data quality profiling

### Analytics Techniques
- Exploratory data analysis (EDA)
- Geographic and temporal aggregation
- Multi-dataset joining strategies
- Feature engineering

### Correlation Analysis
- Pearson correlation (linear relationships)
- Spearman correlation (monotonic relationships)
- Correlation interpretation and visualization
- Identifying confounders and spurious correlations

### Data Quality Guardrails
- **Grain consistency**: Standardizing datasets to same granularity before joins
- **No data leakage**: Avoiding future information in historical predictions
- **Join validation**: Verifying cardinality and coverage
- **Statistical rigor**: Testing significance and avoiding p-hacking

## Lab Progression Philosophy

The labs are designed with progressive complexity following **consultant mindset** (from our playbook):

1. **Lab 1** - Foundation: Geographic joins + "So What" thinking
2. **Lab 2** - Intermediate: Temporal features + business impact translation
3. **Lab 3** - Application: Calendar analysis + actionable recommendations
4. **Lab 4** - Advanced: Fuzzy matching + data enrichment storytelling
5. **Lab 5** - Scale: High-volume data + performance-conscious delivery

**Each lab produces 3 deliverables:**
1. **Data Outputs** (CSVs in `data/processed/`)
2. **Visualizations** (Charts in `visualizations/`)
3. **Insights** (Executive summary in `findings/`)

**Consistent workflow (aligned with consulting process):**
1. **Explore** → Understand the data
2. **Standardize** → Clean for consistent grain
3. **Aggregate** → Summarize to business-relevant level
4. **Join** → Combine with validation
5. **Analyze & Visualize** → Create charts that answer "So What"
6. **Present** → Write executive summary with recommendations

## Support Resources

### Documentation
- [Setup Guide](./docs/setup-guide.md) - Technical environment configuration
- [Dataset Download Guide](./docs/dataset-download-guide.md) - Kaggle API setup
- [Teaching Guidelines](./docs/teaching-guidelines.md) - Pedagogical approach and best practices
- [Correlation Primer](./docs/correlation-primer.md) - Statistical concepts explained

### Code Repository
- **This repo**: Documentation, datasets, and exercises
- **Boilerplate repo** (separate): Python starter code and Streamlit templates

### Getting Help
- Review the hints files in each lab's `hints/` directory
- Check common pitfalls sections in lab READMEs
- Consult the correlation primer for statistical questions

## Expected Time Investment

**Per Lab:**
- Data exploration: 30-60 minutes
- Standardization: 45-90 minutes
- Aggregation and joining: 60-90 minutes
- Correlation analysis: 90-120 minutes
- **Total per lab**: 4-6 hours

**Full Course:**
- 5 labs × 5 hours average = **25 hours**
- Plus setup time: ~2 hours
- **Grand total**: ~27 hours of hands-on learning

## Learning Objectives

By completing all 5 labs, you will be able to:

- ✅ Perform comprehensive data quality assessments
- ✅ Execute geographic and temporal standardization
- ✅ Design and implement multi-dataset join strategies
- ✅ Calculate and interpret Pearson and Spearman correlations
- ✅ Create effective data visualizations
- ✅ Identify and avoid common analytical pitfalls
- ✅ Apply correlation analysis to business problems
- ✅ Handle large datasets with appropriate techniques
- ✅ Document analytical workflows clearly

## Dataset Attribution

All datasets are sourced from Kaggle and are subject to their respective licenses. Please review each dataset's license on Kaggle before use in production or publication.

### Acknowledgments
- New York City Open Data
- NOAA National Centers for Environmental Information
- Kaggle dataset contributors
- TMDb and Netflix for entertainment data

## Contributing

This repository is designed for internal SRX training. If you discover errors or have suggestions for improvements, please contact the repository maintainer.

## License

Internal use only - SRX training materials.

---

**Ready to start?** Head to [Lab 1: NYC Neighborhood Signals](./lab-01-nyc-neighborhood-signals/README.md) and begin your data science journey!
