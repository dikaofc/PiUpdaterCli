---
name: xss-audit
description: Audit all XSS sink points (innerHTML, dangerouslySetInnerHTML, DOM insertion via template literals); validate and escape the data flow.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for index, search, and show steps; browser or jsdom only when sink reachability must be proven.
metadata:
  category: security
  tags: [xss, dom, injection, escaping]
---

# XSS A
<!-- built by @dikaacode (telegram) -->
udit

## Objective
Locate every sink where attacker-influenced data can reach the DOM as executable
content — `innerHTML`, `outerHTML`, `insertAdjacentHTML`, `document.write`,
`dangerouslySetInnerHTML`, `eval`/`new Function`, unsafe `attribute`/`href`/`src`
assignments, and template literals interpolated into HTML strings — classify each
path as confirmed / probable / possible / false-positive, and fix sinks with
allowed-list validation or framework-native escaping.

## Preconditions
- Frontend code is in the repo and indexed (`cap index --refresh`).
- A list of entry points where user input enters the app (URL params, forms, APIs,
  WebSocket messages, storage) is identifiable via `cap explore`.

## Workflow
1. Run `cap status` and `cap repo` to confirm language/framework (React, Vue, plain JS) and build setup.
2. `cap index --refresh`, then `cap search` the sink surface: `innerHTML`, `outerHTML`, `insertAdjacentHTML`, `document\.write`, `dangerouslySetInnerHTML`, `setAttribute\(`, `.href\s*=`, `.src\s*=`, `eval\(`, `new Function`, `prototype\.extend` (old-school), and HTML string building with backticks.
3. For each sink, identify the data source: `cap explore <sink-symbol>` maps import origin; `cap search` for the variable feeding the sink, tracing back to any entry point (URL params, form values, API responses, cookies).
4. `cap show <file> [--lines a-b]` on the traced path and determine whether the data is already sanitized (framework escaping like React's text interpolation, `textContent`, a sanitizer library) or reaches the DOM raw.
5. Classify: **confirmed** — attacker-controlled input reaches a raw HTML sink with a fully traced path; **probable** — input can plausibly reach the sink but the path is not fully exercised; **possible** — sink pattern present, source unclear; **false-positive** — data is validated, escaped, or constant. Only confirmed/probable may be HIGH (docs/review-engine.md).
6. Fix each open sink: use `textContent` instead of `innerHTML` for text, framework-native escaping for interpolation, an allow-listed sanitizer for rich HTML, and `encodeURIComponent`/scheme check (`http:`, `https:`, `mailto:`) for `href`/`src`; never build HTML by string concatenation.
7. For each fix, `cap show` the patched region, then run `cap lint`, `cap typecheck`, and the targeted tests via `cap test`; finish with `cap verify` and confirm scope with `cap diff`.

## Verification
- [ ] Every sink pattern family was searched, including ones with no hits.
- [ ] Each finding has a traced source-to-sink path with file:line evidence.
- [ ] Every finding classified; false-positives documented with the guard shown.
- [ ] Fixed paths re-verified: no raw interpolation remains into HTML sinks.
- [ ] `cap lint`, `cap typecheck`, `cap test` pass after fixes.
- [ ] `cap diff` shows only intended changes.

## Failure Handling
- If the sink's reachability cannot be proven: classify as probable/possible, never confirmed.
- If no sanitizer/escaping exists and the framework offers none: report the sink as a blocker and propose the minimal escaping utility instead of inventing it.
- If test coverage for the fixed path is missing: add one regression test with a malicious payload; do not claim safety without it.
- If a proposed fix changes behavior: flag it in the report; escaping is not free.

## Output Format
Report: sink inventory (file, line, sink type, source, classification, severity),
source-to-sink traces, fixes applied (with file:line diffs), remaining unfixed
findings with rationale, and verification results.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap search`, `cap show`, `cap explore`, `cap test`, `cap verify`, `cap diff`.
- docs/review-engine.md §5 classification rules.