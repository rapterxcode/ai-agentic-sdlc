# AIDLC-lite SDLC workflow Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Status:** Implemented and verification passed on 2026-07-21

**Goal:** Extend the repository's existing AI-team workflow into a complete, lightweight SDLC with scope-adaptive paths, traceability, release readiness, operations handoff, and a Mermaid lifecycle diagram.

**Architecture:** Keep `docs/WORKFLOW.md` as the canonical lifecycle rather than introducing a second orchestrator or full AIDLC manifest. A single reusable work-item Markdown template preserves the small set of decisions, artifacts, and trace links needed to resume non-trivial work. `GLOBAL_RULE.md`, the team-leader prompt, and README point to that canonical workflow and reinforce the same controls.

**Tech Stack:** Markdown, Mermaid, Git, Bash, Ripgrep.

## Global Constraints

- Preserve existing Superpowers lifecycle, TDD, specialist review gates, and human approval gates.
- Do not add dependencies, scripts, CI configuration, AIDLC runtime skills, or a machine-managed manifest.
- Do not authorize, automate, or execute deployment; Phase 8 is release planning and a human approval gate only.
- Use `new`, `feature`, `bugfix`, `refactor`, and `investigation` as the only documented workflow scopes.
- Require `REQ-* → DES-* → TASK-* → TEST-* → VERIFY-*` traceability only for multi-step, security-sensitive, or production-affecting work.
- Keep `docs/WORKFLOW.md` the single lifecycle source of truth; other files link to it rather than restating phase mechanics.

---

## File Structure

| File | Change | Responsibility |
|---|---|---|
| `docs/templates/sdlc-work-item.md` | Create | Copyable, single-file record for scope, decisions, requirements, traceability, release readiness, and operations handoff. |
| `docs/WORKFLOW.md` | Rewrite | Canonical ten-phase SDLC, scope matrix, decision gates, artifacts, traceability policy, and Mermaid diagram. |
| `docs/GLOBAL_RULE.md` | Modify | Durable cross-agent requirements for scope selection, work-item records, phase evidence, and release/operations completion. |
| `agents/project-agents/team-leader.md` | Modify | Orchestration behavior that routes scope, requests decomposition, and checks lifecycle evidence without duplicating Superpowers inner-loop work. |
| `README.md` | Modify | Discoverability: describe the complete SDLC, template, and canonical workflow link. |

## Task 1: Create the reusable SDLC work-item record

**Files:**

- Create: `docs/templates/sdlc-work-item.md`
- Reference: `docs/superpowers/specs/2026-07-21-aidlc-lite-sdlc-design.md:84-104`

**Interfaces:**

- Consumes: A user request, selected scope, approved decisions, and actual verification evidence.
- Produces: One target-project record at `docs/work-items/<feature>.md` that later phases read and update.

- [x] **Step 1: Add the usage contract and lifecycle status fields**

  Write the template introduction with this explicit contract:

  ```markdown
  # SDLC work item: <feature>

  Copy this file to `docs/work-items/<feature>.md` in the target repository.
  Use it for multi-step, security-sensitive, or production-affecting work.
  Keep evidence factual; do not record secrets, credentials, or customer data.

  ## Status

  - Scope: `new | feature | bugfix | refactor | investigation`
  - Current phase: `0-9`
  - Owner:
  - Risk level: `low | medium | high`
  - Last verified:
  - Next human decision:
  ```

- [x] **Step 2: Add requirements, design, task, and traceability sections**

  Add the exact headings `## Context and decisions`, `## Requirements`,
  `## Design and non-functional requirements`, `## Implementation plan`, and
  `## Traceability`. In the traceability section, include this complete table
  shape and instruct users to write `NOT VERIFIED` rather than inventing an
  evidence link:

  ```markdown
  | Requirement | Design decision | Task | Test | Verification evidence | Status |
  |---|---|---|---|---|---|
  | REQ-01 | DES-01 | TASK-01 | TEST-01 | VERIFY-01 | Planned |
  ```

  Require each requirement to have an acceptance criterion and each task to
  name its verification command or review evidence.

- [x] **Step 3: Add release, operations, and handoff sections**

  Add the exact headings `## Release readiness`, `## Operations and rollback`,
  and `## Final handoff`. Include explicit fields for deployment approval,
  rollback owner, smoke-test evidence, monitoring/alert owner, runbook path,
  unresolved risks, and recovery instructions. State that a real deployment,
  migration, credential change, or external publication needs separate human
  authorization.

