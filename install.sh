#!/bin/sh
#​@dikaacode​
# PiUpdaterCli -- universal installer for the pi coding agent upgrade pack.
# POSIX sh; runs on Termux (Android), Linux, macOS.
#
# WHY: the npm-installed "pi" binary shebang is `#!/usr/bin/env node`, which
# fails on Termux -- the bionic kernel cannot follow the /usr/bin/env symlink
# interpreter. Fix: a wrapper at ~/.local/bin/pi (first in PATH via
# ~/.bashrc) running node with the absolute path to dist/cli.js. Same wrapper
# makes the pack work on Linux/macOS, where the npm root differs.

# NOTE: no `set -e` — a single failing step (e.g. offline npm, missing patch
# target) must NOT abort the rest of the install. Each section reports status.
DRY_RUN=0
FORCE=0

usage() {
	cat <<'EOF'
Usage: install.sh [OPTIONS]

Options:
  -h, --help      Show this help and exit.
  -d, --dry-run   Print what would be done without changing anything.
  -f, --force     Overwrite existing files without backing them up first.

Installs the pi upgrade pack:
  - writes bin/pi wrapper -> ~/.local/bin/pi (with PATH configured)
  - copies agent-boost.ts, super-fast + agent-efficiency skills, terminal-boost theme
  - merges settings.json (never clobbers user keys)
  - moves unused native deps (clipboard, photon-node) out of node_modules
EOF
}

# ---------- flag parsing (getopt-style) ----------
for arg in "$@"; do
	case "$arg" in
		-h|--help) usage; exit 0 ;;
		-d|--dry-run) DRY_RUN=1 ;;
		-f|--force) FORCE=1 ;;
		--schedule) SCHEDULE=1 ;;
		*) echo "unknown option: $arg" >&2; usage >&2; exit 2 ;;
	esac
done

say() { printf '%s\n' "$*"; }

# ---------- color + spinner (bright, responsive CLI UX) ----------
if [ -t 1 ] && [ "$PLAIN" = 0 ]; then
	C=$'\033[1;36m'; G=$'\033[1;32m'; Y=$'\033[1;33m'; R=$'\033[1;31m'
	M=$'\033[1;35m'; B=$'\033[1;34m'; W=$'\033[0m'; DIM=$'\033[2m'
else
	C=""; G=""; Y=""; R=""; M=""; B=""; W=""; DIM=""
fi
spin_chars="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
spin() { # $1 = pid to watch
	# Plain (Windows) mode: spinner rewrites the same line via \r, which the
	# windows console miscounts against multi-byte glyphs -> duplicated output.
	# Instead just print the step once and wait silently.
	[ "$PLAIN" = 1 ] && { wait "$1" 2>/dev/null; return 0; }
	i=0
	while kill -0 "$1" 2>/dev/null; do
		printf '\r%s%s %s%s' "$DIM" "${spin_chars:i%10:1}" "$2" "$W"
		i=$((i+1)); sleep 0.08
	done
	printf '\r\033[K'
}
ok()  { printf '%s✓ %s%s\n' "$G" "$1" "$W"; }
warn(){ printf '%s! %s%s\n' "$Y" "$1" "$W"; }
err() { printf '%s✗ %s%s\n' "$R" "$1" "$W"; }
step(){ printf '%s▸ %s%s\n' "$C" "$1" "$W"; }

# PACK_DIR: this pack's dir. Follow symlink if $0 is one (macOS installs
# often symlink the script into the repo).
SELF=$0
if command -v readlink >/dev/null 2>&1 && [ -L "$0" ]; then
	SELF=$(readlink "$0" 2>/dev/null) || SELF=$0
fi
PACK_DIR=$(cd "$(dirname "$SELF")" && pwd)

# Guard: PACK_DIR must contain the pack source. If empty/wrong, every copy
# below would silently install nothing (and stale theme from a prior install
# would make it look like "only color changed"). Fail loud instead.
if [ ! -d "$PACK_DIR/agent/extensions" ] || [ ! -d "$PACK_DIR/agent/skills-all" ]; then
	echo "ERROR: pack source not found at $PACK_DIR/agent/" >&2
	echo "hint: run from the cloned repo root, e.g.  cd ~/PiUpdaterCli && ./install.sh" >&2
	exit 1
fi

