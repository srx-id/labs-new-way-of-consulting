# Exercise 3: Entity Resolution

**[Lab 4 Home](../README.md) > Exercise 3**

## Overview

Fuzzy matching found candidate matches, but now you need to **resolve entities** - deciding which TMDb record truly represents each Netflix title. This is where data quality and business logic meet.

**Time**: 45-60 minutes

## What is Entity Resolution?

Entity Resolution (ER) is deciding when two records refer to the same real-world thing:
- "The Dark Knight (2008)" on Netflix = "Dark Knight, The" on TMDb
- But: "Iron Man (2008)" ≠ "Iron Man (TV Series)"

It's not just string matching - it's making smart decisions.

---

## Task 3.1: Analyze Ambiguous Matches

### What You Want to Achieve
Identify matches that need human-like judgment.

### The Vibe Coding Prompt

```
Find ambiguous matches in our fuzzy matching results:

1. Multiple high-scoring matches:
   - Netflix titles with 2+ TMDb matches scoring > 80
   - Show these cases

2. Near ties:
   - Where top two matches differ by less than 5 points
   - Example: Netflix "Home" → TMDb "Home" (87) AND "Home Alone" (84)

3. Year mismatches:
   - High score (85+) but years differ by 5+
   - Might be remake or wrong match

4. Common title problems:
   - Very short titles (3-4 characters)
   - Titles with numbers ("Mission Impossible 2" vs "II")
   - Titles that are common words ("Up", "Her", "It")

List the top 20 most ambiguous matches for analysis.
```

### Ambiguity Categories
| Category | Example | Resolution Approach |
|----------|---------|---------------------|
| Remakes | A Star Is Born | Use year to pick correct version |
| Short titles | "It", "Up", "Her" | Require near-perfect score + year |
| Numbered sequels | "Rocky 2" vs "Rocky II" | Normalize numbers |
| Same name different thing | "Focus" (2001) vs "Focus" (2015) | Must match year |

---

## Task 3.2: Create Resolution Rules

### What You Want to Achieve
Define rules for automatically resolving common cases.

### The Vibe Coding Prompt

```
Create entity resolution rules:

Rule 1: High Confidence Auto-Accept
- Score > 95 AND year matches exactly
- Action: Accept match automatically

Rule 2: Title + Year Match
- Score > 85 AND year within 1 year
- Action: Accept match

Rule 3: Remake Handling
- Same title exists for multiple years
- Action: Pick closest year, require year within 2

Rule 4: Short Title Caution
- Title < 4 words AND score < 95
- Action: Flag for review

Rule 5: Ambiguous Multiple
- Two matches within 5 points of each other
- Action: Use popularity as tie-breaker, flag if still ambiguous

Apply these rules to all matches.
How many fall into each category?
```

---

## Task 3.3: Apply Tie-Breaking Logic

### What You Want to Achieve
Resolve ties using additional metadata.

### The Vibe Coding Prompt

```
Implement tie-breaking for ambiguous matches:

Priority order for tie-breaking:
1. Exact year match (highest priority)
2. Higher fuzzy match score
3. Closer release year (if not exact)
4. Higher TMDb popularity (more likely to be the "main" version)
5. Higher TMDb vote count (more data = more reliable)

For each ambiguous case:
- Apply tie-breaking in priority order
- Record which rule resolved it
- Flag if still unresolved after all rules

Show examples:
- 5 cases resolved by year
- 5 cases resolved by popularity
- 5 cases still unresolved
```

---

## Task 3.4: Handle Unmatched Titles

### What You Want to Achieve
Analyze and categorize titles that couldn't be matched.

### The Vibe Coding Prompt

```
Analyze Netflix titles with no good match (score < 70):

1. Total unmatched:
   - How many Netflix movies have no good TMDb match?
   - What percentage of the catalog?

2. Categorize unmatched:
   - Netflix Originals (might not be in TMDb)
   - International films (different title in English?)
   - Very old or obscure films
   - Data quality issues (weird titles)

3. Check for Netflix Originals:
   - Look for "Netflix" in description or tags
   - These may legitimately not exist in TMDb

4. International title check:
   - Movies with non-English original language
   - Might need original_title matching

5. Recommendations:
   - X% are expected gaps (Originals)
   - X% might be findable with different approach
   - X% are likely not in TMDb

Document the unmatched analysis.
```

### Netflix Originals Reality
```
Netflix Originals (like "Stranger Things", "Bird Box") may not have TMDb IDs,
or may have been added to TMDb later.

These are legitimate "no match" cases, not matching failures.
```

---

## Task 3.5: Create Confidence Scores

### What You Want to Achieve
Assign confidence levels to each match.

### The Vibe Coding Prompt

