# Visualizations Folder

This folder contains charts and graphs that communicate insights to clients.

## Visualization Philosophy (From Playbook)

**Every visualization must answer a specific business question.** No exploratory charts in client deliverables.

### Good Visualization Principles

1. **Clear Title**: State the insight, not just the data
   - ❌ "Price vs Crime Rate"
   - ✅ "Higher Crime Neighborhoods Command 15% Lower Prices"

2. **Business Context**: Use client-friendly language
   - ❌ "Pearson r = -0.52, p < 0.01"
   - ✅ "Strong negative relationship (statistically significant)"

3. **Action-Oriented**: What should client do with this?
   - Add annotation: "Target neighborhoods with <50 crimes/month"

4. **Professional Aesthetics**: Clean, branded, print-ready
   - Use consistent color palette
   - Remove chart junk (unnecessary gridlines, borders)
   - Export high resolution (300 DPI)

## Expected Visualizations

### 1. Correlation Heatmap (`correlation_heatmap.png`)
**Business Question**: Which neighborhood metrics are most strongly associated with Airbnb performance?

**Chart Type**: Heatmap (Seaborn)
- Rows/Columns: Price, Reviews, Complaints, Crime, Temperature, Precipitation
- Color scale: Red (negative) → White (zero) → Blue (positive)
- Annotations: Show correlation coefficients
- Callout: Highlight strongest correlations (|r| > 0.5)

### 2. Price vs Crime Scatter (`price_vs_crime_scatter.png`)
**Business Question**: How much does crime rate affect pricing power?

**Chart Type**: Scatter plot with trend line
- X-axis: Crime count per borough-month
- Y-axis: Average Airbnb price
- Color: Borough (5 distinct colors)
- Trend line: Show negative correlation
- Annotation: Slope interpretation ("$5 decrease per 10 crimes")

### 3. Seasonality Trends (`seasonality_trends.png`)
**Business Question**: When should we expect peak demand and pricing?

**Chart Type**: Multi-line time series
- X-axis: Month (Jan-Dec 2019)
- Y-axis (dual): Price (left), Review volume (right)
- Lines: Price (solid), Reviews (dashed), Temperature (dotted)
- Shaded regions: Peak seasons (May-Sep)
- Annotation: "Summer months show 20% price premium"

### 4. Borough Comparison (`borough_comparison.png`)
**Business Question**: Which boroughs offer best risk-adjusted returns?

**Chart Type**: Small multiples (faceted bar charts)
- Facets: 5 boroughs (one panel each)
- Bars: Price, Crime, Complaints (standardized/normalized)
- Sort: By average price (Manhattan → Staten Island)
- Annotation: "Manhattan: High price, high complaints"

## Python Visualization Template

```python
import matplotlib.pyplot as plt
import seaborn as sns

# Set publication-quality style
sns.set_style("whitegrid")
plt.rcParams['figure.dpi'] = 300
plt.rcParams['font.family'] = 'sans-serif'

# Create figure
fig, ax = plt.subplots(figsize=(10, 6))

# Your plot code here
sns.scatterplot(data=df, x='crime_count', y='avg_price', hue='borough', ax=ax)

# Business-focused title
ax.set_title('Higher Crime Neighborhoods Command 15% Lower Prices\nNYC Airbnb Analysis (2019)',
             fontsize=14, fontweight='bold')

# Clean labels
ax.set_xlabel('Crime Incidents per Borough-Month', fontsize=12)
ax.set_ylabel('Average Nightly Price ($)', fontsize=12)

# Add trend line
sns.regplot(data=df, x='crime_count', y='avg_price', scatter=False, ax=ax, color='red')

# Save high-res
plt.tight_layout()
plt.savefig('visualizations/price_vs_crime_scatter.png', dpi=300, bbox_inches='tight')
print("✓ Saved: visualizations/price_vs_crime_scatter.png")
```

## Visualization Checklist

Before saving a chart for client delivery:

- [ ] Title states an insight, not just data description
- [ ] Axes have clear, business-friendly labels (not code variable names)
- [ ] Legend is positioned clearly (not overlapping data)
- [ ] Color palette is colorblind-friendly
- [ ] Font sizes are readable (minimum 10pt)
- [ ] Chart has a clear "so what" message
- [ ] File saved at 300 DPI
- [ ] File name is descriptive (not "chart1.png")

## File Naming Conventions

- Use descriptive names: `price_vs_crime_scatter.png` (not `viz1.png`)
- Include chart type if helpful: `correlation_heatmap.png`
- Version if iterating: `seasonality_v2.png`
- Export format: PNG for presentations, PDF for reports

## Recommended Libraries

```python
import matplotlib.pyplot as plt  # Core plotting
import seaborn as sns            # Statistical visualizations
import pandas as pd              # Data manipulation
```

**Optional** (for interactive dashboards in separate boilerplate repo):
- Streamlit (covered in boilerplate repo)
- Plotly (interactive charts)

---

**Remember**: Client pays for insights, not charts. Every visualization must drive a business decision.
