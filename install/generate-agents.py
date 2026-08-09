#!/usr/bin/env python3
"""Generate the Codex (TOML) and Gemini (Markdown) agent rosters from the
canonical Claude markdown agents in agents/project-agents/ and agents/user-agents/.

Claude markdown is the single source of truth for agent *prompts*. Each target
platform needs the same role prompt in its own agent-file format:

  - Codex CLI  -> agents/codex-agents/<name>.toml   (name/description/developer_instructions)
  - Gemini CLI -> agents/gemini-agents/<name>.md     (YAML frontmatter + body)

Kiro's JSON roster (agents/kiro-agents/) is intentionally hand-maintained because
it carries Kiro-specific subagent config (toolsSettings.subagent) that does not
map from the Claude frontmatter.

Run from the repo root:  python3 install/generate-agents.py
Verified field requirements (2026-07):
  - Codex custom agent TOML: name, description, developer_instructions required.
  - Gemini custom subagent MD: name, description required; model defaults to inherit.
"""
import pathlib
import re
import sys

REPO = pathlib.Path(__file__).resolve().parent.parent
SRC_DIRS = [REPO / "agents" / "project-agents", REPO / "agents" / "user-agents"]
CODEX_OUT = REPO / "agents" / "codex-agents"
GEMINI_OUT = REPO / "agents" / "gemini-agents"

FRONTMATTER_RE = re.compile(r"^---\n(.*?)\n---\n(.*)$", re.S)


def parse_agent(path: pathlib.Path):
    text = path.read_text(encoding="utf-8")
    m = FRONTMATTER_RE.match(text)
    if not m:
        raise ValueError(f"{path}: missing YAML frontmatter")
    fm, body = m.group(1), m.group(2).strip("\n")
    name = _field(fm, "name", path)
    description = _field(fm, "description", path)
    return name, description, body


def _field(frontmatter: str, key: str, path: pathlib.Path) -> str:
    m = re.search(rf"^{key}:\s*(.+)$", frontmatter, re.M)
    if not m:
        raise ValueError(f"{path}: frontmatter missing '{key}'")
    return m.group(1).strip().strip('"').strip("'")


def toml_basic(s: str) -> str:
    """Escape a string for a TOML basic (double-quoted) value."""
    return s.replace("\\", "\\\\").replace('"', '\\"')


def yaml_double(s: str) -> str:
    """Escape a string for a YAML double-quoted scalar."""
    return s.replace("\\", "\\\\").replace('"', '\\"')


def write_codex(name: str, description: str, body: str):
    CODEX_OUT.mkdir(parents=True, exist_ok=True)
    # Use a TOML literal multiline string (''') for the body so backslashes and
    # arrows are preserved verbatim. Bodies never contain a triple single-quote.
    if "'''" in body:
        raise ValueError(f"{name}: body contains ''' which breaks TOML literal string")
    out = (
        f"# Generated from agents/*/{name}.md by install/generate-agents.py — do not edit by hand.\n"
        f'name = "{toml_basic(name)}"\n'
        f'description = "{toml_basic(description)}"\n'
        f"developer_instructions = '''\n{body}\n'''\n"
    )
    (CODEX_OUT / f"{name}.toml").write_text(out, encoding="utf-8")


def write_gemini(name: str, description: str, body: str):
    GEMINI_OUT.mkdir(parents=True, exist_ok=True)
    out = (
        "---\n"
        f"# Generated from agents/*/{name}.md by install/generate-agents.py — do not edit by hand.\n"
        f'name: "{yaml_double(name)}"\n'
        f'description: "{yaml_double(description)}"\n'
        "model: inherit\n"
        "---\n\n"
        f"{body}\n"
    )
    (GEMINI_OUT / f"{name}.md").write_text(out, encoding="utf-8")


def main():
    agents = []
    for d in SRC_DIRS:
        for md in sorted(d.glob("*.md")):
            agents.append(parse_agent(md))
    if not agents:
        sys.exit("no source agents found")
    for name, description, body in agents:
        write_codex(name, description, body)
        write_gemini(name, description, body)
    names = sorted(a[0] for a in agents)
    print(f"generated {len(agents)} agents into {CODEX_OUT.relative_to(REPO)}/ and {GEMINI_OUT.relative_to(REPO)}/")
    print("  " + ", ".join(names))


if __name__ == "__main__":
    main()