- [x] **Step 4: Validate the template structure**

  Run:

  ```bash
  rg -n '^## (Status|Context and decisions|Requirements|Design and non-functional requirements|Implementation plan|Traceability|Release readiness|Operations and rollback|Final handoff)$|REQ-01|DES-01|TASK-01|TEST-01|VERIFY-01' docs/templates/sdlc-work-item.md
  ```

  Expected: Every listed section heading and all five traceability ID prefixes
  appear exactly as the template contract requires.

- [x] **Step 5: Commit the independent template change**

  ```bash
  git add docs/templates/sdlc-work-item.md
  git commit -m "docs: add SDLC work item template"
  ```

## Task 2: Make `WORKFLOW.md` the complete canonical SDLC

**Files:**

- Modify: `docs/WORKFLOW.md`
- Reference: `docs/superpowers/specs/2026-07-21-aidlc-lite-sdlc-design.md:22-82`
- Depends on: Task 1

**Interfaces:**

- Consumes: `docs/templates/sdlc-work-item.md` as the optional work record.
- Produces: The authoritative phase order, scope behavior, artifacts, gates,
  and Mermaid lifecycle diagram for all other documentation and agents.

- [x] **Step 1: Extend the entry contract and Phase 0**

  Add `scope` to the required entry information. Replace the Phase 0 title
  with `## Phase 0: Classify, route, and select scope`. Document the five
  scopes and the following fixed routing rules:

  ```markdown
  - `new` / `feature`: all phases; decompose only when the work is complex.
  - `bugfix`: lightweight requirements, regression coverage, no release phase unless deployment is requested.
  - `refactor`: preserve external behavior; skip requirements and release unless behavior or deployment changes.
  - `investigation`: establish context and return an evidence-backed report; do not implement without a separate request.
  ```

  Define complex work as crossing two independent domains, requiring multiple
  owners, or being too large to verify as one bounded change.

- [x] **Step 2: Replace the Phase 2 design-only section with requirements and decomposition**

  Rename Phase 2 to `## Phase 2: Define requirements and decompose complex
  work`. Require requirement IDs, prioritized acceptance criteria, and a
  lightweight requirements record for a bugfix. For complex `new` or
  `feature` work, require independently testable units with clear dependencies
  before Phase 3. Retain `superpowers:brainstorming` for design work, but move
  its invocation to Phase 3 so requirements exist first.

- [x] **Step 3: Clarify phases 3 through 9 and preserve current gates**

  Use these exact phase titles and outcomes:

  ```markdown
  ## Phase 3: Design the solution and operations
  ## Phase 4: Write the implementation plan and traceability
  ## Phase 5: Execute with a single active writer
  ## Phase 6: Review at task boundaries
  ## Phase 7: Integrated build and verification
  ## Phase 8: Release readiness and branch completion
  ## Phase 9: Operations and durable knowledge
  ```

  In Phase 3, require security, NFRs, observability, rollback, and Gate A.
  After Gate A and before Phase 4, retain the existing
  `using-git-worktrees` isolation, dependency setup, and documented baseline
  verification steps. In Phase 4, require the trace matrix in the work-item record when the
  global constraints require it, then retain Gate B. In Phase 7, keep every
  existing quality check and record requirement-to-verification gaps. In
  Phase 8, require release readiness, deployment plan, approval, rollback,
  and the existing finish-branch choices, while retaining Gate C before any
  real deployment. In Phase 9, require a runbook path, monitoring/alert
  ownership when applicable, recovery instructions, and verified knowledge
  handoff.

- [x] **Step 4: Add the approved Mermaid diagram after the scope table**

  Insert this diagram exactly once:

  ```mermaid
  flowchart TD
      A[Receive request] --> B{Select scope}
      B -->|new / feature| C[Context]
      B -->|bugfix| C
      B -->|refactor| C
      B -->|investigation| C
      C -->|new / feature / bugfix| D[Requirements]
      C -->|refactor| G[Design]
      C -->|investigation| Z[Evidence-backed report]
      D --> E{Complex work?}
      E -->|Yes| F[Decompose into units]
      E -->|No| G
      F --> G
      G --> H[Gate A: approve design]
      H --> I[Plan and traceability]
      I --> J[Gate B: approve plan]
      J --> K[Implement: TDD and single writer]
      K --> L[Review: code, security, test quality]
      L --> M[Build and integrated verification]
      M --> N{Release or deploy needed?}
      N -->|Yes| O[Release plan and Gate C]
      N -->|No| P[Operations and knowledge handoff]
      O --> P
      P --> Q[Runbook, monitoring, rollback]
  ```

