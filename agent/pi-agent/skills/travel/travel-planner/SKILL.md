---
name: travel-planner
description: Generate day-by-day itineraries, compare timezones, convert currency, and estimate distances.
license: MIT
compatibility: "POSIX shell + curl + jq + python3. Network needed for currency/distance."
source: https://wiki.openstreetmap.org/wiki/Nominatim
metadata:
  category: travel
  language: bash
  tags: [travel, itinerary, timezone, currency]
---
# Travel Planner

Plan trips without leaving the terminal: generate day-by-day
itineraries from interests, compare timezones between cities,
convert currency with live rates, and estimate straight-line
distances via OpenStreetMap geocoding.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

No installation. `plan` and `timezones` work fully offline;
`currency` and `distance` need network access.

## Usage

```bash
travel-planner.sh plan --dest "Tokyo" --days 5 --interests food,culture,nature --budget 80
travel-planner.sh timezones Jakarta London
travel-planner.sh currency 100 USD EUR
travel-planner.sh distance "New York" "London"
```

## Options

- `--dest CITY` — destination (required for `plan`)
- `--days N` — trip length (default 3)
- `--interests a,b,c` — food, culture, nature, shopping, nightlife, history
- `--budget USD` — daily budget (default 100)
