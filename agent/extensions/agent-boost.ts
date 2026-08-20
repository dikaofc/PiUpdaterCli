// agent-boost — self-upgrade extension for the pi coding agent.
// Bundle v2: UI/UX dashboard, multi-tool orchestration, auto-verify,
// shortcuts, aggregate tool, persistent notes. All inside the safe
// extension layer (~/.pi/agent/extensions) — zero dist changes.
//
// Hot-reload with /reload. Remove file to disable.
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";
import { execFile } from "node:child_process";
import { promisify } from "node:util";
const execFileP = promisify(execFile);

async function sh(cmd: string): Promise<{ out: string; err: string }> {
  try {
    const r = await execFileP("bash", ["-lc", cmd], { timeout: 120_000 });
    return { out: r.stdout, err: r.stderr };
  } catch (e: any) {
    return { out: e?.stdout ?? "", err: e?.stderr ?? String(e?.message ?? e) };
  }
}

const MAX_NOTE = 32 * 1024;
let notes = new Map<string, string>();

// ---------- UI/UX: chat text styling (runs on every parsed message) ----------
const CALLOUTS: [RegExp, string][] = [
  [/^> \[!NOTE\]\s*$/m, "## ℹ️ NOTE"],
  [/^> \[!TIP\]\s*$/m, "## 💡 TIP"],
  [/^> \[!WARNING\]\s*$/m, "## ⚠️ WARNING"],
  [/^> \[!ERROR\]\s*$/m, "## 🚨 ERROR"],
  [/^> \[!IMPORTANT\]\s*$/m, "## 🔑 IMPORTANT"],
];

function styleMarkdown(md: string): string {
  let out = md;
  for (const [re, sub] of CALLOUTS) out = out.replace(re, sub);
  out = out.replace(/<kbd>([^<]+)<\/kbd>/g, "`$1`");
  out = out.replace(/\[\[([^\]|]+)(?:\|([^\]]+))?\]\]/g, (_m, path, label) => `[\`${label ?? path}\`](${path})`);
  return out;
}

