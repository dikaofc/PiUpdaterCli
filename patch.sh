#!/bin/sh
# patch.sh — re-apply the dist patches after an npm update/reinstall
# of @earendil-works/pi-coding-agent. Idempotent: backs up once, then
# overwrites with the patched copies from patches/.
# WHY: npm reinstall wipes node_modules, losing the mouse-click patch.
# Run: ./patch.sh   (needs node_modules path detection like install.sh)

set -e

PKG_ROOT=
if command -v npm >/dev/null 2>&1; then
	PKG_ROOT=$(npm root -g 2>/dev/null || true)
fi
PACK_DIR=$(cd "$(dirname "$0")" && pwd)

find_cli_js() {
	for c in \
		"$PKG_ROOT/@earendil-works/pi-coding-agent/dist/cli.js" \
		/data/data/com.termux/files/usr/lib/node_modules/@earendil-works/pi-coding-agent/dist/cli.js \
		/usr/lib/node_modules/@earendil-works/pi-coding-agent/dist/cli.js \
		/usr/local/lib/node_modules/@earendil-works/pi-coding-agent/dist/cli.js
	do
		[ -f "$c" ] && { printf '%s\n' "$c"; return 0; }
	done
	return 1
}
CLI_JS=$(find_cli_js) || { echo "ERROR: package not found" >&2; exit 1; }
PKG_DIR=${CLI_JS%/dist/cli.js}

TS=$(date +%Y%m%d%H%M%S 2>/dev/null || printf 1)
apply() {
	# $1=patched-file-in-pack  $2=target
	target="$PKG_DIR/$2"
	[ -f "$target" ] || { echo "skip $2 (not found at $target)"; return 0; }
	if [ ! -e "$target.bak.pre-pi" ]; then
		cp "$target" "$target.bak.pre-pi.$TS"
		echo "backed up $2 -> .bak.pre-pi.$TS"
	fi
	cp "$PACK_DIR/patches/$1" "$target"
	echo "patched $2"
}

apply pi-tui.tui-alt-screen.mouse.js node_modules/@earendil-works/pi-tui/dist/tui-alt-screen.js
apply interactive-mode.mouse.js modes/interactive/interactive-mode.js

echo
echo "=== patches applied ==="
echo "To roll back: cp the .bak.pre-pi.* over the patched file, or reinstall the package."