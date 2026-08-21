---
name: database-backup-recovery
description: Plan database backups and recovery — RPO/RTO, backup types, restore drills, encryption, verification.
category: Database
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Backup & Recovery

## Define targets first
- **RPO** (how much data you can lose): ≤ 5 min (continuous WAL/binlog) typical for prod; guidelines per system (analytics 24h OK, billing ≤ 1 min).
- **RTO** (how fast you're back): ≤ 15 min hot standby failover; ≤ 2h restore-from-backup. Write targets down — recovery without targets is improvisation.

## Backup types (layer all)
- **Logical dumps** (pg_dump/mysqldump): portable, for migration/restore-only — slow on large DBs.
- **Physical hot backups** (pg_basebackup + WAL / xtrabackup / mariabackup): fast restore, base for PITR.
- **WAL/binlog archiving**: continuous point-in-time; archive to object store with retention (≥ 2× audit window; restore to any timestamp).
- **Managed DB**: RDS/GCP snapshots still need WAL retention + **test restore** — managed ≠ safe automatically.
- Frequency: full daily (or weekly + daily PITR), PITR continuous, plus pre-deploy-migration snapshot.

## Restore discipline (the part people skip)
- **Monthly restore drill**: restore latest backup to scratch environment, run smoke queries (row counts, a hand-written verify query), measure time → confirm RTO claim.
- Document runbook: who, how, expected duration, credentials access, fallback (last-known-good backup if latest corrupt).
- Test restore **the new server instance** — don't assume same-host restore.
- Corruption detection: `pg_amcheck` / `mysqlcheck --check`, plus CHECKSUM on restore compare.

## Encryption & access
- Backups at rest encrypted (object store SSE/KMS); keys rotated; access least-privilege (restore path separate from read path).
- Never store plaintext secrets inside DB backups (rotate DB creds quarterly) — backup = sensitive dataset, treat as such in retention/access docs.

## Verification checklist
- [ ] RPO/RTO documented and achievable
- [ ] Backup + PITR archived with retention
- [ ] Restore drill passed this quarter (with time recorded)
- [ ] Encryption + access control on backups
- [ ] Runbook current; someone knows how to run it