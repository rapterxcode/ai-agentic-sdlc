#!/usr/bin/env bash
# Install this repo's skills / agents / global-rule into Gemini CLI.
#
# Verified against gemini-cli 0.51.0 (official docs):
#   - SKILLS: discovered at ~/.gemini/skills/ (user) or .gemini/skills/ (workspace);
#     auto-activated by description match + a consent prompt. There is NO per-skill
#     slash command — `/skills` is only for management. So the AI-DLC skill runs by
#     description match, not by typing `/aidlc`.
#   - SUBAGENTS: supported. Custom subagents are markdown+frontmatter in
#     ~/.gemini/agents/*.md (user) or .gemini/agents/*.md (project). IMPORTANT:
#     a Gemini subagent CANNOT spawn another subagent — so the orchestrator role
#     (aidlc-lead) works best as the MAIN agent persona (via GEMINI.md), delegating
#     to the specialist subagents. Invoke a specialist directly with `@name`.
#   - DEFAULT AGENT: none. The main-agent persona comes from GEMINI.md only.
#
# Usage:
#   ./install-gemini.sh [--project <path>] [--skip-skills] [--skip-global-rule]
#                       [--install-agents]
#
#   --project <path>     Install into <path>/.gemini/{skills,agents} and merge the
#                        global rule + Karpathy guidelines into
#                        <path>/.gemini/GEMINI.md.
#   --install-agents     Install the full Gemini subagent roster from
#                        agents/gemini-agents/*.md (the 8 specialists + aidlc-lead
#                        + team-leader). ON BY DEFAULT — pass --skip-agents to skip.
#                        Delegate to a specialist with @name.
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
    --install-agents) DO_AGENTS=1; shift ;;
    -h|--help) grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown argument: $1" >&2; exit 1 ;;
  esac
done

if [[ -n "$PROJECT_PATH" ]]; then
  if [[ ! -d "$PROJECT_PATH" ]]; then echo "error: --project path does not exist: $PROJECT_PATH" >&2; exit 1; fi
  ABS="$(cd "$PROJECT_PATH" && pwd)"
  GEMINI_DIR="$ABS/.gemini"
  SCOPE_LABEL="workspace ($GEMINI_DIR)"
else
  GEMINI_DIR="${GEMINI_CONFIG_DIR:-$HOME/.gemini}"
  SCOPE_LABEL="global ($GEMINI_DIR)"
fi

echo "== Gemini CLI =="
echo "Scope: $SCOPE_LABEL"

if [[ "$DO_SKILLS" == 1 ]]; then
  echo "Installing skills -> $GEMINI_DIR/skills"
  install_skills_flat "$REPO_DIR/skills" "$GEMINI_DIR/skills"
fi

if [[ "$DO_GLOBAL_RULE" == 1 ]]; then
  echo "Merging global rule -> $GEMINI_DIR/GEMINI.md"
  merge_marked_block "$REPO_DIR/docs/GLOBAL_RULE.md" "$GEMINI_DIR/GEMINI.md" "AI_TEAM_GLOBAL_RULE"
  echo "Merging Karpathy guidelines -> $GEMINI_DIR/GEMINI.md"
  merge_marked_block "$REPO_DIR/skills/andrej-karpathy-guidelines/CLAUDE.md" "$GEMINI_DIR/GEMINI.md" "AI_TEAM_KARPATHY_GUIDELINES"
fi

if [[ "$DO_AGENTS" == 1 ]]; then
  echo "Installing Gemini subagent roster -> $GEMINI_DIR/agents"
  copy_files_if_missing "$GEMINI_DIR/agents" "$REPO_DIR"/agents/gemini-agents/*.md
  echo "Merging AI-DLC orchestration gate-map -> $GEMINI_DIR/GEMINI.md"
  echo "  (main-agent orchestration: Gemini has no default-agent + no sub-agent recursion, so the main session drives /aidlc)"
  merge_marked_block "$REPO_DIR/docs/AIDLC_ORCHESTRATION.md" "$GEMINI_DIR/GEMINI.md" "AI_TEAM_AIDLC_ORCHESTRATION"
fi

echo
echo "Done."
if [[ "$DO_AGENTS" == 1 ]]; then
  cat <<'EOF'

Gemini has no default-agent and no per-skill slash command. To run the workflow:
  - the AI-DLC skill auto-activates when your request matches its description
    (e.g. "run the AI-DLC workflow to build ..."), then asks for consent;
  - delegate a review/implementation step to a specialist with @name, e.g.
    `@plan-reviewer check this plan` or `@security-auditor audit the auth code`.
Note: Gemini subagents cannot spawn other subagents, so the orchestrator role
(aidlc-lead) is best driven from the main session (GEMINI.md carries the global
rule); the main agent delegates to the specialist subagents.
EOF
fi
