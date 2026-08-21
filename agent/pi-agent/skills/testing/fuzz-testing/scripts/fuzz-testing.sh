#!/usr/bin/env bash
# Fuzz Testing — generate random inputs and detect crashes/hangs
# Source: https://owasp.org/www-community/Fuzzing
set -euo pipefail

SCRIPT_NAME="fuzz-testing.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} fuzz <command...> [--iterations N] [--timeout S] [--out DIR]
       ${SCRIPT_NAME} corpus [DIR]
Fuzz a target program by feeding it generated random inputs on stdin
and watching for non-zero exits, timeouts, or crashes. No external
deps: uses python3 for input generation.

Example:
  ${SCRIPT_NAME} fuzz ./my_parser --iterations 200 --timeout 2

Options:
  --iterations N  number of test cases (default 100)
  --timeout S     per-case timeout seconds (default 2)
  --out DIR       save corpus + crashes under DIR (default ./fuzz_out)
  -h | --help     show this help
EOF
}

[ $# -lt 2 ] && { usage; exit 1; }

CMD=""
TARGET=()
ITERS=100
TIMEOUT=2
OUT_DIR="fuzz_out"
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    fuzz) CMD="fuzz"; shift;;
    corpus) CMD="corpus"; shift;;
    --iterations) ITERS="$2"; shift 2;;
    --timeout) TIMEOUT="$2"; shift 2;;
    --out) OUT_DIR="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) TARGET+=("$1"); shift;;
  esac
done
[ -z "$CMD" ] && { usage; exit 1; }

case "$CMD" in
  corpus)
    D="${TARGET[0]:-fuzz_out}"
    [ -d "$D" ] || { echo "no corpus dir: $D" >&2; exit 1; }
    echo "$(ls "$D" | wc -l) files in $D:"
    ls -la "$D" | head -20
    ;;
  fuzz)
    [ ${#TARGET[@]} -eq 0 ] && { echo "missing target command" >&2; exit 2; }
    mkdir -p "$OUT_DIR"
    export FUZZ_ITERS="$ITERS" FUZZ_TIMEOUT="$TIMEOUT" FUZZ_DIR="$OUT_DIR"
    # target serialized for python
    TARGET_STR=$(printf '%s ' "${TARGET[@]}")
    export FUZZ_TARGET="$TARGET_STR"
    python3 - <<'PYEOF'
import os, random, string, subprocess, sys, time

iters = int(os.environ["FUZZ_ITERS"])
timeout = float(os.environ["FUZZ_TIMEOUT"])
outdir = os.environ["FUZZ_DIR"]
target = os.environ["FUZZ_TARGET"].split()

rng = random.Random(1337)
corpus_dir = os.path.join(outdir, "corpus")
crashes_dir = os.path.join(outdir, "crashes")
os.makedirs(corpus_dir, exist_ok=True)
os.makedirs(crashes_dir, exist_ok=True)

def gen_input(i):
    kind = i % 4
    if kind == 0:  # random bytes
        return bytes(rng.randrange(256) for _ in range(rng.randrange(0, 512)))
    if kind == 1:  # ascii soup
        return "".join(rng.choice(string.printable) for _ in range(rng.randrange(0, 400))).encode()
    if kind == 2:  # structured-ish: numbers, quotes, brackets
        parts = [rng.choice(["", "{", "(", "[", "\"", "'", "0x", "-", "+", "null", "true", "NaN", "\\u0000"]) for _ in range(rng.randrange(1, 30))]
        return "".join(parts).encode()
    # long strings / huge values
    return (rng.choice(["A", "0", " ", "\t", "\n", "\\"]) * rng.randrange(0, 20000)).encode()

crashes = 0
t0 = time.time()
for i in range(iters):
    data = gen_input(i)
    # save seed to corpus occasionally
    if i % 10 == 0:
        with open(os.path.join(corpus_dir, f"seed_{i:05d}.bin"), "wb") as f:
            f.write(data)
    try:
        p = subprocess.run(target, input=data, capture_output=True, timeout=timeout)
        if p.returncode != 0 and p.returncode not in (1, 2, 126, 127):
            crashes += 1
            name = f"crash_{i:05d}_rc{p.returncode}"
            with open(os.path.join(crashes_dir, name), "wb") as f:
                f.write(data)
            print(f"  crash #{crashes}: rc={p.returncode} input->{os.path.join(crashes_dir, name)} ({len(data)} bytes)")
    except subprocess.TimeoutExpired:
        crashes += 1
        name = f"timeout_{i:05d}"
        with open(os.path.join(crashes_dir, name), "wb") as f:
            f.write(data)
        print(f"  timeout #{crashes}: input->{os.path.join(crashes_dir, name)} ({len(data)} bytes)")

elapsed = time.time() - t0
print(f"done: {iters} inputs in {elapsed:.1f}s, {crashes} crash/timeout(s)")
print(f"corpus: {outdir}/corpus/  crashes: {outdir}/crashes/")
PYEOF
    ;;
esac