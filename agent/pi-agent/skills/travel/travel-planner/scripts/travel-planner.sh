#!/usr/bin/env bash
# Travel Planner — itineraries, timezones, currency, distances
# Source: https://wiki.openstreetmap.org/wiki/Nominatim
set -euo pipefail

SCRIPT_NAME="travel-planner.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} plan --dest <city> [--days N] [--interests a,b,c] [--budget USD]
       ${SCRIPT_NAME} timezones <city1> <city2>
       ${SCRIPT_NAME} currency <amount> <from> <to>
       ${SCRIPT_NAME} distance <city1> <city2>
Plan a day-by-day itinerary, compare timezones, convert currency
(Frankfurter API), and estimate travel distance (OpenStreetMap).

Options:
  --dest CITY     destination city
  --days N        trip length in days (default 3)
  --interests L   comma list: food, culture, nature, shopping, nightlife, history
  --budget USD    daily budget in USD (default 100)
  -h | --help     show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
DEST=""
DAYS=3
INTERESTS="food,culture"
BUDGET=100
ARGS=()
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    plan|timezones|currency|distance) CMD="$1"; shift;;
    --dest) DEST="$2"; shift 2;;
    --days) DAYS="$2"; shift 2;;
    --interests) INTERESTS="$2"; shift 2;;
    --budget) BUDGET="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) ARGS+=("$1"); shift;;
  esac
done
[ -z "$CMD" ] && { usage; exit 1; }

case "$CMD" in
  plan)
    [ -z "$DEST" ] && { echo "missing --dest" >&2; exit 2; }
    PLAN_DEST="$DEST" PLAN_DAYS="$DAYS" PLAN_INTERESTS="$INTERESTS" PLAN_BUDGET="$BUDGET" python3 - <<'PYEOF'
import os

dest = os.environ["PLAN_DEST"]
days = int(os.environ["PLAN_DAYS"])
interests = [i.strip() for i in os.environ["PLAN_INTERESTS"].split(",") if i.strip()]
budget = int(os.environ["PLAN_BUDGET"])

ACTIVITIES = {
    "food":      ["breakfast at a local market", "street food walking tour", "cooking class", "dinner at a rooftop restaurant"],
    "culture":   ["visit the main museum", "guided old-town walking tour", "temple/cathedral visit", "evening folk performance"],
    "nature":    ["morning park walk", "scenic viewpoint hike", "botanical garden", "sunset river cruise"],
    "shopping":  ["craft market browsing", "boutique district stroll", "souvenir shopping", "night market"],
    "nightlife": ["cocktail bar crawl", "live music venue", "club night", "theater show"],
    "history":   ["heritage quarter tour", "ancient ruins visit", "history museum", "monument at dusk"],
}
ALL = [a for v in ACTIVITIES.values() for a in v]

print(f"Itinerary: {days} days in {dest}  (budget ${budget}/day)")
print("=" * 50)
used = []
for d in range(1, days + 1):
    print(f"\nDay {d} — {dest}")
    picks = []
    for i, interest in enumerate(interests):
        pool = [a for a in ACTIVITIES.get(interest, []) if a not in used]
        if not pool:
            pool = [a for a in ALL if a not in used] or ALL
        act = pool[(d + i) % len(pool)]
        used.append(act)
        picks.append(act)
    for i, act in enumerate(picks):
        slot = ["morning", "afternoon", "evening"][i % 3]
        print(f"  {slot:9s}: {act}")
    print(f"  budget   : ~${budget}")
PYEOF
    ;;
  timezones)
    C1="${ARGS[0]:?usage: timezones <city1> <city2>}"
    C2="${ARGS[1]:?usage: timezones <city1> <city2>}"
    python3 - "$C1" "$C2" <<'PYEOF'
import sys
from zoneinfo import ZoneInfo
from datetime import datetime

def zone(city):
    c = city.strip().lower().replace(" ", "_")
    aliases = {
        "jakarta": "Asia/Jakarta", "london": "Europe/London", "new_york": "America/New_York",
        "tokyo": "Asia/Tokyo", "sydney": "Australia/Sydney", "paris": "Europe/Paris",
        "dubai": "Asia/Dubai", "singapore": "Asia/Singapore", "bali": "Asia/Makassar",
        "san_francisco": "America/Los_Angeles", "berlin": "Europe/Berlin", "delhi": "Asia/Kolkata",
    }
    return aliases.get(c, c)

