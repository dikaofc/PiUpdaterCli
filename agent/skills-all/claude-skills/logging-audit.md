---
name: logging-audit
description: Audit logs — sensitive data exposure, level usage, structure (JSON), and rate — with confirmed findings.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for all fact-gathering, verification, and rollback steps.
metadata:
  category: review
  tags: [logging, secrets, pii, observability]
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Logging Audit

## Objective
Audit the project's logging for four failure classes: sensitive data written to
logs, wrong log levels (noise at info, silence at error), unstructured output that
breaks parsing, and runaway log rate. Deliver a findings table with file:line
evidence, severity, and a patch list for confirmed leaks only.

## Preconditions
- Repository is indexed (`cap index --refresh`); the logging entry points (logger
  module, config) are known or discoverable via `cap explore`.
- The project's log destination and format are identified (`cap show <logger>`).

## Workflow
1. Run `cap status` and `cap repo` to confirm environment and locate the logger.
2. Find the logger API: `cap explore "logger|log\."`; note whether it emits JSON (`cap show <logger>`).
3. Grep for sensitive data patterns at log call sites: `cap search "password|token|secret|apiKey|authorization"` restricted to log statements, `cap search "logger\.(info|warn|error).*body|headers"` for whole-object logging.
4. Check level discipline: `cap search "logger\.(log|debug|trace)"` — debug/verbose content at info level, and `cap search "console\.log"` for bypasses of the logger.
5. Check structure: `cap show` a sample of log calls; flag string-interpolation-only calls in a JSON pipeline and `console.error` used beside the structured logger.
6. Check rate risk: `cap search "logger\..*for \("` or locate loops containing log calls (`cap explore` the loop symbols); flag per-iteration logging in hot loops.
7. Read each flagged site with `cap show <file> [--lines a-b]` and confirm: SENSITIVE (actual secret/PII present), LEVEL (wrong level), UNSTRUCTURED (breaks pipeline), RATE (per-iteration in loop).
8. Run `cap risk --json`; then patch confirmed SENSITIVE and RATE sites (redact, drop, or move outside the loop) with `cap plan` + minimal edits.
9. Verify: `cap verify`, `cap test`, `cap lint`, `cap typecheck`; `cap rollback --task <id>` on regression.
10. `cap memory add` the log conventions (redaction rules, JSON-only, loop rule).

## Verification
- [ ] Every SENSITIVE finding confirmed by reading the code path (`cap show`), not guessed from grep alone.
- [ ] Patched sites: secrets redacted or removed; loop logging moved or leveled down.
- [ ] `cap verify` passes; `cap diff` shows only logging changes.
- [ ] UNSTRUCTURED/LEVEL findings listed with evidence even when not patched.
- [ ] No `console.log` bypass left on patched paths.

## Failure Handling
- If a SENSITIVE finding's data path is unclear (dynamic keys, spread of an object): read the caller chain via `cap explore <symbol>` before patching — redact the whole object if provenance is uncertain.
- If log rate is enforced by infra outside the repo: note the per-iteration site and recommend the fix; do not restructure a hot loop on suspicion without profiling evidence.
- If the logger is not JSON-structured: report the structural finding; converting the logger is out of scope unless the user requests it (`cap plan` first).

## Output Format
- Findings table: file:line | class (SENSITIVE/LEVEL/UNSTRUCTURED/RATE) | severity | evidence | status (patched/reported).
- Patch list: redactions, removals, level changes.
- Verification results (`cap verify`, `cap test`, `cap risk`).
- Conventions recorded via `cap memory add`.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap explore`, `cap search`, `cap show`, `cap risk`, `cap rollback`.
- CONTRACT.md §3 Secret-handling rules (never commit secrets; logs are output, not storage).