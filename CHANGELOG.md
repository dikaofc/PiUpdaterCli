# Changelog — PiUpdaterCli

All notable changes to the pack installer/updater are documented here.
Format: version — date — what changed.

## 1.0.5 — 2026-08-26
- Fix pi-boost panel glitch on Windows (ConPTY): box-drawing + block glyphs
  (─ │ ┌ █ ░) miscount width → panel overflowed and duplicated border/thinking
  lines every render. Panel now renders ASCII (`- | + #`) on win32, rich frame
  elsewhere. Added idempotency guard so a double-loaded extension can't stack
  listeners/transformers (the "many thinking blocks" symptom).

## 1.0.4 — 2026-08-26
- Fix Windows terminal glitch: on MINGW/MSYS/Cygwin shells the ANSI spinner
  (`\r` rewrites) and box-drawing UTF-8 misaligned the cursor, duplicating
  output. Those platforms now drop to plain ASCII (no color/spinner/frame).
  WSL stays rich. Affects `install.sh` and `update.sh`.
- Print this changelog at the end of every `update.sh` run.

## 1.0.3 — 2026-08-19
- Dedupe top-level extensions against the pi-agent package to fix
  "Tool X conflicts" load failures (extensions silently dying).
- Sync subagents to user scope (`~/.pi/agent/agents`) so the subagent tool
  finds bundled agents.

## 1.0.2 — 2026-08-12
- Force native pi compaction + retry resilience on every install.
- Auto-switch fresh installs to the terminal-boost-aurora theme.

## 1.0.1 — 2026-08-05
- Single skills dir (`~/.pi/skills`); skip package-owned names to avoid
  collision warnings. Remove legacy skill dirs.
- Re-apply dist patches (mouse-click thinking toggle) idempotently.

## 1.0.0 — 2026-07-28
- Initial pack: bin/pi wrapper, agent-boost extension, terminal-boost
  themes, settings merge, plugin/skill sync, auto-update hook.
