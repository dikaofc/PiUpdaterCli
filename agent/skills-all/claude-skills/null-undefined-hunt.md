---
name: null-undefined-hunt
description: Hunt TypeError on null/undefined by tracing data flow from producer to consumer — bounded scope, edge-case tests, no shotgun optional-chaining.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for all fact-gathering, verification, and rollback steps.
metadata:
  category: debugging
  tags: [null, undefined, typeerror, data-flow]
---

# Null / Undefined Hunt
<!-- built by @dikaacode (telegram) -->

## Objective
Find the producer of the null/undefined that a crashing line consumed: trace the value from each assignment site to the dereference, determine which path yields the empty value, and fix at the producer or enforce at the boundary — with edge-case tests, not a blanket of `?.` sprinkled downstream.

## Preconditions
- The TypeError message names the offending property/method and file:line.
- The symbol's producer sites are reachable via `cap explore <symbol>`.
- Repository is indexed (`cap index --refresh`).

## Workflow
1. Run `cap status` and `cap repo`; `cap show <file>` the crash line — confirm it dereferences a property/method on a nullable expression.
2. Find every assignment into that symbol: `cap explore <symbol>` lists producers and consumers; open each producer with `cap show <file>`.
3. Classify each producer: literal (always null), computed (may be null: optional chain result, map get, parse, conditional), or imported/parameter (nullability depends on caller — trace one hop up).
4. Narrow to the failing input: which caller path was live for the failing run (`cap search <caller>` and the branch conditions feeding it). Reproduce with that path; the crash input is the fixture.
5. Decide the boundary: the fix belongs at the *producer or trust boundary* (return default, validate the param, throw a typed error) — not at the dereference, unless the consumer is an external/published API that must be defensive. Check `cap rules` for contract obligations on which layer may assume non-null.
6. Apply the minimal fix on the chosen layer; for computed producers, prefer a default or explicit check over `?.` chains (one readable guard beats five sit-ops). `cap diff` to scope.
7. Write edge-case tests: empty string, missing key, empty collection, explicit null — one case per failure class from step 3, as a parameterized check in the project's runner (`cap test --target`).
8. Run `cap test`, `cap lint`, `cap typecheck`, `cap verify`; `cap memory add` the producer→consumer pattern (e.g., "API response field assumed present by UI").
9. Verify the original failing input now passes and no consumer changed (diff shows producer/boundary only).

## Verification
- [ ] Crash reproduced with a fixture before the fix; the fixture matches the failing run's path.
- [ ] Producer of the null identified with its classification (literal/computed/imported).
- [ ] Fix applied at producer or trust boundary; zero consumer-only changes (unless the consumer is a published API).
- [ ] Edge-case tests cover empty-string/missing-key/empty-collection/explicit-null for the symbol.
- [ ] `cap verify` passes; `cap diff` scoped.

## Failure Handling
- The value can be null at *every* producer (schema guarantees nothing): the contract is the problem — enforce at the boundary (validation, schema, typed function) instead of chasing call sites; if the schema cannot change, document and guard once at the boundary, naming the debt.
- Multiple crash sites share one producer: fix the producer once; the test set now covers all sites.
- Null arrives from a dependency (JSON parse, DB): `cap plugins` for the surface; add a validation schema at the parse boundary if the dependency does not validate — do not patch three consumers.
- A consumer is a published API but nullable internally: keep the defensive check there AND fix the producer; report both, the consumer check is the contract, the producer fix is the leak.

## Output Format
Report:
- Crash site (file:line) and the dereference expression.
- Producer trace: each assignment site, its classification, and the live path for the failing run.
- Boundary decision: which layer owns the guarantee, with the rule consulted.
- Fix: producer/default/boundary change, scoped `cap diff`.
- Edge-case tests added and their results; `cap verify` result.

## References
- CONTRACT.md §2 Skill Format; §1 Tool Layer (`cap explore`, `cap search`, `cap show`).
- `src-api.md` rules: validate at the trust boundary, validate at the trust boundary only.
- CONTRACT.md §7.3: trace the flow; the dereference is the symptom, the producer is the cause.