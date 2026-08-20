# COMPARE.md — pi-agent.local vs pi-agent.csp

| | `scripts/pi-agent.local` | `scripts/pi-agent.csp` |
|---|---|---|
| Source | `~/.local/bin/pi-agent` | `claude-skills-and-plugins/bin/pi-agent` |
| mtime | 2026-08-20 13:05:51 +0700 | 2026-08-20 12:59:35 +0700 |
| Size | 7164 bytes | 5675 bytes |
| Shebang/preamble | none (bash) | `portable-ify` comment |

`.local` is **newer** (mtime) and **bigger** (1489 bytes). The two diverge
significantly; `.local` is a superset, not a mere revision:

## Key differences (diff, local vs csp)

1. **Portability fix (in csp only, otherwise a local-only bug):**
   `run_one` in `.csp` resolves a symlinked `pi` to its real `cli.js` and
   invokes `node "$PI_BIN"` directly, because `pi`'s `#!/usr/bin/env node`
   shebang is missing/broken on some Termux installs. `.local` relies on
   `pi_bin()` which handles a symlink the same way — but only for symlinks.
2. **Model fallback (csp):** `DEFAULT_MODEL="${PI_MODEL:-oc/hy3-free}"`; checks
   `pi --list-models` and falls back to the default when the agent-def model
   isn't available (no key). `.local` has `DEFAULT_MODEL=""` and no
   availability probe.
3. **Added flags (local only):** `--jobs/-j` (concurrency limit, default 4),
   `--timeout/-t` (per-agent wall-clock timeout), `--json` (machine-readable
   summary via jq), `--nodefmodel`.
4. **Auth retry (local only):** after a run, agents that failed with
   `no api key | api key is invalid | authentication_error | 401` or exit 124
   are re-run once with `DEFAULT_MODEL`.
5. **Output (csp):** cats every log inline in RESULTS; local has `--json`
   mode and a terse per-launch line instead.
6. **Misc:** local logs `EXIT=` markers, has a `--rm`/`clean` parity, uses
   `readlink -f` under `pi_bin`; csp prints `launched:` per target and
   collapses `run`/`fan` into one path.

## Verdict — which to prefer

**Prefer `pi-agent.local`** (the `~/.local/bin` copy): it is the newer file
(mtime 13:05 vs 12:59), strictly more capable (jobs/timeout/json/auth-retry),
and the csp-only portability fix is a Termux-specific workaround — the
install script should ship the local version as the canonical
`scripts/pi-agent`, optionally merging the `node "$PI_BIN"` portability
branch from csp if the target is a Termux host. Keep both here for reference.
