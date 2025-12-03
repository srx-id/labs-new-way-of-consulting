# Exercise 4: Enrichment Validation

**[Lab 4 Home](../README.md) > Exercise 4**

## Overview

You've matched Netflix titles to TMDb - now you need to **validate the enrichment** by joining the metadata and checking that everything makes sense.

**Time**: 45-60 minutes

## The Goal

Enrich Netflix catalog with TMDb metadata:
- Ratings (vote_average)
- Popularity score
- Genre details
- Budget and revenue
- Production information

Then validate it all makes sense!

---

## Task 4.1: Join Matched Data

### What You Want to Achieve
Combine Netflix and TMDb data using your matches.

### The Vibe Coding Prompt

```
Join Netflix data with TMDb data using match results:

1. Load:
   - Netflix original data
   - TMDb metadata
   - Match results (from Exercise 3)

2. Join on:
   - Netflix: netflix_id
   - Match: netflix_id → tmdb_id
   - TMDb: tmdb_id (or id)

3. Select columns to keep:
   From Netflix:
   - title, type, release_year, country, listed_in (genres)

   From TMDb:
   - vote_average, vote_count, popularity
   - budget, revenue
   - genres, runtime
   - original_language

4. Create enriched dataset:
   - How many rows?
   - What % of Netflix is now enriched?

Save as data/processed/netflix_enriched.csv
```

---

## Task 4.2: Validate Genre Consistency

### What You Want to Achieve
Check if Netflix genres align with TMDb genres.

### The Vibe Coding Prompt

```
Validate genre enrichment:

1. Compare Netflix genres vs TMDb genres:
   - Netflix: "listed_in" column
   - TMDb: "genres" column

2. For matched titles:
   - Do the genres overlap?
   - Show 10 examples where they match well
   - Show 10 examples where they differ

3. Genre mapping analysis:
   - Most common Netflix genres
   - Most common TMDb genres
   - Any systematic differences?

4. Potential issues:
   - Netflix says "Comedy" but TMDb says "Drama"
   - Could indicate wrong match
   - How many have zero genre overlap?

Create visualization comparing genre distributions.
Save as visualizations/genre_comparison.png
```

### Genre as Validation Signal
```
If genres completely disagree, it might be a wrong match:
- Netflix: "Horror, Thriller" matched to TMDb: "Romantic Comedy"
- This should trigger a review

Some disagreement is OK (genre definitions vary).
```

---

## Task 4.3: Validate Year Alignment

### What You Want to Achieve
Confirm release years are consistent.

### The Vibe Coding Prompt

```
Validate year alignment:

1. Compare Netflix year vs TMDb year:
   - Calculate year difference for all matches
   - Distribution of differences

2. Acceptable vs concerning:
   - Exact match: Perfect
   - Off by 1: Usually OK (release date quirks)
   - Off by 2-3: Check if remake
   - Off by 5+: Likely wrong match

3. Investigate big mismatches:
   - Show all matches where year differs by 5+
   - Are these errors or legitimate (remakes)?

4. Error rate estimate:
   - What % of matches have year mismatch > 2?
   - These need review

Create histogram of year differences.
Save as visualizations/year_alignment.png
```

---

## Task 4.4: Validate Rating Distribution

### What You Want to Achieve
Check if enriched ratings look reasonable.

### The Vibe Coding Prompt

```
Validate TMDb ratings for enriched titles:

1. Rating distribution:
   - Average vote_average for our matches
   - Histogram of ratings
   - Does it look like a typical movie rating curve?

2. Suspicious patterns:
   - Any ratings of exactly 0 or 10?
   - Very low vote counts (<10) might be unreliable
   - Any missing ratings?

3. Compare to TMDb overall:
   - Our enriched titles average rating: X
   - All TMDb movies average: Y
   - Are we biased toward popular/well-rated movies?

4. Netflix genres vs TMDb ratings:
   - Average TMDb rating by Netflix genre
   - Any surprising findings?

Create rating distribution visualization.
Save as visualizations/rating_distribution.png
```

---

## Task 4.5: Check for Enrichment Gaps

### What You Want to Achieve
Identify what metadata is missing after enrichment.

### The Vibe Coding Prompt

```
Analyze enrichment completeness:

1. For each TMDb column, check null rate:
   | Column | Non-null | Null | % Missing |
   | vote_average | X | Y | Z% |
   | budget | ... | ... | ... |

2. Budget/revenue special case:
   - Many movies have 0 budget (missing, not free)
   - How many have budget > 0?
   - How many have revenue > 0?

3. Vote count quality:
   - How many have < 10 votes (unreliable)?
   - How many have > 1000 votes (solid)?

4. Runtime:
   - Any suspiciously short (<30 min)?
   - Any suspiciously long (>300 min)?
   - (Might indicate TV shows matched to movies)

Document enrichment gaps and data quality issues.
```

