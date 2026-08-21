---
name: secret-scanner
description: Scan the whole repository for hardcoded secrets, keys, and tokens; triage each hit and drive remediation.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18) for index, search, show, and verification steps.
metadata:
  category: security
  tags: [secrets, credentials, scanning, triage]
---

# Secret S
<!-- built by @dikaacode (telegram) -->
canner

## Objective
Find hardcoded secrets, API keys, tokens, and private keys anywhere in the repository
(committed or not), distinguish real credentials from test fixtures and placeholders,
classify every hit as confirmed / probable / possible / false-positive, and drive
revocation-plus-rotation remediation without ever printing the secret value.

## Preconditions
- Repository is indexed (`cap index --refresh`).
- Secret rotation channel (vault, CI secrets store, provider console) is available to
  the operator; this skill only flags, never mints new secrets.

## Workflow
1. Run `cap status` and `cap index --refresh` so searches cover the whole tree.
2. `cap search` generic credential patterns: `(api[_-]?key|secret|token|password)\s*[=:]\s*['"][^'"]{8,}`, `BEGIN (RSA|EC|OPENSSH|DSA) PRIVATE KEY`, `AKIA[0-9A-Z]{16}`, `sk-`, `ghp_`, `xox[baprs]-`, `eyJ` (JWT), WhatsApp/Telegram bot tokens, database connection strings with credentials, `.env` bodies.
3. `cap search` for secret files by name: `.env*`, `*.pem`, `*.p12`, `*.pfx`, `id_rsa`, `*.keystore`, `service-account*.json`, `credentials*.json`; check which are committed with `cap diff --base <first-commit>` or `cap show` on `.gitignore` / `.git/info/exclude`.
4. For every hit, `cap show <file> [--lines a-b]` to inspect the value: is it a literal, a placeholder (`xxx`, `changeme`, `your-...`), or a reference to an env var? Check whether a `.env` example or mock value is committed rather than the real one.
5. Classify each hit: **confirmed** — real-looking credential value present in a committed or shipped file; **probable** — matches credential shape and is referenced by runtime code; **possible** — candidate shape, unclear if used or real; **false-positive** — placeholder, test-only fixture, or docs example. Follow the classification rules in docs/review-engine.md.
6. Cross-check findings against `cap rules check` on the affected files and `cap memory list` for known allowlisted secrets; record durable exceptions with `cap memory add`.
7. Produce the remediation queue: confirmed bleeding secrets get revoke > rotate > redeploy (see secrets-rotation skill); code moved to env vars / secret vault; `.env` added to `.gitignore`; history rewrite decision escalated to the team — never executed unilaterally.

## Verification
- [ ] Whole tree scanned, not just the working diff.
- [ ] Every hit classified (confirmed/probable/possible/false-positive), none unclassified.
- [ ] Real secret values never appear in the final report (masked to 4 chars).
- [ ] `.env` and key files confirmed ignored or committed-state documented.
- [ ] `cap diff` confirms no secret-involving file was modified during the scan.

## Failure Handling
- If the repo history is clean, rotation is skipped but the revoke path stays: the value was still exposed.
- If a provider has no rotation API: document the manual revoke steps instead of guessing.
- If a hit cannot be inspected (`cap show` fails): classify as possible, never confirmed.
- If the operator cannot reach the secrets store: produce the queue and stop before any write.

## Output Format
Report: scan scope (files, pattern families), findings table (file, line, pattern,
classification, severity, masked value tail), committed-files list, remediation queue,
`cap risk` if a diff is present, and any allowlisted/memory exceptions.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap status`, `cap search`, `cap show`, `cap diff`, `cap memory add`.
- docs/review-engine.md §5-6 classification rules.