# ---------- sync pack from GitHub (so a bare clone/old copy always installs latest) ----------
# WHY: users run ./install.sh expecting the newest pack. Without this, an old
# clone (or a stale local copy) installs yesterday's files and "nothing changes"
# after a fix is pushed. Non-fatal: skips silently offline or on a diverged tree.
PI_REMOTE="https://github.com/dikaofc/PiUpdaterCli.git"
if [ -d "$PACK_DIR/.git" ]; then
	if ( cd "$PACK_DIR" && git pull --ff-only 2>/dev/null ); then
		step "synced pack from GitHub ($(git -C "$PACK_DIR" rev-parse --short HEAD 2>/dev/null))"
	elif ( cd "$PACK_DIR" && git diff --quiet 2>/dev/null ) && ( cd "$PACK_DIR" && git fetch 2>/dev/null ) \
	     && ( cd "$PACK_DIR" && git reset --hard origin/main 2>/dev/null ); then
		step "fast-forwarded pack to latest from GitHub ($(git -C "$PACK_DIR" rev-parse --short HEAD 2>/dev/null))"
	else
		warn "git sync skipped (offline, diverged, or uncommitted edits) — using local pack"
	fi
else
	warn "no .git in pack dir — install uses local files only; run 'git clone $PI_REMOTE' to auto-update"
fi
# TERMUX_VERSION is set on Termux and only there: canonical platform switch.
[ -n "$TERMUX_VERSION" ] && PLATFORM=termux || PLATFORM=$(uname -s 2>/dev/null || printf unknown)

# PLAIN mode: Windows native shells (Git Bash / MSYS / Cygwin) render ANSI
# `\r` spinner rewinds + multi-byte box-drawing chars with byte-counted cursor
# math, which misaligns and shows duplicated/overlapping text ("glitch").
# On those we drop color, the spinner, and the box frame for clean ASCII output.
# WSL reports "Linux" and handles UTF-8+ANSI fine, so it stays rich.
case "$PLATFORM" in
	*MINGW*|*MSYS*|*CYGWIN*|*Windows*) PLAIN=1 ;;
	*) PLAIN=0 ;;
esac

# NODE -- absolute node interpreter for the wrapper.
if command -v node >/dev/null 2>&1; then NODE=$(command -v node); fi
if [ "$PLATFORM" = termux ] && [ -x /data/data/com.termux/files/usr/bin/node ]; then
	NODE=/data/data/com.termux/files/usr/bin/node
fi
[ -n "$NODE" ] || { echo "ERROR: node not found" >&2; exit 1; }

# SHELL -- wrapper shebang (Termux has its own bash outside PATH).
if [ "$PLATFORM" = termux ]; then SHELL_BIN=/data/data/com.termux/files/usr/bin/bash
elif command -v sh >/dev/null 2>&1; then SHELL_BIN=$(command -v sh)
else SHELL_BIN=/bin/sh; fi

# HOME -- user home. Avoid getent (not always present on Termux/Android).
home_detect() {
	if [ "$PLATFORM" = termux ] && [ -d /data/data/com.termux/files/home ]; then
		printf '%s\n' /data/data/com.termux/files/home; return 0
	fi
	if [ -n "$HOME" ]; then printf '%s\n' "$HOME"; return 0; fi
	if command -v getent >/dev/null 2>&1; then
		h=$(getent passwd "$(id -u 2>/dev/null)" 2>/dev/null | cut -d: -f6 || true)
		if [ -n "$h" ]; then printf '%s\n' "$h"; return 0; fi
	fi
	printf '%s\n' /root
}
HOME_DET=$(home_detect)

# PKG -- locate dist/cli.js. Fallback chain: npm root -g, known Termux
# path, standard Linux paths.
PKG_ROOT=
if command -v npm >/dev/null 2>&1; then
	PKG_ROOT=$(npm root -g 2>/dev/null || true)
fi
find_cli() {
	for c in \
		"$PKG_ROOT/@earendil-works/pi-coding-agent/dist/cli.js" \
		/data/data/com.termux/files/usr/lib/node_modules/@earendil-works/pi-coding-agent/dist/cli.js \
		/usr/lib/node_modules/@earendil-works/pi-coding-agent/dist/cli.js \
		/usr/local/lib/node_modules/@earendil-works/pi-coding-agent/dist/cli.js
	do
		if [ -f "$c" ]; then printf '%s\n' "$c"; return 0; fi
	done
	return 1
}
if ! CLI_JS=$(find_cli); then
	echo "ERROR: could not find @earendil-works/pi-coding-agent/dist/cli.js" >&2
	echo "hint: install it first: npm install -g @earendil-works/pi-coding-agent" >&2
	exit 1
fi
PKG_DIR=${CLI_JS%/dist/cli.js}

