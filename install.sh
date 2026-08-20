#!/bin/sh
# PiUpdaterCli -- universal installer for the pi coding agent upgrade pack.
# POSIX sh; runs on Termux (Android), Linux, macOS.
#
# WHY: the npm-installed "pi" binary shebang is `#!/usr/bin/env node`, which
# fails on Termux -- the bionic kernel cannot follow the /usr/bin/env symlink
# interpreter. Fix: a wrapper at ~/.local/bin/pi (first in PATH via
# ~/.bashrc) running node with the absolute path to dist/cli.js. Same wrapper
# makes the pack work on Linux/macOS, where the npm root differs.

set -e
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
  - copies agent-boost.ts, super-fast skill, terminal-boost theme
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
		*) echo "unknown option: $arg" >&2; usage >&2; exit 2 ;;
	esac
done

say() { printf '%s\n' "$*"; }

# PACK_DIR: this pack's dir. Follow symlink if $0 is one (macOS installs
# often symlink the script into the repo).
SELF=$0
if command -v readlink >/dev/null 2>&1 && [ -L "$0" ]; then
	SELF=$(readlink "$0" 2>/dev/null) || SELF=$0
fi
PACK_DIR=$(cd "$(dirname "$SELF")" && pwd)

# ---------- environment detection ----------
# TERMUX_VERSION is set on Termux and only there: canonical platform switch.
[ -n "$TERMUX_VERSION" ] && PLATFORM=termux || PLATFORM=$(uname -s 2>/dev/null || printf unknown)

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

echo "Detected: node=$NODE"
echo "          shell=$SHELL_BIN"
echo "          home=$HOME_DET"
echo "          package=$PKG_DIR"

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
	say "installed $3 -> $2"
}

# ---------- wrapper ----------
# Generated, not copied from bin/pi (which hardcodes Termux paths and would
# be wrong on Linux/macOS). WHY direct exec: the package shebang
# (\`#!/usr/bin/env node\`) fails on Termux's kernel, which cannot follow
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

# ---------- PATH setup ----------
for rc in "$HOME_DET/.bashrc" "$HOME_DET/.profile"; do
	if [ -f "$rc" ] && grep -Fq ".local/bin" "$rc" 2>/dev/null; then
		continue
	fi
	if [ "$DRY_RUN" = 1 ]; then say "[dry-run] append PATH export to $rc"; continue; fi
	printf '\n# added by PiUpdaterCli\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$rc"
	say "PATH configured in $rc"
done

# ---------- agent extension/skill/theme ----------
install_copy "$PACK_DIR/agent/extensions/agent-boost.ts" "$AGENT_DIR/extensions/agent-boost.ts" "extension agent-boost.ts"
install_copy "$PACK_DIR/agent/skills/super-fast/SKILL.md" "$AGENT_DIR/skills/super-fast/SKILL.md" "skill super-fast"
install_copy "$PACK_DIR/agent/themes/terminal-boost.json" "$AGENT_DIR/themes/terminal-boost.json" "theme terminal-boost"

# ---------- settings.json merge ----------
# Merge, never clobber: add missing pack keys, preserve user theme/model.
# Done in node (guaranteed present), not sed/grep JSON surgery.
DEFAULT_SETTINGS='{
  "lastChangelogVersion": "0.84.2",
  "theme": "dark",
  "enableSkillCommands": true,
  "skills": [
    "~/.pi/skills",
    "~/.pi/agent/skills",
    "~/.claude/skills"
  ],
  "extensions": [
    "~/.pi/agent/extensions"
  ]
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
			for (const k of ["skills", "extensions"]) {
				if (Array.isArray(def[k])) {
					const s = new Set(Array.isArray(u[k]) ? u[k] : []);
					for (const x of def[k]) s.add(x);
					u[k] = [...s];
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

# ---------- summary ----------
printf '\n=== PiUpdaterCli install complete ===\nwrapper:  %s\next:      %s\nskill:    %s\ntheme:    %s\nsettings: %s\n\nverify with: %s --version\n' \
	"$WRAPPER" "$AGENT_DIR/extensions/agent-boost.ts" \
	"$AGENT_DIR/skills/super-fast/SKILL.md" "$AGENT_DIR/themes/terminal-boost.json" "$SETTINGS" "$WRAPPER"
[ "$DRY_RUN" = 1 ] && echo "(dry-run: nothing was written)"
exit 0