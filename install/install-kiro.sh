#!/usr/bin/env bash
# Install this repo's skills / agents / global-rule into Kiro CLI.
#
# Verified against kiro-cli 2.13.0 (amazon-q-developer-cli lineage): classic
# JSON agents, subagent delegation via toolsSettings.subagent, skills auto-
# register as /<name> slash commands, and a real default-agent switch (global
# via `kiro-cli agent set-default`, workspace via `kiro-cli settings
# --workspace chat.defaultAgent`).
#
# Usage:
#   ./install-kiro.sh [--project <path>] [--skip-skills] [--skip-global-rule]
#                     [--install-agents] [--set-default-agent] [--default-agent <name>]
#
#   --project <path>              Install into <path>/.kiro/ (workspace scope)
#                                 instead of ~/.kiro/ (global). Workspace skills
#                                 and agents override global ones of the same
#                                 name and travel with the repo (git-committable).
#   --install-agents              Install the full Kiro agent roster from
#                                 agents/kiro-agents/*.json into <target>/.kiro/agents/
#                                 (aidlc-lead, team-leader, researcher,
#                                 plan-reviewer, security-auditor,
#                                 test-quality-auditor, devsecops-engineer,
#                                 fullstack-engineer, platform-engineer,
#                                 test-engineer). ON BY DEFAULT — pass --skip-agents
#                                 to skip. Skips files that already exist.
#                                 (--install-team-leader-agent is kept as an alias.)
#   --skip-agents                 Don't install the agent roster.
#   --set-default-agent           Requires the roster installed (or the target
#                                 agent JSON already present) and `kiro-cli` on
#                                 PATH. Global: kiro-cli agent set-default "<name>".
#                                 With --project: kiro-cli settings --workspace
#                                 chat.defaultAgent "<name>" (run in <path>).
#                                 Default target is `aidlc-lead` (the write-capable
#                                 /aidlc orchestrator). Override with --default-agent.
#   --default-agent <name>        Which agent --set-default-agent points at
#                                 (default: aidlc-lead; e.g. team-leader for the
#                                 read-only orchestrator).
set -euo pipefail
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=lib.sh
source "$REPO_DIR/install/lib.sh"

PROJECT_PATH=""
DO_SKILLS=1
DO_GLOBAL_RULE=1
DO_AGENTS=1
SET_DEFAULT_AGENT=0
DEFAULT_AGENT="aidlc-lead"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project) PROJECT_PATH="$2"; shift 2 ;;
    --skip-skills) DO_SKILLS=0; shift ;;
    --skip-global-rule) DO_GLOBAL_RULE=0; shift ;;
    --skip-agents) DO_AGENTS=0; shift ;;
    --install-agents|--install-team-leader-agent) DO_AGENTS=1; shift ;;
    --set-default-agent) SET_DEFAULT_AGENT=1; shift ;;
    --default-agent) DEFAULT_AGENT="$2"; shift 2 ;;
    -h|--help) grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown argument: $1" >&2; exit 1 ;;
  esac
done

# Resolve the target .kiro directory: workspace (<path>/.kiro) or global (~/.kiro).
if [[ -n "$PROJECT_PATH" ]]; then
  if [[ ! -d "$PROJECT_PATH" ]]; then
    echo "error: --project path does not exist: $PROJECT_PATH" >&2
    exit 1
  fi
  ABS_PROJECT="$(cd "$PROJECT_PATH" && pwd)"
  KIRO_DIR="$ABS_PROJECT/.kiro"
  SCOPE_LABEL="workspace ($ABS_PROJECT)"
else
  KIRO_DIR="${KIRO_HOME:-$HOME/.kiro}"
  SCOPE_LABEL="global ($KIRO_DIR)"
fi

echo "== Kiro CLI =="
echo "Scope: $SCOPE_LABEL"

if [[ "$DO_SKILLS" == 1 ]]; then
  echo "Installing skills -> $KIRO_DIR/skills"
  install_skills_flat "$REPO_DIR/skills" "$KIRO_DIR/skills"
fi

if [[ "$DO_GLOBAL_RULE" == 1 ]]; then
  echo "Merging global rule -> $KIRO_DIR/steering/ai-team-global-rule.md"
  merge_marked_block "$REPO_DIR/docs/GLOBAL_RULE.md" "$KIRO_DIR/steering/ai-team-global-rule.md" "AI_TEAM_GLOBAL_RULE"
  echo "Merging Karpathy guidelines -> $KIRO_DIR/steering/ai-team-karpathy-guidelines.md"
  merge_marked_block "$REPO_DIR/skills/andrej-karpathy-guidelines/CLAUDE.md" "$KIRO_DIR/steering/ai-team-karpathy-guidelines.md" "AI_TEAM_KARPATHY_GUIDELINES"
fi

if [[ "$DO_AGENTS" == 1 ]]; then
  echo "Installing Kiro agent roster -> $KIRO_DIR/agents"
  copy_files_if_missing "$KIRO_DIR/agents" "$REPO_DIR"/agents/kiro-agents/*.json
fi

if [[ "$SET_DEFAULT_AGENT" == 1 ]]; then
  if [[ ! -f "$KIRO_DIR/agents/$DEFAULT_AGENT.json" ]]; then
    echo "error: --set-default-agent needs '$DEFAULT_AGENT' installed first (add --install-agents, or pass --default-agent <name>)" >&2
    exit 1
  fi
  if ! command -v kiro-cli >/dev/null 2>&1; then
    echo "error: kiro-cli not found on PATH. Run manually once it is installed:" >&2
    if [[ -n "$PROJECT_PATH" ]]; then
      echo "  (cd \"$ABS_PROJECT\" && kiro-cli settings --workspace chat.defaultAgent \"$DEFAULT_AGENT\")" >&2
    else
      echo "  kiro-cli agent set-default \"$DEFAULT_AGENT\"" >&2
    fi
    exit 1
  fi
  if [[ -n "$PROJECT_PATH" ]]; then
    ( cd "$ABS_PROJECT" && kiro-cli settings --workspace chat.defaultAgent "$DEFAULT_AGENT" )
    echo "Set workspace default agent -> $DEFAULT_AGENT (in $ABS_PROJECT/.kiro/settings/cli.json)"
  else
    kiro-cli agent set-default "$DEFAULT_AGENT"
    echo "Set global default agent -> $DEFAULT_AGENT"
  fi
fi

echo
echo "Done."
if [[ "$DO_AGENTS" == 1 ]]; then
  if [[ -n "$PROJECT_PATH" ]]; then
    cat <<EOF

Next (workspace scope): the /aidlc command comes from $ABS_PROJECT/.kiro/skills/aidlc/.
Run kiro-cli from inside the project so it picks up the workspace agents/skills:

  cd "$ABS_PROJECT"
  kiro-cli chat --agent aidlc-lead      # or set workspace default (above), then: kiro-cli chat
  > /aidlc build the CSV export feature
EOF
  else
    cat <<'EOF'

Next: the /aidlc command is provided by the installed `aidlc` skill
(~/.kiro/skills/aidlc/). Launch a session on the orchestrator and run it:

  kiro-cli chat --agent aidlc-lead      # or set it as default (above), then just: kiro-cli chat
  > /aidlc build the CSV export feature
EOF
  fi
  cat <<'EOF'

aidlc-lead drives the SDLC phases and delegates review gates + heavy
implementation to the specialist sub-agents (plan-reviewer, security-auditor,
test-quality-auditor, devsecops-engineer, fullstack/platform/test engineers).
EOF
fi
