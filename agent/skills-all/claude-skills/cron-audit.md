---
name: cron-audit
description: Audit cron jobs and scheduled tasks for overlaps, clock-drift, missing files, and absent failure notifications.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18); the audit is read-only and covers cron, systemd timers, and in-app schedulers.
metadata:
  category: review
  tags: [cron, schedule, timers, audit]
---

# Cron Audit
<!-- ​​ built by @dikaacode (telegram) ​​ -->

## Objective
Audit all scheduled jobs (crontab entries, systemd timers, in-app schedulers such as node-cron or CI schedules) for overlapping runs, schedule drift, missing target scripts, unsafe logging, and absent failure notification — and produce a prioritized fix plan.

## Preconditions
- Access to the schedule sources: user crontab and `/etc/cron*` (where permitted), systemd timer units, in-app scheduler declarations (`cap search` for cron libraries), CI schedule files.
- Read-only audit; fixes are only applied with explicit user approval.

## Workflow
1. Run `cap status` and `cap repo` to record repo state; note whether cron config lives in-repo (e.g. `.github/workflows`, `crontab`, systemd units) or out-of-repo (machine crontab).
2. Inventory schedulers in-repo: `cap search` for `crontab`, `*/` schedule patterns, cron libraries (`node-cron`, `cron`, `crontab` in code, `github actions schedule`); read each with `cap show`.
3. Inventory machine schedulers (environment-dependent): user crontab (`crontab -l`), systemd timers (`systemctl list-timers`), `/etc/cron.*` entries. Record each job: schedule expression, command, environment, output/redirection.
4. Fire-time computation: expand each cron expression against the upcoming 7 days; detect overlaps (jobs with intersecting windows) and heavy-window collisions (same minute across jobs).
5. Drift check: for each job compare schedule intent vs expression; compute expected fire count per day and flag expressions that never fire on some platforms (e.g. `0 0 * * 0` Sunday quirks, DST-sensitive hours).
6. Target-existence check: for each command, verify the script path exists (`cap show`/stat), is executable, and its dependencies are present; run `cap explore <script>` to check the job's entry symbol.
7. Failure-notification check: for each job record whether exit codes are captured, output is logged to a file (not lost to `/dev/null` twice), and an alert mechanism exists (e-mail, webhook, CI failure status).
8. Compile findings: severity (blocker = lost work, warning = missed schedule, info = hygiene), each with evidence (job, expression, line).
9. If fixes are approved: apply the smallest edit (correct expression, add redirect, add guard), then validate the changed schedule parses and `cap verify` passes for in-repo changes; show `cap diff`.

## Verification
- [ ] Both in-repo and machine schedulers inventoried (or explicitly marked unavailable).
- [ ] Every job's expression expanded and checked for overlaps and never-fire cases.
- [ ] Every job's target script/path existence verified.
- [ ] Exit-code capture, logging target, and failure-notification status recorded per job.
- [ ] Findings have evidence (job, expression, file:line) and severity.
- [ ] If fixes applied: schedule parses, `cap verify` passes for repo changes, `cap diff` shown.

## Failure Handling
- If machine crontab/systemd is not readable in this environment: mark that inventory UNKNOWN, audit in-repo schedulers only, and state the gap.
- If a job's target is missing: blocker — do not "fix" by creating a stub; report and ask the user for the correct target.
- If an overlap cannot be resolved without knowing job priorities: pause and ask the user; do not reorder jobs silently.
- If editing a crontab fails (syntax/permission): never force-write; restore previous content from the recorded backup and report.

## Output Format
Final report:
- Inventory: scheduler type, job, schedule expression, command, environment.
- Upcoming-week fire map and overlap/collision list.
- Drift and never-fire findings with platform notes.
- Missing-target and notification-gap findings.
- Severity-ordered fix plan and applied fixes (if any) with `cap verify`/`cap diff` results.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap status`, `cap repo`, `cap search`, `cap show`, `cap explore`, `cap verify`, `cap diff`.