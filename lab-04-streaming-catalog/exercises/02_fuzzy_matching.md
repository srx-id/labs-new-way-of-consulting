# Exercise 2: Fuzzy Matching Implementation

**[Lab 4 Home](../README.md) > Exercise 2**

## Overview

Exact matching only caught ~30% of titles. Now you'll learn **fuzzy matching** - finding similar strings even when they're not identical. This is a key skill for entity resolution in real-world data.

**Time**: 60-90 minutes

## What is Fuzzy Matching?

Fuzzy matching finds strings that are "close" to each other:
- "Spider-Man" matches "Spiderman" (score: 95)
- "The Matrix" matches "Matrix" (score: 85)
- "Amélie" matches "Amelie" (score: 92)

The algorithm calculates a similarity score (0-100), and we choose matches above a threshold.

---

## Task 2.1: Title Normalization

### What You Want to Achieve
Clean titles before matching to improve results.

### The Vibe Coding Prompt

```
Create a title normalization function that:

1. Convert to lowercase
2. Remove "the " from the beginning
3. Remove punctuation (colons, hyphens, apostrophes)
4. Remove special characters (accents → regular letters)
5. Remove extra whitespace
6. Optionally remove year patterns like "(2019)"

Apply to 10 example titles and show before/after:
| Original | Normalized |
| The Matrix | matrix |
| Spider-Man: Homecoming | spiderman homecoming |

Test on titles we know don't match exactly.
Does normalization help?
```

### Normalization Decisions
```
Be careful not to over-normalize:
- "Mission: Impossible" → "mission impossible" (good)
- "Iron Man 2" → "iron man 2" (keep the number!)
- "2001: A Space Odyssey" → "2001 a space odyssey" (keep the year in title)
```

---

## Task 2.2: Understand Fuzzy Matching Algorithms

### What You Want to Achieve
Learn about different matching algorithms before applying them.

### The Vibe Coding Prompt

```
Explain the main fuzzy matching algorithms:

1. Levenshtein Distance:
   - What is it?
   - How does it work?
   - Example: "kitten" vs "sitting"

2. Ratio vs Partial Ratio:
   - Simple ratio compares entire strings
   - Partial ratio finds best substring match
   - When to use each?

3. Token Sort Ratio:
   - Sorts words before comparing
   - Good for: "Star Wars" vs "Wars Star"

4. Token Set Ratio:
   - Ignores word order and duplicates
   - Good for: "The Good, The Bad, and The Ugly"

Show examples of each with movie titles.
Which is best for our use case?
```

### Quick Algorithm Guide
| Algorithm | Best For |
|-----------|----------|
| Simple Ratio | Titles that should be nearly identical |
| Partial Ratio | Finding title within longer string |
| Token Sort | Same words, different order |
| Token Set | Titles with extra or missing words |

---

## Task 2.3: Implement Basic Fuzzy Matching

### What You Want to Achieve
Match Netflix titles to TMDb using fuzzy matching.

### The Vibe Coding Prompt

```
Implement fuzzy matching between Netflix and TMDb:

1. For each Netflix title:
   - Normalize the title
   - Search TMDb titles for best match
   - Return: best match title, score, TMDb ID

2. Use token_set_ratio or token_sort_ratio (explain your choice)

3. Apply to first 100 Netflix titles as a test:
   - How many get scores above 90?
   - How many between 80-90?
   - How many below 80?

4. Show examples:
   - 5 excellent matches (score > 95)
   - 5 good matches (85-95)
   - 5 questionable matches (70-85)
   - 5 poor matches (<70)

What threshold should we use?
```

### Performance Note
```
Matching every Netflix title against ALL TMDb titles is slow.
For the full dataset, consider:
- Pre-filtering TMDb by first letter
- Using blocking on release year
- Processing in chunks

For learning, start with 100 titles.
```

---

## Task 2.4: Add Year-Based Filtering

### What You Want to Achieve
Use release year to improve match quality.

### The Vibe Coding Prompt

```
Improve matching by adding year filtering:

1. For each Netflix title with release_year:
   - First filter TMDb to movies within ±2 years
   - Then fuzzy match only within that subset

2. Compare results:
   - Without year filtering: X matches above 80
   - With year filtering: Y matches above 80
   - False positive reduction

3. Handle missing years:
   - What if Netflix title has no year?
   - Match against all TMDb (no filter)

4. Show examples where year filtering helped:
   - Same title, multiple years (found correct one)
   - Avoided wrong match (different movie, same title)

Does year filtering improve accuracy?
```

### The Remake Problem
```
"A Star Is Born" exists for 1937, 1954, 1976, 2018.
Without year filtering, might match wrong version.
With year filtering, get the correct remake.
```

---

## Task 2.5: Score Threshold Analysis

### What You Want to Achieve
Find the optimal match score threshold.

### The Vibe Coding Prompt

