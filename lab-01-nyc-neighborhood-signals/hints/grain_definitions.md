# Grain Definitions

## Standard Borough Names

Use these exact names for consistency:
- Manhattan
- Brooklyn
- Queens
- Bronx
- Staten Island

## Month Format

- Format: `YYYY-MM`
- Example: `2019-01` for January 2019
- Padding: Always use 2 digits for month (01-12)

## Handling Edge Cases

- Listings without reviews: Document your approach (exclude or include with null reviews_per_month)
- Unknown boroughs: Consider excluding or creating separate category
- Date ranges: Verify all datasets cover 2019 before aggregating

