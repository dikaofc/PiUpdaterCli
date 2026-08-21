# typescript-toolkit — Reference

## Commands

| Command | Description |
|---|---|
| `syntax <file>` | `node --check` — fast syntax validation, no deps |
| `check <file\|dir>` | `tsc --noEmit` type check |
| `build [dir]` | `tsc` emit |
| `test [dir]` | `npm test` |
| `deps [dir]` | `npm ls --depth=0` |

## tsc resolution

1. `./node_modules/.bin/tsc` (project-local)
2. global `tsc` on PATH

Install project-local: `npm i -D typescript`.

## Examples

```bash
typescript-toolkit.sh syntax src/index.ts
typescript-toolkit.sh check .
typescript-toolkit.sh test .
```

## Notes

- `check` on a directory runs tsc with the project's `tsconfig.json`.
- On a single file it type-checks just that file with default options.
