---
name: yagni-runner
description: Execute tasks from task_plan.md step-by-step obeying strict Structural Budgets, zero single-use helpers, zero untested branches/parameters, write-then-prune 20% subtraction, temp cleanup, and diff self-review.
---
# YAGNI Runner

Read `task_plan.md` in the current project and execute the first unchecked (`- [ ]`) task:

## Execution Workflow
1. **Lock Task & Structural Budget**: Read `task_plan.md`, check `First-Principles & Structural Budget`, and lock onto the first unchecked task (`- [ ]`).
2. **First-Principles Scoped Implementation**:
   - Modify ONLY the designated `Target` files and read ONLY the listed `References` files. Do NOT browse unrelated directories.
   - **Hard YAGNI Guardrails**:
     - **Structural Budget**: Strictly obey `New Production Files Allowed`, `New Interfaces/Classes Allowed`, and `New Single-Use Helpers Allowed`.
     - **Zero Single-Use Helpers**: Keep sequential logic inline within the target function. Do NOT extract private helper functions/methods unless called 2 or more times.
     - **Zero Untested Branches & Parameters**: Every added function parameter, optional config flag, or conditional branch (`if`/`else`/`switch`) must be directly exercised by the Acceptance Criteria tests. Remove speculative parameters and dead fallback branches.
3. **Targeted Verification & Write-Then-Prune Gate**:
   - Run ONLY the specified `Verification` test command until tests pass (Green).
   - **Mandatory 20% Subtraction Pass**: Once Green, inspect your changes and actively delete ~20% of redundant intermediate variables, wrapper abstractions, single-use helpers, or untested defensive branches while keeping tests Green.
   - **Remove Temporary Verification Scripts**: Delete any temporary test scripts, scratch files, or throwaway runners immediately after tests pass so only designated `Target` files remain modified/created.
4. **Self Diff Review Gate**:
   - Run `git status -s` and `git diff <Target>` to inspect your workspace.
   - Checklist:
     - Does the diff strictly obey `Structural Budget` (zero unbudgeted files, interfaces, or single-use helpers)?
     - Are there zero untested branches or speculative function parameters?
     - Are all temporary verification scripts removed?
     - Are any errors swallowed (e.g., empty `catch` blocks, ignored error returns)?
   - If self-review fails, prune/refine the code and re-verify.
5. **Report Status (Do NOT Check Off or Commit)**:
   - **Strictly DO NOT mark checkboxes in `task_plan.md` and DO NOT run `git commit`** (managed exclusively by the orchestrator).
   - Output a concise report under 50 words containing modified `Target` files, test PASS status, and the explicit signal `WORKER_SUCCESS`.
   - If tests fail or criteria cannot be met, output `WORKER_FAILURE` with error details.
6. **Single-Step Constraint**: Execute strictly ONE task per invocation and exit immediately upon completion.
