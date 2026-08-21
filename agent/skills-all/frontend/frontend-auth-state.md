# Skill: Frontend Auth State

## Purpose

Analyze frontend auth state: how the client knows authentication state, and
whether client-side state is ever treated as a security control.

## Scope

- Included: auth state storage, route guards, UI gating, client roles.
- Excluded: server auth (`../authentication/*`).
- Layers: frontend.

## Trigger Conditions

- Route guards as the only protection.
- Client-stored roles.

## Inputs

- frontend code
- backend (verification)

## Investigation Method

1. Identify entry points: client auth decisions.
2. Identify trust boundaries: client vs server truth.
3. Track relevant data: auth state.
4. Identify validation: server enforcement.
5. Identify security-sensitive operations: gated features.
6. Inspect authorization: server-side checks.
7. Inspect error handling: N/A.
8. Inspect tests: direct-API tests.
9. Determine exploitability or correctness impact: bypass.
10. Validate the finding: call APIs directly.

## Evidence Requirements

- E1: frontend gating + backend.
- E2: server gap.
- E3: test showing direct API access succeeds.

## Confidence

- CONFIRMED with E3; HIGH with E2.

## Severity

- HIGH if server lacks enforcement.

## Safe Reproduction

- Local direct-API tests.

## Root Cause

- Client auth state trusted server-side; UI-only gating.

## Impact

- Authorization bypass.

## Remediation

- Server-side enforcement; treat client state as UX only.

## Regression Test

- Direct-API tests.

## Common False Positives

- Server enforcement present (verify).

## Related Skills

- `../authorization/client-side-authorization.md`
- `local-storage-security.md`
- `../authorization/server-side-authorization.md`

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

- OWASP Authorization Cheat Sheet
- CWE-602
