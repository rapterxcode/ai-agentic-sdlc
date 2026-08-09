#!/usr/bin/env bash
# Dispatcher: runs the right per-CLI installer(s).
#
# Usage:
#   ./install.sh                      Auto-detect installed CLIs and install into all of them
#   ./install.sh claude codex         Install into specific CLIs only
#   ./install.sh --list                List which CLIs were detected, do nothing else
#
# Extra flags after the CLI name(s) are forwarded as-is to that CLI's script,
# e.g.:
#   ./install.sh claude -- --project ~/code/my-app --set-default-agent
#
# For anything beyond the defaults (per-project installs, default-agent
# switches, the best-effort team-leader agent on Codex/Kiro), call the
# individual install-<cli>.sh script directly — see its --help.
set -euo pipefail
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

detect_claude() { [[ -d "$HOME/.claude" ]] || command -v claude >/dev/null 2>&1; }
detect_codex()  { [[ -d "$HOME/.codex" ]]  || command -v codex  >/dev/null 2>&1; }
detect_gemini() { [[ -d "$HOME/.gemini" ]] || command -v gemini >/dev/null 2>&1; }
detect_kiro()   { [[ -d "$HOME/.kiro" ]]   || command -v kiro-cli >/dev/null 2>&1; }

if [[ "${1:-}" == "--list" ]]; then
  detect_claude && echo "claude: detected"  || echo "claude: not found"
  detect_codex  && echo "codex:  detected"  || echo "codex:  not found"
  detect_gemini && echo "gemini: detected"  || echo "gemini: not found"
  detect_kiro   && echo "kiro:   detected"  || echo "kiro:   not found"
  exit 0
fi

TARGETS=()
EXTRA_ARGS=()
if [[ $# -eq 0 ]]; then
  detect_claude && TARGETS+=("claude")
  detect_codex  && TARGETS+=("codex")
  detect_gemini && TARGETS+=("gemini")
  detect_kiro   && TARGETS+=("kiro")
  if [[ ${#TARGETS[@]} -eq 0 ]]; then
    echo "no supported CLI detected (checked ~/.claude, ~/.codex, ~/.gemini, ~/.kiro, and PATH). Nothing to do." >&2
    exit 1
  fi
else
  while [[ $# -gt 0 ]]; do
    case "$1" in
      claude|codex|gemini|kiro) TARGETS+=("$1"); shift ;;
      --) shift; EXTRA_ARGS=("$@"); break ;;
      *) echo "unknown CLI: $1 (expected: claude codex gemini kiro)" >&2; exit 1 ;;
    esac
  done
fi

echo "Installing into: ${TARGETS[*]}"
echo

for t in "${TARGETS[@]}"; do
  "$REPO_DIR/install/install-$t.sh" "${EXTRA_ARGS[@]}"
  echo
done
