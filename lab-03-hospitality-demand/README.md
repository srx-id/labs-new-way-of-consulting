# Lab 3: Hospitality Demand and Cancellation Drivers

**[Home](../README.md) > Lab 3**

## Learning Objectives

✅ Perform calendar-based joins using arrival dates
✅ Analyze cancellation patterns and drivers
✅ Understand seasonality in hospitality data
✅ Correlate lead time with cancellation probability
✅ Apply business metrics analysis (ADR, RevPAR concepts)

**Estimated Time**: 4-5 hours | **Difficulty**: ⭐⭐

## Business Context

Analyze hotel booking demand patterns and identify factors that influence cancellations. This analysis helps hotel revenue managers optimize pricing, overbooking strategies, and marketing campaigns.

**Target Grain**: Arrival Date (or Arrival Month for aggregated analysis)

## Datasets

1. **Hotel Booking Demand** - Booking records with cancellation flags
2. **Worldwide Public Holidays** - Filter to Portugal
3. **NOAA Weather (GSOD)** - Portugal weather stations

See [data/raw/README.md](./data/raw/README.md) for download instructions.

## Exercises

1. **Booking Pattern Analysis** - Explore booking windows, lead times, customer types
2. **Cancellation Analysis** - Profile cancellation rates by segment
3. **Holiday Impact Assessment** - Join holiday calendar and measure impact
4. **Seasonality Feature Engineering** - Create seasonal indicators
5. **Lead Time Correlation** - Correlate booking characteristics with cancellation

## Key Concepts

- **ADR**: Average Daily Rate - pricing metric
- **Lead Time**: Days between booking and arrival
- **Market Segment**: Online TA, Offline TA, Direct, Corporate, Groups
- **Deposit Type**: No deposit, Non-refund, Refundable
- **Distribution Channel**: Direct, Corporate, TA/TO, GDS

## Common Pitfalls

⚠️ **Data Leakage**: Don't use post-arrival information to predict cancellation
⚠️ **Portugal Holidays**: Filter worldwide dataset to Portugal only
⚠️ **Arrival Date Construction**: Combine arrival year/month/day fields
⚠️ **Special Requests**: High correlation with non-cancellation (selection bias)

---

**Download datasets**: `python ../../shared/utilities/download_datasets.py --lab 3`

[Home](../README.md) | [← Lab 2](../lab-02-us-safety-drivers/README.md) | [Lab 4 →](../lab-04-streaming-catalog/README.md)
