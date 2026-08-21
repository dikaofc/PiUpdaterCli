# Skill: Repository Layer Analysis

## Purpose

Analyze repository/data-access layer: tenant scoping, query safety,
parameterization, and consistent data access.

## Scope

- Included: repository queries, tenant filters, parameterization.
- Excluded: ORM config (`../database/orm-security.md`).
- Layers: data access.

## Trigger Conditions

- Multi-tenant data access.
- Query audits.

## Inputs

- source code

## Investigation Method

1. Identify entry points: repository methods.
2. Identify trust boundaries: caller → data.
3. Track relevant data: filters.
4. Identify validation: scoping/parameterization.
5. Identify security-sensitive operations: queries.
6. Inspect authorization: tenant scoping.
7. Inspect error handling: N/A.
8. Inspect tests: coverage.
9. Determine exploitability or correctness impact: gaps.
10. Validate the finding: repository tests.

## Evidence Requirements

- E1: repository code.
- E2: scoping/query gap.
- E3: test demonstrating it.

## Confidence

- CONFIRMED with E3; HIGH with E2.

## Severity

- HIGH for tenant-scoping gaps.

## Safe Reproduction

- Local repository tests with fixtures.

## Root Cause

- Missing tenant filters; raw queries.

## Impact

- Cross-tenant access, injection.

## Remediation

- Scope every query; parameterize; centralize data access.

## Regression Test

- Per-repository isolation tests.

## Common False Positives

- Scoping in ORM global filters (verify).

## Related Skills

- `service-layer-analysis.md`
- `../database/query-safety.md`
- `../authorization/resource-ownership.md`

## Review Checklist

- [ ] Entry point identified
- [ ] Trust boundary identified
- [ ] Data flow understood
- [ ] Validation checked
- [ ] Authorization checked
- [ ] Runtime behavior verified
- [ ] Evidence collected
- [ ] Severity assigned
- [ ] Root cause identified
- [ ] Remediation proposed
- [ ] Regression test proposed

## References

- OWASP ASVS V4
