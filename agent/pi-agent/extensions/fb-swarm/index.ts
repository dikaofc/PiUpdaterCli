/**
 * fb-swarm — orchestrasi agent Freebuff dari dalam pi.
 *
 * Menyediakan tool untuk men-spawn agent Freebuff (tmux session "fbswarm"),
 * mengirim tugas, membaca layarnya, dan menghentikannya — supaya pi bisa
 * menjalankan beberapa Freebuff agent sebagai kolaborator di proyek yang
 * sama, masing-masing dengan konteks/session chat sendiri.
 *
 * Backend: ~/.local/bin/fb-agent (wrapper tmux).
 */
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";
import { execFile } from "node:child_process";
import { promisify } from "node:util";

const execFileP = promisify(execFile);
const FB = "/data/data/com.termux/files/home/.local/bin/fb-agent";

export default function (pi: ExtensionAPI) {
  const run = async (args: string[]): Promise<string> => {
    try {
      const r = await execFileP(FB, args, {
        timeout: 90000,
        maxBuffer: 8 * 1024 * 1024,
      });
      return r.stdout;
    } catch (e: unknown) {
      const err = e as { message?: string; stdout?: string; stderr?: string };
      return `ERROR: ${err.message ?? String(e)}\n${err.stdout ?? ""}${err.stderr ?? ""}`;
    }
  };

  const sleep = (ms: number) => new Promise((r) => setTimeout(r, ms));

  pi.registerTool({
    name: "fb_spawn",
    label: "Freebuff agent: mulai",
    description:
      "Start a new independent Freebuff coding agent in a tmux window (session 'fbswarm') working on a project directory. Each agent has its own chat session and context window, and works in parallel with pi. After spawning, wait ~10-15s, then use fb_read to see its screen and fb_send to give it tasks. The agent's model is a free-tier cloud model (DeepSeek V4 Flash).",
    parameters: Type.Object({
      name: Type.String({
        description: "Short unique id (a-z0-9_-), e.g. 'worker1' or 'refactor-a'",
      }),
      dir: Type.String({
        description: "Absolute path of the project directory the agent works on",
      }),
    }),
    async execute(_toolCallId, params, _signal, _onUpdate) {
      const out = await run(["new", params.name, params.dir]);
      await sleep(12000);
      const screen = await run(["read", params.name, "60"]);
      return {
        content: [{ type: "text", text: `${out}\n--- screen setelah boot ---\n${screen}` }],
        details: {},
      };
    },
  });

  pi.registerTool({
    name: "fb_send",
    label: "Freebuff agent: kirim pesan",
    description:
      "Send a message/task to a running Freebuff agent (created with fb_spawn). The text is typed into the agent's TUI and Enter is pressed. If the agent is not in the chat input yet (welcome/project screen), first send navigation keys with fb_send_keys or check fb_read.",
    parameters: Type.Object({
      name: Type.String({ description: "Agent id from fb_spawn" }),
      text: Type.String({ description: "Message/task to send" }),
    }),
    async execute(_toolCallId, params) {
      const out = await run(["send", params.name, params.text]);
      await sleep(6000);
      const screen = await run(["read", params.name, "50"]);
      return {
        content: [{ type: "text", text: `${out}\n--- screen agent ---\n${screen}` }],
        details: {},
      };
    },
  });

  pi.registerTool({
    name: "fb_send_keys",
    label: "Freebuff agent: kirim tombol",
    description:
      "Send raw keyboard keys to a Freebuff agent's TUI (e.g. Enter, Down, Tab, ESC). Useful for navigating the welcome/project-picker screens before the chat input is focused.",
    parameters: Type.Object({
      name: Type.String({ description: "Agent id from fb_spawn" }),
      keys: Type.Array(Type.String(), {
        description: "Key names or text, e.g. ['Enter'] or ['Down','Down','Enter']",
      }),
    }),
    async execute(_toolCallId, params) {
      const out = await run(["keys", params.name, ...params.keys]);
      return { content: [{ type: "text", text: out }], details: {} };
    },
  });

  pi.registerTool({
    name: "fb_read",
    label: "Freebuff agent: baca layar",
    description:
      "Read the current screen (terminal capture) of a running Freebuff agent so pi can see its state, progress, and answers. Use this to check on agents you spawned with fb_spawn.",
    parameters: Type.Object({
      name: Type.String({ description: "Agent id from fb_spawn" }),
      lines: Type.Optional(
        Type.Number({ description: "How many lines of scrollback to include (default 150)" }),
      ),
    }),
    async execute(_toolCallId, params) {
      const out = await run(["read", params.name, String(params.lines ?? 150)]);
      return { content: [{ type: "text", text: out }], details: {} };
    },
  });

  pi.registerTool({
    name: "fb_list",
    label: "Freebuff agent: daftar",
    description: "List all running Freebuff agents (windows in tmux session 'fbswarm').",
    parameters: Type.Object({}),
    async execute() {
      const out = await run(["list"]);
      return { content: [{ type: "text", text: out }], details: {} };
    },
  });

  pi.registerTool({
    name: "fb_stop",
    label: "Freebuff agent: hentikan",
    description: "Stop one Freebuff agent (by id) or all agents in the swarm.",
    parameters: Type.Object({
      name: Type.String({
        description: "Agent id to stop, or 'all' to stop every Freebuff agent",
      }),
    }),
    async execute(_toolCallId, params) {
      const out = await run(["stop", params.name]);
      return { content: [{ type: "text", text: out }], details: {} };
    },
  });
}
