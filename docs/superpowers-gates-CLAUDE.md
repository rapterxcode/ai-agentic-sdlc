# Custom review gates for the superpowers workflow
<!-- Copy the section below into your project's CLAUDE.md -->

## Custom review gates (used with superpowers)

- After `writing-plans` produces an implementation plan, ALWAYS dispatch the
  `plan-reviewer` subagent before starting execution. All blocking issues
  must be fixed before the first task runs.
- For any task tagged SECURITY-SENSITIVE by plan-reviewer (authentication,
  authorization, input parsing, secrets, cryptography, network boundaries):
  after the superpowers code review passes, dispatch the `security-auditor`
  subagent as an additional gate. Critical findings block progress to the
  next task.
- During `brainstorming`, when codebase exploration or external documentation
  is needed, dispatch the `researcher` subagent instead of exploring in the
  main conversation.
- Before `finishing-a-development-branch` merges or opens a PR:
  1. Dispatch `devsecops-engineer` for one final scan of the branch
     (secrets, dependency CVEs, CI/IaC changes).
  2. Dispatch `test-quality-auditor` to audit the test suite.
     A FAIL verdict blocks the merge.
- Reviewer subagents report only and never modify files. All fixes go
  through the normal superpowers task flow (TDD).