- [x] **Step 5: Add a phase-to-artifact table and link to the template**

  Include a compact table mapping Phase 1 to context evidence, Phase 2 to
  requirements and optional units, Phase 3 to design/ADR, Phase 4 to plan and
  trace matrix, Phase 7 to verification evidence, Phase 8 to release plan,
  and Phase 9 to runbook/handoff. Link `docs/templates/sdlc-work-item.md` as
  the copyable record and explicitly say it is optional for trivial work.

- [x] **Step 6: Validate workflow content and Mermaid presence**

  Run:

  ```bash
  rg -n '^## Phase [0-9]:|^## Scope-adaptive paths$|^## Traceability$|^```mermaid$|^flowchart TD$|Gate [ABC]|REQ-\*.*VERIFY-\*' docs/WORKFLOW.md
  ```

  Expected: Ten phase headings, one scope section, one traceability section,
  one Mermaid fence with `flowchart TD`, all three gates, and the complete
  trace ID pattern.

- [x] **Step 7: Commit the canonical workflow change**

  ```bash
  git add docs/WORKFLOW.md
  git commit -m "docs: extend workflow to full SDLC"
  ```

## Task 3: Align durable rules and team-leader orchestration

**Files:**

- Modify: `docs/GLOBAL_RULE.md`
- Modify: `agents/project-agents/team-leader.md`
- Reference: `docs/superpowers/specs/2026-07-21-aidlc-lite-sdlc-design.md:106-123`
- Depends on: Tasks 1-2

**Interfaces:**

- Consumes: Canonical phases and scope behavior from `docs/WORKFLOW.md`.
- Produces: Cross-platform instructions and orchestration expectations that
  use the same terminology without restating the full workflow.

- [x] **Step 1: Add an SDLC execution-record rule to `GLOBAL_RULE.md`**

  Add a short `## SDLC scope and traceability` section after the core
  operating principles. It must require selected scope for non-trivial work,
  require the work-item record for multi-step/security-sensitive/
  production-affecting work, and require every trace entry to contain actual
  evidence or `NOT VERIFIED`. Link to `docs/WORKFLOW.md` and the template;
  do not duplicate the phase steps.

- [x] **Step 2: Strengthen the completion rule**

  Extend the existing completion rule so release-affecting work cannot be
  complete without release readiness, named rollback/recovery, and operations
  handoff. Preserve the existing rule that a human authorizes production or
  destructive activity.

- [x] **Step 3: Add a focused SDLC routing section to `team-leader.md`**

  Add `## SDLC routing and evidence` after the roster. Require the leader to:

  ```markdown
  1. classify the request as `new`, `feature`, `bugfix`, `refactor`, or `investigation`;
  2. request decomposition for complex work before detailed design;
  3. require requirement, design, task, test, and verification links when a work-item record is required;
  4. keep Superpowers responsible for its inner implementation loop and specialist agents responsible for independent gates;
  5. stop for the human at Gate A, Gate B, Gate C, or an unresolved traceability gap.
  ```

- [x] **Step 4: Verify terminology alignment**

  Run:

  ```bash
  rg -n 'SDLC scope and traceability|work-item record|NOT VERIFIED|Gate [ABC]' docs/GLOBAL_RULE.md
  rg -n 'SDLC routing and evidence|new.*feature.*bugfix.*refactor.*investigation|traceability' agents/project-agents/team-leader.md
  ```

  Expected: Both files use the documented scope names, traceability contract,
  and approval-gate vocabulary.

- [x] **Step 5: Commit the policy and agent guidance**

  ```bash
  git add docs/GLOBAL_RULE.md agents/project-agents/team-leader.md
  git commit -m "docs: add SDLC routing and traceability rules"
  ```

## Task 4: Update README discoverability without duplicating the workflow

**Files:**

- Modify: `README.md`
- Reference: `docs/WORKFLOW.md`, `docs/templates/sdlc-work-item.md`
- Depends on: Tasks 1-3

**Interfaces:**

- Consumes: The workflow as canonical content.
- Produces: A concise entry point for users of the skill collection.

