#!/usr/bin/env bash
# Install this repo's skills/agents into Claude Code.
#
# Verified against Claude Code 2.1.216: skills at ~/.claude/skills/<name>/ (invoked
# both auto and as /skill-name), sub-agents are markdown+frontmatter in
# ~/.claude/agents/ (user) or <project>/.claude/agents/ (project), and the default
# agent is set via the `agent` key in settings.json (or the --agent CLI flag).
#
# Usage:
#   ./install-claude.sh [--project <path>] [--set-default-agent] [--default-agent <name>]
#                        [--skip-skills] [--skip-agents] [--skip-global-rule]
#
#   --project <path>        Also install the FULL agent roster into
#                            <path>/.claude/agents/, and merge the superpowers
#                            review-gate hooks into <path>/CLAUDE.md.
#   --set-default-agent      Set the default agent. Global by default
#                            (~/.claude/settings.json). With --project, sets it in
#                            <path>/.claude/settings.json instead. Default target
#                            is `aidlc-lead` (the write-capable /aidlc orchestrator).
#   --default-agent <name>   Which agent --set-default-agent points at
#                            (default: aidlc-lead; e.g. team-leader for the
#                            read-only orchestrator).
#   --skip-skills            Don't touch ~/.claude/skills/
#   --skip-agents             Don't touch ~/.claude/agents/
#   --skip-global-rule        Don't touch ~/.claude/CLAUDE.md (skips both the
#                             global rule and the Karpathy guidelines merge)
set -euo pipefail
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=lib.sh
source "$REPO_DIR/install/lib.sh"

CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
PROJECT_PATH=""
SET_DEFAULT_AGENT=0
DEFAULT_AGENT="aidlc-lead"
DO_SKILLS=1
DO_AGENTS=1
DO_GLOBAL_RULE=1

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project) PROJECT_PATH="$2"; shift 2 ;;
    --set-default-agent) SET_DEFAULT_AGENT=1; shift ;;
    --default-agent) DEFAULT_AGENT="$2"; shift 2 ;;
    --skip-skills) DO_SKILLS=0; shift ;;
    --skip-agents) DO_AGENTS=0; shift ;;
    --install-agents|--install-team-leader-agent) DO_AGENTS=1; shift ;;
    --skip-global-rule) DO_GLOBAL_RULE=0; shift ;;
    -h|--help) grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown argument: $1" >&2; exit 1 ;;
  esac
done

echo "== Claude Code =="

if [[ "$DO_SKILLS" == 1 ]]; then
  echo "Installing personal skills -> $CLAUDE_DIR/skills"
  install_skills_flat "$REPO_DIR/skills" "$CLAUDE_DIR/skills"
fi

if [[ "$DO_AGENTS" == 1 ]]; then
  echo "Installing user-level agent roster -> $CLAUDE_DIR/agents"
  # Full roster so aidlc-lead can delegate to every specialist at user scope:
  # orchestrators + reviewers (project-agents/) + implementers (user-agents/).
  copy_files_if_missing "$CLAUDE_DIR/agents" \
    "$REPO_DIR"/agents/project-agents/*.md \
    "$REPO_DIR"/agents/user-agents/*.md
fi

if [[ "$DO_GLOBAL_RULE" == 1 ]]; then
  echo "Merging global rule -> $CLAUDE_DIR/CLAUDE.md"
  merge_marked_block "$REPO_DIR/docs/GLOBAL_RULE.md" "$CLAUDE_DIR/CLAUDE.md" "AI_TEAM_GLOBAL_RULE"
  echo "Merging Karpathy guidelines -> $CLAUDE_DIR/CLAUDE.md"
  merge_marked_block "$REPO_DIR/skills/andrej-karpathy-guidelines/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md" "AI_TEAM_KARPATHY_GUIDELINES"
fi

if [[ -n "$PROJECT_PATH" ]]; then
  echo "Installing project-scoped agent roster -> $PROJECT_PATH/.claude/agents"
  copy_files_if_missing "$PROJECT_PATH/.claude/agents" "$REPO_DIR"/agents/project-agents/*.md

  echo "Merging superpowers review gates -> $PROJECT_PATH/CLAUDE.md"
  echo "  (no-op behaviorally unless the obra/superpowers plugin is also installed there — see docs/EXTERNAL_TOOLS.md)"
  merge_marked_block "$REPO_DIR/docs/superpowers-gates-CLAUDE.md" "$PROJECT_PATH/CLAUDE.md" "AI_TEAM_REVIEW_GATES"
fi

if [[ "$SET_DEFAULT_AGENT" == 1 ]]; then
  if [[ -n "$PROJECT_PATH" ]]; then
    set_json_agent "$PROJECT_PATH/.claude/settings.json" "$DEFAULT_AGENT"
  else
    set_json_agent "$CLAUDE_DIR/settings.json" "$DEFAULT_AGENT"
  fi
fi

cat <<EOF

Done. If ~/.claude/agents/ or ~/.claude/skills/ didn't exist before this run,
restart Claude Code once so it picks up the new top-level directories.

Run the workflow (default agent = ${DEFAULT_AGENT}):
  claude --agent aidlc-lead
  > /aidlc build the CSV export feature

aidlc-lead drives the SDLC phases and delegates review gates + heavy
implementation to the specialist sub-agents. Verify agents with: type @ in a
prompt (or @agent-<name>) and check they appear in typeahead.
EOF
