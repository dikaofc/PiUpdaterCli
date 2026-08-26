#!/data/data/com.termux/files/usr/bin/bash
#​@dikaacode​
# build.sh — assemble the pi coding agent upgrade pack into PiUpdaterCli/.
# Copies verified live sources, prints manifest + sha256 sums. Idempotent.
set -euo pipefail

PACK="$(cd "$(dirname "$0")" && pwd)"
HOME_ROOT="$HOME"

declare -a SRC DST
S+=("$HOME_ROOT/.local/bin/pi"                                "$PACK/scripts/pi.termux.example")
S+=("$HOME_ROOT/.local/bin/pi-agent"                          "$PACK/scripts/pi-agent.local")
S+=("$HOME_ROOT/claude-skills-and-plugins/bin/pi-agent"       "$PACK/scripts/pi-agent.csp")
S+=("$HOME_ROOT/claude-skills-and-plugins/bin/sync-skills-to-pi.sh" "$PACK/scripts/sync-skills-to-pi.sh")
S+=("$HOME_ROOT/claude-skills-and-plugins/bin/spawn-agent.sh" "$PACK/scripts/spawn-agent.sh")
S+=("$HOME_ROOT/claude-skills-and-plugins/bin/cap"            "$PACK/scripts/cap")
S+=("$HOME_ROOT/.pi/agent/extensions/agent-boost.ts"          "$PACK/agent/extensions/agent-boost.ts")
S+=("$HOME_ROOT/.pi/agent/skills/super-fast/SKILL.md"         "$PACK/agent/skills/super-fast/SKILL.md")
S+=("$HOME_ROOT/.pi/agent/skills/agent-efficiency/SKILL.md"   "$PACK/agent/skills/agent-efficiency/SKILL.md")
S+=("$HOME_ROOT/.pi/agent/themes/terminal-boost.json"         "$PACK/agent/themes/terminal-boost.json")
S+=("$HOME_ROOT/.pi/agent/settings.json"                      "$PACK/agent/settings.json")

fail=0
for ((i = 0; i < ${#S[@]}; i += 2)); do
  [[ -f "${S[i]}" ]] || { echo "MISSING SOURCE: ${S[i]}"; fail=1; }
done
[[ $fail -eq 1 ]] && exit 1

for ((i = 0; i < ${#S[@]}; i += 2)); do
  dst="${S[i + 1]}"
  mkdir -p "$(dirname "$dst")"
  cp -f "${S[i]}" "$dst"
  chmod +x "$dst" 2>/dev/null || true
done

echo "=== PACK MANIFEST ($(date -u +%FT%TZ)) ==="
printf '%-46s %8s  %s\n' "FILE" "SIZE" "SHA256"
for ((i = 1; i < ${#S[@]}; i += 2)); do
  f="${S[i]}"
  printf '%-46s %8s  %s\n' "${f#"$PACK"/}" "$(wc -c <"$f")" "$(sha256sum "$f" | cut -d' ' -f1)"
done

printf '%-46s %8s  %s\n' "SCRIPTS.md" "$(wc -c <"$PACK/SCRIPTS.md")" "$(sha256sum "$PACK/SCRIPTS.md" | cut -d' ' -f1)"
printf '%-46s %8s  %s\n' "COMPARE.md" "$(wc -c <"$PACK/COMPARE.md")" "$(sha256sum "$PACK/COMPARE.md" | cut -d' ' -f1)"

: > "$PACK/checksums.sha256"
for ((i = 1; i < ${#S[@]}; i += 2)); do
  f="${S[i]}"
  (cd "$PACK" && sha256sum "${f#"$PACK"/}") >> "$PACK/checksums.sha256"
done
(cd "$PACK" && sha256sum SCRIPTS.md COMPARE.md) >> "$PACK/checksums.sha256"

echo "=== DONE: $(( ${#S[@]} / 2 )) files copied, checksums.sha256 written ==="
