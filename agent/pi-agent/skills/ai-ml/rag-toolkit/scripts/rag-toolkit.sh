#!/usr/bin/env bash
# RAG Toolkit — chunking, embeddings, vector search, citation grounding
# Source: https://python.langchain.com/docs/integrations/vectorstores
set -euo pipefail

SCRIPT_NAME="rag-toolkit.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} chunk <file> [--size N] [--overlap M] [--out <file>]
       ${SCRIPT_NAME} embed <text> [--out <file>]          # OpenAI embeddings
       ${SCRIPT_NAME} search <query> <index.json> [--top N] [--out <file>]
       ${SCRIPT_NAME} ground <query> <doc.txt> [--window N] [--out <file>]
Chunk documents, embed text (OpenAI), cosine-search an embedding index,
and ground answers by extracting the most relevant passage.

Index format (from 'embed' + 'chunk'): [{"id": "...", "text": "...", "embedding": [...]}]

Options:
  --size N       chunk size in words (default 200)
  --overlap M    chunk overlap in words (default 20)
  --top N        top-k results (default 5)
  --window N     context window in chars for grounding (default 1500)
  --out FILE     write JSON to FILE
  -h | --help    show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
INPUT=""
INPUT2=""
SIZE=200
OVERLAP=20
TOP=5
WINDOW=1500
OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    chunk|embed|search|ground) CMD="$1"; shift;;
    --size) SIZE="$2"; shift 2;;
    --overlap) OVERLAP="$2"; shift 2;;
    --top) TOP="$2"; shift 2;;
    --window) WINDOW="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) if [ -z "$INPUT" ]; then INPUT="$1"; else INPUT2="$1"; fi; shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }

emit() {
  if [ -n "$OUT" ]; then
    echo "$1" > "$OUT"
    echo "Saved to $OUT"
  else
    echo "$1"
  fi
}

case "$CMD" in
  chunk)
    [ -f "$INPUT" ] || { echo "file not found: $INPUT" >&2; exit 1; }
    python3 - "$INPUT" "$SIZE" "$OVERLAP" <<'PYEOF' > "${TMPDIR:-/tmp}/rag_chunks.json"
import json, re, sys

path, size, overlap = sys.argv[1], int(sys.argv[2]), int(sys.argv[3])
text = open(path, encoding="utf-8", errors="replace").read()
words = re.findall(r"\S+", text)
chunks, i = [], 0
step = size - overlap
while i < len(words):
    chunk = " ".join(words[i:i + size])
    if chunk:
        chunks.append({"id": f"chunk-{len(chunks)}", "text": chunk})
    i += step
print(json.dumps(chunks, indent=2))
PYEOF
    emit "$(jq -c '{n_chunks: length, size: '"$SIZE"', overlap: '"$OVERLAP"', chunks: .}' "${TMPDIR:-/tmp}/rag_chunks.json" | jq .)"
    rm -f "${TMPDIR:-/tmp}/rag_chunks.json"
    ;;
  embed)
    : "${OPENAI_API_KEY:?OPENAI_API_KEY not set}"
    BASE="${OPENAI_BASE_URL:-https://api.openai.com/v1}"
    RESP=$(curl -sS --max-time 60 "$BASE/embeddings" \
      -H "Authorization: Bearer ${OPENAI_API_KEY}" \
      -H "Content-Type: application/json" \
      -d "$(python3 -c 'import json,sys; print(json.dumps({"model":"text-embedding-3-small","input":sys.argv[1]}))' "$INPUT")")
    echo "$RESP" | jq -e '.error' >/dev/null 2>&1 && { echo "API error: $(echo "$RESP" | jq -r '.error.message')" >&2; exit 1; }
    emit "$(echo "$RESP" | jq '{embedding: .data[0].embedding, dimensions: (.data[0].embedding | length)}')"
    ;;
  search)
    [ -f "$INPUT2" ] || { echo "index file not found: $INPUT2" >&2; exit 1; }
    : "${OPENAI_API_KEY:?OPENAI_API_KEY not set}"
    BASE="${OPENAI_BASE_URL:-https://api.openai.com/v1}"
    QEMB=$(curl -sS --max-time 60 "$BASE/embeddings" \
      -H "Authorization: Bearer ${OPENAI_API_KEY}" \
      -H "Content-Type: application/json" \
      -d "$(python3 -c 'import json,sys; print(json.dumps({"model":"text-embedding-3-small","input":sys.argv[1]}))' "$INPUT")" | jq -c '.data[0].embedding')
    jq -n --argjson q "$QEMB" --slurpfile idx "$INPUT2" --argjson top "$TOP" '
      ($idx[0] | if type == "object" then [.[]] else . end) as $docs |
      [ $docs[] | . as $d |
        (([range(0; ($q | length))] | map(($q[.] * $d.embedding[.]) // 0) | add) / 
         ((($q | map(. * .) | add) | sqrt) * (($d.embedding | map(. * .) | add) | sqrt))) as $sim |
        {id: $d.id, text: $d.text, score: $sim} ] |
      sort_by(-.score) | .[:$top]' > "${TMPDIR:-/tmp}/rag_results.json"
    emit "$(jq '{query: "'"$INPUT"'", results: .}' "${TMPDIR:-/tmp}/rag_results.json")"
    rm -f "${TMPDIR:-/tmp}/rag_results.json"
    ;;
  ground)
    [ -f "$INPUT2" ] || { echo "document file not found: $INPUT2" >&2; exit 1; }
    python3 - "$INPUT" "$INPUT2" "$WINDOW" <<'PYEOF' > "${TMPDIR:-/tmp}/rag_ground.json"
import json, re, sys

query, doc_path, window = sys.argv[1], sys.argv[2], int(sys.argv[3])
text = open(doc_path, encoding="utf-8", errors="replace").read()
# score sentences by term overlap with query
terms = set(re.findall(r"[a-z0-9]+", query.lower()))
sentences = re.split(r"(?<=[.!?])\s+", text)
scored = []
for i, s in enumerate(sentences):
    st = set(re.findall(r"[a-z0-9]+", s.lower()))
    score = len(st & terms) / max(1, len(terms)) + (0.01 * len(st) / max(1, len(terms)))
    scored.append((score, i, s))
scored.sort(reverse=True, key=lambda x: x[0])
best = scored[0] if scored else (0, 0, "")
start = max(0, best[1])
passage = " ".join(sentences[start:start + 5])[:window]
print(json.dumps({"query": query, "passage": passage, "score": best[0],
                  "evidence_sentence": best[2], "n_sentences": len(sentences)}, indent=2))
PYEOF
    emit "$(cat "${TMPDIR:-/tmp}/rag_ground.json")"
    rm -f "${TMPDIR:-/tmp}/rag_ground.json"
    ;;
esac
