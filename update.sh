#!/bin/sh
# update.sh — keep the pi coding agent + this upgrade pack in sync.
#
# WHAT IT DOES (zero-config, idempotent):
#   1. Reads the installed pi version and the latest npm version.
#   2. If a newer pi is published, runs `npm update` for the package.
#   3. Re-runs install.sh, which re-applies the dist patches and
#      re-merges our extension/theme/settings on top of the new pi.
#   4. If no update is available, still re-syncs our pack files so local
#      mods are never left stale after a manual change.
#
# WHY: npm reinstall wipes node_modules (losing dist patches) and a pi
# upgrade can ship a new interactive-mode.js that our patch must follow.
# Running this after any pi release keeps the pack working.
#
# Usage: ./update.sh [-f|--force]   (force = update even if versions match)

set -e
FORCE=0
for arg in "$@"; do
	case "$arg" in
		-h|--help) sed -n '2,20p' "$0"; exit 0 ;;
		-f|--force) FORCE=1 ;;
		*) echo "unknown option: $arg" >&2; exit 2 ;;
	esac
done

say() { printf '%s\n' "$*"; }
PACK_DIR=$(cd "$(dirname "$0")" && pwd)

# ---------- locate node + package ----------
NODE=$(command -v node || true)
[ -n "$NODE" ] || { echo "ERROR: node not found on PATH" >&2; exit 1; }
NPM=$(command -v npm || true)
[ -n "$NPM" ] || { echo "ERROR: npm not found on PATH" >&2; exit 1; }

PKG="@earendil-works/pi-coding-agent"
CLI_JS=$("$NODE" -e 'try{console.log(require.resolve(process.argv[1]+"/dist/cli.js"))}catch(e){}' "$PKG" 2>/dev/null || true)
[ -n "$CLI_JS" ] || CLI_JS=/data/data/com.termux/files/usr/lib/node_modules/$PKG/dist/cli.js
[ -f "$CLI_JS" ] || { echo "ERROR: $PKG not installed" >&2; exit 1; }

# ---------- version compare ----------
cur=$("$NODE" -e 'const fs=require("fs"),path=require("path");try{const root=path.dirname(path.dirname(process.argv[1]));const v=JSON.parse(fs.readFileSync(path.join(root,"package.json"),"utf8")).version;console.log(v)}catch(e){}' "$CLI_JS" 2>/dev/null || true)
latest=$("$NPM" view "$PKG" version 2>/dev/null || true)
say "installed pi: ${cur:-unknown}"
say "latest pi:    ${latest:-unknown}"

needs_update=0
if [ "$FORCE" = 1 ]; then
	needs_update=1
elif [ -z "$latest" ]; then
	say "(could not reach npm — skipping version check, re-syncing pack only)"
elif [ "$cur" != "$latest" ]; then
	needs_update=1
fi

if [ "$needs_update" = 1 ]; then
	say "updating $PKG -> $latest ..."
	# ALWAYS run npm from outside node_modules. Running it inside the package
	# dir (e.g. node_modules/@earendil-works/pi-coding-agent) makes npm prune
	# the ENTIRE global node_modules — wiping npm and pi themselves. Use -g and
	# run from PACK_DIR so the cwd is never inside node_modules.
	( cd "$PACK_DIR" && "$NPM" install -g "$PKG@latest" ) || {
		echo "WARN: npm install failed — continuing to re-sync pack files" >&2
	}
else
	say "pi is up to date."
fi

# ---------- pull latest pack from GitHub (non-fatal if offline) ----------
# WHY: install.sh only copies local repo files. Without this, a fix pushed
# to GitHub (e.g. the boost status-bar fix) never reaches this machine until
# auto-update runs. --ff-only avoids clobbering local edits on a diverged tree.
if [ -d "$PACK_DIR/.git" ]; then
	( cd "$PACK_DIR" && git pull --ff-only 2>/dev/null ) \
		&& say "pulled latest pack from GitHub" \
		|| say "(git pull skipped — offline or diverged; using local pack)"
fi

# ---------- re-sync our pack mods (always) ----------
say "re-syncing upgrade pack ..."
"$PACK_DIR/install.sh"

say ""
say "=== update complete ==="
"$NODE" -e 'const fs=require("fs"),path=require("path");try{const root=path.dirname(path.dirname(process.argv[1]));const v=JSON.parse(fs.readFileSync(path.join(root,"package.json"),"utf8")).version;console.log("pi now:",v)}catch(e){}' "$CLI_JS" 2>/dev/null || true
