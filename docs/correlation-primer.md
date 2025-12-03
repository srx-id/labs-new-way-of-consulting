# Correlation Analysis Primer

## Overview

This guide explains the fundamentals of correlation analysis, focusing on the two primary methods used in the SRX Data Science Labs: **Pearson correlation** and **Spearman correlation**.

## What is Correlation?

**Correlation** measures the strength and direction of the relationship between two variables.

**Key Characteristics**:
- Ranges from -1 to +1
- **Positive correlation** (+1): Variables move together in the same direction
- **Negative correlation** (-1): Variables move in opposite directions
- **Zero correlation** (0): No linear relationship

**Important**: Correlation measures **association**, not **causation**.

### Visual Examples

```
Perfect Positive (r = +1)     No Correlation (r = 0)      Perfect Negative (r = -1)
    Y                             Y                             Y
    |    ●                         |  ●    ●                     |         ●
    |   ●                          |    ●      ●                 |       ●
    |  ●                           | ●     ●                     |      ●
    | ●                            |   ●   ●  ●                  |    ●
    |●                             |  ●  ●    ●                  |   ●
    └────────── X                  └────────── X                 |  ●
                                                                 | ●
                                                                 |●
                                                                 └────────── X
```

## Pearson Correlation Coefficient

### Definition

The **Pearson correlation coefficient** (denoted as **r**) measures the **linear relationship** between two continuous variables.

### Formula

$$r = \frac{\sum{(X_i - \bar{X})(Y_i - \bar{Y})}}{\sqrt{\sum{(X_i - \bar{X})^2} \sum{(Y_i - \bar{Y})^2}}}$$

Where:
- $X_i$, $Y_i$ are individual data points
- $\bar{X}$, $\bar{Y}$ are the means of X and Y
- The numerator is the covariance of X and Y
- The denominator normalizes the result to [-1, 1]

### Interpretation

| Coefficient Value | Interpretation |
|------------------|----------------|
| +0.9 to +1.0 | Very strong positive correlation |
| +0.7 to +0.89 | Strong positive correlation |
| +0.4 to +0.69 | Moderate positive correlation |
| +0.1 to +0.39 | Weak positive correlation |
| 0.0 to +0.09 | Negligible correlation |
| -0.1 to -0.39 | Weak negative correlation |
| -0.4 to -0.69 | Moderate negative correlation |
| -0.7 to -0.89 | Strong negative correlation |
| -0.9 to -1.0 | Very strong negative correlation |

### Assumptions

Pearson correlation assumes:
1. **Continuous variables**: Both X and Y are measured on continuous scales
2. **Linear relationship**: The relationship is linear (not curved)
3. **Normality**: Data is approximately normally distributed
4. **Homoscedasticity**: Variance is constant across the range
5. **No outliers**: Extreme values can disproportionately influence results

### When to Use Pearson

✅ **Use Pearson when**:
- Both variables are continuous (e.g., temperature and price)
- The relationship appears linear in a scatter plot
- No extreme outliers are present
- Data is approximately normally distributed

❌ **Don't use Pearson when**:
- Variables are ordinal (ranked data)
- The relationship is curved or non-linear
- Data has significant outliers
- Distribution is heavily skewed

### Python Example

```python
import pandas as pd
import scipy.stats as stats

# Calculate Pearson correlation
pearson_r, pearson_p = stats.pearsonr(df['temperature'], df['airbnb_price'])

print(f"Pearson r: {pearson_r:.3f}")
print(f"P-value: {pearson_p:.4f}")

# Interpretation
if pearson_p < 0.05:
    print(f"Statistically significant (p < 0.05)")
else:
    print(f"Not statistically significant")
```

## Spearman Correlation Coefficient

### Definition

The **Spearman correlation coefficient** (denoted as **ρ** or **r_s**) measures the **monotonic relationship** between two variables using their ranks rather than raw values.

### How It Works

1. Convert each variable to ranks
2. Calculate Pearson correlation on the ranks

### Formula

$$\rho = 1 - \frac{6 \sum{d_i^2}}{n(n^2 - 1)}$$

Where:
- $d_i$ is the difference between ranks for each observation
- $n$ is the number of observations

### Interpretation