```
Analyze match scores to find the best threshold:

1. Score distribution:
   - Histogram of all match scores
   - What does the distribution look like?
   - Is there a natural break point?

2. Manual validation at different thresholds:
   - At threshold 90: What % are correct matches?
   - At threshold 80: What % are correct?
   - At threshold 70: What % are correct?

3. Trade-off analysis:
   - Higher threshold = fewer matches but more accurate
   - Lower threshold = more matches but more errors
   - What's the right balance?

4. Recommendation:
   - Primary threshold for confident matches
   - Secondary threshold for "needs review"

Create visualization of match quality vs threshold.
Save as visualizations/threshold_analysis.png
```

### Threshold Recommendations
| Threshold | Use Case |
|-----------|----------|
| 95+ | Auto-accept as correct match |
| 85-95 | High confidence, spot-check only |
| 70-85 | Manual review recommended |
| <70 | Likely not a match |

---

## Task 2.6: Handle Multiple Matches

### What You Want to Achieve
Decide what to do when multiple TMDb titles match well.

### The Vibe Coding Prompt

```
Handle cases where multiple matches are close:

1. Find Netflix titles with multiple good matches:
   - More than one TMDb title with score > 80
   - List these cases

2. Tie-breaking strategies:
   - Pick highest score (simple)
   - Use release year closeness (better)
   - Use TMDb popularity (prefer popular)
   - Return all matches for manual review

3. Implement tie-breaking:
   - Primary: Highest fuzzy score
   - Secondary: Closest year
   - Tertiary: Highest TMDb popularity

4. Show examples:
   - Case with clear winner
   - Case needing year tie-breaker
   - Case still ambiguous

What should we do with truly ambiguous cases?
```

---

## Task 2.7: Run Full Matching

### What You Want to Achieve
Match the entire Netflix catalog and assess results.

### The Vibe Coding Prompt

```
Run fuzzy matching on the full Netflix movie catalog:

1. Filter Netflix to movies only (skip TV shows)

2. For each movie:
   - Normalize title
   - Filter TMDb by year (±2)
   - Find best fuzzy match
   - Store: Netflix_ID, title, year, TMDb_ID, TMDb_title, score

3. Save results to data/processed/match_results.csv

4. Summary statistics:
   - Total Netflix movies
   - Matched at 90+: X%
   - Matched at 80-90: X%
   - Matched at 70-80: X%
   - No good match (<70): X%

5. Overall match rate at threshold 80?

Save matching results and summary.
```

---

## Task 2.8: Quality Check Matches

### What You Want to Achieve
Validate a sample of matches manually.

### The Vibe Coding Prompt

```
Quality check the fuzzy matching results:

1. Random sample:
   - Pick 20 random matches from 80-90 range
   - For each, show Netflix title vs TMDb match
   - Are they correct? Mark Y/N

2. Precision estimate:
   - What % of sampled matches are correct?
   - Extrapolate to full dataset

3. Problem cases:
   - Show 5 matches that look WRONG
   - What caused the error?
   - Can we fix these patterns?

4. Confidence levels:
   - Create match confidence tiers
   - High: 95+ score + year match
   - Medium: 85-95 score or year within 3
   - Low: <85 or year mismatch

Document the quality assessment.
```

---

## Deliverables Checklist

After completing this exercise, you should have:

- [ ] Title normalization function created
- [ ] Fuzzy matching algorithm understood and applied
- [ ] Year filtering implemented
- [ ] Threshold analysis completed
- [ ] Multiple match handling implemented
- [ ] `data/processed/match_results.csv`
- [ ] `visualizations/threshold_analysis.png`
- [ ] Quality check completed and documented

---

## Key Vocabulary for Vibe Coding

When doing fuzzy matching, these keywords help:

| What You Want | Keywords to Use |
|---------------|-----------------|
| Clean strings | "normalize", "lowercase", "remove punctuation" |
| Compare strings | "fuzzy match", "similarity score", "Levenshtein" |
| Find best | "best match", "highest score", "top match" |
| Filter candidates | "pre-filter", "year range", "blocking" |
| Handle ties | "tie-break", "multiple matches", "disambiguation" |

---

## Common Issues and How to Fix Them

**If matching is too slow:**
```
Matching 5000 Netflix titles against 40000 TMDb takes forever.
Speed up by:
- Pre-filter TMDb by first letter of normalized title
- Filter by year range first
- Process in batches with progress tracking
```

**If too many false positives:**
```
"Home" matched to "Home Alone" at score 80.
Partial ratio is too lenient for short titles.
For titles under 10 characters, require higher threshold (90+).
```

**If accented characters cause issues:**
```
"Amélie" isn't matching "Amelie".
Make sure normalization converts accents:
é → e, ñ → n, ü → u
Use Unicode normalization (NFKD) to decompose accents.
```

---

## What's Next?

Now that you have fuzzy matches, Exercise 3 will teach you how to **resolve conflicts** and choose the best match when multiple options exist.

---

[← Previous: Catalog Profiling](./01_catalog_profiling.md) | [Lab 4 Home](../README.md) | [Next: Entity Resolution →](./03_entity_resolution.md)
