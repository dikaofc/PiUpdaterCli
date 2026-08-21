# Brave Search

Search the web and extract page content via the [Brave Search API](https://brave.com/developers/).

- 🔍 Web search with titles, URLs, and snippets
- 📜 Optional full-text extraction of result pages (via a readability proxy)
- 💾 Optional JSON dump to disk for downstream processing

## Setup

1. Sign up for a Brave Search API key: https://brave.com/developers/
2. Make the key available to this skill:

```bash
# Option A — shell environment (one session)
export BRAVE_API_KEY="your-key-here"

# Option B — pi-scoped secret (recommended)
pi config env BRAVE_API_KEY
```

3. (Optional) For full-text extraction, run a readability service locally:

```bash
pip install readability-lxml
```

If `READABILITY_URL` (e.g. `http://localhost:5050/api/text`) is unset, `--content`
degrades gracefully: the script still emits search hits; page bodies that fail
extraction are noted as `(failed)`.

## Usage

Type `/skill:brave-search <query>` in the editor. Arguments after the skill
name are appended to the script invocation — see frontmatter `User:` passthrough.

| Command | Description |
|---------|-------------|
| `/skill:brave-search typescript async iterators` | Plain search, 10 hits |
| `/skill:brave-search "openapi 3.1 spec" --content` | Search + extract page bodies |
| `/skill:brave-search "rust serde derive" --save results.json` | Save JSON to `results.json` |
| `/skill:brave-search -h` | Full help |

### Argument reference

```text
<query...>            search query (words are joined)
--content            also fetch readable text for each result URL
--save <file>         write JSON results to <file>
-n, --count <N>       number of results (default 10, max 20)
-h, --help            show help
```

## When to use

Use this skill when the task involves:

- Verifying a fact or current event
- Researching an unfamiliar API / library
- Collecting URLs to read or scrape later
- Building a bibliography of web sources

## Architecture notes

The skill is intentionally **self-contained**: no `npm install` is required.
It uses Node 20+ global `fetch` and only stdlib modules. Run standalone outside pi:

```bash
BRAVE_API_KEY=xxx node skills/web-search/brave-search/scripts/search.ts "openai gym"
```

## Source & spec

- Brave Search API: https://brave.com/developers/
- Web Search endpoint: https://api.search.brave.com/res/v1/web/search
- Agent Skills spec: https://agentskills.io/specification
- Related pi skills: https://github.com/badlogic/pi-skills

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| `BRAVE_API_KEY not set` | Set env var / `pi config env BRAVE_API_KEY` |
| `401 Unauthorized` | Key invalid; regenerate at brave.com/developers |
| Extraction fails for a URL | Some sites block automated fetches; use `--content` selectively |
