# Exercise 5: Correlation Analysis & Visualization

**[Lab 1 Home](../README.md) > Exercise 5**

## Objectives

✅ Calculate Pearson and Spearman correlations
✅ Identify statistically significant relationships
✅ **Create client-ready visualizations** (correlation heatmap, scatter plots, trend charts)
✅ Write executive summary with "So What" insights
✅ Deliver actionable recommendations

**Estimated Time**: 90-120 minutes

## Business Question (From Client)

"What neighborhood characteristics should we weight most heavily when evaluating Airbnb investment opportunities?"

## Tasks

### Task 5.1: Calculate Correlations

Load your final dataset from Exercise 4:

```python
import pandas as pd
import numpy as np
from scipy import stats

# Load final joined dataset
df = pd.read_csv('../data/processed/final_dataset.csv')

# Calculate Pearson correlations
variables = ['avg_price', 'median_reviews_per_month', 'complaint_count',
             'crime_count', 'avg_temp', 'total_precip']

correlation_pearson = df[variables].corr(method='pearson')
correlation_spearman = df[variables].corr(method='spearman')

# Save correlation matrices
correlation_pearson.to_csv('../data/processed/correlation_matrix_pearson.csv')
correlation_spearman.to_csv('../data/processed/correlation_matrix_spearman.csv')

print("✓ Saved correlation matrices")
```

### Task 5.2: Extract Significant Correlations

Identify which correlations are statistically significant (p < 0.05):

```python
# Calculate p-values for all pairs
from itertools import combinations

significant_correlations = []

for var1, var2 in combinations(variables, 2):
    pearson_r, pearson_p = stats.pearsonr(df[var1], df[var2])
    spearman_r, spearman_p = stats.spearmanr(df[var1], df[var2])

    if pearson_p < 0.05:  # Statistically significant
        significant_correlations.append({
            'Variable_1': var1,
            'Variable_2': var2,
            'Pearson_r': round(pearson_r, 3),
            'Pearson_p': round(pearson_p, 4),
            'Spearman_r': round(spearman_r, 3),
            'Spearman_p': round(spearman_p, 4),
            'Strength': 'Strong' if abs(pearson_r) > 0.5 else 'Moderate' if abs(pearson_r) > 0.3 else 'Weak',
            'Direction': 'Positive' if pearson_r > 0 else 'Negative'
        })

df_sig = pd.DataFrame(significant_correlations)
df_sig.to_csv('../data/processed/significant_correlations.csv', index=False)

print(f"✓ Found {len(significant_correlations)} significant correlations")
print("\nTop 3 Strongest Correlations:")
print(df_sig.nlargest(3, 'Pearson_r')[['Variable_1', 'Variable_2', 'Pearson_r', 'Strength']])
```

### Task 5.3: Create Correlation Heatmap

**Business Question**: Which metrics are most strongly related?

```python
import matplotlib.pyplot as plt
import seaborn as sns

# Set professional style
sns.set_style("white")
plt.rcParams['figure.dpi'] = 300

# Create figure with two subplots (Pearson and Spearman)
fig, axes = plt.subplots(1, 2, figsize=(16, 6))

# Pearson heatmap
sns.heatmap(correlation_pearson, annot=True, cmap='coolwarm', center=0,
            vmin=-1, vmax=1, square=True, ax=axes[0],
            cbar_kws={'label': 'Correlation Coefficient'})
axes[0].set_title('Pearson Correlation: Neighborhood Metrics\nLinear Relationships',
                  fontsize=14, fontweight='bold')

# Spearman heatmap
sns.heatmap(correlation_spearman, annot=True, cmap='coolwarm', center=0,
            vmin=-1, vmax=1, square=True, ax=axes[1],
            cbar_kws={'label': 'Correlation Coefficient'})
axes[1].set_title('Spearman Correlation: Neighborhood Metrics\nMonotonic Relationships',
                  fontsize=14, fontweight='bold')

plt.tight_layout()
plt.savefig('../visualizations/correlation_heatmap.png', dpi=300, bbox_inches='tight')
print("✓ Saved: visualizations/correlation_heatmap.png")
```

### Task 5.4: Price vs Crime Scatter Plot

**Business Question**: How much does crime affect pricing power?

