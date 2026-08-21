# travel-planner — Reference

## Commands

| Command | Description |
|---|---|
| `plan` | day-by-day itinerary from interests (offline) |
| `timezones <c1> <c2>` | compare current local time + UTC offset (offline) |
| `currency <amt> <from> <to>` | live FX conversion (Frankfurter API) |
| `distance <c1> <c2>` | straight-line km/mi via OSM geocoding |

## Options (plan)

- `--dest CITY` — destination (required)
- `--days N` — default 3
- `--interests a,b,c` — food, culture, nature, shopping, nightlife, history
- `--budget USD` — daily budget, default 100

## Built-in timezone aliases

`jakarta, london, new_york, tokyo, sydney, paris, dubai, singapore,
bali, san_francisco, berlin, delhi` — any IANA zone also works
(e.g. `Asia/Seoul`).

## Examples

```bash
travel-planner.sh plan --dest "Bali" --days 7 --interests nature,food,nightlife --budget 50
travel-planner.sh timezones Jakarta "San Francisco"
travel-planner.sh currency 500000 IDR USD
travel-planner.sh distance "Jakarta" "Singapore"
```

## Notes

- `currency` tries `api.frankfurter.dev` then `api.frankfurter.app`.
- `distance` uses OpenStreetMap Nominatim (1 req/s policy — be polite).
