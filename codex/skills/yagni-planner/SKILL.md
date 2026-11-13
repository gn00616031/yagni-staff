---
name: yagni-planner
description: Break down development tasks into token-optimized, falsifiable first-principles implementation plans with explicit structural budgets and justification proofs in task_plan.md.
---
# YAGNI Planner

Act as a pragmatic Staff Engineer. Apply **Falsifiable First-Principles Thinking** to break down user requirements into a token-optimized, step-by-step implementation plan, and create or overwrite `task_plan.md` in the current directory.

## Core Rules
1. **Falsifiable First-Principles & Structural Budget (YAGNI)**:
   - Trace the exact physical `Data Flow` from input to output before defining any tasks.
   - Enforce a strict `Structural Budget` at the top of `task_plan.md` (`New Production Files Allowed`, `New Interfaces/Classes Allowed`, and `New Single-Use Helpers Allowed`, all defaulting to `0` unless >= 2 concrete implementations/call sites exist right now).
   - **Reverse Burden of Proof**: Every task MUST include `Purpose & Why Necessary` (which concrete Acceptance Criterion breaks without this step) and `Why Not Simpler` (why a direct inline implementation in an existing file is insufficient). Hypothetical future extensibility is strictly invalid.
2. **Branch Naming Standard**:
   - Always format `Recommended Branch` with the `feature/` prefix (e.g., `feature/<feature-slug>`).
3. **Integration Test First**:
   - Prioritize writing or updating integration tests before implementation.
   - For features involving business workflows, APIs, databases, or cross-module interactions, plan the integration test step prior to the implementation step.
4. **Atomic Tasks (Commit-Ready)**:
   - Each task must have a single responsibility and clear boundaries so it can be independently verified and committed to Git.
5. **Boundary Isolation**: Do NOT roam or search across unrelated project directories.
6. **Immediate Stop**: Stop immediately after writing `task_plan.md`. Do NOT begin writing application code.

## task_plan.md Format Standard

```markdown
# Implementation Plan: [Feature Name]

## First-Principles & Structural Budget
- **Recommended Branch**: `feature/<feature-slug>`
- **Data Flow**: `[Input] -> [Transform/Action] -> [Output]`
- **New Production Files Allowed**: `0` (or explicit list of required new files)
- **New Interfaces/Classes Allowed**: `0` (must be 0 unless >= 2 concrete implementations exist now)
- **New Single-Use Helpers Allowed**: `0` (do not extract private functions called only once)
- **Scope**: [Brief summary] — Do not inspect or touch unrelated directories.

## Tasks
- [ ] Task 1: [Test First: Integration Test / Update Testcase]
  - Target: `tests/integration/test_feature.rs`
  - References: `src/types/index.d.ts`
  - Purpose & Why Necessary: Establish a failing integration test covering [specific behavior]; without this, Task 2 cannot be objectively verified.
  - Why Not Simpler: Unit tests alone cannot verify cross-module/DB interaction required by the criteria.
  - Verification: `cargo test --test test_feature`
  - Acceptance Criteria:
    - [ ] Update existing testcases or add integration tests covering the new requirement
    - [ ] Verify tests fail as expected prior to implementation (Red)
- [ ] Task 2: [Implementation]
  - Target: `src/path/to/target.ts`
  - References: `src/types/index.d.ts`
  - Purpose & Why Necessary: Implement [specific data transformation] to satisfy Task 1's failing integration test.
  - Why Not Simpler: Direct in-place implementation in existing target file; zero new abstractions, files, or single-use helpers needed.
  - Verification: `npm test -- tests/integration/test_feature.test.ts`
  - Acceptance Criteria:
    - [ ] Fulfill functional logic within Structural Budget with zero untested branches or speculative parameters, passing all Task 1 tests (Green)
```
