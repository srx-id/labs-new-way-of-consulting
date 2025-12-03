# Teaching Guidelines

## Overview

This document outlines the pedagogical approach, learning principles, and quality guardrails that guide the SRX Data Science Labs curriculum.

## Target Audience

**Primary Learners**: Non-engineer SRX team members who:
- Have basic computer literacy
- Are familiar with spreadsheets (Excel, Google Sheets)
- Want to perform data-driven analysis
- May have limited programming experience

**Learning Goals**:
- Develop practical data manipulation skills
- Understand correlation analysis techniques
- Build confidence with Python and pandas
- Apply analytical thinking to business problems

## Pedagogical Approach

### Constructivist Learning

Labs are designed using constructivist principles:

1. **Hands-On Experience**: Learners work with real datasets, not toy examples
2. **Progressive Complexity**: Each lab builds on previous knowledge
3. **Problem-Based Learning**: Business contexts motivate each analysis
4. **Guided Discovery**: Hints provide scaffolding without revealing complete solutions
5. **Reflection**: Exercises include interpretation and documentation tasks

### Bloom's Taxonomy Alignment

Each lab progresses through cognitive levels:

| Exercise | Cognitive Level | Activities |
|----------|----------------|------------|
| 1. Data Exploration | **Remembering/Understanding** | Load data, describe structure, identify types |
| 2. Standardization | **Applying** | Apply learned techniques to clean data |
| 3. Aggregation | **Analyzing** | Break down data into components, identify patterns |
| 4. Joining | **Evaluating** | Validate join quality, assess data coverage |
| 5. Correlation Analysis | **Creating/Evaluating** | Synthesize findings, interpret relationships |

### Learning Cycle

Each lab follows a consistent 5-stage cycle:

```
Explore → Standardize → Aggregate → Join → Analyze
   ↑                                           ↓
   └────────────── Reflect & Apply ───────────┘
```

This cycle reinforces the **data science workflow** while building muscle memory for best practices.

## Core Teaching Principles

### 1. Grain Consistency

**Principle**: Before joining datasets, standardize all tables to the same granularity (grain).

**Why It Matters**:
- Prevents double-counting and incorrect aggregations
- Ensures join cardinality is predictable (1:1, 1:many)
- Makes results reproducible and auditable

**Teaching Approach**:
- **Exercise 3** in every lab explicitly defines target grain
- Validation checklists require row count verification
- Hints explain grain mismatches with examples

**Example**:
```
Lab 1 Target Grain: Borough × Month
- Airbnb: Aggregate listings to borough-month averages
- 311 Requests: Count complaints per borough-month
- Crime: Count incidents per borough-month
- Weather: Average temperatures per month (replicate across boroughs)

Result: 5 boroughs × 12 months = 60 rows per dataset
```

### 2. No Data Leakage

**Principle**: Never include information from the future in historical analysis or predictions.

**Why It Matters**:
- Prevents artificially inflated model performance
- Ensures findings generalize to new data
- Maintains analytical integrity

**Teaching Approach**:
- Exercises explicitly note temporal ordering requirements
- Hints identify potential leakage scenarios
- Correlation exercises discuss lagged relationships

**Example**:
```python
# WRONG: Using end-of-month data to predict mid-month outcomes
df['monthly_sales_total'] = df.groupby(['year', 'month'])['sales'].transform('sum')
df['predict_target'] = df['daily_sales'] > df['monthly_sales_total'].median()

# RIGHT: Use only information available at prediction time
df['7day_avg_sales'] = df.groupby('product_id')['sales'].transform(
    lambda x: x.rolling(7, min_periods=1).mean()
)
```

### 3. Correlation ≠ Causation

**Principle**: Correlation identifies relationships but does not prove cause-and-effect.

**Why It Matters**:
- Prevents over-interpretation of findings
- Encourages critical thinking about confounders
- Builds scientific reasoning skills

**Teaching Approach**:
- **Correlation Primer** provides theoretical foundation
- Exercise 5 requires written interpretation with caveats
- Hints suggest alternative explanations for observed correlations

**Example Interpretations**:

**Good**: "We observe a moderate positive correlation (r=0.65) between average temperature and Airbnb reviews per month in NYC. This suggests that warmer months may see increased tourist activity, though other factors like holidays and school schedules likely contribute. Further analysis controlling for seasonality and events would strengthen this finding."

**Poor**: "Higher temperatures cause more Airbnb reviews. We should heat the city to increase tourism."

### 4. Pearson vs. Spearman Selection

**Principle**: Choose the appropriate correlation method based on data characteristics.

**When to Use Each**:

| Method | Best For | Assumptions |
|--------|---------|-------------|
| **Pearson** | Linear relationships | Normal distribution, continuous data, no outliers |
| **Spearman** | Monotonic relationships | Ordinal or continuous data, robust to outliers |

**Teaching Approach**:
- **Correlation Primer** explains both methods with visualizations
- Exercise 5 requires calculating both and comparing
- Hints note when results diverge and why

