# Reference: Bug Taxonomy

Taxonomy of non-security correctness defects (still reportable, still need
regression tests).

## State & Logic

- Invalid state transitions → `skills/business-logic/state-transition-analysis.md`
- Inconsistent balances/counters → `price-integrity.md`, `quantity-integrity.md`
- Duplicate operations → `duplicate-operation.md`
- Replay/retry amplification → `replay-protection.md`, `retry-analysis.md`
- Quota bypass → `quota-bypass-analysis.md`

## Concurrency

- Data races → `skills/concurrency/race-condition.md`
- TOCTOU → `toctou-analysis.md`
- Deadlocks → `deadlock-analysis.md`
- Lost updates → `atomicity-analysis.md`
- Cross-request shared state → `concurrent-state.md`, `async-state-analysis.md`

## Errors & Resilience

- Unhandled/incorrect exceptions → `skills/errors/exception-analysis.md`
- Fail-open on errors → `fallback-security.md`
- Infinite/amplified retries → `retry-analysis.md`
- Missing timeouts → `timeout-analysis.md`
- Crash loops → `error-boundary-analysis.md`

## Resources & Performance

- Memory leaks → `skills/performance/memory-leak-analysis.md`
- Connection/fd leaks → `connection-leak.md`, `file-descriptor-leak.md`
- Unbounded work → `infinite-loop-analysis.md`, `algorithmic-complexity.md`
- Cache correctness → `caching-correctness.md`
- Exhaustion → `resource-exhaustion.md`, `cpu-exhaustion.md`, `disk-exhaustion.md`

## Data

- Type confusion → `skills/input-validation/type-confusion.md`
- Numeric overflow/rounding → `boundary-validation.md`
- Encoding/unicode mishandling → `encoding-validation.md`, `unicode-handling.md`
- Transaction partiality → `skills/database/transaction-integrity.md`

## Related

- `../skills/business-logic/*`, `../skills/concurrency/*`,
  `../skills/errors/*`, `../skills/performance/*`
- `../templates/bug-report.md`
