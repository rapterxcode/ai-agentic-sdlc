#!/usr/bin/env bash
# Shared helpers for install-*.sh. Sourced, not executed directly.

# merge_marked_block <source-md-file> <dest-md-file> <MARKER_NAME>
# Appends source content between "<!-- MARKER_NAME_START -->" / "_END -->"
# markers. Idempotent: does nothing if the marker is already present, and
# never touches the rest of dest-md-file. Creates dest-md-file if missing.
merge_marked_block() {
  local src="$1" dest="$2" marker="$3"
  local start="<!-- ${marker}_START -->"
  local end="<!-- ${marker}_END -->"

  mkdir -p "$(dirname "$dest")"
  touch "$dest"

  if grep -qF "$start" "$dest" 2>/dev/null; then
    echo "  already merged: $marker in $dest (skipped)"
    return 0
  fi

  {
    echo ""
    echo "$start"
    cat "$src"
    echo "$end"
  } >>"$dest"
  echo "  merged: $marker -> $dest"
}

# set_json_agent <settings-json-file> <agent-name>
# Safely sets {"agent": "<agent-name>"} in a JSON file without clobbering
# other keys. Creates the file (and parent dir) if missing. Aborts loudly
# instead of guessing if the existing file isn't valid JSON.
set_json_agent() {
  local file="$1" agent="$2"
  mkdir -p "$(dirname "$file")"
  python3 - "$file" "$agent" <<'PYEOF'
import json, sys, pathlib

path, agent = pathlib.Path(sys.argv[1]), sys.argv[2]
data = {}
if path.exists() and path.stat().st_size > 0:
    try:
        data = json.loads(path.read_text())
    except json.JSONDecodeError as e:
        sys.exit(
            f"error: {path} exists but is not valid JSON ({e}). "
            f"Fix or empty it, then re-run."
        )
data["agent"] = agent
path.write_text(json.dumps(data, indent=2) + "\n")
print(f'  set "agent": "{agent}" -> {path}')
PYEOF
}

# copy_if_missing <src-file> <dest-file>
# Copies src to dest only if dest doesn't already exist yet, so re-running
# an installer never overwrites a file you may have since edited. Creates
# the destination directory if needed.
copy_if_missing() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -e "$dest" ]]; then
    echo "  skip (already exists): $dest"
  else
    cp "$src" "$dest"
    echo "  installed: $dest"
  fi
}

# copy_files_if_missing <dest-dir> <src-file>...
# copy_if_missing for a batch of files into the same destination directory.
copy_files_if_missing() {
  local dest_dir="$1"; shift
  mkdir -p "$dest_dir"
  local f
  for f in "$@"; do
    copy_if_missing "$f" "$dest_dir/$(basename "$f")"
  done
}

# install_skills_flat <repo-skills-dir> <target-skills-dir>
# Claude/Codex/Gemini/Kiro all expect ONE FLAT directory of
# <skill-name>/SKILL.md under their respective skills root — not the
# category subfolders (engineering/, productivity/, ...) this repo groups
# them in for readability. This walks every SKILL.md in the source tree and
# copies its containing directory straight into the flat target root.
install_skills_flat() {
  local src_root="$1" dst_root="$2"
  mkdir -p "$dst_root"
  local count=0
  while IFS= read -r -d '' skill_md; do
    local leaf_dir name dest
    leaf_dir="$(dirname "$skill_md")"
    name="$(basename "$leaf_dir")"
    dest="$dst_root/$name"
    if [[ -e "$dest" ]]; then
      echo "  skip (already exists): $dest"
    else
      cp -r "$leaf_dir" "$dest"
      count=$((count + 1))
    fi
  done < <(find "$src_root" -name SKILL.md -print0)
  echo "  installed $count skill(s) into $dst_root"
}