Spearman uses the same scale as Pearson (-1 to +1) with similar interpretations, but measures **monotonic** relationships instead of strictly **linear** ones.

**Monotonic** means variables move in the same direction, but not necessarily at a constant rate.

### Advantages Over Pearson

✅ **Robust to outliers**: Extreme values have less influence
✅ **Works with ordinal data**: Suitable for ranked variables
✅ **Detects non-linear monotonic relationships**: Captures curved trends
✅ **No normality assumption**: Distribution-free method

### When to Use Spearman

✅ **Use Spearman when**:
- Variables are ordinal (e.g., satisfaction ratings 1-5)
- The relationship is monotonic but not linear
- Data has outliers
- Distribution is non-normal or unknown
- You want a robust alternative to Pearson

### Python Example

```python
import scipy.stats as stats

# Calculate Spearman correlation
spearman_r, spearman_p = stats.spearmanr(df['complaint_count'], df['crime_rate'])

print(f"Spearman ρ: {spearman_r:.3f}")
print(f"P-value: {spearman_p:.4f}")
```

## Pearson vs. Spearman: When Results Diverge

### Scenario 1: Non-Linear Relationship

```python
import numpy as np
import matplotlib.pyplot as plt

# Create non-linear data
x = np.linspace(0, 10, 100)
y = x ** 2  # Quadratic relationship

pearson_r, _ = stats.pearsonr(x, y)
spearman_r, _ = stats.spearmanr(x, y)

print(f"Pearson: {pearson_r:.3f}")   # ~0.97 (misses curvature)
print(f"Spearman: {spearman_r:.3f}")  # 1.00 (perfect monotonic)
```

**Interpretation**: Spearman correctly identifies the perfect monotonic relationship, while Pearson underestimates due to non-linearity.

### Scenario 2: Outliers

```python
# Data with outlier
df = pd.DataFrame({
    'x': [1, 2, 3, 4, 5, 6, 7, 8, 9, 100],  # Outlier at 100
    'y': [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]
})

pearson_r, _ = stats.pearsonr(df['x'], df['y'])
spearman_r, _ = stats.spearmanr(df['x'], df['y'])

print(f"Pearson: {pearson_r:.3f}")   # Heavily influenced by outlier
print(f"Spearman: {spearman_r:.3f}")  # Robust to outlier
```

**Interpretation**: Spearman is more robust because it uses ranks (100 becomes rank 10), while Pearson uses the raw value.

### Decision Rule

**If |Pearson r - Spearman ρ| > 0.1**:
- Investigate for outliers (create scatter plot)
- Check for non-linear relationships
- Consider transforming variables (log, sqrt)
- Report both values with explanation

## Statistical Significance (P-Values)

### What is a P-Value?

The **p-value** represents the probability of observing a correlation at least as extreme as the one calculated, assuming there is no true relationship (null hypothesis).

### Interpretation

| P-Value | Interpretation |
|---------|----------------|
| p < 0.001 | Highly significant (***) |
| p < 0.01 | Very significant (**) |
| p < 0.05 | Significant (*) |
| p ≥ 0.05 | Not statistically significant |

### Important Caveats

⚠️ **Significance ≠ Importance**: A correlation can be statistically significant but practically meaningless (e.g., r=0.05, p<0.001 with huge sample size)

⚠️ **Large N Problem**: With large datasets, even tiny correlations become significant

⚠️ **Multiple Testing**: Testing many correlations increases false positives (consider Bonferroni correction)

### Example Interpretation

```python
pearson_r, pearson_p = stats.pearsonr(df['x'], df['y'])

print(f"r = {pearson_r:.3f}, p = {pearson_p:.4f}")

# Good interpretation
if pearson_p < 0.05:
    if abs(pearson_r) > 0.5:
        print("Strong and statistically significant relationship")
    elif abs(pearson_r) > 0.3:
        print("Moderate and statistically significant relationship")
    else:
        print("Weak but statistically significant relationship (may not be practically important)")
else:
    print("No statistically significant relationship detected")
```

## Correlation ≠ Causation

### The Golden Rule

**Correlation measures association, not causation.**

### Classic Examples

#### 1. Ice Cream Sales and Drowning Deaths