```python
# Create scatter plot
fig, ax = plt.subplots(figsize=(10, 6))

# Scatter with borough colors
for borough in df['borough'].unique():
    borough_data = df[df['borough'] == borough]
    ax.scatter(borough_data['crime_count'], borough_data['avg_price'],
               label=borough, alpha=0.6, s=100)

# Add trend line
z = np.polyfit(df['crime_count'], df['avg_price'], 1)
p = np.poly1d(z)
x_trend = np.linspace(df['crime_count'].min(), df['crime_count'].max(), 100)
ax.plot(x_trend, p(x_trend), "r--", linewidth=2, alpha=0.8, label='Trend')

# Calculate correlation for title
r, p_val = stats.pearsonr(df['crime_count'], df['avg_price'])

# Title with insight
ax.set_title(f'Higher Crime Areas Show Lower Prices (r = {r:.2f}, p < 0.01)\n' +
             f'NYC Airbnb Analysis: Borough-Month Level (2019)',
             fontsize=14, fontweight='bold')

ax.set_xlabel('Crime Incidents per Borough-Month', fontsize=12)
ax.set_ylabel('Average Nightly Price ($)', fontsize=12)
ax.legend(title='Borough', loc='upper right')
ax.grid(True, alpha=0.3)

# Add annotation with business insight
slope = z[0]
ax.annotate(f'Every 10 crimes/month\nassociated with ${abs(slope*10):.0f} lower price',
            xy=(0.7, 0.95), xycoords='axes fraction',
            bbox=dict(boxstyle='round', facecolor='wheat', alpha=0.8),
            fontsize=10)

plt.tight_layout()
plt.savefig('../visualizations/price_vs_crime_scatter.png', dpi=300, bbox_inches='tight')
print("✓ Saved: visualizations/price_vs_crime_scatter.png")
```

### Task 5.5: Seasonality Trends

**Business Question**: When should we expect peak demand?

```python
# Aggregate by month (across boroughs)
monthly = df.groupby('year_month').agg({
    'avg_price': 'mean',
    'median_reviews_per_month': 'mean',
    'avg_temp': 'mean'
}).reset_index()

# Extract month for x-axis
monthly['month'] = pd.to_datetime(monthly['year_month'] + '-01').dt.month
monthly = monthly.sort_values('month')

# Create figure with dual y-axis
fig, ax1 = plt.subplots(figsize=(12, 6))
ax2 = ax1.twinx()

# Plot price and reviews
line1 = ax1.plot(monthly['month'], monthly['avg_price'],
                 marker='o', color='#2E86AB', linewidth=2, label='Avg Price')
line2 = ax2.plot(monthly['month'], monthly['median_reviews_per_month'],
                 marker='s', color='#A23B72', linewidth=2, label='Reviews/Month')

# Temperature as background
ax3 = ax1.twinx()
ax3.spines['right'].set_position(('outward', 60))
line3 = ax3.plot(monthly['month'], monthly['avg_temp'],
                 linestyle='--', color='#F18F01', linewidth=1.5, alpha=0.7, label='Temperature')

# Labels
ax1.set_xlabel('Month (2019)', fontsize=12)
ax1.set_ylabel('Average Price ($)', fontsize=12, color='#2E86AB')
ax2.set_ylabel('Reviews per Month', fontsize=12, color='#A23B72')
ax3.set_ylabel('Temperature (°F)', fontsize=12, color='#F18F01')

# Title with insight
ax1.set_title('Summer Months Drive 20% Higher Review Activity\n' +
              'NYC Airbnb Seasonality Analysis (2019)',
              fontsize=14, fontweight='bold')

# Month labels
month_labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
ax1.set_xticks(range(1, 13))
ax1.set_xticklabels(month_labels)

# Highlight peak season
ax1.axvspan(6, 9, alpha=0.1, color='green', label='Peak Season')

# Legend
lines = line1 + line2 + line3
labels = [l.get_label() for l in lines]
ax1.legend(lines, labels, loc='upper left')

plt.tight_layout()
plt.savefig('../visualizations/seasonality_trends.png', dpi=300, bbox_inches='tight')
print("✓ Saved: visualizations/seasonality_trends.png")
```

### Task 5.6: Write Executive Summary

Create `../findings/executive_summary.md` answering the client's question.

**Template**: See [findings/README.md](../findings/README.md) for structure.

