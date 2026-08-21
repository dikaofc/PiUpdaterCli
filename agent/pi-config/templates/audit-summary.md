# Audit Summary: <subject>

## Audit Information

- **Date:** <date>
- **Auditor:** <agent/human>
- **Scope:** <components in scope>
- **Workflow used:** <full-project-audit | quick-audit | deep-audit | ...>
- **Environment:** <repos/versions/config reviewed>

## Headline Results

- Total findings: <n> (security: <n>, correctness: <n>)
- By severity: CRITICAL <n> / HIGH <n> / MEDIUM <n> / LOW <n> / INFORMATIONAL <n>
- By confidence: CONFIRMED <n> / HIGH <n> / MEDIUM <n> / LOW <n> / FALSE POSITIVE <n>

## Top Risks (priority order)

1. <finding title> — <severity/confidence> — <one-line impact>
2. ...

## Findings Detail

| # | Finding | Type | Severity | Confidence | Evidence | Status |
|---|---------|------|----------|------------|----------|--------|

## Remediation Status

- Fixed with regression tests: <list>
- In progress: <list>
- Scheduled: <list>
- Waived/risk-accepted: <list with owners>

## Verified Safe Areas

<negative results: what was checked and found safe>

## Coverage Gaps & Limitations

<what was not audited and why; residual risk statement>

## Recommendations

<next actions: fixes, deeper audit of X, dependency upgrades, process changes>

---

## Notes

- Prioritize output per AI Response Rules (../METHODOLOGY.md): confirmed →
  probable → high-confidence → architectural → medium → low.
- Never include speculative findings; convert them to coverage-gap notes.
