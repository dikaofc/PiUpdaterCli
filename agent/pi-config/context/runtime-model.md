# Runtime Model

Runtime behavior is the highest-value evidence (E3+) and the only way to confirm
findings that static analysis can only suspect. This model defines how to analyze
runtime behavior safely and reproducibly.

## What Runtime Analysis Answers

- Does the suspicious path actually execute? (reachability at runtime)
- What does the behavior look like? (E3 behavioral evidence)
- What is the impact? (E4 impact evidence)
- Does the proposed fix change the behavior? (E5 root-cause evidence)

## Safe Runtime Methods

- **Local dev server** against a seeded database with synthetic data.
- **Unit/integration tests** that exercise the path with real input.
- **Mocks and stubs** for external services (HTTP, SMTP, payment, cloud APIs).
- **Sandboxes/containers** with network egress disabled or allow-listed.
- **Instrumentation** (tracing, logging, profilers) on the local instance only.
- **Request/response captures** from the local or mocked service.

Never point runtime tests at systems the auditor does not control, and never send
destructive or credential-harvesting probes anywhere.

## What to Observe

- Request/response pairs (status, headers, body, timing).
- Database queries executed (via local query logs) — confirms sink behavior.
- Error paths: stack traces, log output, returned messages (leakage analysis).
- Resource usage: memory, CPU, file descriptors, connections (exhaustion analysis).
- State transitions: before/after snapshots of the relevant state.
- Concurrency: parallel request patterns to expose races (with careful, safe
  orchestration on local state).

## Reproduction Discipline

1. Write the minimal reproduction first (a failing test is ideal).
2. Run it before the fix: capture the failure artifact (assertion, trace, log).
3. Apply the minimal fix; run the same test: it passes.
4. Run the surrounding functional tests: no regressions.
5. Record all three results as evidence (E3 → E4 → E5).

## Limits

- Runtime analysis in mocks may miss environment-specific behavior (versions,
  platform, deployment config). State environment differences explicitly.
- Absence of observed exploitation ≠ absence of defect; document what was not
  exercised.

## Related

- `../context/evidence-model.md` (E3–E5)
- `../skills/dynamic-analysis/dynamic-behavior-analysis.md`
- `../skills/dynamic-analysis/runtime-instrumentation.md`
- `../skills/testing/reproduction-test-design.md`
- `../workflows/incident-debugging.md`
