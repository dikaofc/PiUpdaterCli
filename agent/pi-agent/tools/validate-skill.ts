#!/usr/bin/env node
/**
 * validate-skill.ts — Lint + validate every SKILL.md in the repo.
 *
 * Implements the relevant subset of the Agent Skills specification
 * frontmatter rules (name format, description presence/length, etc.)
 * plus repo-specific structural checks.
 *
 * Usage:  npx tsx tools/validate-skill.ts [root]
 */
import { readFileSync, readdirSync, statSync } from "node:fs";
import { join, relative } from "node:path";

const SPEC_URL = "https://agentskills.io/specification";
const ROOT = process.argv[2] ?? process.cwd();

const NAME_RE = /^[a-z0-9][a-z0-9-]{0,62}[a-z0-9]$/;
const MAX_DESC = 1024;
const MAX_COMPAT = 500;

interface Result {
  file: string;
  errors: string[];
  warnings: string[];
}

function walk(root: string): string[] {
  const out: string[] = [];
  for (const entry of readdirSync(root, { withFileTypes: true })) {
    const p = join(root, entry.name);
    if (entry.isDirectory()) {
      // ignore node_modules / .git / references
      if (
        entry.name === "node_modules" ||
        entry.name === ".git" ||
        entry.name === "assets"
      )
        continue;
      out.push(...walk(p));
    } else if (entry.name === "SKILL.md") {
      out.push(p);
    }
  }
  return out;
}

function splitFrontmatter(text: string): {
  ok: boolean;
  data: Record<string, unknown>;
  body: string;
  rawYaml: string;
} {
  const m = /^---\n([\s\S]*?)\n---\n([\s\S]*)$/m.exec(text);
  if (!m) return { ok: false, data: {}, body: text, rawYaml: "" };
  const yaml = m[1];
  const body = m[2];
  // tiny yaml parser for flat key: "value" or key: value or multiline
  const data: Record<string, unknown> = {};
  for (const line of yaml.split("\n")) {
    const colon = line.indexOf(":");
    if (colon < 0) continue;
    const key = line.slice(0, colon).trim();
    let val: string = line.slice(colon + 1).trim();
    if (val.startsWith('"') && val.endsWith('"')) val = val.slice(1, -1);
    if (val === "") val = ""; // placeholder; real multiline not parsed here
    data[key] = val;
  }
  return { ok: true, data, body, rawYaml: yaml };
}

function validate(file: string): Result {
  const rel = relative(ROOT, file);
  const errors: string[] = [];
  const warnings: string[] = [];
  let text: string;
  try {
    text = readFileSync(file, "utf-8");
  } catch (e) {
    errors.push(`cannot read file: ${(e as Error).message}`);
    return { file: rel, errors, warnings };
  }
  const { ok, data, body } = splitFrontmatter(text);
  if (!ok) {
    errors.push("missing or malformed YAML frontmatter (expected `---` block)");
    return { file: rel, errors, warnings };
  }
  const name = data.name;
  const description = data.description;
  if (!name || typeof name !== "string") {
    errors.push("frontmatter `name` is required and must be a string");
  } else if (!NAME_RE.test(name)) {
    errors.push(
      `frontmatter \`name\` "${name}" invalid: must start/end with lowercase alnum, 1-64 chars, only [a-z0-9-]`
    );
  }
  if (!description || typeof description !== "string") {
    errors.push("frontmatter `description` is required and must be a string");
  } else {
    if (description.length > MAX_DESC) {
      warnings.push(`description exceeds ${MAX_DESC} chars (${description.length})`);
    }
    if (/^helps with/i.test(description) || /^a tool to/i.test(description)) {
      warnings.push(
        "description should be specific (avoid vague phrases like 'helps with')"
      );
    }
  }
  if (data.compatibility && typeof data.compatibility === "string") {
    if (data.compatibility.length > MAX_COMPAT) {
      warnings.push(`compatibility exceeds ${MAX_COMPAT} chars`);
    }
  }
  if (data.disableModelInvocation === true) {
    warnings.push(
      "`disableModelInvocation` hides skill from system prompt; ensure intended"
    );
  }
  // structural checks
  const dir = file.replace(/\/SKILL\.md$/, "");
  if (statSync(dir).isDirectory()) {
    const entries = readdirSync(dir, { withFileTypes: true });
    const hasScripts = entries.some(
      (e) => e.name === "scripts" && e.isDirectory()
    );
    const hasRefs = entries.some(
      (e) => e.name === "references" && e.isDirectory()
    );
    const hasAssets = entries.some(
      (e) => e.name === "assets" && e.isDirectory()
    );
    if (!hasScripts) warnings.push("no scripts/ directory (optional)");
    if (!hasRefs) warnings.push("no references/ directory (optional)");
    if (!hasAssets) warnings.push("no assets/ directory (optional)");
  }
  // body must have at least a Setup or Usage section
  if (!/##\s+(Setup|Usage|How)/i.test(body)) {
    warnings.push("SKILL.md body missing a Setup or Usage section");
  }
  return { file: rel, errors, warnings };
}

function main() {
  const files = walk(ROOT).sort();
  const results = files.map(validate);
  let errors = 0,
    warnings = 0;
  for (const r of results) {
    if (r.errors.length === 0 && r.warnings.length === 0) continue;
    console.log(`\n${r.file}`);
    for (const e of r.errors) {
      console.log(`  ERROR: ${e}`);
      errors++;
    }
    for (const w of r.warnings) {
      console.log(`  WARN:  ${w}`);
      warnings++;
    }
  }
  const ok = results.length;
  console.log(
    `\nValidated ${results.length} skill(s): ${errors} error(s), ${warnings} warning(s)`
  );
  if (errors > 0) {
    console.log(`\nSpec reference: ${SPEC_URL}`);
    process.exit(1);
  }
}

main();
