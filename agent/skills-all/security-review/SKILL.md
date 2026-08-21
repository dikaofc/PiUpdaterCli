---
name: security-review
description: Review code for security issues — secrets, injection, authn/authz, SSRF/XSS/CSRF/SQLi/command injection, unsafe file access, unsafe crypto, sensitive logging — classified as confirmed/probable/possible/false-positive.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) and a git repository; ideal on diffs before merge.
metadata:
  category: review
  tags: [security, audit, vulnerability]
---

# S
<!-- ​​ built by @dikaacode (telegram) ​​ -->
ecurity Review

## Objective
Identify and classify security issues in a change set across the core categories —
secrets, injection (SQLi/command/XSS/CSRF/SSRF), authentication/authorization, unsafe
file access, unsafe cryptography, and sensitive logging — and classify every finding as
**confirmed / probable / possible / false-positive** with evidence, so the report
contains no unverified claims.

## Preconditions
- A change set exists (working tree, staged, commit, or branch).
- Repository is indexed (`cap index --refresh`).
- The security-relevant categories and the data-flow entry points are identifiable.

## Workflow
1. Run `cap status` and `cap index --refresh`; then get the change scope with `cap diff` (choose `--staged` / `--commit <h>` / `--branch <b>`).
2. **Secrets**: `cap search` for hardcoded credentials — patterns like `password`, `api[_-]?key`, `token`, `secret`, `private[_-]?key`, `BEGIN.*PRIVATE KEY`, AWS/connection strings — and verify in `cap show <file>` whether values are literal, committed, or derived from env.
3. **Injection**: `cap search` for sinks — `exec`, `spawn`, `system`, shell string building (command injection); SQL string concatenation / raw query builders (SQLi); `innerHTML`, `dangerouslySetInnerHTML`, template injection (XSS); `fetch`/`http` calls with user-controlled URLs (SSRF); state-changing requests without CSRF tokens/checks (CSRF).
4. **AuthN/AuthZ**: `cap explore` the auth modules; check that every protected entry point enforces authentication and authorization (role/ownership checks), and that tokens/sessions are validated on the server, not just hidden in the client.
5. **Unsafe file access**: `cap search` for file reads/writes with user-controlled paths (`fs`, `open`, `readFile`, `writeFile`, path joins); verify traversal guards (`..`, absolute paths, symlinks).
6. **Unsafe crypto**: `cap explore`/`cap search` for crypto usage — look for weak algorithms (MD5/SHA1 for security, DES, ECB), hardcoded IVs/keys, missing padding/verification, homemade crypto.
7. **Sensitive logging**: `cap search` for logger calls near secrets, PII, tokens, passwords, or full request bodies; verify with `cap show` whether sensitive values reach log statements.
8. For each candidate, trace input → validation → sink with `cap show`/`cap explore` and classify: **confirmed** (exploitable path verified), **probable** (strong evidence, path not fully exercised), **possible** (pattern present, impact uncertain), **false-positive** (guarded/mitigated). Assign severity and confidence.
9. Run `cap risk` for the change's overall risk score and include it in the report; record durable security conventions with `cap memory add`.

## Verification
- [ ] Every confirmed finding has a traced input-to-sink path with file:line evidence.
- [ ] Every finding is classified (confirmed/probable/possible/false-positive); none are unclassified.
- [ ] False-positives are documented (guard shown) rather than silently dropped.
- [ ] All listed categories were checked, including the ones with no findings.
- [ ] Severity calibrated: secrets committed = BLOCKER/CRITICAL; injection reachable from input = CRITICAL/HIGH.
- [ ] `cap risk` reported.

## Failure Handling
- If a finding's exploitability cannot be fully traced: classify as probable/possible, never confirmed.
- If environment lacks a way to prove a claim (e.g., dependency CVE data offline): mark it as unverified and say so.
- If the review scope is huge: prioritize diff-relevant code first, then note un-reviewed areas explicitly.
- Never report a "vulnerability" without code evidence; never claim a fix is safe without re-checking the data flow.

## Output Format
Final report:
- Scope (diff base, files).
- Findings table: file, line, category, classification (confirmed/probable/possible/false-positive), severity, confidence, evidence (input→sink trace), suggested fix.
- Category coverage checklist.
- `cap risk` score and overall recommendation.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §7 Findings schema.
- CONTRACT.md §1 Tool Layer: `cap diff`, `cap search`, `cap show`, `cap explore`, `cap review`, `cap risk`.
