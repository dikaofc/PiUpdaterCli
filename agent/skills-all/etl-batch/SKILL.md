---
name: etl-batch
description: Build ETL/ELT batch jobs — extractors, transforms, load strategies, incremental patterns, backfills, testing.
category: Data & AI
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# ETL / ELT (Batch)

## Architecture choice
- **ELT (modern default)**: load raw → warehouse (dbt/SQL transforms). Cheap storage, transform at query time, single source of truth.
- ETL (transform before load) only when: target is a database that can't transform (legacy), or security needs pre-processing before the warehouse.

## Extract
- Full extract for small tables (< 1M rows); incremental via `updated_at` watermark or CDC (binlog/WAL → Debezium) for big/hot tables.
- API sources: paginate, respect rate limits, retry with exponential backoff; checkpoint last success (resume).
- File drop: S3 watch/event or scheduled scan; schema version in filename (`users_v3.csv`).

## Transform
- Clean in deterministic layers: validate → normalize (types, enums, nulls) → enrich (joins, lookups) → aggregate (daily_metrics).
- SQL layers (dbt): `staging_` (source-light cleaning) → `marts_` (business models); tests on staging (not-null, unique, accepted_values).
- Python transforms: pure functions tested (no I/O inside); scale = Spark/DuckDB when memory bound.

## Load strategies
- Full replace (small), upsert on natural key (`MERGE`/`ON CONFLICT`), append-only with `valid_to` SCD Type 2 for history needs.
- Partition by date at load; vacuum/optimize (delta/iceberg compaction) after big loads.

## Incremental pattern (the core skill)
```sql
-- dbt-style
{{ config(materialized='incremental', unique_key='user_id') }}
SELECT ... FROM source
{% if is_incremental() %}
WHERE updated_at > (SELECT MAX(updated_at) FROM {{ this }})
{% endif %}
```
- Watermark: monotonic column, not wall-clock; backfill windows via `--select +full-refresh` or `--vars '{start_date: ...}'`.

## Backfills
- Reproducible: rerun any date range; lock concurrent runs (`flock`/task lock); run in small date windows (parallelize), never one giant query.

## Testing
- Contract tests on source schema; golden-data tests per transform (input fixture → expected output); pipeline smoke in CI (sample data through full stack); post-load DQ asserts (see `data-pipelines`).

## Checklist
- [ ] Incremental + watermark, backfill-capable
- [ ] Retries/checkpoints on extract
- [ ] Deterministic transforms; tested with fixtures
- [ ] SCD/upsert strategy deliberate
- [ ] Partitioning + compaction after loads