# SCRIPTS.md — pack scripts reference

Copied from live, verified sources on this device. See COMPARE.md for the
pi-agent comparison; build.sh copies everything and emits checksums.

| File | Source | Purpose |
|---|---|---|
| `scripts/pi.termux.example` | `~/.local/bin/pi` | Working Termux `pi` wrapper. Hardcodes the absolute node path + dist path because the `#!/usr/bin/env node` shebang fails on Termux kernels. Reference only — the installer's `bin/pi` is the portable rewrite. |
| `scripts/pi-agent.local` | `~/.local/bin/pi-agent` | **Canonical pi-agent** (see COMPARE.md). Orchestrates pi subagents in parallel: `run <agent> <target>`, `fan <agent> <t1> <t2>...`, `agents`, `clean`. Zero deps beyond pi + python3 + jq; `--jobs`, `--timeout`, `--json`, auth-failure retry. |
| `scripts/pi-agent.csp` | `claude-skills-and-plugins/bin/pi-agent` | Older (12:59 vs 13:05), smaller (5675 vs 7164 B). Carries a Termux portability fix (`node` invoked directly on the resolved cli.js) and model-availability fallback. |
| `scripts/sync-skills-to-pi.sh` | `claude-skills-and-plugins/bin/sync-skills-to-pi.sh` | Copies skills repos into `~/.pi/skills`. |
| `scripts/spawn-agent.sh` | `claude-skills-and-plugins/bin/spawn-agent.sh` | Spawns a pi agent session (helper wrapper). |
| `scripts/cap` | `claude-skills-and-plugins/bin/cap` | Launcher for `cap.mjs`. **Portable** — explicitly uses `node` from PATH (no `/usr/bin/env` dependency, works Linux/macOS/Android/Termux/Windows-Git-Bash/VPS), resolves its own symlink, then `exec node "$DIR/cap.mjs"`. Not Termux-specific; needs `cap.mjs` beside it and Node >= 18. |

## Not included (deliberately)

- `~/.pi/agent/models.json` — contains a real API key / tunnel URL. Excluded
  from the pack entirely; never copied, never written to disk here.
- `bin/cap.mjs` — lives in the plugin repo; `scripts/cap` is just the
  launcher and expects `cap.mjs` next to it at install time.
