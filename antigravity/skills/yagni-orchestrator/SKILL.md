---
name: yagni-orchestrator
description: Automated loop advancing through all tasks in task_plan.md using isolated yagni-runner workers, adversarial diff reviews enforcing Structural Budgets and zero single-use helpers/untested branches, feature/ branch safety, and target-scoped Git commits.
---

# YAGNI Orchestrator

You are a Staff Engineering Orchestrator (`yagni-staff`). Your sole source of state is `task_plan.md`.

## Core Principles (Token & State Isolation)

- **Main Thread Isolation**: Never read, search, or modify project source code directly in the main conversation.
- **Minimal Context**: Keep only `task_plan.md` and step return statuses in your context.
- **Branch Safety (`feature/` prefix)**: Never execute tasks or commit automatically on protected branches (`main`, `master`, `develop`). Feature branches must use the `feature/` prefix.
- **One Task, One Target-Scoped Commit**: Stage and commit ONLY the task's designated `Target` files immediately after review passes. Never commit `task_plan.md` or temporary verification scripts.

## Pre-Flight Check (Git Branch Safety)

Before starting the execution loop, ensure a safe and clean development branch:

1. **Check Current Branch**: Run `git branch --show-current` to inspect the active branch.
2. **Branch Isolation**:
   - If currently on a protected branch (`main`, `master`, or `develop`):
     - Extract `Recommended Branch` from `task_plan.md` (ensuring it starts with `feature/`, e.g., `feature/yagni-impl`; if missing or using `feat/`, normalize it to `feature/<slug>`).
     - Run `git checkout -b <feature-branch-name>`.
   - If already on a non-protected feature branch, continue using it.
3. **Verify Clean Working Tree**: Ensure there are no uncommitted or untracked changes (aside from `task_plan.md`) before entering the loop.

## Automated Execution Loop (Loop Protocol)

Repeat the following steps until all items in `task_plan.md` are marked complete (`- [x]`) or an error occurs:

1. **Find Next Task**:
   - Read `task_plan.md` and locate the first unchecked item (`- [ ]`).
   - Record its exact `Target` file paths and the plan's `Structural Budget`.
   - If no unchecked items remain, report a final summary to the user and terminate.

2. **Phase 1: Dispatch `yagni-runner` Worker**:
   - Spawn an isolated single-execution worker via CLI explicitly invoking `yagni-runner`:
     ```bash
     antigravity -p "Load and follow @yagni-runner rules to execute the first unchecked task in task_plan.md. Obey Structural Budget, zero single-use helpers, zero untested branches/parameters, and execute the 20% write-then-prune subtraction pass. Run targeted verification, delete any temporary verification scripts before finishing, perform self diff review, then return WORKER_SUCCESS (do NOT check off task_plan.md or commit), or return WORKER_FAILURE with error details."
     ```
   - **On Worker Failure** (`WORKER_FAILURE` or process error):
     - Safely stash dirty changes (preserving `task_plan.md`):
       ```bash
       git stash push -u -m "failed-task-backup" -- ':!task_plan.md'
       ```
     - Halt the loop immediately and report error details to the user (noting changes are safely backed up in git stash).

3. **Phase 2: Independent Diff Review Gate**:
   - Upon `WORKER_SUCCESS`, spawn a separate isolated process to audit uncommitted changes:
     ```bash
     antigravity -p "Run git status -s and git diff HEAD to inspect all changes for the latest task and audit strictly against its Target, Acceptance Criteria, and Structural Budget in task_plan.md: 1. Are any acceptance criteria missing? 2. Did the changes violate Structural Budget or introduce AI pattern-matching bloat (single-implementation interfaces, single-use private helper functions, untested conditional branches, or speculative/unused parameters)? 3. Are any errors swallowed? 4. Were out-of-scope files modified or leftover temporary verification scripts left untracked? Return REVIEW_PASS if compliant, or REVIEW_FAIL with bulleted reasons."
     ```
   - **On Review Failure** (`REVIEW_FAIL`):
     - Safely stash non-compliant code changes (keeping `task_plan.md` unchecked):
       ```bash
       git stash push -u -m "review-failed-backup" -- ':!task_plan.md'
       ```
     - Halt the loop immediately and output the specific review failure reasons.

4. **Phase 3: Target-Scoped Git Commit & Advance**:
   - **Upon `REVIEW_PASS`**:
     - Update `task_plan.md` to mark the completed item as checked (`- [x]`).
     - Stage ONLY the current task's designated `Target` files and commit:
       ```bash
       git add -- <Target_Files> && git commit -m "feat(yagni): complete $(git branch --show-current) task"
       ```
     - Output `"[Progress] Task verified and committed"` and **loop back to Step 1**.
