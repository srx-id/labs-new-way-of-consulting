# Join Strategy

## Base Table

Use Airbnb aggregated data as the base (left table) for all joins.

## Join Keys

- `borough`: Standardized borough name
- `year_month`: YYYY-MM format

## Expected Cardinality

At borough-month grain:
- Airbnb ← 311: 1:1 (60 rows)
- Airbnb ← Crime: 1:1 (60 rows)
- Airbnb ← Weather: 1:1 (60 rows)

## Validation

```python
df_merged = df_airbnb.merge(df_311, on=['borough', 'year_month'], how='left', indicator=True)
print(df_merged['_merge'].value_counts())
```

Expected: All rows show "both" if datasets have complete coverage.