- **Observation**: Strong positive correlation
- **Naive Interpretation**: Ice cream causes drowning
- **Reality**: Both are caused by a third variable (hot weather)

#### 2. Number of Firefighters and Fire Damage

- **Observation**: Positive correlation
- **Naive Interpretation**: More firefighters cause more damage
- **Reality**: Larger fires require more firefighters and cause more damage

### Confounding Variables

A **confounder** is a third variable that influences both X and Y, creating a spurious correlation.

**Example from Lab 1**:

- **X**: Number of 311 complaints in a borough
- **Y**: Airbnb prices
- **Observed Correlation**: Positive
- **Potential Confounder**: Population density
  - Dense areas have more complaints (more people)
  - Dense areas have higher prices (more demand)
  - Complaints may not cause higher prices

### Establishing Causation

To infer causation, you need:
1. **Temporal Precedence**: Cause precedes effect
2. **Covariation**: Variables are correlated
3. **No Alternative Explanations**: Controlled for confounders
4. **Mechanism**: Plausible explanation for how X causes Y

**In Observational Data** (like these labs): Correlation alone cannot prove causation. Always:
- List potential confounders
- Suggest controlled experiments
- Use cautious language ("associated with", "related to", not "causes")

## Creating Correlation Heatmaps

Heatmaps visualize multiple correlations simultaneously.

### Python Example

```python
import seaborn as sns
import matplotlib.pyplot as plt

# Calculate correlation matrix (Pearson by default)
corr_matrix = df[['price', 'reviews', 'complaints', 'crime', 'temperature']].corr()

# Create heatmap
plt.figure(figsize=(10, 8))
sns.heatmap(corr_matrix,
            annot=True,  # Show values
            cmap='coolwarm',  # Color scheme
            center=0,  # Center colormap at 0
            vmin=-1, vmax=1,  # Fix scale
            square=True)  # Square cells

plt.title('Correlation Heatmap: Pearson Coefficients')
plt.tight_layout()
plt.show()
```

### For Spearman Heatmap

```python
# Calculate Spearman correlations
corr_matrix_spearman = df[['price', 'reviews', 'complaints', 'crime', 'temperature']].corr(method='spearman')

# Plot
sns.heatmap(corr_matrix_spearman, annot=True, cmap='coolwarm', center=0, vmin=-1, vmax=1, square=True)
plt.title('Correlation Heatmap: Spearman Coefficients')
plt.show()
```

## Best Practices for Lab Exercises

### 1. Always Calculate Both Pearson and Spearman

```python
# Standard approach in labs
pearson_r, pearson_p = stats.pearsonr(df['x'], df['y'])
spearman_r, spearman_p = stats.spearmanr(df['x'], df['y'])

print(f"Pearson:  r = {pearson_r:.3f}, p = {pearson_p:.4f}")
print(f"Spearman: ρ = {spearman_r:.3f}, p = {spearman_p:.4f}")

if abs(pearson_r - spearman_r) > 0.1:
    print("⚠️ Significant divergence - investigate further")
```

### 2. Visualize Before Calculating

Always create a scatter plot first:

```python
import matplotlib.pyplot as plt

plt.scatter(df['x'], df['y'], alpha=0.5)
plt.xlabel('X Variable')
plt.ylabel('Y Variable')
plt.title('Scatter Plot: X vs Y')
plt.show()
```

Look for:
- Linear vs. non-linear patterns
- Outliers
- Homoscedasticity (constant variance)
- Clusters or subgroups

### 3. Report Results Properly

**Good Example**:

> "We observe a moderate positive Pearson correlation (r = 0.58, p < 0.001) between average temperature and Airbnb reviews per month. The Spearman correlation is slightly higher (ρ = 0.64, p < 0.001), suggesting some non-linearity. This relationship is statistically significant and suggests that warmer months are associated with increased review activity. However, this does not prove causation; potential confounders include holidays, school schedules, and other seasonal tourism drivers. Further analysis controlling for these factors would strengthen the finding."

**Poor Example**:

> "Temperature and reviews are correlated at 0.58, so warmer weather causes more reviews."

### 4. Check Assumptions

Before using Pearson, verify:

