---
name: input-validation
description: Audit every trust boundary for input validation, allow-listing, and sanitization gaps.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for index, explore, search, show, and verification steps.
metadata:
  category: security
  tags: [input-validation, trust-boundary, sanitization]
---

# Input Validation A
<!-- built by @dikaacode (telegram) -->
udit

## Objective
Enumerate every trust boundary in the codebase — HTTP request bodies/params,
headers, cookies, file uploads, CLI arguments, env vars, queue messages, and
external API responses — and verify each one validates and sanitizes input before it
is used. Unvalidated boundaries become findings classified confirmed / probable /
possible / false-positive and are fixed with allow-list validation and
sanitization at the boundary, never deep in the code.

## Preconditions
- Entry points are identifiable (route handlers, message consumers, CLI entry,
  public functions) and indexed (`cap index --refresh`).
- The validation rules per domain (used validation library or hand-rolled checks)
  are discoverable via `cap explore`.

## Workflow
1. Run `cap status` and `cap index --refresh`; map entry points with `cap explore` of the router/controllers and `cap search` for `app\.(get|post|put|patch|delete|use)|consumer|subscribe|parse|argv|process\.env|req\.(body|query|params|headers|cookies)|file upload` patterns.
2. For each boundary, `cap show` the handler and check for validation: type checks, required fields, length limits, format (regex/allow-list), range/enum checks, and normalization. Hand-rolled checks count only if they reject, not just coerce (loose `parseInt` can mask and later crash or inject).
3. Trace validated data downstream: does the validated value reach a sensitive sink (SQL, shell, filesystem path, HTML, redirect URL, log)? A boundary with validation is fine only if the rules cover what the sink needs (e.g., SQL needs no extra escaping if parameterized — but the type/value check still applies).
4. Check sanitization needs: HTML escaping on output is the renderer's job (XSS audit), but input sanitization is required where data is stored and re-emitted or used in paths/URLs (`encodeURIComponent`). Distinguish validation (reject) from sanitation (transform) and record which each boundary uses.
5. Classify: **confirmed** — attacker-reachable boundary with no validation reaching an observable effect (error, crash, injection); **probable** — boundary has weak/partial validation, impact not fully exercised; **possible** — boundary unvalidated but downstream use unclear; **false-positive** — input validated, typed, allow-listed, or only used in a safe way (e.g., length-bounded into an indexed column). Follow docs/review-engine.md rules.
6. Fix: add boundary validation — required + type + length + format via allow-list regex or the project's validation library (never blocklist-only), reject with a clear 4xx/error and log at INFO (no sensitive echo); apply the same rules to headers, cookies, uploads (size/type/mime allow-list), CLI args, and parsed messages.
7. Re-verify with `cap show` on each patched handler, run `cap lint`, `cap typecheck`, and targeted tests via `cap test`; finish with `cap verify`, `cap diff` scope check, and `cap memory add` for boundary conventions.

## Verification
- [ ] All trust boundaries enumerated with entry-point evidence.
- [ ] Every boundary has a verdict: validated (which rules) or a finding with classification.
- [ ] No blocklist-only validation remains (whitelist or allow-list required where safety matters).
- [ ] Inputs reaching SQL/shell/path/HTML sinks are covered by boundary rules (cross-checked with the injection audits).
- [ ] Applied fixes pass `cap lint`, `cap typecheck`, `cap test`, `cap verify`.
- [ ] `cap diff` shows only intended changes.

## Failure Handling
- If a boundary is too large to audit fully: audit it in sections, mark the un-audited remainder explicitly, and never claim full coverage.
- If validation would reject legitimate traffic: adjust the allow-list to the documented format with evidence; escalation if ambiguous.
- If the project owns no validation library: hand-rolled checks are acceptable when they reject on failure — document the needed test.
- If a sink kind is not covered by this audit (XSS output context): refer to the xss-audit skill instead of enlarging scope.

## Output Format
Report: trust-boundary inventory (type, entry point, file), per-boundary verdict
table (file, line, validation present, rules, classification, severity, evidence),
sink cross-check summary, fixes applied, remaining gaps, and verification results.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap search`, `cap show`, `cap explore`, `cap test`, `cap verify`, `cap diff`, `cap memory add`.
- .claude/rules/src-api.md — validate at the trust boundary.
- docs/review-engine.md §5 classification rules.