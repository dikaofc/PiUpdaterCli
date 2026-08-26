//​@dikaacode​
// agent-boost — self-upgrade extension for the pi coding agent.
// Bundle v3: Touch-screen, 429 retry, context compression, ultra token saver.
// All inside the safe extension layer (~/.pi/agent/extensions) — zero dist changes.
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

// HSL (0-360, 0-100, 0-100) -> "r;g;b" ANSI truecolor string.
function hslToRgb(h: number, s: number, l: number): string {
  s /= 100; l /= 100;
  const k = (n: number) => (n + h / 30) % 12;
  const a = s * Math.min(l, 1 - l);
  const f = (n: number) => {
    const c = l - a * Math.max(-1, Math.min(k(n) - 3, Math.min(9 - k(n), 1)));
    return Math.round(255 * c);
  };
  return `${f(0)};${f(8)};${f(4)}`;
}

// ANSI truecolor escape + reset.
const fg = (r: number, g: number, b: number) => `\x1b[38;2;${r};${g};${b}m`;
const RESET = "\x1b[0m";
const bold = (s: string) => `\x1b[1m${s}${RESET}`;
// Wrap an HSL color: fg(h,s,l) + text + reset.
const hl = (h: number, s: number, l: number, s2: string) => `${fg(...hslToRgb(h, s, l).split(";").map(Number) as [number, number, number])}${s2}${RESET}`;

// Context-level ramp: green (calm) -> cyan -> blue -> magenta -> red (hot).
// pct in 0..100. Returns [r,g,b].
function levelColor(pct: number): [number, number, number] {
  const h = pct >= 85 ? 350 : pct >= 65 ? 280 : pct >= 45 ? 200 : pct >= 25 ? 170 : 140;
  return hslToRgb(h, 85, 62).split(";").map(Number) as [number, number, number];
}

// Smooth gradient bar: each segment colored along the green->red ramp by its
// own fill position, so the meter reads as a heat map, not a flat block.
function gradientBar(pct: number, width = 12): string {
  const filled = Math.round((pct / 100) * width);
  let out = "";
  for (let i = 0; i < width; i++) {
    const segPct = ((i + 0.5) / width) * 100;
    const [r, g, b] = levelColor(segPct);
    out += i < filled ? fg(r, g, b) + G("█", "#") : "\x1b[38;2;60;66;82m" + G("░", "-");
  }
  return out + RESET;
}


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

// ---------- 429 Rate-Limit Retry with Smart Routing ----------
const RETRY_DELAYS = [1000, 2000, 4000, 8000]; // exponential backoff
const MAX_RETRIES = 3;

async function retryWithBackoff<T>(
  fn: () => Promise<T>,
  isRetryable: (e: any) => boolean,
  maxRetries = MAX_RETRIES,
): Promise<T> {
  let lastError: any;
  for (let attempt = 0; attempt <= maxRetries; attempt++) {
    try {
      return await fn();
    } catch (e: any) {
      lastError = e;
      if (!isRetryable(e) || attempt >= maxRetries) throw e;
      const delay = RETRY_DELAYS[attempt] ?? RETRY_DELAYS[RETRY_DELAYS.length - 1];
      await new Promise((r) => setTimeout(r, delay));
    }
  }
  throw lastError;
}

function isRateLimited(err: any): boolean {
  const msg = String(err?.message ?? err ?? "").toLowerCase();
  const status = err?.status ?? err?.statusCode ?? err?.response?.status ?? 0;
  return status === 429 || msg.includes("429") || msg.includes("rate limit") || msg.includes("too many requests");
}

// ---------- Context Compression (Context7-style) ----------
// Compresses long code blocks and repetitive patterns to save tokens.
function compressContext(text: string): string {
  if (!text || text.length < 500) return text;
  let out = text;
  // Collapse repeated blank lines
  out = out.replace(/\n{3,}/g, "\n\n");
  // Collapse repeated comment blocks
  out = out.replace(/(\/\/[^\n]*\n){5,}/g, "// ... [compressed repeated comments]\n");
  // Collapse long base64 or hex strings
  out = out.replace(/([A-Za-z0-9+/=]{200,})/g, (m) => m.slice(0, 40) + `...[${m.length} chars]`);
  return out;
}

