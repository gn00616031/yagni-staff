# yagni-staff

A pragmatic Staff Engineer workflow for **Google Antigravity**, **Claude Code**, **OpenAI Codex CLI**, and **Cursor**—built on Falsifiable First-Principles Thinking, structural budgets, Deletion Tests, isolated token execution, and diff-gated commits.

## Core Mechanisms
1. **Falsifiable First-Principles & Structural Budgets**: Every plan traces the exact physical `Data Flow` and enforces hard caps on `New Production Files Allowed`, `New Interfaces/Classes Allowed`, and `New Single-Use Helpers Allowed`.
2. **Reverse Burden of Proof & Deletion Test**: Each task must justify `Purpose & Why Necessary` and `Why Not Simpler`. `yagni-reviewer` executes an adversarial Deletion Test to prune 30%–50% of speculative abstractions before code is written.
3. **Hard Worker Guardrails & 20% Subtraction Pass**: Enforces zero single-use private helpers, zero untested branches or speculative parameters, and a mandatory write-then-prune 20% subtraction pass after tests turn green.
4. **Integration Test First**: Enforces Red-Green integration test verification prior to implementation.
5. **Token & Context Isolation**: Delegates single-task implementation and adversarial diff reviews to isolated sub-processes/subagents so the main thread never bloats.
6. **Git `feature/` Branch Safety & Target-Scoped Commits**: Automatically switches off protected branches (`main`/`master`/`develop`) to a `feature/*` branch, commits strictly designated `Target` files per task (excluding `task_plan.md` and temp scripts), and safely stashes failed attempts without losing work.
7. **Zero Code Comments**: Enforces self-documenting code and strict type naming without noisy inline comments.

## Quick Install

Install for all supported tools (**Antigravity**, **Claude Code**, **Codex CLI**, and **Cursor**):
```bash
curl -fsSL https://raw.githubusercontent.com/gn00616031/yagni-staff/main/install.sh | bash
```

Install for a specific tool only:
```bash
curl -fsSL https://raw.githubusercontent.com/gn00616031/yagni-staff/main/install.sh | bash -s -- antigravity
curl -fsSL https://raw.githubusercontent.com/gn00616031/yagni-staff/main/install.sh | bash -s -- claude
curl -fsSL https://raw.githubusercontent.com/gn00616031/yagni-staff/main/install.sh | bash -s -- codex
curl -fsSL https://raw.githubusercontent.com/gn00616031/yagni-staff/main/install.sh | bash -s -- cursor
```

## Workflow

<table>
  <thead>
    <tr>
      <th align="left">Step</th>
      <th align="left">Google Antigravity</th>
      <th align="left">Claude Code</th>
      <th align="left">OpenAI Codex CLI</th>
      <th align="left">Cursor</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>1. Plan</strong></td>
      <td><code>@yagni-planner</code></td>
      <td><code>/yagni-planner &lt;req&gt;</code></td>
      <td><code>$yagni-planner &lt;req&gt;</code></td>
      <td><code>/yagni-planner &lt;req&gt;</code></td>
    </tr>
    <tr>
      <td><strong>2. Audit Plan</strong></td>
      <td><code>@yagni-reviewer</code></td>
      <td><code>/yagni-reviewer</code></td>
      <td><code>$yagni-reviewer</code></td>
      <td><code>/yagni-reviewer</code></td>
    </tr>
    <tr>
      <td><strong>3. Human Review</strong></td>
      <td colspan="4"><em>You’re in control—bring your judgment to refine and approve what matters most.</em></td>
    </tr>
    <tr>
      <td><strong>4. Execute Loop</strong></td>
      <td><code>@yagni-orchestrator</code></td>
      <td><code>/yagni-orchestrator</code></td>
      <td><code>$yagni-orchestrator</code></td>
      <td><code>/yagni-orchestrator</code></td>
    </tr>
  </tbody>
</table>
