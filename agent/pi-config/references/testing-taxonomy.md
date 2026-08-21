# Reference: Testing Taxonomy

Taxonomy of testing strategies and their purposes. Use during remediation to pick
the right regression-test type, and during audits to spot missing coverage.

## Functional Testing

- Unit tests → `skills/testing/unit-test-security.md`
- Integration tests → `integration-test-security.md`
- Regression tests → `regression-testing.md`

## Negative & Boundary

- Negative testing (denied/unexpected must fail) → `negative-testing.md`
- Boundary/limit testing → `boundary-testing.md`

## Generative

- Property-based testing → `property-based-testing.md`
- Fuzzing (coverage-guided, grammar, API) → `skills/fuzzing/fuzzing-strategy.md`
- Mutation testing (test quality) → `mutation-testing.md`

## Security-Specific

- Security test design (abuse cases, threat-driven) → `security-test-design.md`
- Reproduction test design (bug → test) → `reproduction-test-design.md`

## Static & Dynamic

- Static analysis / SAST → `skills/static-analysis/static-code-analysis.md`
- Taint analysis → `taint-analysis.md`
- Dynamic behavior analysis → `skills/dynamic-analysis/dynamic-behavior-analysis.md`
- Runtime instrumentation → `runtime-instrumentation.md`

## Mapping Defect → Test

| Defect class | Preferred test |
|---|---|
| Input boundary | boundary/negative tests |
| Authorization | per-endpoint × role negative tests |
| Invalid state transition | state-machine tests |
| Concurrent request | parallel invocation tests |
| Malformed payload | fuzz/property tests |
| Expired token | lifecycle tests |
| Missing permission | negative tests |
| Duplicate operation | idempotency tests |
| Dependency behavior | upgrade + contract tests |
| Error path | exception injection tests |

## Related

- `../skills/testing/*`, `../skills/fuzzing/*`
- `../templates/regression-test.md`
