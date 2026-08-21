# Global Bug-Hunting Methodology

This is the canonical investigation sequence and the analysis rules that apply to
every audit in this knowledge base.

## The Investigation Sequence

Every audit follows this sequence. Do not skip stages; do not jump from "suspicious
code" to "critical vulnerability."

```
DISCOVER     — inventory the project: structure, manifests, entry points, tests
MAP          — architecture map: components, boundaries, assets, integrations
MODEL        — select the applicable analysis model (threat, data flow, trust)
TRACE        — trace data and control flow: source → validation → authorization → sink
HYPOTHESIZE  — form a small number of testable hypotheses about the defect
VERIFY       — verify with evidence (E1 → E5), starting with the cheapest test
CLASSIFY     — type, severity, confidence, evidence level
ROOT CAUSE   — identify the underlying defect, not the symptom
REMEDIATE    — minimal targeted fix
REGRESSION TEST — add a test proving fix + no breakage
RECHECK      — re-run tests; re-review related paths for the same defect class
REPORT       — structured report per the Report Format below
```

## Source-Code Analysis Rules

### Entry Points

Inspect all places untrusted data or control enters:

- HTTP handlers, RPC handlers, GraphQL resolvers
- CLI commands, WebSocket handlers
- queue consumers, scheduled jobs, file processors
- authentication callbacks, webhook handlers

### Sensitive Sinks

For each entry point, determine which sensitive operations it can reach:

- database queries, shell execution, filesystem operations, network requests
- template rendering, HTML rendering, deserialization
- cryptographic operations, privilege changes
- payment operations, account changes, configuration changes

### Security Boundaries

Track every transition: Browser→API, API→Service, Service→Database,
Service→External API, User→Admin, Tenant A→Tenant B, Container→Host, CI→Deployment,
Application→Cloud Resource. A defect that crosses a boundary is a vulnerability; a
defect contained within a boundary is usually a correctness bug (still reportable).

## Data-Flow Analysis

For each suspicious path reason through:

```
SOURCE → TRANSFORMATION → VALIDATION → AUTHORIZATION → SINK
```

Record for each path: source, origin, trust level, transformations, validation,
sanitization, encoding, authorization, sink, resulting behavior. If any element is
unknown, mark it `UNKNOWN` and determine whether the unknown blocks a conclusion.

## Authorization Rule

Never trust:

- frontend checks, hidden UI elements, disabled buttons
- route naming, client-provided roles, client-provided ownership
- client-side feature flags

Authorization must be enforced server-side where the operation executes
(`skills/authorization/server-side-authorization.md`).

## API Bug-Hunting Rule

For every endpoint analyze: authentication, authorization, input validation, object
ownership, rate limiting, idempotency, pagination, data exposure, error handling,
state transitions, concurrency, logging (`workflows/api-audit.md`).

## Business-Logic Analysis

Auditing is not limited to technical vulnerabilities. Analyze: duplicate operations,
replay, inconsistent state, negative quantities, invalid transitions, missing
ownership validation, quota bypass, inconsistent pricing, inconsistent balances,
race conditions, partial transactions, retry behavior, cancellation behavior, refund
behavior, approval workflows.

**Always understand the intended business rule before declaring a business-logic
bug** (`skills/business-logic/business-rule-analysis.md`).

## Dependency Analysis

Never report "package X has CVE Y" as automatically exploitable. Determine:

1. Is the dependency actually installed?
2. Is the vulnerable component included (bundled, imported)?
3. Is the affected functionality used?
4. Is the vulnerable code reachable from attacker input?
5. Does configuration mitigate it?
6. Is the application affected?
7. Is a patch available?
8. What regression risk exists in upgrading?

(`context/dependency-model.md`, `skills/dependencies/dependency-audit.md`)

## False-Positive Control

Before reporting, attempt to disprove the finding using the questions in
`context/false-positive-model.md` (input attacker-controlled? path reachable? auth
required? authorization elsewhere? sanitization? encoding? sink executed? dependency
used? config disables it? behavior intentional? compensating control?). If an answer
invalidates the finding, classify it FALSE POSITIVE.

## Fixing Mode

For a confirmed finding:

```
FINDING → ROOT CAUSE → MINIMAL FIX → SECURITY TEST → FUNCTIONAL TEST
       → REGRESSION TEST → REVIEW DIFF → RECHECK RELATED PATHS
```

Do not rewrite entire modules unnecessarily. Avoid introducing: unrelated refactors,
new dependencies without reason, behavior changes unrelated to the issue, insecure
shortcuts, client-only security controls.

## Report Format

Every finding uses this structure (see `templates/vulnerability-report.md`):

```
# Finding: <title>

## Classification        — Type, Severity, Confidence
## Affected Component    — <component>
## Root Cause            — <root cause>
## Evidence              — <evidence, with evidence level E0–E5>
## Data Flow             — <source → transformations → sink>
## Impact                — <realistic impact>
## Reproduction          — <safe controlled reproduction>
## Why It Happens        — <technical explanation>
## Remediation           — <recommended fix>
## Regression Test       — <test>
## Related Components    — <related code>
## False Positive Considerations — <analysis>
```

## AI Response Rules

When auditing a project, do NOT dump hundreds of speculative findings. Prioritize:

1. Confirmed vulnerabilities
2. Confirmed correctness bugs
3. High-confidence security risks
4. High-impact architectural weaknesses
5. Medium-confidence findings requiring validation
6. Low-confidence observations

For each finding provide: severity, confidence, evidence, root cause, impact, fix,
regression test. Findings that do not meet the evidence bar become notes, not
vulnerabilities.

## Related

- `OPERATING_MODEL.md` — standing behavior
- `context/evidence-model.md` — evidence levels
- `context/false-positive-model.md` — disprove-first questions
- `workflows/*` — composed procedures
- `SKILL_ROUTER.md` — activating the right skills