**Key Sections**:
1. **Executive Summary** (2-3 sentences): What are the top 3 drivers of Airbnb performance?
2. **Key Findings** (3-4 findings): Each with correlation, business impact, and "So What"
3. **Recommendations** (4-5 actions): What should client do?
4. **Supporting Evidence**: Reference your visualizations
5. **Confidence & Limitations**: Be honest about data constraints

**Example Finding Format**:

```markdown
### 1. Crime Impact on Pricing (Strongest Predictor)
- **Correlation**: Strong negative (r = -0.52, p < 0.01)
- **Business Impact**: Every 10 crimes/month associated with $8 lower nightly price
- **So What**: Prioritize neighborhoods with <50 crimes/month for premium positioning
- **Evidence**: See `visualizations/price_vs_crime_scatter.png`
```

### Task 5.7: Create Correlation Insights CSV

For client's easy reference, create a business-friendly summary:

```python
# Build insights table
insights = []

for idx, row in df_sig.iterrows():
    var1_clean = row['Variable_1'].replace('_', ' ').title()
    var2_clean = row['Variable_2'].replace('_', ' ').title()

    # Business interpretation
    if 'price' in row['Variable_1'].lower():
        if row['Direction'] == 'Negative':
            implication = f"Higher {var2_clean} → Lower prices"
        else:
            implication = f"Higher {var2_clean} → Higher prices"
    elif 'review' in row['Variable_1'].lower():
        if row['Direction'] == 'Negative':
            implication = f"Higher {var2_clean} → Lower demand"
        else:
            implication = f"Higher {var2_clean} → Higher demand"
    else:
        implication = f"{row['Strength']} {row['Direction'].lower()} relationship"

    insights.append({
        'Relationship': f"{var1_clean} vs {var2_clean}",
        'Correlation': f"{row['Pearson_r']} ({row['Strength']})",
        'P_Value': row['Pearson_p'],
        'Statistical_Significance': 'Yes' if row['Pearson_p'] < 0.05 else 'No',
        'Business_Implication': implication,
        'Action': 'Include in investment model' if abs(row['Pearson_r']) > 0.4 else 'Monitor but lower priority'
    })

df_insights = pd.DataFrame(insights)
df_insights.to_csv('../data/processed/correlation_insights.csv', index=False)

print("✓ Saved: data/processed/correlation_insights.csv")
print("\nTop Insights:")
print(df_insights[['Relationship', 'Correlation', 'Business_Implication']].head())
```

## Deliverables Checklist

Before considering this exercise complete, verify:

- [ ] `data/processed/correlation_matrix_pearson.csv` - Pearson correlations
- [ ] `data/processed/correlation_matrix_spearman.csv` - Spearman correlations
- [ ] `data/processed/significant_correlations.csv` - Filtered significant relationships
- [ ] `data/processed/correlation_insights.csv` - Business-friendly summary
- [ ] `visualizations/correlation_heatmap.png` - Pearson & Spearman comparison
- [ ] `visualizations/price_vs_crime_scatter.png` - Crime impact on pricing
- [ ] `visualizations/seasonality_trends.png` - Monthly demand patterns
- [ ] `findings/executive_summary.md` - 1-page client brief with "So What"

## Validation

### Statistical Validation
- All correlations between -1 and +1
- P-values calculated for all pairs
- Pearson and Spearman compared (divergence > 0.1 investigated)

### Business Validation
- Every finding translates to business impact
- Recommendations are specific and actionable
- Limitations acknowledged (2019 data, borough grain, correlation ≠ causation)

### Visualization Validation
- Every chart has business-focused title (insight, not description)
- Axes labeled clearly (no code variable names)
- High resolution (300 DPI)
- Color-blind friendly palette

## Interpretation Framework

For each significant correlation, answer:

1. **What**: Correlation coefficient and strength
2. **Confidence**: P-value and significance
3. **Comparison**: Pearson vs Spearman (linear vs monotonic)
4. **Business Impact**: Translate to $ or % terms
5. **So What**: Specific action client should take
6. **Caveats**: Confounders, limitations, alternative explanations

---

**Remember**: Client hired you to think, not just calculate. Your executive summary is the deliverable, not the correlation matrix.

[← Exercise 4](./04_dataset_joining.md) | [Lab 1 Home](../README.md)
