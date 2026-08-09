# Multi-AI Native Installer Design

**Date:** 2026-07-22
**Status:** Approved for implementation

## Objective

Evolve this repository from a collection with four partially independent
installers into a target-explicit installer for Claude Code, Codex, Kiro CLI,
Gemini CLI, and Antigravity CLI (`agy`). Each selected target must receive
skills, a common rule, the team agent/orchestrator set, and native integrations
where that platform supports them.

The installer must never auto-select a target, overwrite an existing user file,
or claim that an adapted workflow is native support.

## Confirmed decisions

- Supported targets are exactly `claude`, `codex`, `kiro`, `gemini`, and
  `antigravity` for the first release.
- The user names one or more targets on every invocation; there is no
  auto-detection-driven installation.
- The default scope is user scope. Workspace installation is explicit and
  requires the workspace/project path.
- A re-run is idempotent and non-destructive: an existing destination is
  skipped, not updated or overwritten.
- Native integrations are opt-in because registering plugins, MCP servers, or
  hooks can have side effects and may need an external dependency or network.
- Kiro CLI agent definitions remain JSON. Each target receives its documented
  native format; no agent file is copied unchanged between incompatible
  platforms.

## Architecture

### Canonical content

The existing `skills/` tree remains the canonical source for skill content and
`docs/GLOBAL_RULE.md` remains the canonical common-rule source. The current
agent prompts are normalized into a platform-neutral agent catalog: structured
role metadata plus a Markdown prompt body for each agent. The catalog contains
the team leader and every specialist role already provided by this repository.

The catalog is source material, not an installable platform artifact. It does
not pretend that one agent-file syntax works everywhere.

### Platform adapters

Add `platforms/<target>/` for each supported target. An adapter owns its
templates, render rules, destination mapping, optional integrations, and
verification checks. Its public contract is:

1. `preflight` checks target availability, source completeness, requested scope,
   and required integration dependencies before a write.
2. `install` renders platform artifacts in a temporary directory, then copies
   or marker-merges only destinations that do not already exist.
3. `verify` reports each requested component as installed, existing/unmanaged,
   unavailable, or failed.
4. `capabilities` supplies the row for the support matrix, including whether a
   capability is native, adapted, preview/version-gated, or unavailable.

Generated artifacts are temporary and are not committed. Versioned templates,
manifests, and catalog inputs are committed so they can be reviewed and tested.

### Native artifact mapping

| Target | Skills and common rule | Agent artifact | Integration surface |
|---|---|---|---|
| Claude Code | `~/.claude/skills/`; marker block in `CLAUDE.md` | Markdown with YAML frontmatter in `~/.claude/agents/` or `.claude/agents/` | Claude plugin, MCP, hooks |
| Codex | `$CODEX_HOME/skills/`; marker block in `AGENTS.md` | TOML in `$CODEX_HOME/agents/` | Codex plugin, MCP, config |
| Kiro CLI | `~/.kiro/skills/`; steering rule | JSON in `~/.kiro/agents/` or `.kiro/agents/` | agent resources, MCP, hooks |
| Gemini CLI | `~/.gemini/skills/`; marker block in `GEMINI.md` | Markdown with YAML frontmatter in `~/.gemini/agents/` or `.gemini/agents/` | Gemini extension |
| Antigravity CLI | plugin `skills/` and `rules/` | `agent.md` with YAML frontmatter in the native agent layout | Antigravity plugin, MCP, hooks |

Antigravity is a target name; its executable is `agy`. The Antigravity adapter
must invoke and verify `agy`, not a speculative `antigravity` binary. It must
use Antigravity's plugin/agent commands and layouts rather than assuming Gemini
paths are interchangeable.

## Installer interface

The dispatcher keeps positional targets for continuity with the current README:

```bash
./install/install.sh claude
./install/install.sh codex kiro
./install/install.sh antigravity --scope workspace --project /path/to/app
```

Supported common options:

- `--scope user|workspace`; defaults to `user`.
- `--project <path>`; required for `workspace` scope.
- `--with-integrations`; explicitly requests optional vendor/native integration
  registration after core installation.
