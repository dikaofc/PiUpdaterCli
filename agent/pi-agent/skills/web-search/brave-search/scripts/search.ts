#!/usr/bin/env node
/**
 * brave-search — Web search & content extraction via Brave Search API.
 *
 * Source:
 *   - Brave Search API docs: https://brave.com/developers/
 *   - Brave Search Web API spec: https://api.search.brave.com/res/v1/web/search
 *
 * Requires BRAVE_API_KEY env var (set via `pi config env` or shell).
 *
 * Skill command:  /skill:brave-search <query> [--content]
 */
import { readFileSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";

const HELP = `# brave-search

Web search + page content extraction via the Brave Search API.

USAGE
  /skill:brave-search <query> [--content]          # search (append --content to fetch page text)
  /skill:brave-search --save <query> <outfile>     # search + dump JSON to a file

ENV
  BRAVE_API_KEY   Brave Search API key (required).

SOURCE
  https://brave.com/developers/  official docs
`;

interface BraveResult {
  title: string;
  url: string;
  description: string;
}

interface BraveWebSearch {
  web?: { results?: BraveResult[] };
}

const KEY = process.env.BRAVE_API_KEY;
if (!KEY) {
  console.error("BRAVE_API_KEY not set. Get a key at https://brave.com/developers/");
  process.exit(2);
}

async function search(query: string, n = 10): Promise<BraveResult[]> {
  const url = `https://api.search.brave.com/res/v1/web/search?q=${encodeURIComponent(
    query
  )}&count=${n}&extra_snippets=true`;
  const res = await fetch(url, {
    headers: { Accept: "application/json", "X-Subscription-Token": KEY },
  });
  if (!res.ok) {
    const body = await res.text();
    throw new Error(`Brave API ${res.status}: ${body}`);
  }
  const json = (await res.json()) as BraveWebSearch;
  return json.web?.results ?? [];
}

async function extract(url: string): Promise<string> {
  // Brave doesn't host page text; fetch via a readable proxy or direct.
  // Prefer a local readability endpoint if available; else plain fetch.
  const READABILITY =
    process.env.READABILITY_URL || "http://localhost:5050/api/text";
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), 15000);
  try {
    const res = await fetch(
      `${READABILITY}?url=${encodeURIComponent(url)}`,
      { signal: controller.signal }
    );
    if (!res.ok) throw new Error(`extract ${res.status}`);
    const json = (await res.json()) as { text?: string };
    return json.text ?? "";
  } finally {
    clearTimeout(timer);
  }
}

function main() {
  const args = process.argv.slice(2);
  let content = false;
  let out: string | null = null;
  const queryParts: string[] = [];
  for (let i = 0; i < args.length; i++) {
    const a = args[i];
    if (a === "--content") content = true;
    else if (a === "--save") out = args[++i];
    else if (a === "-h" || a === "--help") {
      process.stdout.write(HELP);
      return;
    } else queryParts.push(a);
  }
  const query = queryParts.join(" ");
  if (!query) {
    process.stderr.write(HELP + "\n");
    process.exit(1);
  }
  search(query)
    .then(async (results) => {
      let payload: unknown = results;
      if (content) {
        const enriched = await Promise.all(
          results.map(async (r) => ({ ...r, body: await extract(r.url).catch(() => "(failed)") }))
        );
        payload = enriched;
      }
      const json = JSON.stringify(payload, null, 2);
      if (out) {
        writeFileSync(resolve(out), json);
        console.log(`Saved ${results.length} results → ${out}`);
      } else {
        console.log(json);
      }
    })
    .catch((e) => {
      console.error(String(e));
      process.exit(1);
    });
}

main();
