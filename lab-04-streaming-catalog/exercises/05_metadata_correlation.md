# Exercise 5: Metadata Correlation Analysis

**[Lab 4 Home](../README.md) > Exercise 5**

## Overview

You've enriched Netflix with TMDb data - now it's time to **discover insights**! This exercise analyzes correlations between Netflix catalog patterns and TMDb metrics to find interesting content patterns.

**Time**: 90-120 minutes

## The Business Questions

> "What patterns exist in Netflix's content library? Are there relationships between popularity, ratings, genres, and availability?"

Your analysis will reveal:
- What types of content Netflix prioritizes
- How Netflix selection correlates with quality
- Genre trends and gaps

---

## Task 5.1: Analyze Netflix Selection Criteria

### What You Want to Achieve
Understand what types of movies Netflix has selected.

### The Vibe Coding Prompt

```
Analyze Netflix content selection patterns:

1. Rating distribution:
   - Average TMDb rating for Netflix movies
   - Compare to overall TMDb average
   - Does Netflix pick higher-rated movies?

2. Popularity comparison:
   - Average TMDb popularity for Netflix titles
   - Is Netflix biased toward popular movies?

3. Year distribution:
   - What release years does Netflix favor?
   - Recent vs classic movies?
   - Decade breakdown

4. Create visualization:
   - Scatter plot: TMDb rating vs Netflix presence
   - Histogram: Year distribution of Netflix vs all TMDb

Save as visualizations/netflix_selection_patterns.png
```

### Hypothesis Testing
```
Hypothesis: Netflix selects above-average movies.
Test: Compare mean TMDb rating of Netflix titles vs all TMDb titles.
If Netflix average is significantly higher, hypothesis confirmed.
```

---

## Task 5.2: Correlate Ratings with Netflix Metrics

### What You Want to Achieve
Find relationships between TMDb ratings and Netflix data.

### The Vibe Coding Prompt

```
Analyze correlations with TMDb ratings:

1. Genre vs Rating:
   - Average TMDb rating by Netflix genre
   - Which genres rate highest?
   - Which rate lowest?

2. Country vs Rating:
   - Average rating by production country
   - Top 10 countries by movie count
   - Is there a quality difference?

3. Year vs Rating:
   - Rating trend over time
   - Are newer movies rated higher or lower?
   - Any decade sweet spots?

4. Calculate correlations:
   - Rating vs popularity
   - Rating vs vote count
   - Any surprising correlations?

Create multi-panel visualization of key findings.
Save as visualizations/rating_correlations.png
```

---

## Task 5.3: Analyze Genre Patterns

### What You Want to Achieve
Deep dive into genre distribution and quality.

### The Vibe Coding Prompt

```
Analyze genre patterns in enriched data:

1. Genre frequency:
   - Most common Netflix genres
   - Most common TMDb genres
   - Genre mapping (Netflix → TMDb)

2. Genre quality:
   - Average TMDb rating per genre
   - Average popularity per genre
   - Which genres have the most votes?

3. Genre combinations:
   - Most common genre pairs
   - Do multi-genre movies rate differently?
   - Drama+Comedy vs pure Drama

4. Genre gaps:
   - TMDb genres that Netflix has few of
   - Potential content acquisition opportunities

Create genre heatmap or treemap.
Save as visualizations/genre_analysis.png
```

---

## Task 5.4: Analyze Temporal Patterns

### What You Want to Achieve
Find patterns in when movies were released and added.

### The Vibe Coding Prompt

```
Analyze temporal patterns:

1. Netflix additions by year (if date_added available):
   - When did Netflix add most content?
   - Growth pattern over time

2. Release year distribution:
   - How old is Netflix's content?
   - Median and mode release year
   - Classic (pre-2000) vs modern (post-2010)

3. Age vs Quality:
   - Do older Netflix movies have higher ratings?
   - (Survivorship bias - only classics survive)

4. Recency bias:
   - What % of Netflix catalog is < 5 years old?
   - Is Netflix favoring recent content?

Create time-based visualizations.
Save as visualizations/temporal_patterns.png
```

---

## Task 5.5: Compare Netflix Originals vs Licensed

### What You Want to Achieve
Analyze whether Netflix Originals differ from licensed content.

### The Vibe Coding Prompt

```
Compare Netflix Originals to licensed content:

1. Identify Netflix Originals:
   - Look for "Netflix" in description or tags
   - How many titles are Originals?

2. Compare metrics:
   | Metric | Originals | Licensed |
   | Average Rating | X | Y |
   | Average Popularity | X | Y |
   | Median Budget | X | Y |

3. Genre differences:
   - What genres do Originals favor?
   - Different from licensed content?

4. Quality comparison:
   - Do Originals rate better or worse?
   - More or less popular?

Note: Originals may not all be in TMDb, so this might be partial.

Create comparison visualization.
Save as visualizations/originals_vs_licensed.png
```

---

## Task 5.6: Build Content Profile Dashboard

### What You Want to Achieve
Create a summary dashboard of catalog insights.

### The Vibe Coding Prompt

