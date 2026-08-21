---
name: mysql-admin
description: Operate MySQL/MariaDB — InnoDB tuning, replication, backups, pt tools, troubleshooting common issues.
category: Database
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# MySQL / MariaDB Administration

## InnoDB tuning (v8/5.7 compatible)
- `innodb_buffer_pool_size` = 60-75% RAM (the #1 default fix); `innodb_flush_log_at_trx_commit=1` (durability) — change only with documented tradeoff.
- `innodb_buffer_pool_instances` = pool/1GB; `innodb_io_capacity/max` match disk (SSD 1000/4000).
- `innodb_file_per_table` on (default v8) — table-level space reclaim.
- Connection: `max_connections` + thread pool (MariaDB) or proxy (ProxySQL) for spikes.

## Index & schema notes
- `EXPLAIN` MySQL-specific: `key`, `rows`, `Using filesort` (🟡 avoid on hot paths), `type=ALL` (seq scan) — fix by index or rewrite.
- Composite index order left-to-right; `utf8mb4` everywhere (emojis), `COLLATE` consistent in joins (implicit collation errors); `utf8mb4` indexes on VARCHAR(191) (767-byte limit) unless `innodb_large_prefix`.
- Enumerations: prefer lookup tables over ENUM column (ALTER cost).

## Replication & backup
- GTID-based replication (v5.6+/MariaDB 10) — failover simpler; check `Seconds_Behind_Master` (be aware: misleading during heavy replication) + `gtid_executed` gap.
- Semi-sync in between sync caveats; binlog retention plan (PITR needs binlogs ≥ backup cadence).
- `mysqldump` (logical, single-threaded slow) vs `xtrabackup`/`mariabackup` (physical hot backup) — physical for big DBs; `--single-transaction` for consistency while preserving app writes.

## Common incidents
- **Deadlocks**: `SHOW ENGINE INNODB STATUS` LAST DEADLOCK — same lock order missing; retry loop in app (deadlock is expected sometimes — 2-3 retries).
- **Disk full from binlogs**: `expire_logs_days`/`binlog_expire_logs_seconds` set.
- **Slow on big alter**: ALTER copies table (mostly) — schedule, or pt-online-schema-change (Percona Toolkit) with FK care.
- **Table bloat**: `OPTIMIZE TABLE` (locks) vs pt-online-schema-change; temp tablespace runaway `tmp_table_size` review.
- Replication lag: long transactions, full-table DDL, `innodb_flush_log_at_trx_commit` impact, oversized batch updates.

## Checklist
- [ ] Buffer pool sized to RAM
- [ ] EXPLAIN clean on hot queries
- [ ] GTID + binlog retention; backups tested (restore drill)
- [ ] Deadlock retry in app code
- [ ] Alters scheduled/online