# Skill: Code Injection

## Purpose

Find arbitrary code execution via dynamic evaluation of untrusted input: eval, Function(), template evaluation, script engines, polyglot files.

## Scope

- **Included:** all code paths, configuration, and behavior relevant to this concern within the project under review.
- **Excluded:** vulnerabilities outside this concern, unrelated refactors, and any live exploitation of third-party systems.
- **Layers:** source code, configuration, runtime behavior, tests.

## Trigger Conditions

Activate when reviewing code, configuration, or behavior related to: code injection, eval, dynamic evaluation.

## Inputs

- Source code and repository contents
- Configuration and environment definitions
- Logs, traces, and runtime behavior
- API specifications and interface definitions
- Dependency manifests and lockfiles
- Tests and reproduction scripts

## Investigation Method

1. Find dynamic code execution: eval/Function/exec in JS, eval in Python/Lua, reflection-driven loading, dynamic class instantiation from strings.
2. Trace user input into evaluated code or into expressions that reach interpreters.
3. Check interpreter invocation: node -e, python -c, ruby -e, PHP assert/eval, template engines with user templates.
4. Test with a local harmless probe (e.g., an expression that computes a benign constant) proving interpretation.
5. Check polyglot/upload paths that get interpreted (e.g., script-capable file types consumed by a script engine).



## Evidence Requirements

**Do not report a finding solely because a keyword exists, a scanner flags it, a pattern looks suspicious, a dependency is old, or configuration appears unusual.**

Required evidence before declaring a finding:

- A data-flow trace into an eval-like sink plus a local test proving user input changes executed behavior (e.g., computed a value).

Minimum bar: **static evidence (E1)** to open a line of inquiry; **behavioral evidence (E3)** or better for a confirmed report. See `context/evidence-model.md`.

## Confidence

Use one of:

- **CONFIRMED** — behavior reproduced and root cause validated (E3+).
- **HIGH CONFIDENCE** — strong static + data-flow evidence, controlled verification pending.
- **MEDIUM CONFIDENCE** — plausible path but some assumptions remain unverified.
- **LOW CONFIDENCE** — theoretical risk; requires validation.
- **FALSE POSITIVE** — disproven or mitigated after analysis.

Confidence is independent of severity (see `context/confidence-model.md`).

## Severity

Assess severity from actual **impact + exploitability + required privileges + interaction + affected scope + data sensitivity** (see `context/severity-model.md`). Do not automatically label this class CRITICAL. A finding must earn its severity from evidence.

Typical range for this skill: LOW–HIGH depending on reachability and data sensitivity.

## Safe Reproduction

Use local databases (SQLite/Postgres test instance), local shell wrappers, or mock sinks. Verify behavior changes with benign probes; never against live third-party systems.

Recommended local strategy:

- Build a minimal fixture that reproduces the exact code path.
- Drive it with controlled inputs (unit/integration test or a local harness).
- Record the observed behavior and the diff against expected behavior.

## Root Cause

Identify the underlying defect, not the symptom. Look for the specific line/design decision that allows the behavior:

Interpreted code built from unvalidated input or an overly permissive evaluation path.

## Impact

Remote code execution inside the application process.

## Remediation

Remove eval-like patterns; use parsers/interpreters with strict input; sandbox any required dynamic evaluation; validate to allowlists.

## Regression Test

Tests feeding code-shaped strings to every eval-like site, asserting literal/valueless handling.

## Common False Positives

eval of constant/internal strings; user input that cannot reach the evaluated string (e.g., only internal template values); sandboxed interpreters.

## Related Skills

- template-injection.md
- expression-injection.md
- command-injection.md
- deserialization-analysis.md

## References

- OWASP Code Injection
- CWE-94 (improper control of generation of code)

## Review Checklist

- [ ] Entry point identified
- [ ] Trust boundary identified
- [ ] Data flow understood
- [ ] Validation checked
- [ ] Authorization checked
- [ ] Runtime behavior verified
- [ ] Evidence collected (E1–E5 level recorded)
- [ ] Severity assigned (impact-based)
- [ ] Confidence assigned (separate from severity)
- [ ] Root cause identified
- [ ] Remediation proposed
- [ ] Regression test proposed
