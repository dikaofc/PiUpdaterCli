---
name: sql-analytics
description: Write analytical SQL — window functions, aggregations, date bucketing, cohort analysis, retention. Use for any analysis query.
category: Data & AI
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# SQL Analytics

## Windows (the analyst's core)
- `ROW_NUMBER()/RANK()/DENSE_RANK()` for dedupe & ranking (top-N per group); `LAG/LEAD` deltas between rows (session durations, price changes); `SUM() OVER (ORDER BY date)` running totals; `AVG() OVER (PARTITION BY ... ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)` rolling averages.
- Window executes after WHERE/GROUP BY — filter inside `PARTITION BY`, not in WHERE when values are computed.

## Aggregations done right
- `FILTER (WHERE ...)` (PG) / `COUNT(DISTINCT CASE WHEN ...)` — multiple conditional counts in one pass, not separate scans.
- Distinct counting at scale: `approx_distinct`/HLL (cockroach/athena) — 2% error fine for dashboards.
- Grouping sets / `ROLLUP` for subtotals (`GROUPING()` marker); `PIVOT` (PG: `crosstab`/FILTER) vs unpivot (`UNNEST` of columns).

## Date bucketing (reporting workhorse)
- Truncate: `date_trunc('week', ts)`, MySQL `DATE_FORMAT`/`WEEK`; bucket widths: hour/day/week/month; timezone: bucket in the user's TZ (`AT TIME ZONE`), never in server TZ silently.
- Moving windows via `BETWEEN date - INTERVAL '6 days' AND date` joins (or window ROWS).

## Analysis patterns
- **Cohort**: first-event date per user (MIN), then per-cohort retention table: `SELECT cohort, age_days, COUNT(DISTINCT user_id) FROM (...)` — retention = cohorts × age matrix.
- **Funnel**: ordered step timestamps → per-step counts; funnel time-bounded (within 7d of entry).
- **A/B**: group by variant, compare with confidence intervals (avoid naive ratio claims); guard: `COUNT(DISTINCT user)` per variant and randomization check.
- **Survival/first-repeat**: time-to-event via MIN(ts after entry) window.

## Performance for analytics
- Columnar engines: push filters early (`WHERE` before aggregations); avoid `SELECT *`; `LIMIT` + sampling for exploration (hash sample).
- Scan cost: partition pruning (date partition column in WHERE) — dashboard queries MUST hit partition key.

## Checklist
- [ ] Window vs GROUP BY semantics clear
- [ ] Timezone in bucketing explicit
- [ ] Approx distinct for huge cardinality
- [ ] Cohort/funnel logic reviewed for off-by-one dates
- [ ] Partition pruning on dashboard queries