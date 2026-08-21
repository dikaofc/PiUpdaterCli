---
name: testing-strategy
description: Design a testing strategy — test pyramid, unit/integration/e2e split, coverage targets, CI wiring, flaky control.
category: Testing
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Testing Strategy

## Pyramid (realistic 2026)
- **Unit (60-70%)**: pure logic fast (ms); business rules, parsers, helpers.
- **Integration (20-30%)**: module + real DB/queues (testcontainers or service fixtures) — catches wiring bugs units can't.
- **E2E (5-10%)**: user-path smoke (Playwright/Cypress) on staging-like env — slowest, flakiest, most valuable signal per path. Keep small: happy path + 2-3 critical branches per flow.
- Above pyramid: contract tests (provider/consumer, `rest-api-design` + OpenAPI), visual regressions optional.

## Coverage targets (guide, not vanity)
- Line % is a lagging proxy — target meaningful **branch** coverage on business rules (boundaries: empty, zero, negative, max).
- 100% ≠ quality; untested critical paths (authz, payment, refund, migration) are the goal. Coverage report diff in CI (fail on hot-files drop).

## Test design rules
- **Test behavior, not implementation**: assert observable outcome (status, data, side effect), not internals/mock calls.
- Arrange-Act-Assert; one behavior per test (name = "given X, when Y, then Z").
- No test dependencies/ordering; parallel-safe (random data ids).
- Time: inject clocks (`date-fns` mock/clock lib), no sleeps (poll with timeout helper).
- Fixtures: builders/helpers > huge JSON blobs; per-test state over shared.

## Flaky control
- Flakiness = test bug — quarantine (tag, skip in CI, ticket), never ignore; rerun-until-pass is a smell.
- Stability: retry only network-y E2E with backoff, deterministic sleeps avoided.

## CI wiring
- Fast feedback: unit in pre-commit/pre-push, integration on PR, e2e on merge to staging; cache test deps; junit XML for reports; coverage summary comment on PR.

## Checklist
- [ ] Pyramid shape right-sized (fewer flaky E2E)
- [ ] Business rules branch-tested
- [ ] Behavior-over-implementation assertions
- [ ] Deterministic (no sleeps/ordering); flaky quarantined
- [ ] CI runs levels with gate