---

## Task 4.6: Cross-Validate with Logic Checks

### What You Want to Achieve
Apply common-sense validation rules.

### The Vibe Coding Prompt

```
Apply logical validation checks:

1. Budget vs Revenue:
   - Revenue should usually be > 0 if budget > 0
   - Major movies: revenue >> budget (hopefully!)
   - Red flag: Budget $100M but revenue $0

2. Vote count vs popularity:
   - High vote count should correlate with higher popularity
   - Check correlation

3. Runtime vs type:
   - Movies typically 80-180 minutes
   - TV episodes are shorter
   - If Netflix "Movie" has 25 min runtime = possible mismatch

4. Release year vs production:
   - Movie from 1950 shouldn't have $500M budget
   - Check for anachronistic data

Flag any records that fail logical checks.
Create validation report.
```

---

## Task 4.7: Calculate Enrichment Quality Score

### What You Want to Achieve
Summarize the overall quality of the enrichment.

### The Vibe Coding Prompt

```
Calculate overall enrichment quality:

1. Coverage metrics:
   - % of Netflix catalog enriched
   - % with complete TMDb data (no nulls in key fields)
   - % with reliable ratings (vote_count > 50)

2. Accuracy estimate (from validation):
   - Genre overlap rate
   - Year alignment rate
   - Logical check pass rate

3. Quality tiers:
   - Gold: Complete data + high confidence match + passed all checks
   - Silver: Most data + good match + minor issues
   - Bronze: Partial data or lower confidence
   - Flagged: Issues detected, needs review

4. Create quality score for each enriched record:
   quality_score = coverage_points + validation_points + confidence_points

Summarize:
- X% Gold quality
- Y% Silver quality
- Z% Bronze quality
- W% Flagged
```

---

## Task 4.8: Create Enriched Catalog Export

### What You Want to Achieve
Export the final enriched and validated catalog.

### The Vibe Coding Prompt

```
Create final enriched catalog export:

1. Main export (data/processed/netflix_enriched_final.csv):
   - Netflix fields: title, type, release_year, listed_in, country
   - TMDb fields: tmdb_id, vote_average, vote_count, popularity, genres, runtime
   - Match fields: match_score, confidence, quality_tier
   - All matched records

2. Quality summary (data/processed/enrichment_summary.csv):
   - Total records
   - By quality tier
   - By confidence level
   - Key metrics

3. Issues log (data/processed/enrichment_issues.csv):
   - Records that failed validation
   - Reason for flagging
   - Recommended action

4. Documentation update:
   - Add enrichment notes to findings/

Save all outputs with clear naming.
```

---

## Deliverables Checklist

After completing this exercise, you should have:

- [ ] Netflix-TMDb data joined
- [ ] Genre consistency validated
- [ ] Year alignment checked
- [ ] Rating distribution validated
- [ ] Enrichment gaps documented
- [ ] Logic checks applied
- [ ] Quality scores calculated
- [ ] `visualizations/genre_comparison.png`
- [ ] `visualizations/year_alignment.png`
- [ ] `visualizations/rating_distribution.png`
- [ ] `data/processed/netflix_enriched_final.csv`
- [ ] `data/processed/enrichment_summary.csv`
- [ ] `data/processed/enrichment_issues.csv`

---

## Key Vocabulary for Vibe Coding

When validating enrichment, these keywords help:

| What You Want | Keywords to Use |
|---------------|-----------------|
| Check data | "validate", "verify", "consistency check" |
| Find missing | "null rate", "completeness", "gaps" |
| Compare fields | "alignment", "match", "agree" |
| Score quality | "quality tier", "reliability score" |
| Flag issues | "flag", "issue", "needs review" |

---

## Common Issues and How to Fix Them

**If genre columns are in different formats:**
```
Netflix genres: "Comedy, Drama, Thriller"
TMDb genres: "[{'id': 35, 'name': 'Comedy'}, ...]"

Parse both to simple lists before comparing.
Netflix: split by comma
TMDb: extract 'name' values from JSON
```

**If many records fail validation:**
```
40% of records failed year validation.
The matching might have issues, or:
- Check if you're comparing correct columns
- Netflix might use different year definition (premiere vs release)
- Try relaxing threshold to ±2 years
```

**If budget/revenue are mostly 0:**
```
80% of movies have budget = 0.
This is normal - TMDb only has budget data for major releases.
Don't treat as validation failure, just note as "budget unknown."
```

---

## What's Next?

Now that you have validated enrichment, Exercise 5 will teach you how to **analyze metadata correlations** and find interesting patterns.

---

[← Previous: Entity Resolution](./03_entity_resolution.md) | [Lab 4 Home](../README.md) | [Next: Metadata Correlation →](./05_metadata_correlation.md)