**Example**:
```python
import scipy.stats as stats

# Calculate both
pearson_r, pearson_p = stats.pearsonr(df['price'], df['reviews'])
spearman_r, spearman_p = stats.spearmanr(df['price'], df['reviews'])

# Interpret divergence
if abs(pearson_r - spearman_r) > 0.1:
    print("Significant divergence suggests non-linearity or outliers")
    # Investigate further...
```

### 5. Join Validation

**Principle**: Always validate joins to ensure expected cardinality and coverage.

**Validation Steps**:
1. **Pre-join**: Check unique keys in both tables
2. **Post-join**: Verify row count matches expectations
3. **Coverage**: Check for missing values introduced by join
4. **Cardinality**: Confirm 1:1, 1:many, or many:many as intended

**Teaching Approach**:
- Exercise 4 dedicates significant time to join validation
- Hints provide validation scripts
- Common pitfalls sections highlight join errors

**Example Validation**:
```python
# Pre-join checks
print(f"Left table unique keys: {df_left['join_key'].nunique()}")
print(f"Right table unique keys: {df_right['join_key'].nunique()}")

# Perform join
df_merged = df_left.merge(df_right, on='join_key', how='left', indicator=True)

# Post-join validation
print(df_merged['_merge'].value_counts())
# Expected: All 'both' for inner join, 'left_only' acceptable for left join

# Check for introduced nulls
print(df_merged.isnull().sum())

# Verify row count
assert len(df_merged) == len(df_left), "Row count mismatch suggests cartesian join"
```

## Progressive Difficulty Design

### Lab 1: Foundation (Difficulty ⭐⭐)
- **New Concepts**: Geographic standardization, borough-level aggregation, basic joins
- **Complexity**: 4 datasets, straightforward grain (borough × month)
- **Support**: Most detailed hints, clear expectations

### Lab 2: Intermediate (Difficulty ⭐⭐⭐)
- **New Concepts**: Multi-level geography (county, state), temporal features, holiday effects
- **Complexity**: 4 datasets, hierarchical grain (county × day), weather feature engineering
- **Support**: Moderate hints, requires applying Lab 1 concepts

### Lab 3: Application (Difficulty ⭐⭐)
- **New Concepts**: Calendar joins, cancellation analysis, seasonality
- **Complexity**: 3 datasets, date-based grain, business metrics focus
- **Support**: Minimal hints for standardization, guidance on business interpretation

### Lab 4: Advanced Technique (Difficulty ⭐⭐⭐⭐)
- **New Concepts**: Fuzzy matching, entity resolution, data enrichment
- **Complexity**: 3 datasets, requires external libraries (rapidfuzz), join quality metrics
- **Support**: Library-specific hints, algorithm explanation

### Lab 5: Scale and Performance (Difficulty ⭐⭐⭐⭐)
- **New Concepts**: Large dataset handling, chunking strategies, memory optimization
- **Complexity**: 3 datasets, high volume (>10M rows), performance considerations
- **Support**: Technical hints on pandas optimization, dask introduction

## Assessment and Evaluation

### Formative Assessment (During Labs)

**Self-Check Questions** in each exercise:
- Did I achieve the expected row count?
- Are there missing values I need to explain?
- Do my correlation values fall within [-1, 1]?
- Can I articulate why I see this relationship?

**Validation Checklists** at end of each lab:
- Structural checks (row counts, no duplicates)
- Statistical checks (correlation ranges, significance)
- Interpretation quality (written explanations)

### Summative Assessment (After Completing Labs)

**Capstone Project Suggestion**:
Learners apply all 5 labs' techniques to a new cross-dataset problem:
- Choose 2-3 related datasets (approval required)
- Define business question
- Execute full workflow (explore → join → analyze)
- Create Streamlit dashboard (using separate boilerplate)
- Present findings with interpretation

**Evaluation Rubric**:
| Criterion | Weight | Excellent | Satisfactory | Needs Improvement |
|-----------|--------|-----------|--------------|-------------------|
| Data Quality | 20% | Comprehensive profiling, all issues addressed | Basic profiling, major issues addressed | Minimal profiling |
| Grain Consistency | 20% | Perfect standardization, validated | Correct grain, minor validation gaps | Grain mismatches present |
| Join Quality | 20% | Validated cardinality, documented coverage | Joins work, some validation | Join errors or missing validation |
| Correlation Analysis | 20% | Both methods, significance tested, interpreted | One method, basic interpretation | Calculation errors or no interpretation |
| Communication | 20% | Clear narrative, visualizations, caveats | Basic documentation | Unclear or missing documentation |

## Common Learner Challenges and Solutions

### Challenge 1: Overwhelming Dataset Size

**Symptoms**:
- Learner gets stuck trying to load 10GB file
- Kernel crashes or computer freezes

**Solutions**:
1. Introduce chunking early (Lab 1 hints)
2. Provide pre-filtered samples in `data/raw/samples/`
3. Teach `nrows` parameter for testing: `pd.read_csv(file, nrows=1000)`
4. Reference cloud notebook options in download guide

