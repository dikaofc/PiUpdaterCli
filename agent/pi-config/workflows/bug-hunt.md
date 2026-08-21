# Workflow: Bug Hunt

## Purpose

Active, hypothesis-driven hunting for security vulnerabilities and correctness bugs
across a codebase — the exploratory counterpart to structured audit workflows.

## Method

### 1. Generate Hypotheses

- From the threat model (`../context/threat-modeling.md`): ranked attack paths.
- From risky patterns: dynamic sinks, string-built queries, unsafe deserialization,
  raw file paths, custom auth, global mutable state, missing error handling.
- From business rules: state machines, pricing, balances, quotas, approvals
  (`skills/business-logic/business-rule-analysis.md`).
- From recent changes: diffs touching auth, payments, parsers, dependencies.

### 2. Prioritize

Rank hypotheses by (reachable high-impact) — feed into the deep-audit method for
the top ones. Keep a hypothesis log: id, area, why, status.

### 3. Trace & Verify

For each hypothesis: trace data flow, check controls, reproduce safely (E3),
confirm root cause (E5). Skills activated per hypothesis via `../SKILL_ROUTER.md`.

### 4. Classify

- Security vs correctness vs neither.
- Severity + confidence + evidence level.

### 5. Fix & Test

Fixing mode (`../METHODOLOGY.md`): minimal fix + regression test for every
confirmed bug.

### 6. Track & Report

- Log every hypothesis and its disposition (confirmed / probable / suspected /
  false positive) — this is the hunt record.
- Report confirmed/probable findings per the report template; summarize the hunt
  per `../templates/audit-summary.md`.

## Hypothesis Log Format

```
ID | Area | Hypothesis | Evidence | Status (confirmed/probable/suspected/FP)
```

## Rules

- A hypothesis is never a finding until verified.
- Spend budget by impact, not by curiosity.
- Keep the log honest about coverage gaps.

## Related

- `../workflows/full-project-audit.md`, `../workflows/deep-audit.md`
- `../skills/reporting/finding-classification.md`
- `../context/false-positive-model.md`