```
Create a match confidence scoring system:

Factors to include:
1. Fuzzy match score (0-100)
2. Year match: Exact +20, Within 1 +10, Within 3 +5, Otherwise 0
3. Title length: Short titles -10 (more ambiguous)
4. Unique match: If only one good match +10
5. Popularity: High TMDb popularity +5

Calculate confidence_score for each match.

Create confidence tiers:
- High (90+): Auto-accept, no review needed
- Medium (70-90): Spot-check sample
- Low (50-70): Manual review recommended
- Very Low (<50): Likely incorrect, don't use

Distribution:
- How many in each tier?
- What's our overall confidence?

Save confidence scores to data/processed/match_confidence.csv
```

---

## Task 3.6: Manual Verification Sample

### What You Want to Achieve
Validate resolution quality with manual review.

### The Vibe Coding Prompt

```
Create a manual verification sample:

1. Sample selection:
   - 10 High confidence matches (spot check)
   - 20 Medium confidence matches (validate logic)
   - 10 Low confidence matches (understand failures)

2. For each sample, create verification record:
   | Netflix_Title | Netflix_Year | TMDb_Match | TMDb_Year | Score | Confidence | Correct? |

3. Verification process:
   - Show Netflix and TMDb info side by side
   - Mark each as Correct / Incorrect / Unsure
   - Note reason for errors

4. Calculate precision:
   - High confidence: X% correct
   - Medium confidence: X% correct
   - Low confidence: X% correct

This gives us estimated accuracy at each confidence level.
```

---

## Task 3.7: Create Final Match Dataset

### What You Want to Achieve
Produce the validated, confidence-scored match dataset.

### The Vibe Coding Prompt

```
Create the final match dataset:

1. Include only matches above quality threshold:
   - Option A: Only High confidence (safest)
   - Option B: High + Medium with confidence flag

2. Columns to include:
   - netflix_id, netflix_title, netflix_year
   - tmdb_id, tmdb_title, tmdb_year
   - fuzzy_score, confidence_score, confidence_tier
   - match_method (exact, fuzzy, year-filtered)

3. Separate files for:
   - data/processed/matched_titles.csv (confident matches)
   - data/processed/unmatched_titles.csv (needs work)
   - data/processed/review_needed.csv (medium confidence)

4. Summary statistics:
   - Total Netflix titles: X
   - Matched with high confidence: X (Y%)
   - Matched with medium confidence: X (Y%)
   - Unmatched: X (Y%)

Save all outputs.
```

---

## Task 3.8: Document Resolution Decisions

### What You Want to Achieve
Create documentation of your entity resolution approach.

### The Vibe Coding Prompt

```
Create entity resolution documentation:

1. Methodology:
   - Normalization steps
   - Fuzzy matching algorithm used
   - Threshold decisions
   - Tie-breaking rules

2. Performance metrics:
   - Match rate at each confidence level
   - Estimated precision from sample
   - Coverage of Netflix catalog

3. Known limitations:
   - Netflix Originals not in TMDb
   - International titles
   - Short/common title challenges
   - TV shows not matched

4. Recommendations for improvement:
   - Additional data sources
   - Manual curation priorities
   - Ongoing maintenance

Save as findings/entity_resolution_methodology.md
```

---

## Deliverables Checklist

After completing this exercise, you should have:

- [ ] Ambiguous matches identified
- [ ] Resolution rules defined
- [ ] Tie-breaking logic implemented
- [ ] Unmatched titles analyzed
- [ ] Confidence scores assigned
- [ ] Manual verification completed
- [ ] `data/processed/matched_titles.csv`
- [ ] `data/processed/unmatched_titles.csv`
- [ ] `data/processed/review_needed.csv`
- [ ] `data/processed/match_confidence.csv`
- [ ] `findings/entity_resolution_methodology.md`

---

## Key Vocabulary for Vibe Coding

When doing entity resolution, these keywords help:

| What You Want | Keywords to Use |
|---------------|-----------------|
| Handle duplicates | "resolve", "disambiguate", "deduplicate" |
| Choose best | "tie-break", "pick best match", "ranking" |
| Score quality | "confidence score", "match quality", "certainty" |
| Categorize results | "bucket", "tier", "classify matches" |
| Validate | "manual review", "spot check", "verification" |

---

## Common Issues and How to Fix Them

**If too many fall into "review needed":**
```
60% of matches need manual review.
This threshold is too strict. Consider:
- Lowering the High confidence threshold
- Auto-accepting year+title matches even at 85
- Using popularity as stronger signal
```

**If remakes keep mismatching:**
```
"King Kong" keeps matching the wrong year version.
Increase the weight of year matching.
For titles with multiple year versions, require exact or ±1 year match.
```

**If confidence doesn't predict accuracy:**
```
High confidence matches have same error rate as medium.
The confidence formula needs adjustment.
Try: Give more weight to year match, less to fuzzy score alone.
```

---

## What's Next?

Now that you have resolved entities, Exercise 4 will teach you how to **validate enrichment quality** by checking the joined metadata.

---

[← Previous: Fuzzy Matching](./02_fuzzy_matching.md) | [Lab 4 Home](../README.md) | [Next: Enrichment Validation →](./04_enrichment_validation.md)
