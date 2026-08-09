# External tools

Four tiers, by how much of each product lives in this repo and whether
installing it needs internet access:

1. **Fully vendored, offline install, one script** — Superpowers, Ponytail,
   Obsidian Second Brain. Full source lives under [`vendor/`](../vendor/),
   `install/install-external.sh` installs them via a **local marketplace
   path**, not GitHub. Zero network calls.
2. **Skill content vendored, plugin wrapper not** — Superpowers' `skills/`
   folder specifically, vendored a second time in `skills/superpowers/`
   alongside the other 4 skill collections (see `CREDITS.md`).
3. **Registry-installed, one script, needs internet** — CodeGraph, Graphify.
   `install/install-compiled-tools.sh` runs their real installers for you,
   but can't avoid hitting npm/pypi — explained below.
4. **Referenced only, fully manual** — Understand Anything, Kev's Obsidian
   Ingestion Engine, the LLM Wiki method. Out of scope for this repo's core
   AI-team workflow; links only.

## Tier 1 — vendored, offline, `install-external.sh`

| Tool | What it does | Author / repo | License | Local install |
|---|---|---|---|---|
| **Superpowers** | Full software-delivery methodology as composable Claude Code skills (brainstorming → plan → TDD → review → finish-branch). `docs/WORKFLOW.md` and the agents in `agents/` are built to plug the gaps around it, not replace it. | [obra/superpowers](https://github.com/obra/superpowers) — Jesse Vincent | MIT | `./install/install-external.sh claude` (or `codex`, `gemini`) |
| **Ponytail** | Simplicity/YAGNI filter agent — trims speculative abstractions and premature complexity without weakening required controls (security, audit, tests). Referenced in `docs/GLOBAL_RULE.md`. | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) | MIT | Same script |
| **Obsidian Second Brain** | Self-rewriting Obsidian vault as durable cross-agent memory: 44 commands, session-context hook, vault MCP server. Referenced in `docs/GLOBAL_RULE.md` as the durable-knowledge layer. | [eugeniughelbur/obsidian-second-brain](https://github.com/eugeniughelbur/obsidian-second-brain) — Eugeniu Ghelbur | MIT | Claude Code plugin form: same script (`claude plugin marketplace add vendor/obsidian-second-brain`). Codex/Gemini/OpenCode/Pi form is different — see below |

All three verified installed and `enabled` on the machine this repo was
built on, sourced from `vendor/`, not GitHub (`claude plugin list` /
`codex plugin list`).

**Obsidian Second Brain on Codex/Gemini/OpenCode/Pi** doesn't install into
CLI config at all — it builds a platform-specific bundle and copies it
**into your Obsidian vault directory**. That's a different, more
consequential kind of write (it touches your personal notes, not tool
config), so it's a separate explicit subcommand rather than something
`install-external.sh claude/codex/gemini` does silently:

```bash
./install/install-external.sh vault codex-cli  ~/path/to/your/vault
./install/install-external.sh vault gemini-cli ~/path/to/your/vault
```

Always requires an explicit vault path (never guesses or defaults one),
builds from `vendor/obsidian-second-brain/scripts/build.sh` (no network —
it's pure text templating over the vendored source), then `cp -R` the
result into the path you gave it. No official Kiro CLI support upstream.

**Updating the vendored copies:** all three are frozen at whatever commit
was vendored (2026-07) — they won't pick up upstream changes on their own.
Re-run `rsync -a --exclude='.git' <fresh-clone>/ vendor/<name>/` to refresh,
then bump the version noted in `CREDITS.md`.

## Tier 2 — skill content vendored, plugin wrapper not

Superpowers' `skills/` folder is *also* vendored separately in
`skills/superpowers/` and installed by the normal `install-claude.sh` /
`install-codex.sh` / etc. flow (flat, alongside the other 4 skill
collections). That copy exists independently of the Tier-1 plugin install
above — installing both isn't harmful (same files, two paths), just
redundant; the Tier-1 plugin route additionally gets you the session-start
hook that nudges Claude to check these skills automatically.

## Tier 3 — registry-installed, needs internet, `install-compiled-tools.sh`

CodeGraph and Graphify are compiled tools distributed via npm/pypi with
**platform-specific binaries** — confirmed by inspecting the actual
installed packages on this machine:

- CodeGraph's real footprint is 227MB, of which 226MB is
  `@colbymchenry/codegraph-linux-x64` — a prebuilt binary for this exact
  OS/architecture, auto-selected by npm's optional-dependency mechanism.
- Graphify's `uv tool`-managed venv is 159MB, tied to this machine's Python
  version and platform.

Vendoring either into `vendor/` the way Tier 1 was done would (a) bloat
this repo by ~400MB of binary blobs living permanently in git history, and
(b) only work for people on the same OS/architecture as this machine —
directly defeating the point of "someone else can install this." npm and
uv/pypi already solve cross-platform binary selection correctly; fighting
that with a git-vendored blob is strictly worse.

Instead, `install/install-compiled-tools.sh` automates running their real
installers — same one-command experience as Tier 1, but it does reach
npm/pypi:

```bash
./install/install-compiled-tools.sh              # both
./install/install-compiled-tools.sh codegraph     # just one
./install/install-compiled-tools.sh graphify
```

| Tool | What it does | Author / repo | License | What the script runs |
|---|---|---|---|---|
| **CodeGraph** | SQLite knowledge graph of a codebase (symbols, call paths, blast radius) — one query replaces a grep+read loop. Referenced throughout `docs/GLOBAL_RULE.md`. | [colbymchenry/codegraph](https://github.com/colbymchenry/codegraph) — Colby Mchenry | MIT | Installs via the official `install.sh` if missing, then `codegraph install --yes --target=auto --location=global` (codegraph's own non-interactive flags, confirmed from its source) to wire it into every detected agent |
| **Graphify** | Cross-domain architecture knowledge graph spanning code, Terraform, Kubernetes YAML, SQL, docs, ADRs, PDFs. Used when `graphify-out/graph.json` exists. | [safishamsi/graphify](https://github.com/safishamsi/graphify) — Safi Shamsi | MIT | Installs via `uv tool install graphifyy` (falls back to `pipx`) if missing, then `graphify install --platform <cli>` for each detected CLI |

Both verified end-to-end on this machine (already-installed case: script
detects the binary, skips reinstall, still re-runs registration —
idempotent). One quirk found and fixed while testing: `graphify install
--platform gemini` writes a **project-local** `GEMINI.md`/`.gemini/`
wherever it's invoked from — the script now runs that step from `$HOME`
specifically so it can't leak project files into whatever directory you
happen to run the installer from (it did, into this repo, on the first
test — cleaned up before committing).

## Tier 4 — referenced only, fully manual

| Tool | What it does | Author / repo | License | Install |
|---|---|---|---|---|
| **Understand Anything** | Codebase-understanding / onboarding plugin — analyzes a repo and answers "how does this work" questions. | [Egonex-AI/Understand-Anything](https://github.com/Egonex-AI/Understand-Anything) — Yuxiang Lin | MIT | Claude Code: `/plugin marketplace add Egonex-AI/Understand-Anything` then `/plugin install understand-anything`. Other CLIs: `curl -fsSL https://raw.githubusercontent.com/Egonex-AI/Understand-Anything/main/install.sh \| bash` |
| **Kev's Obsidian Ingestion Engine** | Config-driven video ingestion pipeline (Dropbox → transcript → tagged vault notes). | [kevinbadi/kevs-obsidian-ingestion-engine](https://github.com/kevinbadi/kevs-obsidian-ingestion-engine) — Kevin Bahrabadi | MIT | `git clone https://github.com/kevinbadi/kevs-obsidian-ingestion-engine.git && cd kevs-obsidian-ingestion-engine && npm install && pip3 install -r requirements.txt` (also needs `ffmpeg`/`ffprobe`) |
| **LLM Wiki (Karpathy method)** | Not a tool — a written method for building a local, markdown-only "second brain" with an LLM, no vector DB. | Andrej Karpathy (gist) | — | Read: https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f |
