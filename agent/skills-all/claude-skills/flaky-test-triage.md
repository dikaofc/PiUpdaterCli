---
name: flaky-test-triage
description: Triage a flaky test by isolating its nondeterminism — never mask it with retries without evidence.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for all fact-gathering, verification, and rollback steps.
metadata:
  category: testing
  tags: [flaky, test, determinism, triage]
---

# Flaky Test Triage
<!-- built by @dikaacode (telegram) -->

## Objective
Turn "sometimes fails" into a named nondeterminism source: an order dependence, timing dependence, shared-state leakage, or environmental variation — proven by isolation attempts, then fixed by removing the dependence, not by retry wrappers.

## Preconditions
- One failing test is identified as flaky (passes/fails across runs without code change).
- The test and its module are runnable (`cap test --target <file>`).
- Repository is indexed (`cap index --refresh`).

## Workflow
1. Run `cap status` and `cap repo`; reproduce the flake yourself — run the single test repeatedly (budget N=10) and record the pass/fail pattern before touching anything.
2. Read the test with `cap show <file>`: enumerate its inputs (fixtures, env, mocks, shared helpers) and every order-sensitive construct (iteration over unordered collections, `Math.random`, `Date.now`, real timers, external calls).
3. Isolate alone: run the test file in isolation and in random order (`cap test --target <file>` vs. full-suite run). Flake only in the suite = order dependence or leakage from prior tests; flake alone = self-contained nondeterminism (timing, randomness).
4. For timing suspicion: `cap search <setTimeout|interval|real timers|await new Promise>` in the test and its unit under test; replace with deterministic fake timers in the test, re-run N times.
5. For order dependence: `cap search` the shared fixtures/modules the test reads; identify mutations by neighboring tests (`cap explore` the suite's other cases touching the same module state). Fix by isolating state per test (fresh fixture in setup), not by reordering.
6. Check the environment axis last: locale, TZ, network, port collisions (`cap permissions`, `cap rules` for env preconditions). Only after steps 3–5 fail to reproduce should environment be suspected — and then reproduce it with the exact env delta.
7. Fix the dependence (deterministic seed, fake timers, per-test state). Run `cap diff` to scope, then the full suite plus the flaky test alone N times.
8. The test must pass N consecutive runs both alone and in-suite. `cap memory add` the flake root cause and its fingerprint (alone-flaky vs. suite-only).

## Verification
- [ ] Flake reproduced locally (pattern recorded, N runs) before any change.
- [ ] Isolation axis determined: suite-only (order/leakage) or alone (timing/random).
- [ ] Nondeterminism source named: which construct, which neighboring test, which env var.
- [ ] Fix removes the dependence — no retry wrapper, no `--repeat` masking, no skipped test.
- [ ] N consecutive passes alone and in-suite post-fix; `cap verify` passes.
- [ ] `cap diff` scoped to the test and/or the deterministic seam only.

## Failure Handling
- Flake cannot be reproduced locally: note it, and still triage statically — classify by code reading; schedule a re-check when the environment reproduces. Do not label the test "rare, ignore".
- Root cause is an upstream library's nondeterminism: `cap plugins` to confirm the boundary; pin/deterministically seed the dependency if licensable, otherwise document and escalate — a documented cause beats a masked test.
- Retry wrapper already exists on the test: remove it as part of the fix once the true cause is addressed. If the cause cannot be fixed in this session, keep the wrapper ONLY with a comment naming the open cause, and report the debt.
- Fix requires changing behavior of code under test (not just the test): treat as two changes — deterministic seam + test — and review the seam change separately (`cap review`).

## Output Format
Report:
- Reproduction pattern: pass/fail sequence over N runs, alone vs. in-suite.
- Isolation result: which axis (order / timing / env) is implicated, with the probe that decided it.
- Root cause: exact construct (`file:line`) that sources nondeterminism.
- Fix: added determinism (fake timers, seeded RNG, isolated fixture), scoped `cap diff`.
- Post-fix evidence: N passes alone and in-suite; `cap verify` result; memory entry added.

## References
- CONTRACT.md §2 Skill Format; §1 Tool Layer (`cap test`, `cap search`, `cap show`, `cap diff`).
- `test` skill for the targeted-first discipline; `debug` for reproduce-before-theorize.
- CONTRACT.md §7.2/§7.3: evidence over assumption; a flaky test is a bug report, not a skip.