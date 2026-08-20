#!/bin/sh
# PiUpdaterCli -- reverse installer: put everything back.
# POSIX sh. Termux / Linux / macOS.
#
# Reverses install.sh:
#   1. move pi-clipboard-backup/* and pi-photon-backup/* back into the
#      package's node_modules
#   2. restore *.bak.<ts> files over the files install.sh touched
#   3. unlink ~/.local/bin/pi (only the wrapper install.sh created)

set -e

DRY_RUN=0

usage() {
	cat <<'EOF'
Usage: restore.sh [OPTIONS]

Options:
  -h, --help      Show this help and exit.
  -d, --dry-run   Print what would be done without changing anything.

Restores backups left by install.sh:
  - moves pi-clipboard-backup/* and pi-photon-backup/* back into node_modules
  - restores *.bak.<ts> files (most recent wins)
  - removes ~/.local/bin/pi and the PATH lines install.sh added
EOF
}

for arg in "$@"; do
	case "$arg" in
		-h|--help) usage; exit 0 ;;
		-d|--dry-run) DRY_RUN=1 ;;
		*) echo "unknown option: $arg" >&2; usage >&2; exit 2 ;;
	esac
done

say() { printf '%s\n' "$*"; }

# ---------- environment detection (mirrors install.sh) ----------
if [ -n "$TERMUX_VERSION" ]; then
	PLATFORM=termux
else
	PLATFORM=$(uname -s 2>/dev/null || printf unknown)
fi

home_detect() {
	if [ "$PLATFORM" = termux ] && [ -d /data/data/com.termux/files/home ]; then
		printf '%s\n' /data/data/com.termux/files/home; return 0
	fi
	if [ -n "$HOME" ]; then
		printf '%s\n' "$HOME"; return 0
	fi
	if command -v getent >/dev/null 2>&1; then
		getent passwd "$(id -u 2>/dev/null)" 2>/dev/null | cut -d: -f6 | grep . && return 0
	fi
	printf '%s\n' /root
}
HOME_DET=$(home_detect)

# Locate the package the same way install.sh did.
PKG_ROOT=
if command -v npm >/dev/null 2>&1; then
	PKG_ROOT=$(npm root -g 2>/dev/null || true)
fi
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
PKG_DIR=
if CLI_JS=$(find_cli_js 2>/dev/null); then
	PKG_DIR=${CLI_JS%/dist/cli.js}
fi

CMDIR="$HOME_DET/pi-clipboard-backup"
PHDIR="$HOME_DET/pi-photon-backup"
WRAPPER="$HOME_DET/.local/bin/pi"

echo "Detected: home=$HOME_DET"
[ -n "$PKG_DIR" ] && echo "          package=$PKG_DIR"

# ---------- 1. restore native deps ----------
restore_dir() {
	# $1=backup dir $2=target parent (node_modules)
	[ -d "$1" ] || { say "no backup dir $1 -- nothing to restore"; return 0; }
	[ -n "$2" ] || { say "warning: package not found -- cannot restore into $1"; return 0; }
	found=0
	for item in "$1"/*; do
		[ -e "$item" ] || continue
		base=$(basename "$item")
		target="$2/$base"
		if [ -e "$target" ]; then
			say "skip $base (target already exists in $2)"
			continue
		fi
		found=1
		if [ "$DRY_RUN" = 1 ]; then
			say "[dry-run] move $item -> $target"
		else
			mv "$item" "$target"
			say "restored $base -> $target"
		fi
	done
	if [ "$found" = 0 ] && [ "$DRY_RUN" = 0 ]; then
		say "($1 is empty)"
	fi
}
restore_dir "$CMDIR" "$PKG_DIR/node_modules/@mariozechner"
restore_dir "$PHDIR" "$PKG_DIR/node_modules/@silvia-odwyer"

# ---------- 2. restore .bak files ----------
# Multiple backups of the same target may exist; the newest (lexicographic
# ts YYYYMMDDHHMMSS, sortable) wins and superseded ones are dropped.
restore_baks() {
	# $1=directory to scan
	[ -d "$1" ] || return 0
	seen=0
	for bak in "$1"/*.bak.*; do
		[ -f "$bak" ] || continue
		seen=1
		newest=1
		for other in "$1"/*.bak.*; do
			[ -f "$other" ] || continue
			[ "${other%.bak.*}" = "${bak%.bak.*}" ] || continue
			[ "$other" = "$bak" ] && continue
			if [ "$(printf '%s\n' "$other" "$bak" | sort | tail -1)" = "$other" ]; then
				newest=0
				break
			fi
		done
		[ "$newest" = 1 ] || continue
		target=${bak%.bak.*}
		# drop superseded backups of the same target
		for other in "$1"/*.bak.*; do
			[ -f "$other" ] || continue
			[ "${other%.bak.*}" = "$target" ] && [ "$other" != "$bak" ] && rm -f "$other"
		done
		if [ "$DRY_RUN" = 1 ]; then
			say "[dry-run] restore $bak -> $target"
		else
			mv "$bak" "$target"
			say "restored $target (from backup)"
		fi
	done
	if [ "$seen" = 0 ]; then
		say "no .bak files in $1"
	fi
}

# Only restore baks for the files install.sh actually touches.
restore_baks "$HOME_DET/.local/bin"
restore_baks "$HOME_DET/.pi/agent/extensions"
restore_baks "$HOME_DET/.pi/agent/skills/super-fast"
restore_baks "$HOME_DET/.pi/agent/themes"
restore_baks "$HOME_DET/.pi/agent"

# ---------- 3. remove wrapper + PATH lines ----------
if [ "$DRY_RUN" = 1 ]; then
	say "[dry-run] rm $WRAPPER"
else
	rm -f "$WRAPPER"
	say "removed $WRAPPER"
fi

for rc in "$HOME_DET/.bashrc" "$HOME_DET/.profile"; do
	[ -f "$rc" ] || continue
	if [ "$DRY_RUN" = 1 ]; then
		say "[dry-run] remove PiUpdaterCli PATH lines from $rc"
	else
		grep -v '^# added by PiUpdaterCli$' "$rc" | grep -v '^export PATH="$HOME/.local/bin:$PATH"$' > "$rc.tmp" || true
		mv "$rc.tmp" "$rc"
		say "removed PiUpdaterCli PATH lines from $rc"
	fi
done

echo
echo "=== PiUpdaterCli restore complete ==="
echo "Run install.sh again to re-apply the pack."