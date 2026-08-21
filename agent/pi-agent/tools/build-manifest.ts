#!/usr/bin/env node
/**
 * build-manifest.ts — Regenerate manifest.json from the skills/ tree.
 *
 * Scans every SKILL.md, parses frontmatter, reads categories.yml mapping,
 * and writes a single manifest.json catalog.
 *
 * Usage:  npx tsx tools/build-manifest.ts [root]
 */
import { readFileSync, readdirSync, statSync, writeFileSync } from "node:fs";
import { join, relative } from "node:path";

const ROOT = process.argv[2] ?? process.cwd();
const SKILLS_DIR = join(ROOT, "skills");
const CAT_FILE = join(ROOT, "categories.yml");
const OUT = join(ROOT, "manifest.json");

interface SkillEntry {
  name: string;
  path: string;
  category: string;
  description: string;
  license?: string;
  compatibility?: string;
  source?: string;
  disableModelInvocation?: boolean;
  allowedTools?: string;
  metadata?: Record<string, unknown>;
}

interface CategoryDef {
  id: string;
  name: string;
  description: string;
}

// crude category parse: top-level "- id: x" items under "categories:"
function parseCategories(): CategoryDef[] {
  try {
    const y = readFileSync(CAT_FILE, "utf-8");
    const items: CategoryDef[] = [];
    let cur: CategoryDef | null = null;
    for (const line of y.split("\n")) {
      const m = line.match(/^\s*- id:\s*(\S+)/);
      if (m) {
        cur = { id: m[1], name: "", description: "" };
        items.push(cur);
        continue;
      }
      if (cur) {
        const mm = line.match(/^\s+name:\s*(.*)/);
        if (mm) cur.name = mm[1].replace(/^["']|["']$/g, "").trim();
        const md = line.match(/^\s+description:\s*(.*)/);
        if (md)
          cur.description = md[1].replace(/^["']|["']$/g, "").trim();
      }
    }
    return items;
  } catch {
    return [];
  }
}

function walkSkills(root: string): string[] {
  const out: string[] = [];
  for (const entry of readdirSync(root, { withFileTypes: true })) {
    const p = join(root, entry.name);
    if (entry.isDirectory()) {
      if (["node_modules", ".git"].includes(entry.name)) continue;
      out.push(...walkSkills(p));
    } else if (entry.name === "SKILL.md") {
      out.push(p);
    }
  }
  return out;
}

function parseFrontmatter(text: string): Record<string, unknown> {
  const m = /^---\n([\s\S]*?)\n---\n/m.exec(text);
  if (!m) return {};
  const data: Record<string, unknown> = {};
  for (const line of m[1].split("\n")) {
    const colon = line.indexOf(":");
    if (colon < 0) continue;
    const key = line.slice(0, colon).trim();
    let val: string = line.slice(colon + 1).trim();
    if (val.startsWith('"') && val.endsWith('"')) val = val.slice(1, -1);
    // boolean coercion
    if (val === "true") val = true as unknown as string;
    if (val === "false") val = false as unknown as string;
    if (key) data[key] = val as string;
  }
  return data;
}

function guessCategory(path: string, relToRoot: string): string {
  // rel path relative to skills/; first directory = category
  const seg = relative(SKILLS_DIR, path).split("/")[0];
  return seg || "uncategorized";
}

function main() {
  const cats = parseCategories();
  const catIds = new Set(cats.map((c) => c.id));
  const files = walkSkills(SKILLS_DIR).sort();
  const skills: SkillEntry[] = [];
  for (const f of files) {
    const text = readFileSync(f, "utf-8");
    const fm = parseFrontmatter(text);
    const rel = relative(ROOT, f).replace(/\/SKILL\.md$/, "");
    const cat = guessCategory(f, rel);
    if (!catIds.has(cat)) {
      console.warn(`WARN: skill "${fm.name}" category "${cat}" not in categories.yml`);
    }
    skills.push({
      name: (fm.name as string) || "",
      path: rel,
      category: cat,
      description: (fm.description as string) || "",
      license: fm.license as string | undefined,
      compatibility: fm.compatibility as string | undefined,
      source: fm.source as string | undefined,
      disableModelInvocation: fm.disableModelInvocation as boolean | undefined,
      allowedTools: fm.allowedTools as string | undefined,
      metadata:
        (fm.metadata as Record<string, unknown>) || undefined,
    });
  }
  const manifest = {
    $schema: "https://agentskills.io/schema/skills-catalog.json",
    name: "Ultra Aggressive Context Skills",
    description:
      "A large collection of on-demand skills for pi, organized by category, each with setup/usage/reference guides and helper scripts.",
    version: "1.0.0",
    homepage: "https://github.com/earendil-works/pi-skills",
    totalSkills: skills.length,
    categories: cats,
    skills,
  };
  writeFileSync(OUT, JSON.stringify(manifest, null, 2) + "\n");
  console.log(
    `Built manifest.json: ${skills.length} skills across ${cats.length} categories.`
  );
}

main();
