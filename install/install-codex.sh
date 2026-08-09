#!/usr/bin/env bash
# Install this repo's skills / agents / global-rule into Codex CLI.
#
# Verified against codex-cli 0.144.6 (official docs + local install):
#   - SKILLS: Codex discovers user skills at ~/.agents/skills (the cross-tool
#     Agent Skills path), NOT ~/.codex/skills (that is the bundled *system*
#     scope, marked by .codex-system-skills.marker). Earlier versions of this
#     script installed to ~/.codex/skills, where Codex would not discover them.
#     Invoke a skill with `$skill-name` or let Codex auto-match its description.
#   - SUBAGENTS: supported (features.multi_agent, on by default). Custom agents
#     are TOML files in ~/.codex/agents/*.toml (user) or .codex/agents/*.toml
#     (project): name/description/developer_instructions required.
#   - DEFAULT AGENT: Codex has no default-agent selector. Orchestration behavior
#     lives in AGENTS.md (root agent), which can spawn the specialist agents; or
#     switch threads at runtime with /agent.
#
# Usage:
#   ./install-codex.sh [--project <path>] [--skip-skills] [--skip-global-rule]
#                      [--install-agents]
#
#   --project <path>     Install into <path>/.agents/skills, <path>/.codex/agents,
#                        and merge the global rule + Karpathy guidelines into
#                        <path>/AGENTS.md.
#   --install-agents     Install the full Codex agent roster from
#                        agents/codex-agents/*.toml (aidlc-lead, team-leader, and
#                        the 8 specialists). ON BY DEFAULT — pass --skip-agents to
#                        skip. (--install-team-leader-agent alias.)
#   --skip-agents        Don't install the agent roster.
set -euo pipefail
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=lib.sh
source "$REPO_DIR/install/lib.sh"

PROJECT_PATH=""
DO_SKILLS=1
DO_GLOBAL_RULE=1
DO_AGENTS=1

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project) PROJECT_PATH="$2"; shift 2 ;;
    --skip-skills) DO_SKILLS=0; shift ;;
    --skip-global-rule) DO_GLOBAL_RULE=0; shift ;;
    --skip-agents) DO_AGENTS=0; shift ;;
    --install-agents|--install-team-leader-agent) DO_AGENTS=1; shift ;;
    -h|--help) grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown argument: $1" >&2; exit 1 ;;
  esac
done

if [[ -n "$PROJECT_PATH" ]]; then
  if [[ ! -d "$PROJECT_PATH" ]]; then echo "error: --project path does not exist: $PROJECT_PATH" >&2; exit 1; fi
  ABS="$(cd "$PROJECT_PATH" && pwd)"
  SKILLS_DIR="$ABS/.agents/skills"
  AGENTS_DIR="$ABS/.codex/agents"
  RULE_FILE="$ABS/AGENTS.md"
  SCOPE_LABEL="workspace ($ABS)"
else
  CODEX_DIR="${CODEX_HOME:-$HOME/.codex}"
  SKILLS_DIR="${AGENTS_SKILLS_HOME:-$HOME/.agents/skills}"
  AGENTS_DIR="$CODEX_DIR/agents"
  RULE_FILE="$CODEX_DIR/AGENTS.md"
  SCOPE_LABEL="global (skills: $SKILLS_DIR, agents: $AGENTS_DIR)"
fi

echo "== Codex CLI =="
echo "Scope: $SCOPE_LABEL"

if [[ "$DO_SKILLS" == 1 ]]; then
  echo "Installing skills -> $SKILLS_DIR"
  echo "  (Codex discovers user skills here — the cross-tool ~/.agents/skills path, not ~/.codex/skills)"
  install_skills_flat "$REPO_DIR/skills" "$SKILLS_DIR"
fi

if [[ "$DO_GLOBAL_RULE" == 1 ]]; then
  echo "Merging global rule -> $RULE_FILE"
  echo "  (this repo does not remove or edit any existing marker blocks already in AGENTS.md)"
  merge_marked_block "$REPO_DIR/docs/GLOBAL_RULE.md" "$RULE_FILE" "AI_TEAM_GLOBAL_RULE"
  echo "Merging Karpathy guidelines -> $RULE_FILE"
  merge_marked_block "$REPO_DIR/skills/andrej-karpathy-guidelines/CLAUDE.md" "$RULE_FILE" "AI_TEAM_KARPATHY_GUIDELINES"
fi

if [[ "$DO_AGENTS" == 1 ]]; then
  echo "Installing Codex agent roster -> $AGENTS_DIR"
  copy_files_if_missing "$AGENTS_DIR" "$REPO_DIR"/agents/codex-agents/*.toml
  echo "Merging AI-DLC orchestration gate-map -> $RULE_FILE"
  echo "  (root-agent orchestration: Codex has no default-agent + depth-1 nesting, so the root drives /aidlc)"
  merge_marked_block "$REPO_DIR/docs/AIDLC_ORCHESTRATION.md" "$RULE_FILE" "AI_TEAM_AIDLC_ORCHESTRATION"
fi

echo
echo "Done."
if [[ "$DO_AGENTS" == 1 ]]; then
  cat <<'EOF'

Codex has no default-agent switch. To run the AI-DLC workflow:
  - invoke the skill with `$aidlc` (or let Codex auto-match it), and
  - have the root agent orchestrate per the global rule in AGENTS.md,
    delegating to the installed specialist agents (spawn subagents / `/agent`).
Note: Codex agents.max_depth defaults to 1 (the root can spawn specialists,
but those specialists cannot spawn further subagents unless you raise it).
EOF
fi
