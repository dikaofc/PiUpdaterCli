---
name: backup-recovery
description: Define backup cadence, retention, and a tested restore procedure.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository.
metadata:
  category: devops
  tags: [backup, recovery, data]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Backup & Recovery

## Objective
Ensure data is recoverable within an agreed RPO/RTO, proven by a real restore.

## Preconditions
- `cap repo` run; data stores and current backups reviewed (`cap explore <db|backup|snapshot>`).

## Workflow
1. Run `cap explore` for each stateful store and its backup config.
2. Set backup frequency and retention to meet RPO; encrypt backups at rest.
3. Automate offsite/object-storage copies; verify integrity after each backup.
4. Write and schedule a restore runbook; rehearse it (game day) to prove RTO.
5. Monitor backup success/freshness; alert on stale backups.
6. Record RPO/RTO and the runbook with `cap memory add`.

## Verification
- [ ] Backups encrypted + offsite.
- [ ] Integrity verified.
- [ ] Restore rehearsed and timed.
- [ ] Staleness alerted.

## Failure Handling
- If restore fails, fix the backup, not the runbook.
- If RPO unmet, increase frequency or use streaming.

## Output Format
Backup design: cadence, retention, encryption, restore runbook, and rehearsal result.

## References
CONTRACT.md §2 Skill Format.
CONTRACT.md §1 Tool Layer: `cap repo`, `cap status`, `cap index`, `cap explore`, `cap search`, `cap show`, `cap diff`, `cap verify`, `cap risk`, `cap rollback`.
docs/skill-development.md.
