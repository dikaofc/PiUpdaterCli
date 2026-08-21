#!/usr/bin/env bash
# LLM Toolkit — call LLM providers, embed text, token counting, costs
# Sources: https://platform.openai.com/docs/api-reference https://docs.anthropic.com/
set -euo pipefail

SCRIPT_NAME="llm-toolkit.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} chat <prompt> [--model NAME] [--system TEXT] [--out <file>]
       ${SCRIPT_NAME} embed <text> [--out <file>]
       ${SCRIPT_NAME} tokens <text>
       ${SCRIPT_NAME} cost <text> [--rate DOLLARS_PER_1K]
Call OpenAI (default) or Anthropic chat APIs; embed with OpenAI embeddings.

Environment:
  OPENAI_API_KEY      required for openai (default provider)
  ANTHROPIC_API_KEY   required when --provider anthropic
  OPENAI_BASE_URL     override API base (default https://api.openai.com/v1)

Options:
  --provider openai|anthropic   (default openai)
  --model NAME                  override default model
  --system TEXT                 system prompt for chat
  --rate R                      cost per 1K tokens for estimates (default 0.002)
  --out FILE                    write JSON to FILE
  -h | --help                   show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
TEXT=""
PROVIDER="openai"
MODEL=""
SYSTEM=""
RATE=0.002
OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    chat|embed|tokens|cost) CMD="$1"; shift;;
    --provider) PROVIDER="$2"; shift 2;;
    --model) MODEL="$2"; shift 2;;
    --system) SYSTEM="$2"; shift 2;;
    --rate) RATE="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) TEXT="${TEXT:+$TEXT }$1"; shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }
[ -z "$TEXT" ] && { echo "missing input text" >&2; exit 2; }

count_tokens() {
  # Approximation: ~4 chars/token for English; report both
  python3 -c "
import sys
t = sys.argv[1]
print(len(t.split()), round(len(t)/4))
" "$1"
}

emit() {
  if [ -n "$OUT" ]; then
    echo "$1" > "$OUT"
    echo "Saved to $OUT"
  else
    echo "$1"
  fi
}

case "$CMD" in
  tokens)
    read -r WORDS CHARS4 <<< "$(count_tokens "$TEXT")"
    echo "words=$WORDS  approx_tokens(4 chars)=$CHARS4"
    ;;
  cost)
    read -r WORDS CHARS4 <<< "$(count_tokens "$TEXT")"
    python3 -c "
import sys
tokens, rate = int(sys.argv[1]), float(sys.argv[2])
print(f'approx tokens: {tokens}')
print(f'estimated cost: \${tokens/1000*rate:.4f} @ \${rate}/1K tokens')
" "$CHARS4" "$RATE"
    ;;
  embed)
    : "${OPENAI_API_KEY:?OPENAI_API_KEY not set}"
    BASE="${OPENAI_BASE_URL:-https://api.openai.com/v1}"
    RESP=$(curl -sS --max-time 60 "$BASE/embeddings" \
      -H "Authorization: Bearer ${OPENAI_API_KEY}" \
      -H "Content-Type: application/json" \
      -d "$(python3 -c 'import json,sys; print(json.dumps({"model":"text-embedding-3-small","input":sys.argv[1]}))' "$TEXT")")
    echo "$RESP" | jq -e '.error' >/dev/null 2>&1 && { echo "API error: $(echo "$RESP" | jq -r '.error.message')" >&2; exit 1; }
    emit "$(echo "$RESP" | jq '{model, dimensions: (.data[0].embedding | length), embedding: .data[0].embedding}')"
    ;;
  chat)
    if [ "$PROVIDER" = "anthropic" ]; then
      : "${ANTHROPIC_API_KEY:?ANTHROPIC_API_KEY not set}"
      MODEL="${MODEL:-claude-3-5-haiku-latest}"
      RESP=$(curl -sS --max-time 120 "https://api.anthropic.com/v1/messages" \
        -H "x-api-key: ${ANTHROPIC_API_KEY}" \
        -H "anthropic-version: 2023-06-01" \
        -H "Content-Type: application/json" \
        -d "$(python3 -c '
import json, sys
body = {"model": sys.argv[1], "max_tokens": 1024, "messages": [{"role": "user", "content": sys.argv[2]}]}
if sys.argv[3]: body["system"] = sys.argv[3]
print(json.dumps(body))' "$MODEL" "$TEXT" "$SYSTEM")")
      echo "$RESP" | jq -e '.error' >/dev/null 2>&1 && { echo "API error: $(echo "$RESP" | jq -r '.error.message')" >&2; exit 1; }
      emit "$(echo "$RESP" | jq '{model, text: (.content[]? | select(.type=="text") | .text), usage}')"
    else
      : "${OPENAI_API_KEY:?OPENAI_API_KEY not set}"
      BASE="${OPENAI_BASE_URL:-https://api.openai.com/v1}"
      MODEL="${MODEL:-gpt-4o-mini}"
      RESP=$(curl -sS --max-time 120 "$BASE/chat/completions" \
        -H "Authorization: Bearer ${OPENAI_API_KEY}" \
        -H "Content-Type: application/json" \
        -d "$(python3 -c '
import json, sys
msgs = []
if sys.argv[3]: msgs.append({"role": "system", "content": sys.argv[3]})
msgs.append({"role": "user", "content": sys.argv[2]})
print(json.dumps({"model": sys.argv[1], "messages": msgs}))' "$MODEL" "$TEXT" "$SYSTEM")")
      echo "$RESP" | jq -e '.error' >/dev/null 2>&1 && { echo "API error: $(echo "$RESP" | jq -r '.error.message')" >&2; exit 1; }
      emit "$(echo "$RESP" | jq '{model, text: .choices[0].message.content, usage}')"
    fi
    ;;
esac
