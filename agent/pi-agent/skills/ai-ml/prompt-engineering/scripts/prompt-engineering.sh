#!/usr/bin/env bash
# Prompt Engineering — chain-of-thought, few-shot templates, eval prompts
# Source: https://docs.anthropic.com/en/docs/advanced-prompting
set -euo pipefail

SCRIPT_NAME="prompt-engineering.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} <template-file|text> [--vars k=v ...] [--fewshot examples.json] [--cot] [--role TEXT] [--out <file>]
Render a prompt template with variables, optionally adding
chain-of-thought instructions and few-shot examples.

Template placeholders: {{var}} are substituted from --vars.
Few-shot format:       [{"input": "...", "output": "..."}]

Options:
  --vars k=v         set template variables (repeatable)
  --fewshot FILE     JSON array of example {input, output} pairs
  --cot              append chain-of-thought reasoning instructions
  --role TEXT        prepend a system-style role line
  --out FILE         write rendered prompt to FILE
  -h | --help        show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

TEMPLATE=""
VARS=()
FEWSHOT=""
COT=0
ROLE=""
OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    --vars) VARS+=("$2"); shift 2;;
    --fewshot) FEWSHOT="$2"; shift 2;;
    --cot) COT=1; shift;;
    --role) ROLE="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) TEMPLATE="${TEMPLATE:+$TEMPLATE }$1"; shift;;
  esac
done

[ -z "$TEMPLATE" ] && { usage; exit 1; }

# Read template from file or treat args as inline text
if [ -f "$TEMPLATE" ]; then
  BODY=$(cat "$TEMPLATE")
else
  BODY="$TEMPLATE"
fi

# Substitute {{var}} placeholders
for kv in "${VARS[@]}"; do
  K="${kv%%=*}"
  V="${kv#*=}"
  BODY=$(printf '%s' "$BODY" | python3 -c "
import sys
t = sys.stdin.read()
print(t.replace('{{${K}}}', '''$V'''))" 2>/dev/null || printf '%s' "$BODY")
done

# Warn about unfilled placeholders
if printf '%s' "$BODY" | grep -q '{{'; then
  echo "Warning: unfilled placeholders remain: $(printf '%s' "$BODY" | grep -o '{{[^}]*}}' | sort -u | tr '\n' ' ')" >&2
fi

OUTPUT=""
[ -n "$ROLE" ] && OUTPUT+="[ROLE] $ROLE

"
OUTPUT+="$BODY"

if [ -n "$FEWSHOT" ]; then
  [ -f "$FEWSHOT" ] || { echo "few-shot file not found: $FEWSHOT" >&2; exit 1; }
  OUTPUT+="

[EXAMPLES]
"
  OUTPUT+=$(jq -r '.[] | "Input: \(.input)\nOutput: \(.output)\n---"' "$FEWSHOT")
  OUTPUT+="
"
fi

if [ "$COT" = "1" ]; then
  OUTPUT+="

[REASONING INSTRUCTIONS]
Think through the problem step by step before giving the final answer. Show your chain of thought briefly, then conclude with a clearly labeled final answer.
"
fi

if [ -n "$OUT" ]; then
  printf '%s\n' "$OUTPUT" > "$OUT"
  echo "Saved rendered prompt (${#OUTPUT} chars) to $OUT"
else
  printf '%s\n' "$OUTPUT"
fi