- `--dry-run`; renders and reports every planned action without writes or CLI
  registration calls.
- `--verify`; performs only checks and prints a per-component result table.
- `--list-targets`; prints supported targets and their documented support level.

No target means usage error. There is deliberately no no-argument install mode,
no implicit CLI detection, and no `--force` option.

## Installation behavior

For a normal installation, the dispatcher runs:

`preflight -> render into temporary directory -> non-destructive copy/merge -> optional integration registration -> verify -> report`

The core install includes skills, the common rule, and the agent/orchestrator
set. Optional integrations include the vendored or externally installed tools
already documented by this repository, such as Superpowers, Ponytail, Obsidian
Second Brain, CodeGraph, and Graphify. Availability varies by target and is
recorded in the matrix instead of being implied.

Destination collisions are reported as `existing/unmanaged` with their full
path. The installer neither changes nor deletes that file. Existing marker
blocks are recognized and are not merged twice.

If optional integration registration fails after core files have been installed,
the command exits non-zero and reports `partial`, listing completed and failed
steps plus the exact retry command. It does not roll back or remove user
configuration.

## Support matrix and documentation

Add `docs/SUPPORT_MATRIX.md` as the authoritative, human-readable report of
every target/component combination. It must distinguish these states:

- **native**: installed in the platform's documented format or registration
  surface;
- **adapted**: equivalent behavior is supplied by a rule or workflow because a
  native feature is absent;
- **preview/version-gated**: native support exists but the target version must
  be checked;
- **unavailable**: no safe or documented installation route exists.

The README becomes task-oriented: supported targets, target-explicit commands,
scope, dry-run, verify, and a link to the support matrix. Detailed platform
paths and capability caveats live in the matrix and adapter documentation.

## Error handling

The installer fails before writing when it sees an unknown target, missing
target executable, unsupported scope, missing workspace path, incomplete
adapter mapping, invalid generated JSON/TOML/Markdown frontmatter, or an unmet
integration dependency. Error output names the target, failed phase, and a
safe next command.

`skipped` is a successful non-destructive outcome. `partial` is a non-zero
outcome requiring follow-up. The final report is factual and never reports a
component as installed merely because an unrelated file exists.

## Verification and tests

Add isolated installer tests that use a temporary `HOME`, temporary workspace,
and mock executables. They never call a real CLI or mutate a real user config.
The suite covers:

1. Core install and verify for all five targets.
2. Native paths and syntax: Claude Markdown/YAML, Codex TOML, Kiro JSON,
   Gemini Markdown/YAML, Antigravity `agent.md`, and use of the `agy`
   executable.
3. Re-run idempotency and collision safety.
4. `--dry-run` producing no filesystem or registration changes.
5. Successful and failing optional integrations, including accurate `partial`
   reporting.
6. A support-matrix consistency check against adapter capability declarations.

An opt-in manual smoke-test command may exercise installed real CLIs after
installation. It is separate from the automated test suite and never runs by
default.

## Sources checked

- [Claude Code: plugins](https://code.claude.com/docs/en/plugins) and
  [subagents](https://code.claude.com/docs/en/sub-agents)
- [Codex manual](https://developers.openai.com/codex/codex-manual.md)
- [Kiro CLI: custom agents](https://kiro.dev/docs/cli/custom-agents/creating/)
- [Gemini CLI: subagents](https://geminicli.com/docs/core/subagents/) and
  [extensions](https://geminicli.com/docs/extensions/reference/)
- [Antigravity CLI: agents](https://antigravity.google/docs/cli/commands/agents)
  and [plugins](https://antigravity.google/docs/cli-plugins)

## Acceptance criteria

1. A user can explicitly install and verify any supported target without
   affecting another target.
2. Each target receives skills, the common rule, and all defined agents in its
   correct native artifact format.
3. The Kiro adapter produces JSON agents and the Antigravity adapter calls
   `agy`.
4. Existing user files are never overwritten, deleted, or silently changed.
5. Optional integrations require explicit selection and accurately describe
   unsupported or dependency-bound targets.
6. Automated tests verify every adapter, non-destructive behavior, and
   target-specific executable/format expectations.
