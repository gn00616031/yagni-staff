#!/usr/bin/env bash
set -euo pipefail

REPO_RAW_URL="https://raw.githubusercontent.com/gn00616031/yagni-staff/main"
TARGET="${1:-all}"

install_antigravity() {
  echo "Installing Google Antigravity skills (yagni-staff)..."
  local skills_dir="$HOME/.gemini/config/skills"
  for skill in yagni-planner yagni-reviewer yagni-runner yagni-orchestrator; do
    mkdir -p "$skills_dir/$skill"
    curl -fsSL "$REPO_RAW_URL/antigravity/skills/$skill/SKILL.md" -o "$skills_dir/$skill/SKILL.md"
  done
  echo "Antigravity skills installed to $skills_dir"
}

install_claude() {
  echo "Installing Claude Code commands and agents (yagni-staff)..."
  local claude_dir="$HOME/.claude"
  mkdir -p "$claude_dir/commands" "$claude_dir/agents"

  for cmd in yagni-planner yagni-reviewer yagni-orchestrator; do
    curl -fsSL "$REPO_RAW_URL/claude/commands/$cmd.md" -o "$claude_dir/commands/$cmd.md"
  done

  for agent in yagni-worker diff-reviewer; do
    curl -fsSL "$REPO_RAW_URL/claude/agents/$agent.md" -o "$claude_dir/agents/$agent.md"
  done
  echo "Claude Code commands & agents installed to $claude_dir"
}

install_codex() {
  echo "Installing OpenAI Codex CLI skills (yagni-staff)..."
  local skills_dir="$HOME/.codex/skills"
  for skill in yagni-planner yagni-reviewer yagni-runner yagni-orchestrator; do
    mkdir -p "$skills_dir/$skill"
    curl -fsSL "$REPO_RAW_URL/codex/skills/$skill/SKILL.md" -o "$skills_dir/$skill/SKILL.md"
  done
  echo "Codex CLI skills installed to $skills_dir"
}

install_cursor() {
  echo "Installing Cursor skills (yagni-staff)..."
  local skills_dir="$HOME/.cursor/skills"
  for skill in yagni-planner yagni-reviewer yagni-runner yagni-orchestrator; do
    mkdir -p "$skills_dir/$skill"
    curl -fsSL "$REPO_RAW_URL/cursor/skills/$skill/SKILL.md" -o "$skills_dir/$skill/SKILL.md"
  done
  echo "Cursor skills installed to $skills_dir"
}

configure_gitignore() {
  local global_ignore="$HOME/.gitignore_global"
  touch "$global_ignore"
  if ! grep -qxF "task_plan.md" "$global_ignore"; then
    echo "task_plan.md" >> "$global_ignore"
    git config --global core.excludesfile "$global_ignore"
    echo "Added task_plan.md to global gitignore ($global_ignore)"
  fi
}

case "$TARGET" in
  antigravity) install_antigravity ;;
  claude) install_claude ;;
  codex) install_codex ;;
  cursor) install_cursor ;;
  all)
    install_antigravity
    install_claude
    install_codex
    install_cursor
    ;;
  *)
    echo "Usage: bash install.sh [all|antigravity|claude|codex|cursor]"
    exit 1
    ;;
esac

configure_gitignore
echo "yagni-staff installation complete!"