- [x] **Step 1: Update the repository tree and documentation descriptions**

  Add `docs/templates/sdlc-work-item.md` to the tree and describe it as a
  copyable record for non-trivial target-project work. Update the
  `docs/WORKFLOW.md` description to call it the ten-phase SDLC workflow.

- [x] **Step 2: Replace the existing workflow summary with an AIDLC-lite summary**

  Keep the existing Superpowers/reviewer-gate diagram. Add a concise paragraph
  that the canonical Mermaid lifecycle lives in `docs/WORKFLOW.md` and explain
  its three decision points: scope selection, complex-work decomposition, and
  release/deployment need. Link to the work-item template and list the five
  scopes without copying phase details.

- [x] **Step 3: Add a target-project usage example**

  Include this command and explain that it creates a project-local work item,
  not a file in this collection:

  ```bash
  mkdir -p docs/work-items
  cp /path/to/pasitc-ai-agents-skills/docs/templates/sdlc-work-item.md \
    docs/work-items/<feature>.md
  ```

  State that users fill the status and traceability sections as the work moves
  through the canonical workflow.

- [x] **Step 4: Verify README references**

  Run:

  ```bash
  rg -n '10 phase|SDLC|AIDLC-lite|sdlc-work-item|docs/WORKFLOW.md|new.*feature.*bugfix.*refactor.*investigation' README.md
  ```

  Expected: The README exposes the canonical workflow, work-item template,
  all five scopes, and does not duplicate a second phase list.

- [x] **Step 5: Commit the README change**

  ```bash
  git add README.md
  git commit -m "docs: document AIDLC-lite workflow usage"
  ```

## Task 5: Verify documentation integrity and the approved design criteria

**Files:**

- Verify: `README.md`
- Verify: `docs/WORKFLOW.md`
- Verify: `docs/GLOBAL_RULE.md`
- Verify: `docs/templates/sdlc-work-item.md`
- Verify: `agents/project-agents/team-leader.md`
- Reference: `docs/superpowers/specs/2026-07-21-aidlc-lite-sdlc-design.md:124-148`
- Depends on: Tasks 1-4

**Interfaces:**

- Consumes: All documentation changes.
- Produces: A documented verification result and a final branch commit.

- [x] **Step 1: Check whitespace and branch status**

  Run:

  ```bash
  git diff master...HEAD --check
  git status --short
  ```

  Expected: No whitespace errors. Status is clean after the final commit.

- [x] **Step 2: Check every required local file exists**

  Run:

  ```bash
  test -f README.md && \
  test -f docs/WORKFLOW.md && \
  test -f docs/GLOBAL_RULE.md && \
  test -f docs/templates/sdlc-work-item.md && \
  test -f agents/project-agents/team-leader.md
  ```

  Expected: Exit code `0`.

- [x] **Step 3: Check the implementation against the approved acceptance criteria**

  Run:

  ```bash
  rg -n 'Phase 8: Release readiness|Phase 9: Operations|Gate C|rollback|monitoring|REQ-\*.*VERIFY-\*' docs/WORKFLOW.md
  rg -n 'Requirement \| Design decision \| Task \| Test \| Verification evidence \| Status' docs/templates/sdlc-work-item.md
  rg -n 'SDLC scope and traceability|SDLC routing and evidence' docs/GLOBAL_RULE.md agents/project-agents/team-leader.md
  ```

  Expected: Release, operations, approval, rollback, monitoring,
  traceability, and routing evidence appears in the canonical files.

- [x] **Step 4: Review changed documentation as a reader**

  Read the full diff and confirm:

  - `WORKFLOW.md` is the only full phase definition.
  - No text authorizes automatic deployment.
  - Scope names, phase names, and Gate A/B/C names agree across all files.
  - The Mermaid diagram appears once in `WORKFLOW.md` and includes all three
    decision points.
  - Existing Superpowers and specialist-review responsibilities remain intact.

- [x] **Step 5: Commit verification-only adjustments if review finds any**

  If the review identifies a documentation inconsistency, edit only the
  affected file, re-run Steps 1-4, then commit with:

  ```bash
  git add README.md docs/WORKFLOW.md docs/GLOBAL_RULE.md docs/templates/sdlc-work-item.md agents/project-agents/team-leader.md
  git commit -m "docs: align AIDLC-lite workflow guidance"
  ```

  If no adjustment is necessary, do not create an empty commit.
