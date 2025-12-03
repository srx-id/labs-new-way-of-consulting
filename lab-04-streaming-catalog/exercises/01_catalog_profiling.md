# Exercise 1: Catalog Profiling

**[Lab 4 Home](../README.md) > Exercise 1**

## Overview

You've been given Netflix catalog data and want to enrich it with detailed movie metadata from TMDb. Before you can match titles, you need to understand what you're working with.

**Time**: 30-45 minutes

## The Scenario

A streaming analytics company wants to:
- Enrich Netflix catalog with TMDb ratings and metadata
- Analyze content gaps between platforms
- Understand genre trends

Your first task: profile both datasets to understand the matching challenge.

---

## Task 1.1: Load and Profile Netflix Catalog

### What You Want to Achieve
Understand the structure and content of the Netflix dataset.

### The Vibe Coding Prompt

```
Load the Netflix catalog data from data/raw/netflix_titles.csv

Tell me:
1. How many titles total?
2. What columns are available?
3. Show 5 sample rows

Breakdown by type:
- How many Movies vs TV Shows?
- Percentage of each

Content overview:
- Date range (release_year)
- What genres are most common?
- Which countries produce most content?
- Any missing data in key columns?
```

### What to Look For
- **Title column**: This is what we'll match to TMDb
- **Release year**: Helps disambiguate titles with same name
- **Type**: Movies vs TV shows (TMDb handles these differently)

---

## Task 1.2: Load and Profile TMDb Data

### What You Want to Achieve
Understand the TMDb datasets you'll match against.

### The Vibe Coding Prompt

```
Load the TMDb movie data from data/raw/movies_metadata.csv

Tell me:
1. How many movies?
2. What columns are available?
3. Show 5 sample rows

Key columns to examine:
- title (what we'll match on)
- original_title (might be different)
- release_date (for disambiguation)
- popularity (for choosing best match)
- vote_average (what we want to enrich with)
- genres (interesting for analysis)

Data quality:
- Any missing titles?
- Any duplicate titles?
- Any weird characters in titles?
```

### Two TMDb Datasets?
You may have:
- `movies_metadata.csv` - Larger dataset
- `tmdb_5000_movies.csv` - Curated subset

```
If there are two TMDb datasets, profile both.
Which has more movies?
Which has cleaner data?
Which should we use for matching?
```

---

## Task 1.3: Analyze Title Overlap (Quick Check)

### What You Want to Achieve
Get an initial sense of how many exact matches exist.

### The Vibe Coding Prompt

```
Do a quick exact match check between Netflix and TMDb:

1. Extract just the titles from each dataset
2. Find exact matches (case-sensitive first)
3. Find exact matches (case-insensitive)
4. What percentage of Netflix titles have exact matches in TMDb?

Show me:
- 10 Netflix titles that DID match exactly
- 10 Netflix titles that did NOT match

What patterns do you notice in the non-matches?
Are they different spellings, punctuation, or completely missing?
```

### Expected Findings
You'll likely find that:
- Many titles DON'T match exactly
- Differences include: "The", punctuation, accents, spellings
- This is why we need fuzzy matching!

---

## Task 1.4: Identify Matching Challenges

### What You Want to Achieve
Document the specific issues that will make matching difficult.

### The Vibe Coding Prompt

```
Analyze why titles don't match:

1. The "The" problem:
   - How many Netflix titles start with "The "?
   - Do TMDb titles include or exclude "The"?
   - Example: "The Matrix" vs "Matrix"

2. Punctuation differences:
   - Colons, hyphens, apostrophes
   - Example: "Spider-Man" vs "Spiderman"

3. Special characters:
   - Accents (é, ñ, ü)
   - Example: "Amélie" vs "Amelie"

4. Subtitles in title:
   - "Movie Name: The Sequel"
   - Is the colon part handled differently?

5. Year/number suffixes:
   - "Mission Impossible 2" vs "Mission: Impossible II"

List 5 examples of each type of mismatch.
```

---

## Task 1.5: Profile Release Year Distribution

