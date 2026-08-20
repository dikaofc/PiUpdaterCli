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

- **Extension bundle** (`agent/extensions/agent-boost.ts`) — dashboard widget, `aggregate` tool (one call runs N shell commands, saving model round-trips), persistent note tools (`note_save` / `note_get` / `note_list`), `web_fetch` (HTML-stripped page text), and auto-verify that runs `cap verify` after every edit. Hot-reload with `/reload`.
- **super-fast skill** (`agent/skills/super-fast/SKILL.md`) — a token-saving operating mode: batch reads, no narration, no re-reads, multi-file edits in one pass. Auto-reverts to careful prose for security/destructive work.
- **terminal-boost theme** (`agent/themes/terminal-boost.json`) — a color theme you can switch to from settings.
- **settings.json template** (`agent/settings.json`) — safe keys only: `lastChangelogVersion`, `theme`, `enableSkillCommands`, `skills[]`, `extensions[]`. No secrets.

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
mkdir -p ~/.pi/agent/extensions ~/.pi/agent/skills/super-fast ~/.pi/agent/themes
cp agent/extensions/agent-boost.ts ~/.pi/agent/extensions/
cp agent/skills/super-fast/SKILL.md ~/.pi/agent/skills/super-fast/
cp agent/themes/terminal-boost.json ~/.pi/agent/themes/
cp agent/settings.json ~/.pi/agent/settings.json   # merges/overwrites safe keys

# Add bin/pi to your PATH if you want the launcher:
install bin/pi ~/.local/bin/pi
```

Then run `/reload` inside pi so the extension loads.

## Compatibility

| Platform | Launcher (`bin/pi`) | Extension bundle | super-fast | theme | Notes |
|---|---|---|---|---|---|
| Termux | Yes — falls back to known Termux node path, `$PREFIX` scanning | Yes | Yes | Yes | `TERMUX_VERSION` makes the clipboard check skip itself; photon pruning skipped. |
| Linux | Yes | Yes | Yes | Yes | |
| macOS | Yes | Yes (clipboard works) | Yes | Yes | |

On non-macOS / non-Termux systems, features that depend on platform tooling (clipboard, photon) are pruned or skipped automatically. The web_fetch tool needs a network connection.

## Mouse + thinking visibility

- **Mouse click toggles thinking blocks** — left-click anywhere in the TUI toggles `hideThinkingBlock` (the "Thinking... / hidden" collapse). Implemented as a dist patch (see [patches/](patches/)); re-apply with `./patch.sh` after an `npm update`/reinstall of pi-coding-agent.
- **Thinking visible by default** — `settings.json` ships `hideThinkingBlock: false` and `toolOutputExpanded: true`, so thinking blocks and tool output render expanded. Toggle anytime with `ctrl+t` (thinking) / `ctrl+o` (tool output).
- **Chat styling** — the agent-boost extension transforms markdown live: `> [!NOTE/TIP/WARNING/ERROR/IMPORTANT]` become colored headings, `<kbd>X</kbd>` becomes inline code, and `[[wiki links]]` become clickable link tokens. Streaming indicator is a custom block spinner.

## Troubleshooting

- **`pi: bad interpreter: No such file or directory`** — the wrapper's node detection failed. Make sure `node` is on `PATH` (`pkg install nodejs` on Termux) or that the known Termux path exists.
- **`npm root -g` not found** — older npm without a global root query. The wrapper falls back to scanning `/usr/lib/node_modules`, `/usr/local/lib/node_modules`, and `$PREFIX/lib/node_modules`. If install location is unusual, run `npm install -g` again or symlink it.
- **Extension not loading** — run `/reload` inside pi after installing. Check the file is at `~/.pi/agent/extensions/agent-boost.ts` and is listed under `extensions[]` in `~/.pi/agent/settings.json`.
- **settings.json merge** — `install.sh` merges safe keys only; it never touches `models.json` or anything key-like. Your existing settings keys survive.

## Security

This repository stores **no API keys, tokens, or endpoints**. `models.json` (which holds a provider base URL and apiKey on some machines) is **never** copied, committed, or referenced here. Do a `grep -rE 'sk-|apiKey|token' .` sanity check before you push anything that forks from this repo.

## License

MIT — see [LICENSE](LICENSE). Copyright (c) 2026 PiUpdaterCli contributors.