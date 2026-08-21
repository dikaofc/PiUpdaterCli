/**
 * gen-skill.ts — Generate a new skill skeleton from a definition.
 *
 * Usage:
 *   npx tsx tools/gen-skill.ts <cat/name> "<display>" "<description>" "<sources>|<sources>"
 *
 * Creates: SKILL.md, scripts/<name>.sh, references/REFERENCE.md, assets/.gitkeep, LICENSE
 */
import { mkdirSync, writeFileSync, readFileSync, existsSync, chmodSync } from "node:fs";
import { join, relative } from "node:path";

const args = process.argv.slice(2);
if (args.length < 4) {
  console.error("usage: gen-skill.ts <cat/name> <display> <description> <sources>");
  process.exit(2);
}
const [slug, display, description, sources] = args;
const [cat, name] = slug.split("/");
if (!cat || !name) {
  console.error("slug must be <category>/<name>");
  process.exit(2);
}
const ROOT = process.cwd();
const base = join(ROOT, "skills", cat, name);
mkdirSync(`${base}/scripts`, { recursive: true });
mkdirSync(`${base}/references`, { recursive: true });
mkdirSync(`${base}/assets`, { recursive: true });

const scriptName = `${name}.sh`;
const relScript = `scripts/${scriptName}`;
const scriptPath = `${base}/scripts/${scriptName}`;

const sourcesList = sources.split("|").map((s) => s.trim()).filter(Boolean);

const catFile = join(ROOT, "categories.yml");
if (!existsSync(catFile)) {
  writeFileSync(
    catFile,
    `# Category index\ncategories:\n  - id: ${cat}\n    name: ${cat.replace(/-/g, " ")}\n    description: ${description}\n`
  );
} else {
  let cats = readFileSync(catFile, "utf-8");
  if (!cats.includes(`id: ${cat}\n`)) {
    cats = cats.replace(
      /(\ncategories:\n)/,
      `$1  - id: ${cat}\n    name: ${cat.replace(/-/g, " ")}\n    description: ${description}\n`
    );
    writeFileSync(catFile, cats);
  }
}

const fm = [
  `name: ${name}`,
  `description: ${description}`,
  "license: MIT",
  'compatibility: "POSIX shell + curl + jq. No build step."',
  `source: ${sourcesList.join(" ")}`,
  "metadata:",
  `  category: ${cat}`,
  "  language: bash",
  `  tags: [${name}]`,
  "---",
  "",
].join("\n");

const skillMd = `---\n` + `${fm}# ${display}

${description}

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

\`\`\`bash
chmod +x ${relScript}
which curl jq || apt-get install -y curl jq   # debian/ubuntu
\`\`\`

## Usage

\`\`\`bash
./${relScript} "<required-args>"
\`\`\`

### Arguments

\`\`\`
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
\`\`\`

Invoke from pi with: \`/skill:${name} <args>\`
`;

writeFileSync(`${base}/SKILL.md`, skillMd);

const script = `#!/usr/bin/env bash
# ${display}
# Sources: ${sourcesList.join(", ")}
set -euo pipefail

SCRIPT_NAME="${scriptName}"

usage() {
  cat <<EOF
Usage: \${SCRIPT_NAME} <input> [--out <file>]
<input>        primary input
--out FILE     write output to FILE
-h | --help    show help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

INPUT=""
OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    --out) OUT="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) INPUT="\${INPUT:+\$INPUT }\$1"; shift;;
  esac
done

echo "TODO: implement ${name} for input=\${INPUT}"
`;
writeFileSync(scriptPath, script);
try { chmodSync(scriptPath, 0o755); } catch {}

const refMd = `# ${display} — Reference

## Purpose

${description}

## Sources

${sourcesList.map((s) => `- ${s}`).join("\n")}

## Endpoints / Notes

See upstream docs in sources above.

## Troubleshooting

| Problem | Resolution |
|---------|-----------|
`;
writeFileSync(`${base}/references/REFERENCE.md`, refMd);

writeFileSync(`${base}/assets/.gitkeep`, "");
writeFileSync(`${base}/LICENSE`, "MIT\n");

console.log("Generated " + relative(ROOT, base));
