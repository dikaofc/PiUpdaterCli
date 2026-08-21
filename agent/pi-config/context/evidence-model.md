# Evidence Model

Every finding in this knowledge base must be tied to an evidence level. Evidence is the
backbone of the system: severity without evidence is speculation, and confidence without
evidence is guesswork.

Evidence levels are cumulative in practice but must be recorded independently so the
reviewer can see exactly how far the investigation went.

## Evidence Levels

### E0 — No Evidence

Only theoretical suspicion. No code path inspected, no data flow traced, no behavior
observed.

**Reporting rule:** Never report E0 as a finding. An E0 observation may be recorded as a
*note* or a *follow-up item*, explicitly labeled `UNKNOWN`, never as a vulnerability.

### E1 — Static Evidence

Source code (or configuration, dependency manifest, lockfile, spec) indicates a
potentially dangerous path. Examples:

- a sink call exists (e.g., a string built by concatenation is passed to a query API)
- a header or flag enables a dangerous mode
- a dependency version range includes a vulnerable release

**Reporting rule:** E1 alone supports at most a MEDIUM-confidence *suspicion*. Do not
state impact from E1 alone; impact must be derived from later levels.

### E2 — Data-Flow Evidence

The source of the data is identified and the data can be traced (through
transformations, validation, and authorization) to the sensitive operation. Examples:

- an HTTP parameter is traced to a query argument with no intervening validation
- a user-controlled filename reaches a filesystem write
- a deserialized object reaches a dynamic instantiation

**Reporting rule:** E2 is the minimum for a LOW-to-MEDIUM confidence *probable* finding
where exploitability is argued from the trace. E2 without a behavioral check still
cannot be marked CONFIRMED.

### E3 — Behavioral Evidence

A controlled test (unit test, integration test, local run against fixtures, mock
service) demonstrates the unexpected behavior. The behavior is observed, not inferred.

**Reporting rule:** E3 is the minimum evidence level for a CONFIRMED classification of
any HIGH-severity finding unless clearly documented as an architectural risk.

### E4 — Impact Evidence

The behavior produces a meaningful security or correctness impact in the controlled
environment: an authorization boundary was crossed, data was disclosed or modified,
state was corrupted, a resource was exhausted, an operation completed incorrectly.

**Reporting rule:** Severity assignment must be grounded in E4 (or a documented
argument of reachability from E3). Impact claims without E4 must be labeled
`PROJECTED IMPACT` and kept separate from observed impact.

### E5 — Root-Cause Evidence

The exact defective implementation (the line, the missing check, the wrong ordering,
the broken invariant) is identified AND validated: applying the proposed fix to the
reproduction changes the observed behavior, and the regression test fails before the
fix and passes after it.

**Reporting rule:** E5 is required before proposing a minimal fix as "the" fix. Without
E5, remediation must be framed as a hypothesis to verify.

## What Counts as Evidence

Evidence is a reproducible observation or a traceable artifact:

- exact code line(s) with file path and commit/version
- a stack trace from a controlled run
- a failing/passing test with input and assertion
- a request/response pair against a local or mocked service
- a lockfile entry with the resolved version
- a config file value with its source path
- a trace/log excerpt from the auditor's controlled environment

Evidence is NOT:

- a keyword match
- a scanner report without validation
- a pattern that "looks suspicious"
- an outdated dependency alone
- an unusual configuration alone
- an assumption about what the code does
- a finding from someone else's write-up without local validation

## Evidence Recording

Every finding report MUST include an `Evidence` section that:

1. states the highest evidence level reached (E0–E5)
2. lists the artifacts that support it
3. states what was NOT verified (`UNKNOWN`)

## Mapping to Confidence

| Evidence level | Max defensible confidence |
|---|---|
| E0 | (not reportable) |
| E1 | LOW CONFIDENCE (suspected) |
| E2 | MEDIUM CONFIDENCE (probable) |
| E3 | HIGH CONFIDENCE (confirmed behavior) |
| E4 | HIGH CONFIDENCE–CONFIRMED (impact observed) |
| E5 | CONFIRMED (root cause validated) |

Evidence level and confidence are related but distinct: use the table as a ceiling, not
an automatic assignment — a weak E3 test (bad harness, uncontrolled variables) still
cannot yield CONFIRMED.

## Mapping to Reporting

- A high-severity report should normally have **E3 or higher** unless it is explicitly
  documented as an architectural risk (no controlled reproduction possible, risk argued
  from design).
- Architectural risks must state why reproduction is not feasible in the controlled
  environment.
