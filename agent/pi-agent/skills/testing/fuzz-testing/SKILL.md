---
name: fuzz-testing
description: Generate random inputs for any command and detect crashes, timeouts, and non-zero exits.
license: MIT
compatibility: "POSIX shell + python3. No external fuzzer required."
source: https://owasp.org/www-community/Fuzzing
metadata:
  category: testing
  language: bash
  tags: [fuzzing, security, testing]
---
# Fuzz Testing

Feed a target program thousands of generated inputs on stdin and
watch for crashes, timeouts, and unexpected exit codes. Built-in
input generators produce random bytes, ASCII soup, structured-ish
payloads, and long strings — no external fuzzer needed.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

No installation. Uses `python3` for input generation and
`subprocess` for execution. Targets read input from stdin.

## Usage

```bash
fuzz-testing.sh fuzz ./my_parser --iterations 200 --timeout 2
fuzz-testing.sh corpus fuzz_out
```

## Options

- `--iterations N` — number of test cases (default 100)
- `--timeout S` — per-case timeout in seconds (default 2)
- `--out DIR` — output directory (default `fuzz_out/`)

## Output

- `fuzz_out/corpus/` — seed inputs (saved every 10 cases)
- `fuzz_out/crashes/` — every input that crashed or timed out,
  ready for replay/debugging