### What You Want to Achieve
Understand the year coverage of both datasets for disambiguation.

### The Vibe Coding Prompt

```
Compare release year distributions:

1. Netflix release year distribution:
   - Range (oldest to newest)
   - Most common decade
   - Histogram

2. TMDb release year distribution:
   - Range
   - Most common decade
   - Histogram

3. Overlap analysis:
   - What % of Netflix titles have release years in TMDb's range?
   - Any Netflix titles from years not in TMDb?

4. Same-title different-year:
   - How many titles appear in multiple years? (remakes)
   - Example: "A Star Is Born" (1937, 1954, 1976, 2018)

Create visualization comparing year distributions.
Save as visualizations/release_year_comparison.png
```

### Why Year Matters
Same title + same year = strong match signal
Same title + different year = might be wrong match!

---

## Task 1.6: Analyze Content Types

### What You Want to Achieve
Understand if content type affects our matching strategy.

### The Vibe Coding Prompt

```
Analyze content types for matching strategy:

1. Netflix content:
   - Movies vs TV Shows breakdown
   - Does title format differ?

2. TMDb content:
   - Is TMDb movies only, or also TV?
   - If movies only, we need separate TV matching

3. Implications:
   - Should we filter Netflix to movies only first?
   - What % of Netflix is matchable to TMDb movies?

4. TV show handling:
   - If TMDb has a separate TV dataset, note it
   - For now, focus on movies

Create a summary of content type implications for matching.
```

---

## Task 1.7: Create Profiling Summary

### What You Want to Achieve
Document all findings for reference during matching.

### The Vibe Coding Prompt

```
Create a profiling summary:

1. Dataset Overview:
   | Dataset | Records | Key Column | Date Range |
   | Netflix | X | title | YYYY-YYYY |
   | TMDb | Y | title | YYYY-YYYY |

2. Exact Match Baseline:
   - X% exact match (case-insensitive)
   - This is our "floor" - fuzzy matching should do better

3. Matching Challenges Identified:
   - Challenge 1: "The" prefix
   - Challenge 2: Punctuation
   - Challenge 3: Special characters
   - Challenge 4: etc.

4. Strategy Recommendations:
   - Filter Netflix to movies first
   - Normalize titles before matching
   - Use release year as secondary key
   - Consider popularity for tie-breaking

5. Data Quality Issues:
   - Nulls to handle
   - Duplicates to resolve
   - Encoding issues

Save as findings/01_profiling_summary.md
```

---

## Deliverables Checklist

After completing this exercise, you should have:

- [ ] Netflix catalog profiled (count, types, years)
- [ ] TMDb data profiled (count, columns, years)
- [ ] Exact match baseline established
- [ ] Matching challenges documented
- [ ] `visualizations/release_year_comparison.png`
- [ ] Content type implications understood
- [ ] `findings/01_profiling_summary.md`

---

## Key Vocabulary for Vibe Coding

When profiling catalog data, these keywords help:

| What You Want | Keywords to Use |
|---------------|-----------------|
| Count records | "how many", "total count", "breakdown" |
| Check overlap | "exact match", "common values", "intersection" |
| See distribution | "distribution", "histogram", "value counts" |
| Find issues | "missing values", "duplicates", "special characters" |

---

## Common Issues and How to Fix Them

**If file encoding fails:**
```
The file has encoding errors.
Try loading with encoding='latin-1' or encoding='cp1252'.
Show me the first few rows that fail.
```

**If genres are in weird format:**
```
Genres show as "[{'id': 28, 'name': 'Action'}]"
This is JSON in a column. Parse it to extract genre names.
```

**If release dates are inconsistent:**
```
Some release_date values are "2019-01-15" and some are "2019".
Standardize to just the year for matching.
```

---

## What's Next?

Now that you understand both datasets, Exercise 2 will teach you how to **implement fuzzy matching** to find the best TMDb match for each Netflix title.

---

[Lab 4 Home](../README.md) | [Next: Fuzzy Matching →](./02_fuzzy_matching.md)
