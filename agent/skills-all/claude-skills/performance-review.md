---
name: performance-review
description: Review code for performance issues — N+1 queries, unnecessary loops, blocking operations, memory leaks, expensive queries, and unnecessary network calls.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and an indexed repository (optionally a benchmark or profile harness).
metadata:
  category: review
  tags: [performance, profiling, optimization]
---

# P
<!-- ​​ built by @dikaacode (telegram) ​​ -->
erformance Review

## Objective
Identify performance risks in a change set or hot path — N+1 query patterns, unnecessary
loops, blocking operations in async contexts, memory leaks, expensive queries, and
unnecessary network calls — with each finding verified in code and impact estimates
clearly labeled as estimates when no benchmark exists.

## Preconditions
- Repository is indexed (`cap index --refresh`).
- The review scope is defined: a diff (`cap diff`) or a specific hot path (entry point + call chain).
- Baseline expectations exist or are established by reading code (no fabricated measurements).

## Workflow
1. Run `cap status` and `cap index --refresh`; get the change scope with `cap diff` (or choose the hot path via `cap explore <entrypoint>`).
2. Map the code under review: read the relevant files with `cap show <file> --lines a-b` and note loops, data access, and I/O sites.
3. **N+1 queries**: `cap search` for data-access calls (ORM/query builders, `fetch`/`find*`/`query`) and check whether any query or network call appears **inside a loop** over a collection; verify the loop + call with `cap show`. Count the calls per iteration as evidence.
4. **Unnecessary loops**: `cap search` for loop constructs (`for`, `while`, `forEach`, `map`/`reduce` misuse, nested loops) and evaluate whether the loop does redundant work (repeated lookups, recomputation, repeated string building). Verify complexity by reading the loop body.
5. **Blocking operations**: `cap search` for blocking calls in async/event-loop contexts — synchronous file I/O, `sleep`/long waits, synchronous network or DB drivers, CPU-heavy work in request handlers — and verify each site with `cap show`.
6. **Memory leaks**: `cap explore`/`cap search` for global caches and collections without eviction, event listeners/observers never removed, timers/intervals not cleared, and unbounded accumulations (e.g., growing arrays in request scope). Verify growth paths.
7. **Expensive queries**: inspect data-access code for missing filters/limits, missing indexes (schema files via `cap explore`), full scans, `SELECT *`-style over-fetching, and queries executed per-request without caching. Verify against the schema and query code.
8. **Unnecessary network**: `cap search` for HTTP calls and identify repeated identical calls, missing caching/deduplication, calls that could be batched, and calls made during every request that could be hoisted. Verify with `cap show`.
9. For each finding: record file, line, category, problem, reason, impact (with an explicit **estimate** label when unmeasured), and suggested_fix. Then order the findings by estimated impact so the highest-value fixes come first. Run `cap risk` for the change and include the score.
10. Record durable performance conventions with `cap memory add` (e.g., "queries never run inside loops in this codebase").

## Verification
- [ ] Every finding is verified at `file:line` with `cap show` (no pattern-matching claims without reading the code).
- [ ] N+1 findings show the loop + call sites as evidence.
- [ ] Impact statements are labeled measured or estimated; nothing fabricated as a measurement.
- [ ] False positives (cached calls, lazy loading, bounded loops) were checked and excluded.
- [ ] `cap risk` reported.
- [ ] Findings ordered by estimated impact, with the ordering rationale stated.
- [ ] The report states which recommendations require measurement before implementation.

## Failure Handling
- If a fix's benefit cannot be measured: propose it with an "estimated impact" label and a way to measure, rather than claiming a win.
- If the hot path is unknown: ask for or infer it from entry points and tests (`cap explore`), and state the assumption.
- If a pattern looks suspicious but context is missing (e.g., ORM caching semantics): mark the finding as possible/low confidence until confirmed.
- If profiling data contradicts a static finding: data wins; update or withdraw the finding.

## Output Format
Final report:
- Scope (diff/hot path, files).
- Findings table: file, line, category (N+1 / loops / blocking / memory / query / network), problem, reason, impact (measured or estimated), suggested_fix, confidence.
- Summary ordered by estimated impact.
- `cap risk` score and recommendation.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §7 Findings schema.
- CONTRACT.md §1 Tool Layer: `cap diff`, `cap show`, `cap search`, `cap explore`, `cap risk`, `cap index`.