now = datetime.now()
FALLBACK = {  # city: (UTC offset hours, label) — used when zoneinfo tzdata is missing
    "jakarta": (7, "WIB"), "bali": (8, "WITA"), "london": (1, "BST"),
    "paris": (2, "CEST"), "berlin": (2, "CEST"), "new_york": (-4, "EDT"),
    "san_francisco": (-7, "PDT"), "tokyo": (9, "JST"), "sydney": (10, "AEST"),
    "dubai": (4, "GST"), "singapore": (8, "SGT"), "delhi": (5.5, "IST"),
}
for city in (sys.argv[1], sys.argv[2]):
    key = city.strip().lower().replace(" ", "_")
    try:
        tz = ZoneInfo(zone(city))
        dt = now.astimezone(tz)
        print(f"{city:15s}: {dt.strftime('%Y-%m-%d %H:%M %Z')} (UTC{dt.utcoffset().total_seconds()/3600:+.1f})")
    except Exception:
        if key in FALLBACK:
            off, label = FALLBACK[key]
            print(f"{city:15s}: {label} (UTC{off:+.1f}) — approx, tzdata not installed")
        else:
            print(f"{city:15s}: unknown zone (install tzdata: pip install tzdata)")
PYEOF
    ;;
  currency)
    AMT="${ARGS[0]:?usage: currency <amount> <from> <to>}"
    FROM="${ARGS[1]:-USD}"
    TO="${ARGS[2]:-IDR}"
    RESP=$(curl -sSL --max-time 25 "https://api.frankfurter.dev/v1/latest?base=${FROM}&symbols=${TO}" 2>/dev/null || curl -sSL --max-time 25 "https://api.frankfurter.app/latest?base=${FROM}&symbols=${TO}" 2>/dev/null)
    RATE=$(echo "$RESP" | jq -r --arg t "$TO" '.rates[$t] // empty' 2>/dev/null)
    if [ -z "$RATE" ]; then
      echo "currency conversion failed for ${FROM}->${TO} (check ISO codes)" >&2
      exit 1
    fi
    python3 - "$AMT" "$RATE" "$FROM" "$TO" <<'PYEOF'
import sys
amt, rate, frm, to = float(sys.argv[1]), float(sys.argv[2]), sys.argv[3], sys.argv[4]
print(f"{amt:,.2f} {frm} = {amt*rate:,.2f} {to}  (rate {rate:,.6f})")
PYEOF
    ;;
  distance)
    C1="${ARGS[0]:?usage: distance <city1> <city2>}"
    C2="${ARGS[1]:?usage: distance <city1> <city2>}"
    python3 - "$C1" "$C2" <<'PYEOF'
import sys, json, urllib.parse, urllib.request, math

def geocode(city):
    url = "https://nominatim.openstreetmap.org/search?" + urllib.parse.urlencode(
        {"q": city, "format": "json", "limit": 1})
    req = urllib.request.Request(url, headers={"User-Agent": "travel-planner/1.0"})
    with urllib.request.urlopen(req, timeout=20) as r:
        data = json.load(r)
    if not data:
        return None
    return float(data[0]["lat"]), float(data[0]["lon"])

def haversine(a, b):
    R = 6371.0
    la1, lo1, la2, lo2 = map(math.radians, [a[0], a[1], b[0], b[1]])
    dlat, dlon = la2 - la1, lo2 - lo1
    h = math.sin(dlat/2)**2 + math.cos(la1)*math.cos(la2)*math.sin(dlon/2)**2
    return 2 * R * math.asin(math.sqrt(h))

try:
    p1, p2 = geocode(sys.argv[1]), geocode(sys.argv[2])
except Exception as e:
    print(f"geocoding failed: {e} (network required)", file=sys.stderr)
    sys.exit(1)
if not p1 or not p2:
    print("could not geocode one of the cities", file=sys.stderr)
    sys.exit(1)
km = haversine(p1, p2)
print(f"straight-line distance {sys.argv[1]} -> {sys.argv[2]}: {km:,.0f} km ({km*0.621371:,.0f} mi)")
PYEOF
    ;;
esac