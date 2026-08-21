---
name: secrets-rotation
description: Rotate leaked secrets end-to-end — revoke, rotate, redeploy — without ever committing the new secret.
license: MIT
compatibility: Requires the `cap` CLI on PATH (Node.js >= 18); needs operator access to the secrets store (vault, CI secrets, provider console) for the revoke/rotate steps.
metadata:
  category: security
  tags: [secrets, rotation, revoke, incident-response]
---

# Secrets R
<!-- built by @dikaacode (telegram) -->
otation

## Objective
Execute a complete rotation of secrets that were exposed (committed, logged, or
shipped in a client bundle): identify every place the secret is used, revoke the
compromised value, deploy a newly generated value through the secrets store —
without the new value ever appearing in a commit, diff, log, or report — and verify
each consumer is working on the new secret.

## Preconditions
- A leak is established (from the secret-scanner skill or incident report).
- Access exists to the secrets store (vault/CI secrets/SSM) and to each consumer's
  deployment channel. This skill modifies real credentials — operator approval is
  required at each write step (approval mode `smart` or `manual`).

## Workflow
1. Run `cap status`; register the incident as a task with `cap task start <id>` so every change is rollback-auditable.
2. Map consumers and usage, not just leak locations: `cap explore` the secret's import sites, `cap search` for the env var name and value patterns, and `cap show` each usage to determine where the value is read (env, config file, CI, runtime secret store) and where it is referenced (API clients, DB connections, vendor SDKs). Note the blast radius: which services, which external providers.
3. **Revoke first** (order matters): operator revokes the leaked value at the provider — OAuth client secret reset, API key disable, DB password invalidation, session secret rotation plausible only when sessions can be re-created; delete/expire the firebase/push/webhook credential as applicable. Confirm revocation `cap status`-independent: provider console or `cap audit` record of the row. Re-deploy nothing until this step succeeds — a compromised key must not remain valid.
4. Generate the replacement: create a new cryptographically random value (>= 32 bytes, via the secrets store's generation or `openssl rand -base64 32`) directly into the store — never into a file under the repo. Add it as an environment override in the store (e.g., `cap secret set`-style vendor flow or vault write), not a code change.
5. Deploy consumers: update deployment config to read the new value from the store (env injection), redeploy each consumer in dependency order, restart workers that cache the old value. If a consumer hardcodes the value, patch the code to read from env/store first (`cap diff` the change; the diff must show a reference, never a literal).
6. Verify live: exercise each consumer path (login, webhook ping, DB connection, provider API call) with `cap test` where covered; check provider dashboards for successful authenticated activity; run `cap verify` and `cap diff` to confirm no secret literal is in the change set.
7. Clean up and archive: purge the leaked value from logs/history access paths where feasible (document what cannot be purged), update documentation/example files with **placeholders only** (`cap show` the touched files), then `cap memory add` the rotation record (id, consumer list, date — never the value) and close the task with `cap task done <id>`.

## Verification
- [ ] Leaked value revoked at the provider before any new value is deployed (order verified).
- [ ] Every consumer mapped is redeployed or confirmed reading the store value.
- [ ] No commit, diff, log line, or report contains the new or old secret value (grep the diff: `cap diff`).
- [ ] Live consumer checks pass; provider-side authenticated activity confirmed.
- [ ] Documentation/examples hold placeholders only.
- [ ] `cap task done` recorded; rollback path (`cap rollback --task <id>`) is available and understood.

## Failure Handling
- If revocation is not possible at the provider: escalate immediately; mark the secret as at-risk and never proceed to rotation as a "fix".
- If a consumer cannot be redeployed right away: document the at-risk window explicitly — do not rotate "half" and claim completion.
- If a deployment breaks after rotation: `cap rollback --task <id>` for the code change, re-check the consumer's store read path, and confirm the previous secret is already revoked so it is not reused.
- If the new value would appear in any output: stop the step that would write it; the value must live only in the store and in the operator's buffer.
- If the rotation touches many consumers: rotate in waves and verify each wave before the next.

## Output Format
Report: incident id and task id, consumer/blast-radius inventory, revoke confirmation
(with provider evidence type), rotation order and status per consumer (including
verify outcome), change-set summary (`cap diff` — references only), at-risk windows,
cleanup done, and memory record summary.

## References
- CONTRACT.md §2 Skill Format.
- CONTRACT.md §1 Tool Layer: `cap search`, `cap show`, `cap explore`, `cap diff`, `cap test`, `cap verify`, `cap rollback`, `cap task`, `cap memory add`.
- Skill: secret-scanner (leak discovery).
- docs/review-engine.md §5 severity calibration.