```python
import scipy.stats as stats

# Check for normality
stat, p = stats.shapiro(df['x'])
print(f"Shapiro-Wilk test for X: p = {p:.4f}")

stat, p = stats.shapiro(df['y'])
print(f"Shapiro-Wilk test for Y: p = {p:.4f}")

# If p > 0.05, data is approximately normal
# If p < 0.05, consider Spearman instead
```

### 5. Handle Missing Values

```python
# Correlations automatically drop missing values pairwise
# But you should document this

print(f"Total observations: {len(df)}")
print(f"Complete cases for X and Y: {df[['x', 'y']].dropna().shape[0]}")

# If significant missing data:
print("\n⚠️ Warning: {:.1f}% of data missing".format(
    (len(df) - df[['x', 'y']].dropna().shape[0]) / len(df) * 100
))
```

## Common Pitfalls

### 1. Simpson's Paradox

Correlation can reverse when data is aggregated differently.

**Example**:
- Overall negative correlation between study time and test scores
- But positive correlation within each difficulty level
- Explanation: Easy tests require less study, hard tests require more study

**Solution**: Always check correlations within subgroups.

### 2. Restriction of Range

Correlation appears weaker when range of values is restricted.

**Example**:
- True correlation between height and weight in general population: r = 0.7
- Correlation within only NBA players: r = 0.3 (restricted range)

**Solution**: Be aware of sample selection criteria.

### 3. Non-Linear Relationships

Pearson can be near zero even with strong non-linear relationships.

**Solution**: Always visualize data; consider transformations or Spearman.

### 4. Outlier Sensitivity

One extreme value can dominate Pearson correlation.

**Solution**: Identify outliers, consider Spearman, or use robust methods.

### 5. Temporal Autocorrelation

In time series, adjacent values are often correlated, inflating correlation estimates.

**Solution**: Use appropriate time series methods; check for lagged relationships.

## Advanced Topics (Optional)

### Partial Correlation

Controls for the effect of other variables.

```python
from scipy.stats import pearsonr
import numpy as np

# Calculate partial correlation between X and Y, controlling for Z
def partial_correlation(df, x, y, z):
    # Residuals of X regressing on Z
    x_resid = df[x] - np.polyval(np.polyfit(df[z], df[x], 1), df[z])
    # Residuals of Y regressing on Z
    y_resid = df[y] - np.polyval(np.polyfit(df[z], df[y], 1), df[z])
    # Correlation of residuals
    return pearsonr(x_resid, y_resid)
```

### Kendall's Tau

Alternative to Spearman for smaller samples.

```python
from scipy.stats import kendalltau

tau, p = kendalltau(df['x'], df['y'])
print(f"Kendall's τ: {tau:.3f}, p = {p:.4f}")
```

### Correlation with Categorical Variables

Use point-biserial correlation for binary categorical variables.

```python
from scipy.stats import pointbiserialr

# Y is continuous, X is binary (0/1)
r, p = pointbiserialr(df['is_borough_manhattan'], df['price'])
```

## Summary Checklist

When conducting correlation analysis in labs:

- [ ] Visualize data with scatter plots
- [ ] Calculate both Pearson and Spearman
- [ ] Report both coefficient and p-value
- [ ] Check for outliers and non-linearity
- [ ] Investigate if |Pearson - Spearman| > 0.1
- [ ] Identify potential confounders
- [ ] Use cautious causal language
- [ ] Document assumptions and limitations
- [ ] Create correlation heatmap for multiple variables
- [ ] Interpret practical significance, not just statistical

## References and Further Reading

- **Textbooks**:
  - "Statistics" by Freedman, Pisani, Purves
  - "Practical Statistics for Data Scientists" by Bruce & Bruce
  - "The Art of Statistics" by David Spiegelhalter

- **Online Resources**:
  - SciPy Stats Documentation: https://docs.scipy.org/doc/scipy/reference/stats.html
  - Khan Academy: Statistics and Probability
  - StatQuest with Josh Starmer (YouTube)

- **Key Papers**:
  - Spearman, C. (1904). "The proof and measurement of association between two things"
  - Pearson, K. (1895). "Note on regression and inheritance in the case of two parents"

---

**Ready to apply these concepts?** Return to your lab exercises and calculate correlations with confidence!