# ---------- target paths ----------
LOCAL_BIN="$HOME_DET/.local/bin"; WRAPPER="$LOCAL_BIN/pi"
AGENT_DIR="$HOME_DET/.pi/agent"; SETTINGS="$AGENT_DIR/settings.json"

printf '%s%s%s %snode%s   %s%s%s\n' "$C" "▸" "$W" "$B" "$W" "$W" "$NODE" "$W"
printf '%s%s%s %sshell%s %s%s%s\n' "$C" "▸" "$W" "$B" "$W" "$W" "$SHELL_BIN" "$W"
printf '%s%s%s %shome%s   %s%s%s\n' "$C" "▸" "$W" "$B" "$W" "$W" "$HOME_DET" "$W"
printf '%s%s%s %spackage%s%s%s%s\n' "$C" "▸" "$W" "$B" "$W" "$W" "$PKG_DIR" "$W"

# back up target to target.bak.<ts>; --force deletes instead.
backup_file() {
	[ -f "$1" ] || return 0
	if [ "$FORCE" = 1 ]; then rm -f "$1"; return 0; fi
	mv "$1" "$1.bak.$(date +%Y%m%d%H%M%S 2>/dev/null || printf 'default')"
}

# install_copy SOURCE TARGET DESCRIPTION
install_copy() {
	dir=$(dirname "$2")
	mkdir -p "$dir"
	if [ "$DRY_RUN" = 1 ]; then say "[dry-run] install $3 -> $2"; return 0; fi
	backup_file "$2"
	cp "$1" "$2"
	ok "installed $3 -> $2"
}

# ---------- wrapper ----------
# Generated, not copied from bin/pi (which hardcodes Termux paths and would
# be wrong on Linux/macOS). WHY direct exec: the package shebang
# (`#!/usr/bin/env node`) fails on Termux's kernel, which cannot follow
# the /usr/bin/env symlink.
mkdir -p "$LOCAL_BIN"
if [ "$DRY_RUN" = 1 ]; then say "[dry-run] write + chmod wrapper -> $WRAPPER"
else
	backup_file "$WRAPPER"
	printf '#!%s\n# pi wrapper -- installed by PiUpdaterCli, do not edit.\nexec "%s" "%s" "$@"\n' \
		"$SHELL_BIN" "$NODE" "$CLI_JS" > "$WRAPPER"
	chmod +x "$WRAPPER"
	say "installed wrapper -> $WRAPPER"
fi

# ---------- pack location marker (for /pi-update from inside pi) ----------
# WHY: the agent-boost extension's /pi-update command needs the absolute pack
# dir to run update.sh. On Windows $HOME is unset (USERPROFILE instead), so we
# persist the path here and the extension reads it. NOT written in dry-run.
if [ "$DRY_RUN" != 1 ]; then
	printf '%s\n' "$PACK_DIR" > "$HOME_DET/.pi/PiUpdaterCli.path" 2>/dev/null \
		&& say "recorded pack location -> $HOME_DET/.pi/PiUpdaterCli.path" \
		|| warn "could not write pack location marker"
fi

# ---------- PATH setup ----------
for rc in "$HOME_DET/.bashrc" "$HOME_DET/.profile"; do
	if [ -f "$rc" ] && grep -Fq ".local/bin" "$rc" 2>/dev/null; then
		continue
	fi
	if [ "$DRY_RUN" = 1 ]; then say "[dry-run] append PATH export to $rc"; continue; fi
	printf '\n# added by PiUpdaterCli\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$rc"
	say "PATH configured in $rc"
done

# ---------- shell aliases ----------
# `pir` = resume last session picker; `pit <theme>` = switch pi theme live.
for rc in "$HOME_DET/.bashrc" "$HOME_DET/.profile"; do
	[ -f "$rc" ] || continue
	if grep -Fq "alias pi=" "$rc" 2>/dev/null; then
		continue
	fi
	if [ "$DRY_RUN" = 1 ]; then say "[dry-run] append pi alias to $rc"; continue; fi
	cat >> "$rc" <<'ALIASES'

# added by PiUpdaterCli
alias pir="pi --resume"
alias pit='f(){ ~/.local/bin/pi config --set theme "$1"; }; f'
ALIASES
	say "aliases configured in $rc (pir = pi --resume, pit <theme> = switch theme)"
done

# ---------- agent extension/skill/theme ----------
install_copy "$PACK_DIR/agent/extensions/agent-boost.ts" "$AGENT_DIR/extensions/agent-boost.ts" "extension agent-boost.ts"