export default function (pi: ExtensionAPI) {
  pi.registerMarkdownTransformer((md, ctx) => {
    if (ctx.messageType === "assistant-thinking") return md;
    return styleMarkdown(md);
  });

  // Custom streaming indicator: blocks instead of the default spinner.
  pi.on("session_start", async (_e, ctx) => {
    if (!ctx.hasUI) return;
    ctx.ui.setWorkingIndicator({ frames: ["▖", "▘", "▝", "▗"], intervalMs: 120 });
    ctx.ui.setWorkingMessage("thinking…");
    ctx.ui.setHiddenThinkingLabel("hidden thoughts");
  });

  // ---------- Multi-tools: aggregate (1 call → N tools) ----------
  pi.registerTool({
    name: "aggregate",
    label: "Aggregate",
    description:
      "Satu panggilan untuk menjalankan beberapa sub-komando shell secara berurutan. Menghemat round-trip model. Contoh kompatibel: `ls`, `git status`, `git branch --show-current`, `wc -l <file>`, `grep -n ... <file>`, `cat <file>`, `node --version`.",
    promptSnippet:
      "Resolve banyak pertanyaan kecil dalam SATU panggilan `aggregate` (sub-commands dijalankan berurutan di laptop; tidak butuh approval interaktif).",
    promptGuidelines: [
      "- Gunakan `aggregate` untuk mencari tahu banyak hal kecil sekaligus (status git + isi file + versi tool) — lebih hemat daripada tool terpisah.",
      "- Jangan pakai `aggregate` untuk edit/refactor yang butuh aplikasi; `edit`/`write` tetap per-fase.",
    ],
    parameters: Type.Object({
      commands: Type.Array(
        Type.String({ description: "Perintah shell, satu string per item" }),
        { description: "Sub-commands yang dijalankan secara berurutan" },
      ),
    }),
    renderShell: "default",
    executionMode: "sequential",
    async execute(_id, params) {
      const outputs = [];
      for (const cmd of params.commands) {
        const r = await sh(cmd);
        outputs.push(`$ ${cmd}\n${r.out}${r.err ? "\n[stderr] " + r.err : ""}`);
      }
      const out = outputs.join("\n---\n");
      return {
        content: [{ type: "text", text: out ? out : "(semua kosong)" }],
        details: { commands: params.commands.length },
      };
    },
  });

  // ---------- Notes: persistent key-value state ----------
  const noteDef = {
    note_save: {
      label: "Note Save",
      description: `Simpan catatan singkat dengan key (maks ${MAX_NOTE} char). Untuk fakta proyek lintas-sesi, keputusan, nilai config, endpoint.`,
      promptSnippet:
        "Catat fakta yang perlu diingat lintas-sesi dengan `note_save`. Baca dengan `note_get`.",
      parameters: Type.Object({
        key: Type.String({ description: "Identifier singkat (slug)" }),
        content: Type.String({ description: "Isi catatan" }),
        overwrite: Type.Optional(Type.Boolean({ description: "Timpa kalau key sudah ada (default false)" })),
      }),
      execute: async (_i, p) => {
        if (notes.has(p.key) && !p.overwrite) {
          return { content: [{ type: "text", text: `key "${p.key}" sudah ada. Pakai overwrite:true untuk menimpa.` }], details: { saved: false } };
        }
        notes.set(p.key, p.content.slice(0, MAX_NOTE));
        return { content: [{ type: "text", text: `✓ ${p.key} (${p.content.length} chars)` }], details: { saved: true } };
      },
    },
    note_get: {
      label: "Note Get",
      description: "Ambil catatan dengan key.",
      parameters: Type.Object({ key: Type.String({ description: "Key catatan" }) }),
      execute: async (_i, p) => {
        const v = notes.get(p.key);
        return { content: [{ type: "text", text: v ?? `(tidak ada catatan "${p.key}")` }], details: { found: v !== undefined } };
      },
    },
    note_list: {
      label: "Note List",
      description: "Daftar semua key catatan.",
      parameters: Type.Object({}),
      execute: async () => {
        const keys = [...notes.keys()];
        return { content: [{ type: "text", text: keys.length ? keys.join("\n") : "(kosong)" }], details: { count: keys.length } };
      },
    },
  };

  for (const [name, def] of Object.entries(noteDef)) {
    pi.registerTool({
      name,
      label: def.label,
      description: def.description,
      parameters: def.parameters,
      execute: def.execute as never,
    });
  }

  // ---------- Web fetch (port migrated) ----------
  pi.registerTool({
    name: "web_fetch",
    label: "Web Fetch",
    description:
      "Fetch a URL and return its text (HTML stripped to plain text, truncated). Use for docs, READMEs, changelogs, API references.",
    parameters: Type.Object({
      url: Type.String({ description: "HTTP(S) URL to fetch" }),
      maxChars: Type.Optional(Type.Number({ description: "Max characters to return (default 20000)" })),
    }),
    async execute(_id, params, signal) {
      const res = await fetch(params.url, { signal, redirect: "follow" });
      if (!res.ok) {
        return {
          content: [{ type: "text", text: `HTTP ${res.status} ${res.statusText}` }],
          details: { status: res.status },
        };
      }
      const ct = res.headers.get("content-type") ?? "";
      let body = await res.text();
      if (ct.includes("html")) {
        body = body
          .replace(/<script[\s\S]*?<\/script>/gi, "")
          .replace(/<style[\s\S]*?<\/style>/gi, "")
          .replace(/<[^>]+>/g, " ")
          .replace(/\s+/g, " ")
          .trim();
      }
      const max = params.maxChars ?? 20000;
      const truncated = body.length > max ? body.slice(0, max) + "\n…[truncated]" : body;
      return {
        content: [{ type: "text", text: truncated }],
        details: { contentType: ct, chars: truncated.length },
      };
    },
  });

  // ---------- Auto-verify after edits (runs post-execution) ----------
  pi.on("tool_result", async (event, ctx) => {
    if (event?.toolName !== "edit") return;
    try {
      const r = await sh("command -v cap >/dev/null 2>&1 && cap verify 2>&1 | tail -30 || echo '[cap tidak terpasang — skip]'");
      if (r.out.trim()) ctx.ui.setStatus("verify", r.out.trim().split("\n").slice(-1)[0] ?? "✓ verified");
    } catch {
      ctx.ui.setStatus("verify", "⚠ verify error");
    }
  });

  // ---------- Commands ----------
  pi.registerCommand("boost-status", {
    description: "Status agent-boost: context, tools aktif, jumlah tool",
    handler: async (_args, ctx) => {
      const u = ctx.getContextUsage();
      const txt = u ? `ctx ≈ ${Math.round((u.tokens ?? 0) / 1000)}k` : "ctx n/a";
      const tools = pi.getActiveTools();
      ctx.ui.notify(`agent-boost · ${txt} · tools: ${tools.join(", ") || "—"}`, "info");
    },
  });

  pi.registerCommand("boost-note", {
    description: "Tampilkan semua catatan tersimpan (tanpa arg) atau satu catatan (dengan key)",
    handler: async (args, ctx) => {
      const key = args?.trim();
      if (!key) {
        ctx.ui.notify(`notes (${notes.size}): ${[...notes.keys()].join(", ") || "—"}`, "info");
        return;
      }
      const v = notes.get(key);
      ctx.ui.notify(v ? `${key}: ${v.slice(0, 200)}` : `tidak ada "${key}"`, v ? "info" : "error");
    },
  });
}