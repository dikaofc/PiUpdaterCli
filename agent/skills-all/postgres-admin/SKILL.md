---
name: postgres-admin
description: Operate PostgreSQL — maintenance, vacuum, indexes, replication, backups, monitoring, troubleshooting.
category: Database
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# PostgreSQL Administration

## Routine maintenance
- Autovacuum on (default): monitor `n_dead_tup` vs autovacuum threshold; oversized tables need tuned `autovacuum_vacuum_scale_factor` or manual `VACUUM (ANALYZE)` schedule. Bloat check: `pgstattuple` / `pg_bloat_check`.
- `ANALYZE` after bulk loads (stats drive planner); `REINDEX CONCURRENTLY` when index bloat; never `VACUUM FULL` in prod (exclusive lock — it rewrites; only in maintenance window).
- Regular tasks cron: pg_dump nightly + WAL archiving; PITR test monthly.

## Performance
- `pg_stat_statements` = the report card: top by total time/calls → index or rewrite (`sql-query-optimization`).
- Connect pools: local app pool + PgBouncer for high connection counts; `max_connections` sane (not 10000).
- Memory: shared_buffers ≤ 25% RAM (default too low ~128MB), work_mem for sorts (40-70% per op), effective_cache_size ~50-75% RAM; verify with `EXPLAIN` cost changes, not folklore.
- WAL: `wal_level=replica` for PITR; cheap `checkpoint_timeout` review.

## Replication & high availability
- Streaming + synchronous_commit (if consensus), replicas for reads (routing via app/load), WAL archiving to object store.
- Failover rehearsed (pg_ctl promote / Patroni) — test yearly; replication lag alert (pg_stat_replication replay_lsn distance).
- Logical replication (pg_17 standard) for cross-version migrations/distribution.

## Backup
- `pg_basebackup` + continuous WAL (or `pgBackRest`/`WAL-G` — compression+parallel), retention 14-30d, restore tested monthly to scratch cluster (verify queries run).
- Document RPO (≤ 5 min with WAL) and RTO (measured).

## Troubleshooting map
- High CPU: pg_stat_statements top queries. Lock contention: `pg_locks` waiting/blocking pairs. Connection exhaustion: pool config. Slow checkpoint: checkpoint_timeout/IO. Table bloat: vacuum lag → schedule.

## Checklist
- [ ] Autovacuum tuned, bloat monitored
- [ ] pg_stat_statements enabled + reviewed
- [ ] Backups + WAL archiving + PITR test
- [ ] Replica lag alert
- [ ] Failover rehearsed