# All bundled skills (curated pack + full skill library) → ~/.pi/skills ONLY.
#
# WHY a single dir: pi auto-loads skills from BOTH the settings "skills" list
# AND every registered package's skills/ dir. Installing the same skill name
# into multiple of those sources makes pi emit "collision: skipped" and drop
# the skill. The pi-agent package already owns 61 skills (auto-loaded), so we
# sync our library to ~/.pi/skills but SKIP any name the package provides —
# letting the package win those, and avoiding every collision. The other two
# legacy dirs (~/.pi/agent/skills, ~/.claude/skills) are removed so nothing
# stale collides.
SKILL_DIR="$HOME_DET/.pi/skills"
# Build the set of skill names the package already provides (from frontmatter).
PKG_NAMES=""
for f in "$PACK_DIR"/agent/pi-agent/skills/*/*/SKILL.md; do
	[ -f "$f" ] || continue
	n=$(grep -m1 '^name:' "$f" 2>/dev/null | sed 's/name:[[:space:]]*//;s/"//g')
	[ -n "$n" ] && PKG_NAMES="$PKG_NAMES $n"
done
# Legacy dirs that must NOT exist (they collide with the package + this dir).
for stale in "$AGENT_DIR/skills" "$HOME_DET/.claude/skills"; do
	[ -d "$stale" ] && rm -rf "$stale" && warn "removed stale skill dir $stale (collision source)"
done
if [ "$DRY_RUN" = 1 ]; then
	say "[dry-run] sync skills -> $SKILL_DIR (skipping $PKG_NAMES)"
else
	mkdir -p "$SKILL_DIR"
	# collect our skill names first
	names=""
	for src in "$PACK_DIR"/agent/skills-all/*/ "$PACK_DIR"/agent/skills/*/; do
		[ -d "$src" ] || continue
		names="$names $(basename "$src")"
	done
	# remove skills not in our repo set or owned by the package
	for existing in "$SKILL_DIR"/*/; do
		[ -d "$existing" ] || continue
		bn=$(basename "$existing")
		case " $PKG_NAMES " in *" $bn "* ) rm -rf "$existing"; continue ;; esac
		case " $names " in *" $bn "* ) ;; *) rm -rf "$existing" ;; esac
	done
	# copy each, skipping package-owned names
	copied=0
	for src in "$PACK_DIR"/agent/skills-all/*/ "$PACK_DIR"/agent/skills/*/; do
		[ -d "$src" ] || continue
		bn=$(basename "$src")
		case " $PKG_NAMES " in *" $bn "* ) continue ;; esac
		mkdir -p "$SKILL_DIR/$bn"
		cp -r "$src/." "$SKILL_DIR/$bn/" 2>/dev/null
		copied=$((copied+1))
	done
	say "synced skills -> $SKILL_DIR ($copied skills; package provides $(echo $PKG_NAMES | wc -w) more, zero collisions)"
fi

# Plugins (full plugin library).
if [ "$DRY_RUN" = 1 ]; then
	say "[dry-run] sync plugins from agent/plugins -> $AGENT_DIR/plugins"
else
	mkdir -p "$AGENT_DIR/plugins"
	for pd in "$PACK_DIR"/agent/plugins/*/; do
		[ -d "$pd" ] || continue
		name=$(basename "$pd")
		mkdir -p "$AGENT_DIR/plugins/$name"
		cp -r "$pd/." "$AGENT_DIR/plugins/$name/" 2>/dev/null
	done
	say "synced plugins -> $AGENT_DIR/plugins ($(ls "$AGENT_DIR/plugins" | wc -l) plugins)"
fi

# Tools — NOT installed to the deprecated global ~/.pi/agent/tools/ dir.
# pi warns "Global tools/ directory contains custom tools. Move your
# extensions to the extensions/ directory" and may ignore them. The only
# bundled tool (validate_repo.py) is a pack-repo validation script, not a
# pi tool, so it stays in the pack repo and is run from there.
if [ "$DRY_RUN" != 1 ] && [ -d "$AGENT_DIR/tools" ] && [ -z "$(ls -A "$AGENT_DIR/tools" 2>/dev/null)" ]; then
	rmdir "$AGENT_DIR/tools" 2>/dev/null || true
fi
warn "skipped ~/.pi/agent/tools (deprecated by pi — keep scripts in the pack repo)"

