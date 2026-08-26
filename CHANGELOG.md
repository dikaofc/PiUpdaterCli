# Changelog — PiUpdaterCli

All notable changes to the pack installer/updater are documented here.
Format: version — date — what changed.

## 1.0.8 — 2026-08-26
- Windows thinking now renders Claude-like: bright red + bold (ANSI 1;91),
  no animation (ConPTY-safe — text-only transform, no setWidget churn).
  Native PTYs keep the peek-truncate behavior.

## 1.0.7 — 2026-08-26
- Windows (ConPTY) TUI ghost fix: the panel, custom spinner, thinking-peek,
  and all setStatus writes churn the alt-screen and ConPTY doesn't clear the
  prior frame, so answers + thinking blocks stacked and got cut off. On win32
  the extension now skips ALL UI manipulation (panel/spinner/status) and keeps
  only the non-visual tools + commands (/pi-update, /who, notes, etc). Rich
  UX stays on Termux/Linux/macOS/WSL.

## 1.0.6 — 2026-08-26
- Fix /pi-update silent on Windows: shell + path were *nix-only. sh() now
  tries bash then cmd.exe on win32; pack dir read from a marker file written
  by install.sh (Windows uses USERPROFILE, not HOME). Clear error if no clone.
- Fix persistent panel duplication on Windows: ConPTY doesn't clear the
  alt-screen cell before setWidget, so rapid renders ghosted. Debounce to one
  render/400ms, clear widget before redraw, and disable the 220ms pulse timer
  on win32 (rich animation stays on Termux/Linux/macOS/WSL).

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
