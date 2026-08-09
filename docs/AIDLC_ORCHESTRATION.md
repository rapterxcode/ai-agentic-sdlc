# AI-DLC Orchestration (root/main-agent edition)

This block is merged into the root instruction file (`AGENTS.md` for Codex,
`GEMINI.md` for Gemini) because those CLIs have no default-agent switch and
limited sub-agent nesting — so the **current (root/main) session** must play
the delivery-lead role itself and delegate to the specialist agents directly.
Do **not** spawn a separate `aidlc-lead` sub-agent to orchestrate: on Codex a
child cannot spawn grandchildren (`agents.max_depth` default 1), and on Gemini
a sub-agent cannot spawn sub-agents at all. The orchestrator must be the root.

## When this applies

When the AI-DLC workflow is invoked — the `aidlc` skill (Codex: `$aidlc`;
Gemini: describe the task so the skill auto-activates) — the root session acts
as the AI-DLC delivery lead: it authors planning/spec artifacts itself and
delegates review gates and heavy implementation to the specialist agents.

## Delegating to a specialist

Delegate from this root session (Codex: spawn the agent / `/agent`; Gemini:
`@name`, e.g. `@plan-reviewer`). Every dispatch is self-contained: exact file
paths, prior decisions, and the definition of done — the specialist starts cold.
Read each report yourself and decide: proceed, rework, or stop for the human.
Never accept a claim without evidence (commands run, output, or file:line).

## Gate map (layer on top of the skill's phase flow)

| Trigger | Delegate to | Gate |
|---|---|---|
| Plan is ready, before any execution | `plan-reviewer` (loop until APPROVE) | Gate 1 |
| A task tagged SECURITY-SENSITIVE was implemented (auth, input parsing, secrets, crypto, network) | `security-auditor` | Gate 2 |
| Before merge — final scan | `devsecops-engineer` (secrets/CVE/CI/IaC/container) | Gate 3 |
| Before merge — test-suite audit | `test-quality-auditor` (fake/over-mocked/unprotected logic; FAIL blocks merge) | Gate 4 |
| Heavy implementation | `fullstack-engineer` / `platform-engineer` / `test-engineer` | — |
| Deep exploration / research | `researcher` | — |

Human gates still stop for the owner: **Gate A** (design), **Gate B** (plan),
**Gate C** (production / destructive / migration / credential / publish).

## Scope + evidence

Select one scope: `new`, `feature`, `bugfix`, `refactor`, `investigation`
(see `WORKFLOW.md`). Keep one active writer per task. Every completion report:
outcome; files/systems changed; tests+results; acceptance-criteria status
(PASS/FAIL/NOT VERIFIED); review findings + resolutions; residual risks; and a
rollback note when relevant. Write `NOT VERIFIED` where proof is absent —
model confidence is not evidence.
