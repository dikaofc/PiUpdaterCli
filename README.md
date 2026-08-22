# PiUpdaterCli

A self-upgrade pack for the **pi coding agent** ([@earendil-works/pi-coding-agent](https://www.npmjs.com/package/@earendil-works/pi-coding-agent) v0.84.2). It was built on Termux (Android), but everything here is universal — Termux, Linux, and macOS all work. The pack adds a portable launcher, an extension bundle, a speed skill, a color theme, and one-click `install.sh` / `restore.sh` scripts.

```
+---------------------------+
|  pi  (bin/pi wrapper)     |   portable launcher — resolves node + package root
+---------------------------+
|  npm global install       |   @earendil-works/pi-coding-agent/dist/cli.js
|  (cli.js, untouched)      |   zero dist changes
+---------------------------+
|  ~/.pi/agent/             |   extensions/, skills/, themes/ — your config dir
|  (settings.json merges)   |   the pack copies into these folders
+---------------------------+
```

The npm binary itself is never modified. Everything the pack adds lives in the `~/.pi/agent` extension layer.

## Why the wrapper is needed

On Termux (Android), the kernel cannot follow the `#!/usr/bin/env node` shebang in the npm-installed binary. Running `pi` dies with:

```
pi: bad interpreter: No such file or directory
```

The same problem can appear on systems where `/usr/bin/env` sits on a symlinked filesystem. `bin/pi` avoids it entirely by resolving `node` and the package root at runtime.

## What the upgrade adds

- **Extension bundle** (`agent/extensions/agent-boost.ts`) — v3: touch-screen support, `aggregate` tool (one call runs N shell commands, saving model round-trips), `compress_context` (context compression), `ultra_token_saver` (token budget manager), `web_fetch` with auto-429 retry, persistent note tools (`note_save` / `note_get` / `note_list`), and auto-verify after edits. Commands: `/boost-status`, `/boost-note`, `/token-saver`. Hot-reload with `/reload`.
- **super-fast skill** (`agent/skills/super-fast/SKILL.md`) — a token-saving operating mode: batch reads, no narration, no re-reads, multi-file edits in one pass. Auto-reverts to careful prose for security/destructive work.
- **agent-efficiency skill** (`agent/skills/agent-efficiency/SKILL.md`) — operating discipline: minimal diffs, verify before done, YAGNI, safe-by-default. Auto-loaded for non-trivial implementation, refactoring, or debugging tasks.
- **bug-hunter skill** (`agent/skills/bug-hunter/SKILL.md`) — systematic debugging: reproduce first, form evidence-based hypotheses, apply the smallest patch, verify under tests. Includes a high-yield grep checklist for common bug smells (unhandled async, null deref, hardcoded paths, unquoted shell vars). Invoke with `/bug-hunter`.
- **terminal-boost theme** (`agent/themes/terminal-boost.json`) — a minimal-mono color theme: clean grayscale base with a single restrained accent and thin borders.
- **terminal-boost-rainbow theme** (`agent/themes/terminal-boost-rainbow.json`) — a colorful variant: vivid purple input-box border, magenta caret, cyan typed text.
- **terminal-boost-aurora theme** (`agent/themes/terminal-boost-aurora.json`) — the **default** theme: indigo/violet base with an aurora accent ramp. The input-box border shifts color by thinking level (slate → blue → cyan → magenta → pink), so you can read the agent's reasoning depth at a glance. User-message bubbles get a distinct violet tint. **Auto-applied on install**.
- **Input status bar** (via `agent-boost.ts` `setWidget`) — a live token-meter bar + quick-hint line rendered *above* the input box: `████░░░░░░ 42% tokens · pir=resume /boost-status`. Updates after every model turn.
- **settings.json template** (`agent/settings.json`) — safe keys only: `lastChangelogVersion`, `theme`, `enableSkillCommands`, `quietStartup`, `skills[]`, `extensions[]`, `packages[]`, `hideThinkingBlock`, `toolOutputExpanded`, `compaction`, `retry`. No secrets.
- **pi-agent package** (`agent/pi-agent/`) — a full pi-skills catalog (53 skills across 19 categories, 5 agents, 2 extensions) bundled and auto-installed to `~/.pi/agent/packages/pi-agent`. Includes:
  - **Agents** (`agents/`): `pii-auditor`, `planner`, `reviewer`, `scout`, `worker` — run with `pi agent run <agent> <target>`.
  - **Extensions** (`extensions/`): `fb-swarm` (orchestrate Freebuff agents from inside pi), `subagent` (delegate tasks to a spawned `pi` process per call, JSON-mode structured output).
  - **Skill categories**: ai-ml, blockchain, browser, data, database, design, devops, documents, education, finance, infra, media, programming, research, security, testing, travel, web-search, writing — each with SKILL.md + reference + helper scripts.
  - Registered in settings `packages: ["~/.pi/agent/packages/pi-agent"]` (absolute path, stable across repo moves). Loads automatically on every `pi` run.

## Install

```
./install.sh
```

- `--dry-run` shows exactly what would be copied and where, without touching anything.
- The script detects your platform, checks that `node` and the pi package are present, and copies the extension/skill/theme files into `~/.pi/agent`.
- If a file already exists, it is **backed up** first (kept in `backups/`) and then replaced. You can recover later with `./restore.sh`.
- Verify with: `pi --version`.

## Restore

```
./restore.sh
```

Restores the pre-upgrade backups (`backups/`) that `install.sh` created. If no backup exists for a file, that file is left untouched.

## Manual install (no root)

You do not need the scripts at all:

```sh
mkdir -p ~/.pi/agent/extensions ~/.pi/agent/skills/super-fast ~/.pi/agent/skills/agent-efficiency ~/.pi/agent/themes
cp agent/extensions/agent-boost.ts ~/.pi/agent/extensions/
cp agent/skills/super-fast/SKILL.md ~/.pi/agent/skills/super-fast/
cp agent/skills/agent-efficiency/SKILL.md ~/.pi/agent/skills/agent-efficiency/
cp agent/themes/terminal-boost.json ~/.pi/agent/themes/
cp agent/settings.json ~/.pi/agent/settings.json   # merges/overwrites safe keys

# Add bin/pi to your PATH if you want the launcher:
install bin/pi ~/.local/bin/pi
```

Then run `/reload` inside pi so the extension loads.

## Compatibility

| Platform | Launcher (`bin/pi`) | Extension bundle | super-fast | agent-efficiency | theme | Notes |
|---|---|---|---|---|---|
| Termux | Yes — falls back to known Termux node path, `$PREFIX` scanning | Yes | Yes | Yes | Yes | `TERMUX_VERSION` makes the clipboard check skip itself; photon pruning skipped. |
| Linux | Yes | Yes | Yes | Yes | Yes | |
| macOS | Yes | Yes (clipboard works) | Yes | Yes | Yes | |

On non-macOS / non-Termux systems, features that depend on platform tooling (clipboard, photon) are pruned or skipped automatically. The web_fetch tool needs a network connection.

## Touch-Screen + Thinking Visibility

- **Touch-screen support** — tap toggles thinking visibility, swipe scrolls the viewport. Works via dist patches that map SGR mouse events (Termux translates touch to mouse). No extra config needed.
- **Thinking peek by default** — `settings.json` ships `hideThinkingBlock: false`, so thinking renders as a short peek (first ~6 lines, then `…`). Tool output still renders collapsed (`toolOutputExpanded: false`) to keep the chat short. Toggle anytime with `ctrl+t` (thinking) / `ctrl+o` (tool output).
- **Chat styling** — the agent-boost extension transforms markdown live: `> [!NOTE/TIP/WARNING/ERROR/IMPORTANT]` become colored headings, `<kbd>X</kbd>` becomes inline code, and `[[wiki links]]` become clickable link tokens. Streaming indicator is a custom block spinner.

## Token Saver + Smart Route

All features below are **ON by default** — no manual setup needed.

- **Ultra Token Saver** — tracks token usage with a budget, runs in compact mode by default. Use `/token-saver` command to toggle, or the `ultra_token_saver` tool (`action: status|toggle|reset`). Compact mode: responses ≤ 3 lines, no markdown formatting.
- **Context Compression** — `compress_context` tool reduces long code blocks and repetitive patterns. Automatic in `web_fetch` (strips HTML, truncates at 20k chars).
- **Smart Route / 429 Retry** — `web_fetch` auto-retries on HTTP 429 (rate limit) with exponential backoff (1s→2s→4s→8s, max 3 retries). Status shown in footer when rate-limited.
- **super-fast skill** — ultra token saver operating mode: batch reads, no narration, no re-reads, multi-file edits in one pass. Uses `aggregate` to save round-trips.
- **Stream-drop resilience** — the pack sets `retry.maxRetries: 6` so a transient `"Stream ended without finish_reason"` (provider/network drop mid-stream) is retried automatically instead of failing the turn. Only applied when you haven't set `retry` yourself.

> Note: `tokenSaver`, `contextCompression`, and `smartRouteRetry` are pack/config keys but are **not consumed by pi v0.84.2** — they're harmless no-ops. The real token-saving work happens in the `agent-boost.ts` extension (above) and `retry` (above).

## Resume / Session History

Pi auto-saves every conversation to `~/.pi/agent/sessions/` (one JSONL file per working directory). To pick up where you left off:

```bash
pi --resume          # -r: browse all saved sessions, arrow-key select, continue
pi --continue        # -c: jump straight into the most recent session
pi --session <id>    # open a specific session by path or partial UUID
pi --fork <id>       # branch a session into a new file
pi --name "my task"  # set a display name so sessions are easy to find later
```

`--resume` lists your full chat history with timestamps and lets you choose which one to continue — no extra config, works through the `bin/pi` wrapper (it passes all args through). Themes + skills from the pack load automatically inside the resumed session.

## Auto-Update (keep pi + pack in sync)

When a new `pi-coding-agent` ships, `npm` reinstall wipes `node_modules` (losing the dist patches) and a fresh `interactive-mode.js` needs our patch re-applied. Update in one step:

```
./update.sh            # checks npm for a newer pi, npm update, then re-runs install.sh
./update.sh --force    # update even if versions match (just re-syncs pack files)
```

Or from inside the agent: run **`/pi-update`**. It runs the same script and reports the result.

`update.sh` is idempotent and zero-config — it never asks questions. `install.sh` (re)applies the dist patches and re-merges `agent-boost.ts`, `terminal-boost` theme, and `settings.json`, so your local mods stay current after any pi release.

## Settings reference (copy-paste)

`install.sh` writes this for you — but if you want to set it manually, drop this into `~/.pi/agent/settings.json`. The `retry` block is what makes the chat survive transient `"Stream ended without finish_reason"` drops (provider-level retry was `0` by default in pi v0.84.2).

```json
{
  "lastChangelogVersion": "0.84.2",
  "theme": "terminal-boost-aurora",
  "enableSkillCommands": true,
  "quietStartup": true,
  "defaultThinkingLevel": "low",
  "skills": [
    "~/.pi/skills",
    "~/.pi/agent/skills",
    "~/.claude/skills"
  ],
  "extensions": [
    "~/.pi/agent/extensions"
  ],
  "hideThinkingBlock": false,
  "toolOutputExpanded": false,
  "compaction": {
    "enabled": true,
    "reserveTokens": 16384,
    "keepRecentTokens": 20000
  },
  "retry": {
    "maxRetries": 6,
    "baseDelayMs": 2000,
    "provider": {
      "maxRetries": 5,
      "maxRetryDelayMs": 60000
    }
  }
}
```

> The `retry` block makes the chat survive transient `"Stream ended without finish_reason"` drops (provider-level retry was `0` by default in pi v0.84.2). `compaction` auto-padatkan long sessions so context never silently fills — this is the real context-saver (the old `tokenSaver`/`contextCompression`/`smartRouteRetry` keys were removed: they were no-ops in v0.84.2).

## Troubleshooting

- **`pi: bad interpreter: No such file or directory`** — the wrapper's node detection failed. Make sure `node` is on `PATH` (`pkg install nodejs` on Termux) or that the known Termux path exists.
- **`npm root -g` not found** — older npm without a global root query. The wrapper falls back to scanning `/usr/lib/node_modules`, `/usr/local/lib/node_modules`, and `$PREFIX/lib/node_modules`. If install location is unusual, run `npm install -g` again or symlink it.
- **Extension not loading** — run `/reload` inside pi after installing. Check the file is at `~/.pi/agent/extensions/agent-boost.ts` and is listed under `extensions[]` in `~/.pi/agent/settings.json`.
- **settings.json merge** — `install.sh` merges safe keys only; it never touches `models.json` or anything key-like. Your existing settings keys survive.

## Security

This repository stores **no API keys, tokens, or endpoints**. `models.json` (which holds a provider base URL and apiKey on some machines) is **never** copied, committed, or referenced here. Do a `grep -rE 'sk-|apiKey|token' .` sanity check before you push anything that forks from this repo.

## Related repositories

- **[claude-code-android-termux](https://github.com/dikaofc/claude-code-android-termux)** — run **Claude Code** itself on Android/Termux (no root). Patches the npm `os:android` platform block so the musl binary installs, ELF-patches the interpreter, and ships a no-root DNS proxy. Use this if you also want Claude Code (not just the `pi` agent) on your phone.

## License

MIT — see [LICENSE](LICENSE). Copyright (c) 2026 PiUpdaterCli contributors.