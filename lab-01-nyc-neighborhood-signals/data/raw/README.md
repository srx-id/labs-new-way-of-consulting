# Lab 1: Raw Datasets

## Download Instructions

See [Dataset Download Guide](../../../docs/dataset-download-guide.md) for setup instructions.

### Automated Download

```bash
cd /path/to/labs
python shared/utilities/download_datasets.py --lab 1
```

### Manual Download

Visit each dataset URL and download to the respective subdirectory:

| Dataset | URL | Target Directory |
|---------|-----|-----------------|
| NYC Airbnb | https://www.kaggle.com/datasets/dgomonov/new-york-city-airbnb-open-data | `airbnb/` |
| NY 311 | https://www.kaggle.com/datasets/new-york-city/ny-311-service-requests | `311_requests/` |
| NYPD Crime | https://www.kaggle.com/datasets/brunacmendes/nypd-complaint-data-historic-20062019 | `nypd_crime/` |
| NYC Weather | https://www.kaggle.com/datasets/danbraswell/new-york-city-weather-18692022 | `weather/` |

## Dataset Sizes

- NYC Airbnb: ~1.5 MB (manageable)
- NY 311: ~10 GB (large - filter to 2019)
- NYPD Crime: ~2 GB (medium - filter to 2019)
- NYC Weather: ~5 MB (manageable - filter to 2019)

## Filtering Large Datasets

For NY 311 (filter to 2019 only):

```python
import pandas as pd

# Read in chunks
chunks = []
for chunk in pd.read_csv('311_requests/311_Service_Requests.csv', 
                         chunksize=100000,
                         parse_dates=['Created Date']):
    chunk_2019 = chunk[chunk['Created Date'].dt.year == 2019]
    chunks.append(chunk_2019)

df_2019 = pd.concat(chunks, ignore_index=True)
df_2019.to_csv('311_requests/311_Service_Requests_2019.csv', index=False)
```

