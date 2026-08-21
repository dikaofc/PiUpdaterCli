# Skill Template: <NAME>

> **CANONICAL TEMPLATE — every file under `skills/` MUST follow this structure.**
> Section headings appear in this exact order. No section may be omitted or renamed.
> A skill is only complete when every checklist item at the bottom is satisfiable.

---

## Purpose

Explain exactly what this skill detects or analyzes. Be specific:
- WHAT the skill investigates (the defect class, behavior, or property).
- WHY it matters (the class of real failures it prevents).
- WHAT it is NOT (one line, to prevent scope creep).

Avoid generic statements such as "check for security issues" or "use best practices".
State the concrete defect you are looking for.

## Scope

Define:
- **Included:** the code layers, artifacts, and behaviors this skill examines.
- **Excluded:** what is deliberately out of scope (e.g., "does not cover network-layer TLS configuration").
- **Relevant application layers:** e.g., browser/frontend, API, service layer, database, infrastructure.

## Trigger Conditions

List the observable signals that should activate this skill. Be mechanical:
- code patterns (e.g., "string concatenation into a query")
- configuration patterns
- dependency characteristics
- runtime observations
- reviewer prompts

## Inputs

List the inputs the skill operates on. Possible inputs include:
- source code
- repository (full or partial)
- configuration (app, framework, CI/CD, cloud)
- logs (application, access, error, audit)
- API specification (OpenAPI, gRPC, GraphQL schema)
- dependency manifests and lockfiles
- tests
- runtime behavior (tracing, profiling, network captures in a local sandbox)

## Investigation Method

Provide a deterministic, ordered workflow. Adapt the canonical sequence below to this skill:

1. **Identify entry points.** Where does the relevant data or control flow enter?
2. **Identify trust boundaries.** Which transition (browser→API, API→service, service→DB, etc.) is relevant?
3. **Track relevant data.** Source → transformations → validation → authorization → sink.
4. **Identify validation.** Where is input validated, sanitized, encoded, or canonicalized?
5. **Identify security-sensitive operations.** Which sink (query, exec, file write, render, deserialize, crypto, privilege change, payment) is reached?
6. **Inspect authorization.** Is the operation authorized server-side? (Never trust client-side checks.)
7. **Inspect error handling.** Do failures leak data or bypass controls?
8. **Inspect tests.** Do tests cover the negative and boundary paths?
9. **Determine exploitability or correctness impact.** Concrete, not hypothetical.
10. **Validate the finding.** Reproduce safely in a local/mocked environment; confirm root cause.

## Evidence Requirements

Define exactly what evidence is required before declaring a finding. Reference the evidence model (`../context/evidence-model.md`):
- E0 No Evidence — never reportable as a finding.
- E1 Static — code path shows the hazard.
- E2 Data-Flow — attacker/any controlled input reaches the sink.
- E3 Behavioral — a controlled test demonstrates the unexpected behavior.
- E4 Impact — the behavior produces meaningful security/correctness impact.
- E5 Root-Cause — the exact defective implementation is identified and validated.

State the minimum evidence level this skill requires per severity class (e.g., "HIGH findings require at least E3").

Never report a finding solely because:
- a keyword exists
- a scanner reports it
- a pattern looks suspicious
- a dependency is old
- a configuration appears unusual

## Confidence

Use the confidence model (`../context/confidence-model.md`). Choose one of:
- CONFIRMED
- HIGH CONFIDENCE
- MEDIUM CONFIDENCE
- LOW CONFIDENCE
- FALSE POSITIVE

Explain how to pick the level for this skill, and stress that confidence is SEPARATE from severity (a severe theoretical issue can be LOW confidence; a minor leak can be CONFIRMED).

## Severity

Use the severity model (`../context/severity-model.md`). Choose one of:
- CRITICAL
- HIGH
- MEDIUM
- LOW
- INFORMATIONAL

Severity must follow from actual impact + exploitability + privileges + interaction + scope + persistence + data sensitivity — never from appearance. Calibration rules apply: not every injection, auth issue, or outdated dependency is CRITICAL.

