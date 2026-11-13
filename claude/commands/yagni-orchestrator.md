Read `@task_plan.md` in the current project and launch the automated execution loop:

## Core Principles (Token & State Isolation)
- The main conversation must NEVER read, edit source code, or run verification commands directly. All execution must be delegated to subagents.
- **Branch Safety (`feature/` prefix)**: Never execute tasks or commit automatically on protected branches (`main`, `master`, `develop`). Feature branches must use the `feature/` prefix.
- **One Task, One Target-Scoped Commit**: Stage and commit ONLY the task's designated `Target` files immediately after review passes. Strictly NEVER run `git add -A` and NEVER commit `task_plan.md` or temporary verification scripts.

## Pre-Flight Check (Git Branch Safety)
Before starting the execution loop, ensure a safe and clean development branch:
1. Run `git branch --show-current` to inspect the active branch.
2. Branch Isolation:
   - If currently on a protected branch (`main`, `master`, or `develop`):
     - Extract `Recommended Branch` from `task_plan.md` (ensuring it starts with `feature/`, e.g., `feature/yagni-impl`; if missing or using `feat/`, normalize it to `feature/<slug>`).
     - Run `git checkout -b <branch-name>` to create and switch to the new branch.
   - If already on a non-protected feature branch, continue using it.
3. Ensure the working tree is clean (aside from `task_plan.md`) before entering the loop.

## Automated Execution Loop (Loop Protocol)
Repeat the following steps until all items in `task_plan.md` are marked complete (`- [x]`) or an error occurs:

1. **Find Next Task**:
   - Scan `task_plan.md` for the first unchecked task (`- [ ]`).
   - Record its exact `Target` file paths and the plan's `Structural Budget`.
   - If no unchecked tasks remain, output a final summary and terminate.

2. **Phase 1: Worker Implementation**:
   - Extract the task's `Target`, `References`, `Acceptance Criteria`, `Verification`, and top-level `Structural Budget`.
   - Delegate the task to the `yagni-worker` subagent.
   - If `yagni-worker` returns `WORKER_FAILURE`:
     - Safely stash dirty changes via Bash (preserving `task_plan.md`):
       ```bash
       git stash push -u -m "failed-task-backup" -- ':!task_plan.md'
       ```
     - Halt the loop immediately and report error details to the user (noting changes are safely backed up in git stash).

3. **Phase 2: Independent Diff Review**:
   - Upon `WORKER_SUCCESS`, delegate to the `diff-reviewer` subagent to audit current uncommitted changes (`git status -s` and `git diff HEAD`) against `Target`, `Acceptance Criteria`, and `Structural Budget`.
   - If `diff-reviewer` returns `REVIEW_FAIL`:
     - Do NOT check off the task. Safely stash non-compliant code changes (keeping `task_plan.md` unchecked):
       ```bash
       git stash push -u -m "review-failed-backup" -- ':!task_plan.md'
       ```
     - Halt the loop immediately and output the specific review failure reasons.

4. **Phase 3: Mark Complete, Target-Scoped Auto-Commit & Advance**:
   - Upon `REVIEW_PASS`:
     - Mark the task as completed (`- [x]`) in `task_plan.md`.
     - Stage ONLY the current task's designated `Target` files (strictly NEVER stage `task_plan.md` or temp files) and commit:
       ```bash
       git add -- <Target_Files> && git commit -m "feat(yagni): complete $(git branch --show-current) task"
       ```
     - Output a brief progress summary (e.g., `"[Progress] Task verified and committed"`).
     - **Loop back to Step 1** to advance to the next unchecked task.
