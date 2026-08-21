# Security Review: <subject>

## Scope Reviewed

- Change / component / diff / commit range
- In scope: <list>
- Out of scope (explicitly): <list>

## Architecture Context

<how the subject fits: entry points, trust boundaries, assets touched>

## Findings

### Blocking

| # | Finding | Severity | Confidence | Evidence | Fix | Regression test |
|---|---------|----------|------------|----------|-----|-----------------|

### Non-Blocking

| # | Finding | Severity | Confidence | Notes |
|---|---------|----------|------------|-------|

### Informational

<hardening suggestions, no demonstrated impact>

## Verified Safe Items

<items checked and found safe — negative results matter>

## Coverage Gaps

<what was not reviewed and why>

## Recommendation

<APPROVE | APPROVE WITH CHANGES | REQUEST CHANGES>, with rationale.

---

## Notes

- Every finding must reference its evidence (E-level) and a proposed regression test.
- Use `../checklists/pre-release.md` when this review gates a release.