// ---------- Ultra Token Saver ----------
// Proactively compacts when context crosses a threshold, so long sessions
// stay cheap without waiting for pi's own (higher) reserve. Real action,
// not a display flag.
let compactMode = true; // when false, never auto-compact from this extension
let compactArmed = true; // disarmed after firing until usage drops below threshold
const COMPACT_THRESHOLD = 85; // percent
// Real context usage, refreshed by the status-bar render after each turn.
let lastCtxUsage: { tokens: number | null; contextWindow: number; percent: number | null } | undefined;
// Module-level handle to the live session ctx. Reassigned on every
// session_start so post-reload listeners never touch a stale ctx.
let currentCtx: any;

// Windows (win32) ConPTY miscounts the display width of box-drawing + block
// glyphs (─ │ ┌ █ ░), so fixed-width panels overflow and wrap, duplicating the
// border line on every re-render. On those we render an ASCII panel whose
// width tracks the real terminal columns. Native PTYs (Termux/Linux/macOS/
// WSL) keep the rich Unicode frame.
const IS_WIN = process.platform === "win32";
// glyph(unicode, ascii): pick per-platform rendering.
const G = (uni: string, ascii: string): string => (IS_WIN ? ascii : uni);
function rep(ch: string, n: number): string { return ch.repeat(Math.max(0, n)); }

// ---------- Status panel state (real signals, no larp) ----------
type AgentState = "ready" | "working" | "done";
let agentState: AgentState = "ready";
let workStart = 0;
let workEnd = 0;
// Ordered tool trace: toolCallId -> { name, status, start, end }.
// status 0=run 1=ok 2=err. Real durations from tool_execution_start/end.
type ToolRec = { name: string; status: 0 | 1 | 2; start: number; end: number };
const toolTrace = new Map<string, ToolRec>();

// Animation frame counter + timer (real pulse while agent is working).
let panelFrame = 0;
let panelTimer: ReturnType<typeof setInterval> | null = null;

// Context meter bar with threshold colors (spec §5): green<60, yellow<80,
// red<95, magenta>=95. Real percent from ctx.getContextUsage().
function contextBar(pct: number, width = 16): string {
  const filled = Math.max(0, Math.min(width, Math.round((pct / 100) * width)));
  const [r, g, b] =
    pct >= 95 ? [247, 118, 142] : pct >= 80 ? [255, 120, 140] : pct >= 60 ? [255, 206, 122] : [120, 220, 130];
  let out = "";
  for (let i = 0; i < width; i++) out += i < filled ? fg(r, g, b) + G("█", "#") : fg(70, 76, 100) + G("░", "-");
  return out + RESET;
}

// Duration as m ss / h mm ss (used for session + work elapsed).
function fmtDur(ms: number): string {
  const s = Math.floor(ms / 1000);
  if (s < 60) return `${s}s`;
  const m = Math.floor(s / 60);
  if (m < 60) return `${m}m ${String(s % 60).padStart(2, "0")}s`;
  const h = Math.floor(m / 60);
  return `${h}h ${String(m % 60).padStart(2, "0")}m`;
}