### Challenge 2: Conceptual Confusion (Grain vs. Aggregation)

**Symptoms**:
- Joins produce unexpected row counts
- Learner doesn't understand why aggregation is needed

**Solutions**:
1. Visual aids in hints (grain definition tables)
2. Concrete examples: "1 row per borough-month means exactly 60 rows for 5 boroughs × 12 months"
3. Validation exercises that fail if grain is wrong

### Challenge 3: Over-Interpreting Correlations

**Symptoms**:
- Learner states correlation proves causation
- Missing mention of confounders or alternative explanations

**Solutions**:
1. **Correlation Primer** with causation vs. correlation examples
2. Exercise 5 requires listing potential confounders
3. Hints provide alternative explanations for observed patterns

### Challenge 4: Python Syntax Errors

**Symptoms**:
- Indentation errors, missing parentheses
- Confusion between methods and attributes

**Solutions**:
1. Exercises provide code templates to modify
2. Hints include working code snippets
3. Recommend IDE with linting (VS Code with Python extension)
4. Reference boilerplate repo for starter code

### Challenge 5: Motivation Gaps

**Symptoms**:
- Learner questions relevance of exercises
- Skips interpretation steps to "get it done"

**Solutions**:
1. Strong business context in every lab README
2. Real-world datasets (not synthetic data)
3. Connect to actual SRX consulting work
4. Showcase dashboards built from these techniques

## Instructional Best Practices

### For Instructors

1. **Review Hints Before Lab Sessions**: Understand strategic guidance provided
2. **Emphasize Workflow Over Code**: Process matters more than syntax
3. **Use Think-Aloud Protocol**: Demonstrate your reasoning process
4. **Normalize Errors**: Show that debugging is part of learning
5. **Connect to Business Impact**: Always relate techniques to real consulting scenarios

### For Self-Directed Learners

1. **Don't Skip Exercises**: Each builds on the previous
2. **Read Hints Only When Stuck**: Try first, then consult
3. **Document Your Reasoning**: Writing interpretation solidifies understanding
4. **Explore Beyond Requirements**: Experiment with visualizations, additional aggregations
5. **Review Correlation Primer Frequently**: Internalize statistical concepts

## Accessibility Considerations

### Cognitive Load Management

- **Chunking**: 5 exercises per lab, each 30-90 minutes
- **Scaffolding**: Hints available but not forced
- **Repetition**: Same workflow structure across all labs
- **Visual Aids**: Tables, diagrams in documentation

### Varied Learning Styles

- **Visual**: Correlation heatmaps, scatter plots in exercises
- **Textual**: Comprehensive documentation
- **Kinesthetic**: Hands-on coding exercises
- **Logical**: Step-by-step workflow with clear logic

### Inclusivity

- **No Assumed Background**: Tutorials assume only basic Python
- **Multiple Pathways**: Automated scripts + manual approaches
- **Error Tolerance**: Extensive troubleshooting sections
- **Support Resources**: Links to pandas docs, stack overflow patterns

## Ethics and Responsible Data Use

### Dataset Attribution

- Always cite Kaggle sources
- Review dataset licenses before use
- Understand data collection context (e.g., NYPD data has known biases)

### Privacy Considerations

- Datasets chosen are already public
- No personally identifiable information (PII) in exercises
- Discuss aggregation as a privacy protection technique

### Bias Awareness

**Example Discussion Points**:
- NYPD crime data reflects reported crimes, not all crimes
- Airbnb data may have selection bias (not representative of all lodging)
- Weather data from Central Park may not represent all NYC boroughs

## Continuous Improvement

### Feedback Mechanisms

1. **Post-Lab Surveys**: Quick 3-question feedback
2. **Error Logs**: Track common student errors to improve hints
3. **Completion Rates**: Identify drop-off points
4. **Concept Tests**: Short quizzes on grain, correlation, joins

### Iteration Process

1. Collect feedback quarterly
2. Update hints based on common errors
3. Refine exercise wording for clarity
4. Add new datasets as Kaggle releases them
5. Update package versions annually

## Resources for Instructors

### Recommended Reading

- **"Practical Statistics for Data Scientists"** by Bruce & Bruce
- **"Python for Data Analysis"** by Wes McKinney
- **"The Art of Statistics"** by David Spiegelhalter
- **"Weapons of Math Destruction"** by Cathy O'Neil (for bias awareness)

### Online Communities

- Pandas Documentation: https://pandas.pydata.org/docs/
- Stack Overflow: Tag `pandas`, `python`, `correlation`
- Kaggle Learn: https://www.kaggle.com/learn

### SRX-Specific Resources

- Boilerplate Code Repository: [Link to separate repo]
- Internal Slack Channel: #data-science-labs
- Office Hours: [Schedule TBD]

---

**Remember**: The goal is not perfect code, but solid analytical thinking. Help learners become critical consumers and producers of data-driven insights.