```
Create a content profile dashboard:

Panel 1: Volume Metrics
- Total titles enriched
- By type (Movie vs TV)
- By quality tier

Panel 2: Quality Metrics
- Average TMDb rating
- Rating distribution
- Vote count distribution

Panel 3: Genre Mix
- Top 10 genres by count
- Genre quality scores
- Underserved genres

Panel 4: Temporal View
- Release year distribution
- Age of catalog
- Recent vs classic mix

Combine into a 2x2 dashboard visualization.
Save as visualizations/catalog_dashboard.png
```

---

## Task 5.7: Identify Content Opportunities

### What You Want to Achieve
Find potential gaps and opportunities in the catalog.

### The Vibe Coding Prompt

```
Identify content opportunities:

1. High-rated missing titles:
   - TMDb movies with rating > 8 NOT on Netflix
   - What genres are missing?

2. Popular missing titles:
   - High popularity in TMDb but not Netflix
   - Recent releases gaps

3. Genre underserved:
   - Compare Netflix genre mix to TMDb universe
   - Genres with low Netflix coverage

4. Quality opportunities:
   - Genres where Netflix content rates lower than TMDb average
   - Room for better content

Create recommendations:
- Top 10 genres for content acquisition
- Types of content that could improve average quality

Save as findings/content_opportunities.md
```

---

## Task 5.8: Create Executive Summary

### What You Want to Achieve
Deliver final insights from the enrichment project.

### The Vibe Coding Prompt

```
Create executive summary of catalog analysis:

1. Project Overview:
   - Netflix titles analyzed: X
   - Successfully enriched: Y (Z%)
   - High-confidence matches: W%

2. Key Findings:

   Finding 1: Netflix Content Quality
   - Average TMDb rating: X.X vs TMDb universe: X.X
   - Interpretation: Netflix picks [above/below] average

   Finding 2: Genre Strategy
   - Dominant genres: ...
   - Quality leaders: ...
   - Underserved: ...

   Finding 3: Temporal Strategy
   - Catalog age profile
   - Recent vs classic mix

   Finding 4: Originals Performance
   - How Originals compare to licensed

3. Recommendations:
   - Content acquisition priorities
   - Genre expansion opportunities
   - Quality improvement areas

4. Methodology Notes:
   - Matching approach
   - Confidence levels
   - Known limitations

Save as findings/executive_summary.md
```

---

## Task 5.9: Final Deliverables

### What You Want to Achieve
Package everything for delivery.

### The Vibe Coding Prompt

```
Finalize all Lab 4 deliverables:

1. Data files:
   - data/processed/netflix_enriched_final.csv
   - data/processed/match_results.csv
   - data/processed/genre_analysis.csv

2. Visualizations:
   - visualizations/netflix_selection_patterns.png
   - visualizations/rating_correlations.png
   - visualizations/genre_analysis.png
   - visualizations/temporal_patterns.png
   - visualizations/catalog_dashboard.png

3. Findings:
   - findings/entity_resolution_methodology.md
   - findings/content_opportunities.md
   - findings/executive_summary.md

Create checklist confirming all deliverables are complete.
```

---

## Deliverables Checklist

After completing this exercise, you should have:

- [ ] Netflix selection patterns analyzed
- [ ] Rating correlations calculated
- [ ] Genre analysis completed
- [ ] Temporal patterns documented
- [ ] Originals vs licensed compared
- [ ] Content opportunities identified
- [ ] `visualizations/netflix_selection_patterns.png`
- [ ] `visualizations/rating_correlations.png`
- [ ] `visualizations/genre_analysis.png`
- [ ] `visualizations/temporal_patterns.png`
- [ ] `visualizations/catalog_dashboard.png`
- [ ] `findings/content_opportunities.md`
- [ ] `findings/executive_summary.md`

---

## Key Vocabulary for Vibe Coding

When analyzing catalog metadata, these keywords help:

| What You Want | Keywords to Use |
|---------------|-----------------|
| Compare groups | "by genre", "by year", "compare Originals to licensed" |
| Find patterns | "trend", "correlation", "relationship" |
| Identify gaps | "missing", "underserved", "opportunity" |
| Summarize | "average by", "distribution of", "profile" |

---

## Common Issues and How to Fix Them

**If comparison seems biased:**
```
Netflix average rating is 7.5 but all movies is 5.2.
This might be because:
- We only matched popular movies (which rate higher)
- Unmatched titles might be lower quality
- Acknowledge selection bias in findings.
```

**If genres don't match up:**
```
Can't compare Netflix genres to TMDb genres.
They use different naming conventions.
Create a genre mapping table:
Netflix "Thrillers" = TMDb "Thriller"
```

**If "Originals" detection is unreliable:**
```
Can't clearly identify Netflix Originals in the data.
Options:
- Search for "Netflix" in description
- Look for dates around 2015+ (when Originals started)
- Note limitation and analyze what we can identify
```

---

## Congratulations!

You've completed Lab 4! You now know how to:
- Profile catalog datasets
- Implement fuzzy string matching
- Resolve entity matching conflicts
- Validate data enrichment
- Analyze metadata correlations
- Find content opportunities

**Next Step**: [Lab 5: NYC Mobility](../../lab-05-nyc-mobility-externalities/README.md) will teach you how to handle very large datasets with chunking strategies.

---

[← Previous: Enrichment Validation](./04_enrichment_validation.md) | [Lab 4 Home](../README.md)
