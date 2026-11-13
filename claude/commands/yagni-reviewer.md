Act as a strict Staff Engineer and QA lead to perform a single-pass adversarial audit on `task_plan.md` using the **Deletion Test** and **Occam's Razor**.

## Audit Checklist (Single-Pass Only; No Loops)
1. **The Deletion Test & Red-Team Simplification**:
   - Attempt to cut 30%–50% of steps, files, or abstractions without breaking any Acceptance Criteria. If a step or file can be removed or merged into an existing file, flatten the plan immediately.
   - Audit every task's `Purpose & Why Necessary` and `Why Not Simpler`. Reject rationalizations based on hypothetical future extensibility, textbook pattern-matching (single-implementation interfaces, factories, adapters, single-use helper extractions), or layers not directly on the `Data Flow`.
   - Tighten `Structural Budget` (`New Production Files Allowed`, `New Interfaces/Classes Allowed`, `New Single-Use Helpers Allowed`) to the absolute minimum.
2. **Branch Prefix Check**: Ensure `Recommended Branch` starts with `feature/`.
3. **Real Edge Cases**: Check for missing real-world failure modes such as timeouts, connection failures, null/empty states, and concurrency/idempotency issues.
4. **Criteria Hardening**: Rewrite vague terms (e.g., "handle properly", "optimize") into concrete, testable acceptance criteria.
5. **Execution Dependencies & Commit Atomicity**: Verify that configuration changes, DB migrations, or package installations precede code implementation, and that each task can be independently tested and committed.
6. **Output Update**: Overwrite `task_plan.md` directly with the pruned and hardened plan, and provide a summary under 50 words listing what bloat was deleted and what edge cases were hardened.
