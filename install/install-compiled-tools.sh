#!/usr/bin/env bash
# Installs CodeGraph and Graphify by running their own official installers.
#
# Unlike install-external.sh, this DOES need internet access — CodeGraph and
# Graphify are compiled tools distributed via npm/pypi with platform-specific
# binaries (226MB / 159MB respectively on this machine, Linux-x64-locked),
# not plugin-marketplace-format packages. Vendoring those binaries into this
# repo would bloat it by ~400MB and only work for people on the same OS/arch
# — see docs/EXTERNAL_TOOLS.md for the full reasoning. This script just runs
# their real installers for you instead of you doing it by hand.
#
# Usage:
#   ./install-compiled-tools.sh                 # both tools, all detected CLIs
#   ./install-compiled-tools.sh codegraph        # just one
#   ./install-compiled-tools.sh graphify
set -euo pipefail

install_codegraph() {
  echo "== CodeGraph =="
  if ! command -v codegraph >/dev/null 2>&1; then
    echo "  codegraph not found — installing via official script (needs internet)"
    curl -fsSL https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.sh | sh
  else
    echo "  codegraph already on PATH ($(command -v codegraph)), skipping binary install"
  fi
  echo "  wiring into detected agents (non-interactive: install --yes --target=auto --location=global)"
  codegraph install --yes --target=auto --location=global
}

install_graphify() {
  echo "== Graphify =="
  if ! command -v graphify >/dev/null 2>&1; then
    if command -v uv >/dev/null 2>&1; then
      echo "  graphify not found — installing via uv tool (needs internet)"
      uv tool install graphifyy
    elif command -v pipx >/dev/null 2>&1; then
      echo "  graphify not found — installing via pipx (needs internet)"
      pipx install graphifyy
    else
      echo "  error: neither uv nor pipx found. Install one first (see docs/EXTERNAL_TOOLS.md)." >&2
      return 1
    fi
  else
    echo "  graphify already on PATH ($(command -v graphify)), skipping binary install"
  fi
  # Run from $HOME, not the caller's cwd: `graphify install --platform gemini`
  # also writes a PROJECT-local GEMINI.md/.gemini/ wherever it's invoked from
  # (discovered while testing this script from inside this repo — it wrote
  # graphify project files into the repo itself). Global registration
  # (settings.json hook, ~/.gemini/skills/) still happens either way.
  for pair in "claude:claude" "codex:codex" "gemini:gemini" "kiro:kiro-cli"; do
    local platform="${pair%%:*}" binary="${pair##*:}"
    if command -v "$binary" >/dev/null 2>&1; then
      echo "  registering with $platform"
      (cd "$HOME" && graphify install --platform "$platform") || echo "    (skipped — already registered or not applicable)"
    fi
  done
}

targets=("$@")
if [[ ${#targets[@]} -eq 0 ]]; then
  targets=(codegraph graphify)
fi

for t in "${targets[@]}"; do
  case "$t" in
    codegraph) install_codegraph ;;
    graphify) install_graphify ;;
    *) echo "unknown target: $t (expected: codegraph graphify)" >&2; exit 1 ;;
  esac
  echo
done
