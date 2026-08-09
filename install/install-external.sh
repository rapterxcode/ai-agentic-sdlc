#!/usr/bin/env bash
# Installs the vendored external plugins (Superpowers, Ponytail, Obsidian
# Second Brain) from THIS repo's vendor/ directory — using local marketplace
# sources, never GitHub. This is what makes install/ fully offline-capable
# for anyone who clones this repo: no network round-trip to
# obra/superpowers, DietrichGebert/ponytail, or
# eugeniughelbur/obsidian-second-brain is needed.
#
# Not covered here (documented in docs/EXTERNAL_TOOLS.md instead):
#   - CodeGraph / Graphify: compiled CLIs distributed via npm/pypi, not
#     plugin-marketplace format. Vendoring them offline would mean bundling
#     a full node_modules/build toolchain or pre-built binaries — a
#     materially bigger, more fragile undertaking than copying markdown.
#     Install those from their own registry as documented.
#
# Usage:
#   ./install-external.sh                 # claude/codex/gemini plugin installs, all detected CLIs
#   ./install-external.sh claude codex    # specific ones only
#
#   ./install-external.sh vault <platform> <vault-path>
#       Builds Obsidian Second Brain for <platform> (codex-cli, gemini-cli,
#       opencode, or pi) from the vendored source and copies the result into
#       <vault-path> — YOUR Obsidian vault, not CLI config. Always requires
#       an explicit vault path; never guesses or defaults one, since this
#       writes files into your personal notes. Example:
#         ./install-external.sh vault codex-cli ~/Obsidian-Brain/Second-Brain
set -euo pipefail
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENDOR="$REPO_DIR/vendor"

install_claude() {
  if ! command -v claude >/dev/null 2>&1; then echo "claude not found, skip"; return; fi
  echo "== Claude Code =="
  claude plugin marketplace add "$VENDOR/superpowers"
  claude plugin install superpowers@superpowers-dev
  claude plugin marketplace add "$VENDOR/ponytail"
  claude plugin install ponytail@ponytail
  claude plugin marketplace add "$VENDOR/obsidian-second-brain"
  claude plugin install obsidian-second-brain@obsidian-second-brain
  echo "  note: Obsidian Second Brain also needs OBSIDIAN_VAULT_PATH set in"
  echo "  ~/.claude/settings.json 'env' — this script does not set it for you."
}

install_codex() {
  if ! command -v codex >/dev/null 2>&1; then echo "codex not found, skip"; return; fi
  echo "== Codex CLI =="
  codex plugin marketplace add "$VENDOR/superpowers"
  codex plugin add superpowers@superpowers-dev
  codex plugin marketplace add "$VENDOR/ponytail"
  codex plugin add ponytail@ponytail
  echo "  Obsidian Second Brain has no Codex plugin form — use:"
  echo "  ./install-external.sh vault codex-cli <your-vault-path>"
}

install_gemini() {
  if ! command -v gemini >/dev/null 2>&1; then echo "gemini not found, skip"; return; fi
  echo "== Gemini CLI =="
  gemini extensions install "$VENDOR/superpowers" --auto-update
  gemini extensions install "$VENDOR/ponytail" --auto-update
  echo "  Obsidian Second Brain has no Gemini extension form — use:"
  echo "  ./install-external.sh vault gemini-cli <your-vault-path>"
}

install_vault() {
  local platform="${1:?platform required: codex-cli, gemini-cli, opencode, or pi}"
  local vault_path="${2:?vault path required — this writes into that directory}"
  if [[ ! -d "$vault_path" ]]; then
    echo "error: vault path does not exist: $vault_path" >&2
    exit 1
  fi
  echo "== Obsidian Second Brain ($platform) -> $vault_path =="
  bash "$VENDOR/obsidian-second-brain/scripts/build.sh" --platform "$platform"
  local dist_dir="$VENDOR/obsidian-second-brain/dist/$platform"
  if [[ ! -d "$dist_dir" ]]; then
    echo "error: build did not produce $dist_dir" >&2
    exit 1
  fi
  cp -R "$dist_dir/." "$vault_path/"
  echo "  copied $dist_dir/. -> $vault_path/"
  echo "  see $dist_dir/INSTALL.md for platform-specific notes"
}

if [[ "${1:-}" == "vault" ]]; then
  shift
  install_vault "$@"
  exit 0
fi

targets=("$@")
if [[ ${#targets[@]} -eq 0 ]]; then
  targets=(claude codex gemini)
fi

for t in "${targets[@]}"; do
  case "$t" in
    claude) install_claude ;;
    codex) install_codex ;;
    gemini) install_gemini ;;
    *) echo "unknown target: $t (expected: claude codex gemini, or 'vault <platform> <path>')" >&2; exit 1 ;;
  esac
  echo
done