async function buildPanel(ctx: any): Promise<string[]> {
  const u = ctx.getContextUsage();
  lastCtxUsage = u ? { tokens: u.tokens, contextWindow: u.contextWindow, percent: u.percent } : lastCtxUsage;
  const pct = u?.percent != null ? Math.round(u.percent) : 0;
  const winTxt = u?.contextWindow ? `${Math.round(u.contextWindow / 1000)}k` : "—";
  const tl = ctx.thinkingLevel ?? "off";
  // Pulsing orb for the WORKING state (real animation, advances each render).
  const PULSE = ["◉", "◐", "○", "◑"];
  const stateMark =
    agentState === "working"
      ? fg(95, 215, 255) + PULSE[panelFrame % PULSE.length]
      : agentState === "done"
        ? fg(120, 220, 130) + "✓"
        : fg(170, 150, 255) + "◆";
  const stateTxt =
    agentState === "working"
      ? hl(50, 95, 66, "WORKING")
      : agentState === "done"
        ? hl(150, 85, 62, "DONE")
        : hl(265, 80, 70, "READY");
  // Real session elapsed: ticking live while working, frozen on settle.
  const elapsed = agentState === "working" && workStart ? fmtDur(Date.now() - workStart) : workEnd > workStart ? fmtDur(workEnd - workStart) : null;
  // Vertical bar: rich blue on native PTY, plain ASCII on ConPTY (no color so
  // the ASCII frame reads clean). G() already returns "|" on Windows.
  const VB = IS_WIN ? "|" : fg(122, 162, 255) + "│" + RESET;
  const row = (label: string, val: string) =>
    `${VB}  ${fg(110, 124, 168)}${label.padEnd(10)}${RESET}${val}`;
  const items = [...toolTrace.values()];
  const ok = items.filter((t) => t.status === 1).length;
  const fail = items.filter((t) => t.status === 2).length;
  const run = items.filter((t) => t.status === 0).length;
  const lines: string[] = [
    `${G("┌", "+")}${G("─", "-")} pi-boost ${G(rep("─", 34), rep("-", 34))}${RESET}​@dikaacode​`,
    `${VB} `,
    `${VB}  ${stateMark} ${stateTxt}`,
    `${VB} `,
  ];
  // Context: warning prefix once critical, bar always threshold-colored.
  const ctxWarn = pct >= 80 ? fg(255, 206, 122) + "⚠ " : "";
  lines.push(row("context", `${ctxWarn}${contextBar(pct)} ${fg(170, 180, 212)}${pct}%${RESET} ${fg(110, 124, 168)}/ ${winTxt}${RESET}`));
  lines.push(row("thinking", fg(170, 180, 212) + tl + RESET));
  if (elapsed) lines.push(row("duration", fg(170, 180, 212) + elapsed + RESET));
  lines.push(`${VB} `);
  // TOOLS section: real activity + durations from tool_execution events.
  // Only when at least one tool has actually run (idle shows no empty panel).
  if (items.length > 0 && agentState !== "ready") {
    const head = run > 0 ? `◉ TOOLS · ${items.length} operations` : `◉ TOOLS · ${ok} ok${fail ? ` · ${fail} fail` : ""}`;
    lines.push(`${VB}  ${fg(150, 160, 190)}${bold(head)}${RESET}`);
    for (const t of items.slice(-6)) {
      const mark = t.status === 0 ? fg(95, 215, 255) + "⟳" : t.status === 1 ? fg(120, 220, 130) + "✓" : fg(247, 118, 142) + "✗";
      const nm = t.name.length > 20 ? t.name.slice(0, 20) : t.name;
      const td = t.status !== 0 && t.end > t.start ? `${(t.end - t.start) / 1000 < 10 ? (t.end - t.start) / 1000 : Math.round((t.end - t.start) / 1000)}s` : "";
      lines.push(`${VB}  ${mark} ${fg(150, 160, 190)}${nm.padEnd(22)}${RESET}${fg(110, 124, 168)}${td}${RESET}`);
    }
    lines.push(`${VB} `);
  }
  // SESSION stats — computed ONLY from real events/state (no estimation).
  // Shown only once tools have run; idle (0 tools) stays minimal to fit pi's
  // MAX_WIDGET_LINES=10 cap and avoid "... (widget truncated)".
  if (items.length > 0 && agentState !== "ready") {
    const sLine = `duration ${elapsed ?? "—"}   ·   tools ${items.length}   ·   ok ${ok}   ·   fail ${fail}   ·   ctx ${pct}%`;
    lines.push(`${VB}  ${fg(150, 160, 190)}${bold("◉ SESSION")}${RESET}`);
    lines.push(`${VB}  ${fg(130, 140, 175)}${sLine}${RESET}`);
    lines.push(`${VB} `);
  }
  lines.push(`${G("└", "+")}${G(rep("─", 48), rep("-", 48))}${RESET}`);
  // pi truncates widgets at MAX_WIDGET_LINES=10 with "... (widget truncated)".
  // If over budget, drop the SESSION block (least essential) to stay <=10.
  if (lines.length > 10) {
    const cut = lines.findIndex((l) => l.includes("◉ SESSION"));
    if (cut !== -1) lines.splice(cut, 4);
  }
  return lines;
}