# Full pi config (CLAUDE.md, AGENTS.md, commands/, hooks/, rules/, context/,
# prompts/, workflows/, templates/, etc.) — the complete agent environment.
# Prompts are special: the pi-agent package auto-loads its own prompts/, so
# we skip any prompt name it already owns to avoid "collision: skipped".
PKG_PROMPT_NAMES=""
for pf in "$PACK_DIR"/agent/pi-agent/prompts/*.md; do
	[ -f "$pf" ] || continue
	PKG_PROMPT_NAMES="$PKG_PROMPT_NAMES $(basename "$pf" .md)"
done
if [ "$DRY_RUN" = 1 ]; then
	say "[dry-run] sync pi-config -> $HOME_DET/.pi"
else
	for item in "$PACK_DIR"/agent/pi-config/*; do
		[ -e "$item" ] || continue
		base=$(basename "$item")
		if [ -d "$item" ]; then
			mkdir -p "$HOME_DET/.pi/$base"
			if [ "$base" = "prompts" ]; then
				# copy prompts, skipping package-owned names
				for pf in "$item"/*.md; do
					[ -f "$pf" ] || continue
					bn=$(basename "$pf" .md)
					case " $PKG_PROMPT_NAMES " in *" $bn "* ) continue ;; esac
					cp -f "$pf" "$HOME_DET/.pi/$base/" 2>/dev/null
				done
			else
				cp -r "$item/." "$HOME_DET/.pi/$base/" 2>/dev/null
			fi
		else
			cp -f "$item" "$HOME_DET/.pi/" 2>/dev/null
		fi
	done
	say "synced pi-config -> $HOME_DET/.pi (complete agent environment)"
	# Remove any prompt in ~/.pi/prompts that the package already owns
	# (leftover from a prior install) so no collision remains.
	for bn in $PKG_PROMPT_NAMES; do
		[ -f "$HOME_DET/.pi/prompts/$bn.md" ] && rm -f "$HOME_DET/.pi/prompts/$bn.md"
	done
fi

# ---------- pi-agent package (53 skills + agents + extensions) ----------
# Copies the bundled pi-skills catalog package into the agent packages dir
# so it loads on every pi run (registered in settings below). Absolute path
# — not the relative path `pi install` writes — so it survives moving the repo.
if [ "$DRY_RUN" = 1 ]; then
	say "[dry-run] sync pi-agent package -> $AGENT_DIR/packages/pi-agent"
else
	mkdir -p "$AGENT_DIR/packages/pi-agent"
	cp -r "$PACK_DIR/agent/pi-agent/." "$AGENT_DIR/packages/pi-agent/" 2>/dev/null
	say "synced pi-agent package -> $AGENT_DIR/packages/pi-agent ($(ls "$AGENT_DIR/packages/pi-agent/skills" 2>/dev/null | wc -l) skill categories)"
fi

# ---------- dedupe extensions (fix "Tool X conflicts" load failures) ----------
# WHY: pi loads both $AGENT_DIR/extensions and $AGENT_DIR/packages/*/extensions.
# If the same extension (e.g. fb-swarm, subagent) lands in BOTH, pi refuses to
# load either and prints "Tool ... conflicts" — extensions silently die. The
# pi-agent package is the canonical home for bundled extensions; remove any
# duplicate from the top-level extensions/ dir so only one copy loads.
PKG_EXT="$AGENT_DIR/packages/pi-agent/extensions"
if [ -d "$PKG_EXT" ] && [ "$DRY_RUN" != 1 ]; then
	for dup in "$PKG_EXT"/*; do
		[ -e "$dup" ] || continue
		name=$(basename "$dup")
		tgt="$AGENT_DIR/extensions/$name"
		# Never remove our own agent-boost.ts — it lives only at top level.
		[ "$name" = "agent-boost.ts" ] && continue
		if [ -e "$tgt" ]; then
			rm -rf "$tgt"
			warn "removed duplicate extension $name from top-level (canonical copy is in pi-agent package)"
		fi
	done
fi

# ---------- subagents (user scope) ----------
# WHY: the subagent tool's default scope reads from $AGENT_DIR/agents/ (the
# "user" scope), NOT from the pi-agent package dir. The package copy above is
# for skill/extension discovery; agents must ALSO live in the user-scope dir or
# the subagent tool never finds them. This is the bug that made every bundled
# agent invisible to `subagent`. Sync idempotently so re-installs stay in sync.
if [ "$DRY_RUN" = 1 ]; then
	say "[dry-run] sync subagents -> $AGENT_DIR/agents"
else
	mkdir -p "$AGENT_DIR/agents"
	for af in "$PACK_DIR"/agent/pi-agent/agents/*.md; do
		[ -f "$af" ] || continue
		cp -f "$af" "$AGENT_DIR/agents/" 2>/dev/null
	done
	say "synced subagents -> $AGENT_DIR/agents ($(ls "$AGENT_DIR/agents" 2>/dev/null | wc -l) agents available to subagent tool)"
fi

# ---------- Claude Code CLI sync (parallel install) ----------
# WHY: the same agent/skill catalog should also load in Claude Code CLI, which
# reads from ~/.claude/agents and ~/.claude/skills (different scope from pi).
# Agents (.md frontmatter) and skills (SKILL.md) are format-compatible, so we
# copy them wholesale and idempotently. Plugins and tools are skipped: claude
# plugins need a registry (installed_plugins.json), not a flat copy, and claude
# has no ~/.claude/tools dir — those stay pi-only.
CLAUDE_DIR="$HOME_DET/.claude"
if [ "$DRY_RUN" = 1 ]; then
	say "[dry-run] sync agents -> $CLAUDE_DIR (Claude Code CLI)"
else
	# Agents: format-compatible (.md with frontmatter). Skills are already
	# mirrored into ~/.claude/skills by the unified skills sync above.
	mkdir -p "$CLAUDE_DIR/agents"
	for af in "$PACK_DIR"/agent/pi-agent/agents/*.md; do
		[ -f "$af" ] || continue
		cp -f "$af" "$CLAUDE_DIR/agents/" 2>/dev/null
	done
	say "synced Claude Code CLI -> $CLAUDE_DIR/agents ($(ls "$CLAUDE_DIR/agents" 2>/dev/null | wc -l) agents)"
fi

# Themes.
install_copy "$PACK_DIR/agent/themes/terminal-boost.json" "$AGENT_DIR/themes/terminal-boost.json" "theme terminal-boost"
install_copy "$PACK_DIR/agent/themes/terminal-boost-rainbow.json" "$AGENT_DIR/themes/terminal-boost-rainbow.json" "theme terminal-boost-rainbow"
install_copy "$PACK_DIR/agent/themes/terminal-boost-aurora.json" "$AGENT_DIR/themes/terminal-boost-aurora.json" "theme terminal-boost-aurora"

# ---------- settings.json merge ----------
# Merge, never clobber: add missing pack keys, preserve user theme/model.
# Done in node (guaranteed present), not sed/grep JSON surgery.
DEFAULT_SETTINGS='{
  "lastChangelogVersion": "0.84.2",
  "theme": "terminal-boost-aurora",
  "enableSkillCommands": true,
  "quietStartup": true,
  "defaultProjectTrust": "always",
  "defaultThinkingLevel": "low",
  "skills": [
    "~/.pi/skills"
  ],
  "extensions": [
    "~/.pi/agent/extensions"
  ],
  "packages": [
    "~/.pi/agent/packages/pi-agent"
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
}'

if [ "$DRY_RUN" = 1 ]; then
	say "[dry-run] merge settings into $SETTINGS"
else
	mkdir -p "$AGENT_DIR"
	if [ -f "$SETTINGS" ]; then
		# Merge BEFORE moving the original aside: node reads the live file
		# and writes the merged result to a temp then swaps it in.
		"$NODE" -e '
			const fs = require("fs");
			const [, p, o, js] = process.argv;
			const def = JSON.parse(js);
			let u = {};
			try { u = JSON.parse(fs.readFileSync(p, "utf8")); } catch (e) {}
			for (const k in def) if (u[k] === undefined) u[k] = def[k];
			// Force pack default UX every install.
			u.hideThinkingBlock = def.hideThinkingBlock;
			u.toolOutputExpanded = def.toolOutputExpanded;
			// Auto-switch to the colorful rainbow theme so a fresh install
			// looks vibrant out of the box (zero manual config).
			u.theme = "terminal-boost-aurora";
			// Force native pi compaction on every install so long sessions
			// auto-padatkan (the real context-saver; tokenSaver/contextCompression
			// keys are no-ops in pi v0.84.2 and were removed from the pack).
			u.compaction = def.compaction;
			// Force the bundled pi-agent package to load from the absolute
			// install path (not the relative path `pi install` writes, which
			// breaks if the repo moves). Replaced every install.
			u.packages = ["~/.pi/agent/packages/pi-agent"];
			// Force the skills list to a single dir. Union-ing with a stale
			// user settings that still lists the removed dirs would bring
			// collisions back, so we replace, not merge.
			u.skills = ["~/.pi/skills"];
			if (Array.isArray(def.extensions)) {
				const s = new Set(Array.isArray(u.extensions) ? u.extensions : []);
				for (const x of def.extensions) s.add(x);
				u.extensions = [...s];
			}
			// Retry resilience: tolerate transient stream drops
			// ("Stream ended without finish_reason"). Fill defaults only where
			// the user has not set a value; never clobber an explicit config.
			// provider.* is merged recursively so a partial user override survives.
			if (typeof def.retry === "object" && def.retry !== null && !Array.isArray(def.retry)) {
				if (typeof u.retry !== "object" || u.retry === null || Array.isArray(u.retry)) {
					u.retry = {};
				}
				for (const rk in def.retry) {
					if (typeof def.retry[rk] === "object" && def.retry[rk] !== null && !Array.isArray(def.retry[rk])) {
						if (typeof u.retry[rk] !== "object" || u.retry[rk] === null || Array.isArray(u.retry[rk])) {
							u.retry[rk] = {};
						}
						for (const rk2 in def.retry[rk]) {
							if (u.retry[rk][rk2] === undefined) u.retry[rk][rk2] = def.retry[rk][rk2];
						}
					} else if (u.retry[rk] === undefined) {
						u.retry[rk] = def.retry[rk];
					}
				}
			}
			fs.writeFileSync(o, JSON.stringify(u, null, 2) + "\n");
		' "$SETTINGS" "$SETTINGS.merged" "$DEFAULT_SETTINGS"
		backup_file "$SETTINGS"
		mv "$SETTINGS.merged" "$SETTINGS"
		say "merged settings -> $SETTINGS"
	else
		printf '%s\n' "$DEFAULT_SETTINGS" > "$SETTINGS"
		say "created settings -> $SETTINGS"
	fi
fi

# ---------- trim unused native deps ----------
# WHY: clipboard binaries are skipped at runtime when TERMUX_VERSION is set;
# photon-node is lazy-loaded with an `if (!photon) return null` fallback.
# Moving them saves ~14MB. NEVER on macOS (Darwin), where the darwin
# clipboard binary is the one the app actually needs.
trim_native() {
	if [ "$DRY_RUN" = 1 ]; then say "[dry-run] trim native deps (clipboard, photon-node)"; return 0; fi
	if [ "$PLATFORM" = Darwin ]; then say "platform is darwin -- keeping clipboard, skipping trim"; return 0; fi

	# Active CPU token, so the running OS's binary is never moved.
	case "$(uname -m 2>/dev/null || printf unknown)" in
		x86_64|amd64) ACT=x64 ;; aarch64|arm64) ACT=arm64 ;;
		riscv64) ACT=riscv64 ;; *) ACT=linux ;;
	esac

	cmdir="$HOME_DET/pi-clipboard-backup"; phdir="$HOME_DET/pi-photon-backup"
	mkdir -p "$cmdir" "$phdir"

	# clipboard: move every variant that isn't the active platform's.
	for d in "$PKG_DIR/node_modules/@mariozechner"/clipboard-*; do
		[ -d "$d" ] || continue
		case "$d" in *"$ACT"*) continue ;; esac
		base=$(basename "$d")
		if [ -e "$cmdir/$base" ]; then say "skip $base (already backed up)"; continue; fi
		mv "$d" "$cmdir/"; say "moved $base -> $cmdir/ (unused platform)"
	done

	d="$PKG_DIR/node_modules/@silvia-odwyer/photon-node"
	if [ -d "$d" ] && [ ! -e "$phdir/photon-node" ]; then
		mv "$d" "$phdir/"; say "moved photon-node -> $phdir/ (lazy-loaded, not needed)"
	fi
}
trim_native

# ---------- dist patches (mouse-click thinking toggle, auto-reapply) ----------
# After every install, re-apply the patched dist files. Idempotent: backs
# up the stock file once, then overwrites with the patched copy from patches/.
apply_patch() {
	# $1=patched-file-in-pack  $2=target-relative-to-package-root
	target="$PKG_DIR/$2"
	[ -f "$target" ] || { say "skip patch $2 (not found at $target)"; return 0; }
	if [ "$DRY_RUN" = 1 ]; then
		say "[dry-run] patch $2"
		return 0
	fi
	if [ ! -e "$target.bak.pre-pi" ]; then
		cp "$target" "$target.bak.pre-pi.$(date +%Y%m%d%H%M%S 2>/dev/null || printf 1)"
		say "backed up $2 -> .bak.pre-pi"
	fi
	cp "$PACK_DIR/patches/$1" "$target"
	say "patched $2 (mouse-click toggles thinking)"
}
apply_patch pi-tui.tui-alt-screen.mouse.js node_modules/@earendil-works/pi-tui/dist/tui-alt-screen.js
apply_patch interactive-mode.mouse.js dist/modes/interactive/interactive-mode.js

# ---------- verify what actually landed (fail loud on empty) ----------
v_skills=$(ls "$HOME_DET/.pi/skills" 2>/dev/null | wc -l)
v_plugins=$(ls "$AGENT_DIR/plugins" 2>/dev/null | wc -l)
v_ext=$(ls "$AGENT_DIR/extensions"/*.ts 2>/dev/null | grep -v '\.bak' | wc -l)
v_agents=$(ls "$AGENT_DIR/agents" 2>/dev/null | wc -l)
v_pkg=$(ls "$AGENT_DIR/packages/pi-agent/skills" 2>/dev/null | wc -l)
[ "$v_skills" -gt 0 ] && ok "$v_skills skills installed" || warn "0 skills installed!"
[ "$v_plugins" -gt 0 ] && ok "$v_plugins plugins installed" || warn "0 plugins installed!"
[ "$v_ext" -gt 0 ] && ok "$v_ext extension(s) installed" || warn "0 extensions installed!"
[ "$v_agents" -gt 0 ] && ok "$v_agents agents installed" || warn "0 agents installed!"
[ "$v_pkg" -gt 0 ] && ok "pi-agent package: $v_pkg skill categories" || warn "pi-agent package empty!"

# ---------- summary ----------
if [ "$PLAIN" = 1 ]; then
	BORDER="=================================================="
	printf '\n%s[%s]%s\n' "$M" "$BORDER" "$W"
	printf '%s[ PiUpdaterCli -- install complete ]%s\n' "$G"
	printf '%s[%s]%s\n' "$M" "$BORDER" "$W"
else
	BORDER="══════════════════════════════════════════════════════"
	printf '\n%s╔%s╗%s\n' "$M" "$BORDER" "$W"
	printf '%s║%s PiUpdaterCli — install %scomplete%s %s║%s\n' "$M" "$W" "$G" "$W" "$M" "$W"
	printf '%s╚%s╝%s\n' "$M" "$BORDER" "$W"
fi
printf '  %swrapper %s%s  %spath%s %s%s%s\n' "$DIM" "$W" "$C" "$W" "$B" "$WRAPPER" "$W"
printf '  %sext     %s%s  %s%s%s\n' "$DIM" "$W" "$C" "$B" "$AGENT_DIR/extensions/agent-boost.ts" "$W"
printf '  %stheme   %s%s  %saurora%s\n' "$DIM" "$W" "$C" "$M" "$W"
printf '  %ssettings%s %s%s%s\n' "$DIM" "$W" "$C" "$SETTINGS" "$W"
printf '\n  %sdefaults:%s thinking=peek(6), tool-output=collapsed%s\n' "$Y" "$W" "$W"
printf '  %scompaction ON%s (auto-padatkan) · %sretry maxRetries=6%s (stream-drop resilient)%s\n' "$G" "$W" "$G" "$W" "$W"
printf '  %salias%s pir = pi --resume%s\n' "$B" "$W" "$W"
printf '  %supdate%s run ./update.sh or /pi-update (auto git-pull from GitHub)%s\n' "$B" "$W" "$W"
printf '\n  %sverify:%s pi -> %s%s --version%s | claude -> %sclaude --version%s\n' "$DIM" "$W" "$C" "$WRAPPER" "$W" "$C" "$W"
[ "$DRY_RUN" = 1 ] && warn "(dry-run: nothing was written)"

# ---------- optional: schedule auto-update (Termux job scheduler) ----------
# Registers scripts/auto-update.sh to run every 6h via termux-job-scheduler.
# Skipped if the scheduler binary is absent (non-Termux / Termux:API missing)
# or if this is a dry-run. Android enforces a 15-min minimum period.
if [ "$SCHEDULE" = 1 ] && [ "$DRY_RUN" != 1 ]; then
	if command -v termux-job-scheduler >/dev/null 2>&1; then
		termux-job-scheduler -s "$PACK_DIR/scripts/auto-update.sh" \
			--job-id 4242 --period-ms 21600000 --network unmetered \
			--battery-not-low true --persisted true 2>&1 \
			&& say "scheduled auto-update (every 6h via termux-job-scheduler, job 4242)" \
			|| say "auto-update schedule skipped (termux-job-scheduler error)"
	else
		say "auto-update schedule skipped (termux-job-scheduler not found)"
	fi
fi

exit 0
