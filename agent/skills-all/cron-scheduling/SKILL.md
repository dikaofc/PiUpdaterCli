---
name: cron-scheduling
description: Schedule jobs with cron — syntax, logging, mail, environment, overlapping prevention, timezone pitfalls.
category: Shell & CLI
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Cron

## Syntax (5 fields)
`min hour dom mon dow` — add `?`-style warnings: month/day nameswork (`0 9 * * 1-5` = weekdays 9am); ranges `8-10`, steps `*/15`.
- Real-world favorites: minute `* * * * *` ok for light ops; `*/5` for monitors; `0 3 * * 6` backups.
- Second-level: not supported — `sleep` ladder or run every minute and gate (`[[ $((10#$min % 10)) -eq 0 ]]`).

## Environment & gotchas
- cron has minimal PATH/env (no login shell) — every job script: absolute paths, explicit `PATH=...`, `export TZ=...` if timezone matters, `HOME=` set.
- **Logging**: append to `>> job.log 2>&1` every run or you get nothing on failure except cron mail (usually unrouted) — or capture output + alert on nonzero.
- Overlap: `flock -n /tmp/job.lock cmd || exit` — prevents two runs stacking when a job takes longer than cadence; long jobs: check pgrep or use wait marker.
- Output size: log rotation (`logrotate` or `mkdir -p logs; : >` kept last N).
- Cron daemon not running in containers (no cron in many images — use host cron `cron.d` or a task scheduler).

## Time zones & drift
- Cron uses system TZ — document intent; `CRON_TZ=` (vixie) or run with `TZ=... env` inside job.
- DST: jobs on `0 2` may skip/duplicate — prefer UTC cron or job-computed windows.
- `10th minute`? Avoid `0 0 * * *` sync-stampedes (load at midnight) — stagger `7 3 * * *`.

## Testing
- `run-parts --test /etc/cron.d` dry-run; `crontab -l` review; job: run script manually first; check exit codes; sleep-based windows not covered by `croniter`-style validators.

## Checklist
- [ ] Absolute paths + explicit env in cron jobs
- [ ] Logging to file + nonzero-exit alert
- [ ] flock/pgrep overlap guard
- [ ] TZ documented; DST-safe
- [ ] Rotation on verbose jobs