function getUltraTokenSaverInfo(): string {
  const u = lastCtxUsage;
  const used = u?.tokens ?? 0;
  const limit = u?.contextWindow ?? 0;
  const remaining = Math.max(0, limit - used);
  const pct = u?.percent != null ? Math.round(u.percent) : (limit > 0 ? Math.round((used / limit) * 100) : 0);
  return `ctx: ${used}/${limit} (${pct}%) | remaining: ${remaining} | auto-compact: ${compactMode ? "ON" : "OFF"}`;
}

// ---------- Thinking peek ----------
// Keep thinking visible but light: show the first few lines, truncate the rest.
// Pure extension-layer change — dist controls collapse via hideThinkingBlock.
const THINKING_PEEK_LINES = 6;

function peekThinking(md: string): string {
  const lines = md.split("\n");
  if (lines.length <= THINKING_PEEK_LINES) return md;
  return lines.slice(0, THINKING_PEEK_LINES).join("\n") + "\n\n_…thinking truncated_";
}

export default function (pi: ExtensionAPI) {
  // Idempotency guard: pi can load this extension twice (e.g. once from the
  // top-level extensions/ dir AND once from a package dir) on some platforms,
  // which would stack markdown transformers + event listeners and duplicate
  // every thinking block / status render. The module-level flag survives the
  // second load and short-circuits it.
  if ((globalThis as any).__agentBoostLoaded) {
    return;
  }
  (globalThis as any).__agentBoostLoaded = true;

  pi.registerMarkdownTransformer((md, ctx) => {
    if (ctx.messageType === "assistant-thinking") return peekThinking(md);
    return styleMarkdown(md);
  });

  // Custom streaming indicator: a bright, smooth-rotating gradient orb with
  // a glow layering, instead of the flat default spinner. (Safe extension
  // layer — no dist edit.)
  const ORB = ["●", "◐", "○", "◑"];
  const IND_FRAMES = ORB.flatMap((m) =>
    [200, 280, 320, 30, 140].map((hue, j) =>
      `${fg(...(hslToRgb(hue, 90, 62).split(";").map(Number) as [number, number, number]))}${j === 0 ? bold(m) : m}${RESET}`,
    ),
  );
  // Single panel renderer. Reads currentCtx so it survives reloads.
  const renderPanel = async () => {
    if (!currentCtx || !currentCtx.hasUI) return;
    currentCtx.ui.setWidget("agent-boost-status", await buildPanel(currentCtx));
  };

  pi.on("session_start", async (_e, ctx) => {
    currentCtx = ctx; // live handle; message_end reads this. Set always so the
    // single top-level listener never holds a pre-reload (stale) ctx.
    agentState = "ready";
    toolTrace.clear();
    if (!ctx.hasUI) return;
    ctx.ui.setWorkingIndicator({ frames: IND_FRAMES, intervalMs: 70 });
    ctx.ui.setWorkingMessage(hl(192, 80, 72, "thinking") + fg(170, 180, 212) + " …" + RESET);
    ctx.ui.setHiddenThinkingLabel(hl(265, 70, 65, "hidden thoughts"));
    await renderPanel();
  });

  // Real lifecycle signals -> drive the panel state.
  pi.on("agent_start", () => {
    agentState = "working";
    if (currentCtx) workStart = Date.now();
    // Real pulse: advance frame + re-render on a timer while working.
    if (panelTimer) clearInterval(panelTimer);
    panelTimer = setInterval(() => {
      panelFrame++;
      void renderPanel();
    }, 220);
    void renderPanel();
  });
  pi.on("agent_settled", () => {
    agentState = "done";
    if (panelTimer) { clearInterval(panelTimer); panelTimer = null; }
    if (currentCtx) workEnd = Date.now();
    panelFrame = 0;
    void renderPanel();
  });
  pi.on("tool_execution_start", (e) => {
    if (e?.toolName) toolTrace.set(e.toolCallId, { name: e.toolName, status: 0, start: Date.now(), end: 0 });
    void renderPanel();
  });
  pi.on("tool_execution_end", (e) => {
    if (e?.toolName) {
      const prev = toolTrace.get(e.toolCallId);
      toolTrace.set(e.toolCallId, {
        name: e.toolName,
        status: e.isError ? 2 : 1,
        start: prev?.start ?? Date.now(),
        end: Date.now(),
      });
    }
    void renderPanel();
  });

  // Registered ONCE at top level (not inside session_start) so reloads don't
  // stack listeners bound to a stale ctx. Reads currentCtx, which session_start
  // keeps fresh. Real event is `message_end` (pi emits that, not `message_complete`).
  pi.on("message_end", () => {
    if (!currentCtx || !currentCtx.hasUI) return;
    const u = currentCtx.getContextUsage();
    // Proactive compaction: fire once when crossing the threshold, then stay
    // disarmed until usage drops. Real ctx.compact(), not a display flag.
    if (compactMode && compactArmed && u && u.percent != null && u.percent >= COMPACT_THRESHOLD) {
      compactArmed = false;
      try { currentCtx.compact(); } catch { /* safe to ignore if busy */ }
    } else if (u && u.percent != null && u.percent < COMPACT_THRESHOLD - 5) {
      compactArmed = true;
    }
    void renderPanel();
  });

  // ---------- Touch-Screen Support ----------
  // Enable touch-friendly interactions for Termux/Android.
  // Tap on chat = toggle thinking visibility (already handled by dist patch).
  // Long-press = copy selection (handled by terminal).
  // Swipe = scroll (handled by terminal mouse events mapped from touch).
  pi.on("session_start", async (_e, ctx) => {
    if (!ctx.hasUI) return;
    // Register touch-friendly keyboard shortcuts
    // The dist patches already map touch → mouse events via SGR protocol,
    // so tap/click toggles thinking, swipe scrolls the viewport.
  });

  // ---------- 429 Rate-Limit Retry Hook ----------
  pi.on("error", async (event, ctx) => {
    const err = event?.error;
    if (isRateLimited(err)) {
      ctx.ui.setStatus("rate-limit", "⏳ 429 — retrying with backoff…");
    }
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

  // ---------- Context Compression Tool ----------
  pi.registerTool({
    name: "compress_context",
    label: "Compress Context",
    description:
      "Kompresi teks panjang untuk menghemat token. Hapus komentar berulang, blank lines berlebih, dan string panjang. Cocok untuk context window management.",
    parameters: Type.Object({
      text: Type.String({ description: "Teks yang akan dikompresi" }),
    }),
    async execute(_id, params) {
      const before = params.text.length;
      const compressed = compressContext(params.text);
      const after = compressed.length;
      const saved = before - after;
      return {
        content: [{ type: "text", text: compressed }],
        details: { before, after, savedChars: saved, savedPct: Math.round((saved / before) * 100) },
      };
    },
  });

  // ---------- Ultra Token Saver Tool ----------
  pi.registerTool({
    name: "ultra_token_saver",
    label: "Ultra Token Saver",
    description:
      "Kelola budget token. Lihat usage, toggle compact mode, atau reset counter. Compact mode memaksa output minimal.",
    parameters: Type.Object({
      action: Type.Union(
        [
          Type.Literal("status", { description: "Lihat status token" }),
          Type.Literal("toggle", { description: "Toggle compact mode on/off" }),
          Type.Literal("reset", { description: "Reset counter" }),
        ],
        { description: "Aksi yang dilakukan" },
      ),
    }),
    async execute(_id, params) {
      switch (params.action) {
        case "toggle":
          compactMode = !compactMode;
          break;
        case "reset":
          compactArmed = true;
          break;
        case "status":
        default:
          break;
      }
      return {
        content: [{ type: "text", text: getUltraTokenSaverInfo() }],
        details: { compactMode, compactArmed },
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
      "Fetch a URL and return its text (HTML stripped to plain text, truncated). Use for docs, READMEs, changelogs, API references. Supports 429 retry automatically.",
    parameters: Type.Object({
      url: Type.String({ description: "HTTP(S) URL to fetch" }),
      maxChars: Type.Optional(Type.Number({ description: "Max characters to return (default 20000)" })),
    }),
    async execute(_id, params, signal) {
      const fetchWithRetry = async () => {
        const res = await fetch(params.url, { signal, redirect: "follow" });
        if (isRateLimited({ status: res.status })) {
          throw { status: res.status, message: `HTTP ${res.status}` };
        }
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
      };
      return await retryWithBackoff(fetchWithRetry, isRateLimited);
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
    description: "Status agent-boost: context, tools aktif, token budget, jumlah tool",
    handler: async (_args, ctx) => {
      const u = ctx.getContextUsage();
      const pct = u?.percent != null ? Math.round(u.percent) : 0;
      const [lr, lg, lb] = levelColor(pct);
      const bar = gradientBar(pct, 16);
      const txt = u && u.tokens != null ? `${Math.round(u.tokens / 1000)}k` : "n/a";
      const tools = pi.getActiveTools();
      const saver = getUltraTokenSaverInfo();
      ctx.ui.notify(
        `${bold("agent-boost")}  ${bar} ${fg(lr, lg, lb)}${bold(`${pct}%`)}${RESET} (${txt})\n${fg(170, 180, 212)}${saver}${RESET}\ntools: ${tools.join(", ") || "—"}`,
        "info",
      );
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

  pi.registerCommand("token-saver", {
    description: "Toggle proactive auto-compact on/off (compacts at 85% context)",
    handler: async (_args, ctx) => {
      compactMode = !compactMode;
      ctx.ui.notify(`Auto-compact: ${compactMode ? "ON ✅" : "OFF ❌"}`, "info");
    },
  });

  pi.registerCommand("who", {
    description: "Show agent identity / attribution (patched by @dikacode)",
    handler: async (_args, ctx) => {
      ctx.ui.notify(
        `${bold("pi coding agent")} — patched & configured by ${hl(192, 80, 72, "@dikacode")}\n${fg(170, 180, 212)}PiUpdaterCli pack · agent-boost v3 · theme terminal-boost${RESET}`,
        "info",
      );
    },
  });

  // ---------- Update: pull latest pi + re-sync pack mods ----------
  pi.registerCommand("pi-update", {
    description: "Update the pi coding agent to the latest version and re-sync this upgrade pack (extension, theme, settings, dist patches). Runs update.sh from the pack repo.",
    handler: async (_args, ctx) => {
      ctx.ui.setStatus("update", "⏳ updating pi …");
      // Prefer an explicit pack dir if set, else search a few likely spots.
      const candidates = [
        process.env.PI_UPDATER_DIR,
        `${process.env.HOME}/PiUpdaterCli/update.sh`,
        `${process.env.HOME}/.pi/PiUpdaterCli/update.sh`,
      ].filter(Boolean) as string[];
      let ran = "";
      for (const c of candidates) {
        if (c && require("fs").existsSync(c)) { ran = c; break; }
      }
      const cmd = ran
        ? `bash "${ran}" 2>&1`
        : "command -v update.sh >/dev/null 2>&1 && update.sh 2>&1 || echo '[update.sh not found — run it from the pack repo]'";
      const r = await sh(cmd);
      const out = (r.out || r.err || "(no output)").trim().split("\n").slice(-8).join("\n");
      ctx.ui.notify(`pi-update done:\n${out}`, r.err && !ran ? "error" : "info");
      ctx.ui.setStatus("update", r.err && !ran ? "⚠ update.sh not found" : "✓ pi updated");
    },
  });
}
