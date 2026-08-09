# Credits

Everything under `agents/` and `skills/` in this repo is copied (in full or
in the relevant subdirectory) from someone else's open-source work. This
file records exactly where each piece came from. If you are one of the
authors below and want something removed or attributed differently, open an
issue or contact the maintainer of this repo.

External products fall into four tiers — see
[`docs/EXTERNAL_TOOLS.md`](docs/EXTERNAL_TOOLS.md) for the full breakdown:

1. **Fully vendored for offline install**: Superpowers, Ponytail, and
   Obsidian Second Brain's complete source lives under [`vendor/`](vendor/)
   (see below) and installs via a local marketplace path / local build — no
   GitHub required.
2. **Skill content only**: Superpowers' `skills/` are also vendored
   separately in `skills/superpowers/`, same as the other 4 collections.
3. **Registry-installed via one script, needs internet**: CodeGraph and
   Graphify are platform-specific compiled binaries (227MB / 159MB on the
   machine this was built on) — `install/install-compiled-tools.sh` runs
   their real installers instead of vendoring the binaries.
4. **Referenced only, fully manual**: Understand Anything, Kev's Obsidian
   Ingestion Engine, the LLM Wiki method.

## vendor/

| Path in this repo | Original repo | Author | License | Notes |
|---|---|---|---|---|
| `vendor/superpowers/**` | [obra/superpowers](https://github.com/obra/superpowers) | Jesse Vincent | MIT | Full plugin tree (`.claude-plugin/`, `.codex-plugin/`, `hooks/`, `skills/`, `commands/`) minus `.git`, frozen at whatever commit was vendored on 2026-07. Installed via `install/install-external.sh`, which points `claude`/`codex plugin marketplace add` at this local directory instead of GitHub |
| `vendor/ponytail/**` | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) | Dietrich Gebert | MIT | Same treatment as superpowers above |
| `vendor/obsidian-second-brain/**` | [eugeniughelbur/obsidian-second-brain](https://github.com/eugeniughelbur/obsidian-second-brain) | Eugeniu Ghelbur | MIT | Full source (`.claude-plugin/`, `adapters/`, `scripts/build.sh`, `commands/`, `dist/`). Claude Code form installs the same way as superpowers/ponytail above. Codex/Gemini/OpenCode/Pi form is vault-targeted, not CLI-config-targeted — see `install-external.sh vault <platform> <vault-path>` and `docs/EXTERNAL_TOOLS.md` |

## agents/

| Path in this repo | Original source | Author | License |
|---|---|---|---|
| `agents/project-agents/*.md`, `agents/user-agents/*.md` | [claude-agents-superpowers](https://github.com) subagent pack, part of the `sub-agent-team-ai` collection, designed to plug review-gate gaps around [obra/superpowers](https://github.com/obra/superpowers) | (bundled/authored alongside this collection; see the pack's own README for detail) | Not separately licensed in the source pack — treat as MIT-equivalent to match this repo's `LICENSE`, and re-check upstream if you find a formal license file |
| `docs/GLOBAL_RULE.md`, `docs/WORKFLOW.md`, `docs/superpowers-gates-CLAUDE.md` | same pack as above | same | same |

## skills/

| Path in this repo | Original repo | Author | License | Notes |
|---|---|---|---|---|
| `skills/9arm-skills/**` | [thananon/9arm-skills](https://github.com/thananon/9arm-skills) | thananon | Check upstream repo (no `LICENSE` file was present in the vendored copy — verify before redistributing) | engineering / misc / productivity skill categories, copied as-is |
| `skills/mattpocock-skills/**` | [mattpocock/skills](https://github.com/mattpocock/skills) | Matt Pocock | MIT | includes `deprecated/` and `in-progress/` categories, kept as upstream organized them |
| `skills/andrej-karpathy-guidelines/**` | [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) | forrestchang | MIT | "Behavioral guidelines to reduce common LLM coding mistakes," explicitly derived from [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876) on LLM coding pitfalls. Ships two forms: `SKILL.md` (skill, installed by this repo's scripts) and `CLAUDE.md` (drop-in project file, upstream's "Option B" — install manually, see `README.th.md`). `README.th.md` is a Thai-language explainer added in this repo, not part of upstream |
| `skills/loop-engineering/**` | [cobusgreyling/loop-engineering](https://github.com/cobusgreyling/loop-engineering) | Cobus Greyling and contributors | MIT | `loop-budget`, `loop-constraints`, `loop-triage`, `loop-verifier`, `minimal-fix` |
| `skills/superpowers/**` | [obra/superpowers](https://github.com/obra/superpowers) | Jesse Vincent | MIT | 14 skills covering the full delivery lifecycle: `brainstorming`, `writing-plans`, `executing-plans`, `subagent-driven-development`, `test-driven-development`, `systematic-debugging`, `using-git-worktrees`, `requesting-code-review`, `receiving-code-review`, `verification-before-completion`, `finishing-a-development-branch`, `dispatching-parallel-agents`, `using-superpowers`, `writing-skills`. Only the skill content is vendored — the plugin's session-start hook (which nudges Claude to check these automatically) is **not** included; install the plugin itself if you want that enforcement, see `docs/EXTERNAL_TOOLS.md` |

## Registry-installed (Tier 3) and reference-only (Tier 4)

See [`docs/EXTERNAL_TOOLS.md`](docs/EXTERNAL_TOOLS.md) for:

- **CodeGraph** — colbymchenry/codegraph (Colby Mchenry), MIT — installed via `install-compiled-tools.sh`
- **Graphify** — safishamsi/graphify (Safi Shamsi), MIT — installed via `install-compiled-tools.sh`
- **Understand Anything** — Egonex-AI/Understand-Anything (Yuxiang Lin), MIT
- **Kev's Obsidian Ingestion Engine** — kevinbadi/kevs-obsidian-ingestion-engine (Kevin Bahrabadi), MIT
- **LLM Wiki method** — Andrej Karpathy (gist), doc pointer only

## A note on license accuracy

License text above was read directly from each source repository's
`LICENSE` file (or `pyproject.toml` / `package.json` license field) at the
time this repo was assembled (2026-07). Licenses can change upstream —
if you plan to redistribute this repo further, re-verify against the
current upstream repos rather than trusting this snapshot indefinitely.