## Safe Reproduction

Provide a concrete, safe reproduction strategy:
- local environment (dev server, fixtures)
- test fixtures and synthetic data
- mocks and stubs for external services
- isolated containers/sandboxes
- unit/integration tests

Explicitly exclude destructive or unauthorized exploitation. No persistence, credential theft, malware, or destructive payloads. Everything must run against resources the auditor controls.

## Root Cause

Explain how to move from symptom to underlying defect: which incorrect assumption, missing check, wrong ordering, or flawed invariant causes the behavior. Ask "why" until the code change that would prevent the bug is obvious.

## Impact

Describe realistic consequences, ordered by likelihood: correctness failures, data exposure, integrity loss, availability loss, privilege escalation, financial/business impact. Do not exaggerate; tie each consequence to the concrete behavior.

## Remediation

Provide concrete remediation:
- code-level fixes (specific API calls, ordering, validation placement)
- design-level fixes (boundary placement, architecture)
- configuration fixes
- dependency upgrades where relevant (with regression-risk note)

Prefer minimal fixes. Do not rewrite entire modules. Avoid introducing unrelated refactors, new dependencies without reason, behavior changes unrelated to the issue, insecure shortcuts, or client-only security controls.

## Regression Test

Explain exactly what test must be added to prevent recurrence. Specify:
- test type (unit, integration, property, fuzz harness)
- the input/case that triggered the bug
- the assertion that proves the bug is fixed
- an assertion that normal behavior still works

## Common False Positives

List cases that look vulnerable but are safe:
- input that is not actually attacker-controlled
- unreachable code paths
- sanitization/encoding applied downstream
- authorization enforced elsewhere
- compensating controls
- intentional behavior (documented)
- vulnerable dependency present but unused/unreachable

## Related Skills

Reference related skill files by filename in backticks (e.g. `` `sql-injection.md` ``), at least 3 and at most 8. You may reference files in the same category, other categories, `../context/`, `../workflows/`, `../checklists/`, or `../patterns/` by filename. Do not invent filenames that do not exist in this repository.

## Review Checklist

- [ ] Entry point identified
- [ ] Trust boundary identified
- [ ] Data flow understood
- [ ] Validation checked
- [ ] Authorization checked
- [ ] Runtime behavior verified
- [ ] Evidence collected
- [ ] Severity assigned
- [ ] Root cause identified
- [ ] Remediation proposed
- [ ] Regression test proposed

## References

List authoritative references that informed this skill (do not copy large copyrighted sections; summarize original guidance):
- OWASP (relevant guide/project)
- CWE identifier(s) when unambiguous (e.g., CWE-89 SQL Injection)
- NIST / MITRE / CVE-NVD resources when relevant
- official language/framework/cloud documentation
- official package security advisory sources (e.g., OSV, GitHub Advisory DB, Snyk, npm audit)

Each reference must be relevant and real. Do not fabricate URLs, CWE numbers, or CVEs.

---

## Authoring rules (apply to every skill)

- Every claim must be verifiable: WHAT, WHY, WHERE, HOW TO VERIFY, WHAT EVIDENCE COUNTS, WHAT FALSE POSITIVES LOOK LIKE, HOW TO FIX IT, HOW TO TEST THE FIX.
- Prefer source-code evidence over assumptions. Mark anything unknown explicitly as **UNKNOWN**.
- Never invent files, functions, endpoints, dependencies, configurations, or vulnerabilities that do not exist.
- Safe-by-default: all reproduction and demonstration content targets environments the auditor controls (local, fixture, mock, sandbox).
- No destructive exploitation workflows; no persistence/credential-theft/malware/destructive-payload procedures.
- Language-awareness: when a skill mentions concrete APIs, cover the main languages relevant to the skill (JS/TS, Python, Go, Rust, Java, Kotlin, C#, PHP, Ruby, C/C++, SQL, Shell as applicable) and note that patterns differ across languages.
