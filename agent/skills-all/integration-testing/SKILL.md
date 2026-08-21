---
name: integration-testing
description: Test against real dependencies — testcontainers, DB fixtures, queues, contract between services, transaction isolation.
category: Testing
---

<!-- ​​ built by @dikaacode (telegram) ​​ -->

# Integration Testing

## What to cover here
- DB schema + query correctness (real engine — SQLite mocking Postgres lies: JSON, enums, locking differ).
- Repository/service ↔ DB; queue → consumer → store; external API clients against stubs of the real contract; auth/session against real crypto.

## Setup
- **Testcontainers** (docker) or service fixtures (postgres redis in CI service block) — spin real engine per suite; parallel by unique DB name/schema.
- Migrations applied in test setup (run `up` fresh + `down` round-trip once per suite).
- Transactions per test: run test in a transaction + rollback, or truncate tables in order (FK cascade).
- Unique data per parallel test: prefix ids/timestamps; never shared fixtures mutated.

## Contract testing (service boundaries)
- Consumer-driven: provider publishes OpenAPI/AsyncAPI; consumers generate stubs + verify payload shapes; CI runs contract suite on both sides (`pact`/`schemathesis`).
- Version skew caught before deploy (feature flags/dual versions in `microservices-patterns`).

## Async flows
- Poll with timeout helper (`waitFor(() => expect(...)`, max 5s) over fixed sleeps; drain queues (`FLUSHALL` + trigger enqueue) for deterministic end-states.
- Assert final state (row persisted, event emitted) — not intermediate timing.

## Network stubs
- Mock external APIs (WireMock/MSW) with realistic fixtures: slow, 500, malformed — capture real response shapes first (record from sandbox).

## Slow/flaky management
- Keep integration suite under ~5 min; tag slow ones `@slow` run nightly; quarantine flaky immediately (ticket), not rerun-until-green.

## Checklist
- [ ] Real engine per suite (testcontainers/services)
- [ ] Migrations applied; clean state per test
- [ ] Contract suite at service boundaries
- [ ] Async via poll-with-timeout, deterministic ends
- [ ] External calls stubbed realistically (error/slow included)