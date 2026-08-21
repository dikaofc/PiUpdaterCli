---
name: data-pipelines
description: Design data pipelines — ingestion, transformation, orchestration, idempotency, monitoring, schema drift.
category: Data & AI
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Data Pipelines

## Design
- **Ingest**: batch (files/API pulls, daily/hourly) vs stream (events, <1s) — choose by freshness need; one pipeline per source contract.
- **Transform**: extract→clean→validate→enrich→load; keep transforms deterministic (pure functions), versioned SQL/scripts.
- **Load**: staging → warehouse (dbt for SQL layers, or Python jobs); target schema documented; incremental vs full-refresh per table (incremental default with watermark column `updated_at > last_watermark`).
- **Orchestration**: Airflow/Dagster/Prefect — DAG per pipeline, retries with backoff, task dependencies explicit, idempotent retry (rerun-safe).

## Reliability
- **Idempotency is the contract**: rerunning a date partition must yield the same result (recreate partition, dedupe by natural key, `INSERT ... ON CONFLICT DO NOTHING`).
- Watermarks/state: persisted (table or state store) — not recomputed-from-scratch each run.
- Failure handling: alert on task failure (oncall = `monitoring-observability` pattern), dead-letter for skipped rows (quarantine table + review), retry policy per task (transient network vs data-shape error).
- **Schema drift**: source changes column → pipeline breaks; mitigate with explicit source schemas + validation (assert types/counts) + alert on drift; warehouse backfill jobs for corrected historical data.

## Observability
- Data quality checks post-load: row counts vs expected, null-rate thresholds, freshness (max `event_date` within X), referential sanity (FK orphans).
- Metrics: pipeline duration, records/s, error counts, warehouse cost by table; dashboard per pipeline family.

## Cost & scale
- Pushdown: filter/project in SQL (warehouse), not Python; partition tables by date; cluster keys on join/filter columns; batch size tuned (100k-1M rows per task).
- Retain: raw indefinitely (cheap tier), curated 90d-2y per SLA, aggregates compressed.

## Checklist
- [ ] Incremental + watermark; idempotent rerun
- [ ] Orchestration with retries + alerts
- [ ] Schema drift detection + quarantine
- [ ] Post-load quality checks (counts/freshness)
- [ ] Pushdown transforms; partitioned tables