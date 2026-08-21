# fuzz-testing — Reference

## Commands

| Command | Description |
|---|---|
| `fuzz <cmd...> [opts]` | fuzz the target command with generated stdin inputs |
| `corpus [DIR]` | list saved corpus/crash files |

## Input generators

Inputs are generated deterministically (seed 1337) across 4 modes:

1. random bytes (0–512 bytes)
2. ASCII printable soup (0–400 chars)
3. structured-ish payloads: `{`, `(`, `[`, quotes, `0x`, `null`, `true`, `NaN`, `\u0000`, signs
4. long repeated strings (up to 20 KB) — good for buffer/stack issues

## Crash criteria

- exit code not in `{0, 1, 2, 126, 127}` (126/127 = not executable/not found)
- timeout exceeded

## Examples

```bash
# fuzz a parser binary
fuzz-testing.sh fuzz ./json_parser --iterations 500 --timeout 3

# replay the smallest crash input manually
fuzz-testing.sh corpus fuzz_out
./json_parser < fuzz_out/crashes/crash_00042_rc139
```

## Output layout

```
fuzz_out/
  corpus/    seed inputs (every 10th case)
  crashes/   crashing or timing-out inputs, replayable
```

## Notes

- Target must read input from **stdin**.
- `--timeout` guards against infinite loops in the target.
