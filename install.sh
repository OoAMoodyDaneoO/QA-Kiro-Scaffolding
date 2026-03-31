#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────────────────────
# install.sh — Copy the Kiro QA Testing Toolkit into a project
#
# Usage:
#   ./install.sh /path/to/your/project
#
# What it does:
#   1. Copies .kiro/ (agents, hooks, skills, steering)
#   2. Creates docs/test-reports/ with the audit log template
#   3. Optionally copies the SonarQube power
#
# It will NOT overwrite existing files — safe to re-run.
# ─────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${1:-}"

if [ -z "$TARGET" ]; then
  echo "Usage: ./install.sh /path/to/your/project"
  exit 1
fi

if [ ! -d "$TARGET" ]; then
  echo "Error: '$TARGET' is not a directory."
  exit 1
fi

copy_if_missing() {
  local src="$1"
  local dest="$2"
  if [ -e "$dest" ]; then
    echo "  SKIP  $dest (already exists)"
  else
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    echo "  COPY  $dest"
  fi
}

copy_dir_if_missing() {
  local src="$1"
  local dest="$2"
  if [ -d "$dest" ]; then
    echo "  SKIP  $dest/ (already exists)"
  else
    mkdir -p "$(dirname "$dest")"
    cp -r "$src" "$dest"
    echo "  COPY  $dest/"
  fi
}

echo ""
echo "Installing Kiro QA Testing Toolkit into: $TARGET"
echo "================================================="
echo ""

# --- .kiro directory ---
echo "[1/4] Agents"
copy_if_missing "$SCRIPT_DIR/.kiro/agents/qa-test-engineer.json" "$TARGET/.kiro/agents/qa-test-engineer.json"
copy_if_missing "$SCRIPT_DIR/.kiro/agents/qa-test-engineer-prompt.md" "$TARGET/.kiro/agents/qa-test-engineer-prompt.md"

echo ""
echo "[2/4] Hooks"
copy_if_missing "$SCRIPT_DIR/.kiro/hooks/auto-test-on-create.kiro.hook" "$TARGET/.kiro/hooks/auto-test-on-create.kiro.hook"
copy_if_missing "$SCRIPT_DIR/.kiro/hooks/auto-test-on-edit.kiro.hook" "$TARGET/.kiro/hooks/auto-test-on-edit.kiro.hook"
copy_if_missing "$SCRIPT_DIR/.kiro/hooks/test-coverage-report.kiro.hook" "$TARGET/.kiro/hooks/test-coverage-report.kiro.hook"

echo ""
echo "[3/4] Skills & Steering"
copy_dir_if_missing "$SCRIPT_DIR/.kiro/skills/write-unit-tests" "$TARGET/.kiro/skills/write-unit-tests"
copy_dir_if_missing "$SCRIPT_DIR/.kiro/skills/review-test-quality" "$TARGET/.kiro/skills/review-test-quality"
copy_dir_if_missing "$SCRIPT_DIR/.kiro/skills/fix-failing-tests" "$TARGET/.kiro/skills/fix-failing-tests"
copy_if_missing "$SCRIPT_DIR/.kiro/steering/unit-testing-standards.md" "$TARGET/.kiro/steering/unit-testing-standards.md"
copy_if_missing "$SCRIPT_DIR/.kiro/steering/test-bug-fixing-policy.md" "$TARGET/.kiro/steering/test-bug-fixing-policy.md"
copy_if_missing "$SCRIPT_DIR/.kiro/steering/test-evidence-policy.md" "$TARGET/.kiro/steering/test-evidence-policy.md"

echo ""
echo "[4/4] Test reports directory"
mkdir -p "$TARGET/docs/test-reports/coverage"
mkdir -p "$TARGET/docs/test-reports/gap-analysis"
copy_if_missing "$SCRIPT_DIR/docs/test-reports/audit-log.md" "$TARGET/docs/test-reports/audit-log.md"

echo ""

# --- Optional: SonarQube power ---
read -rp "Install SonarQube power? (y/N) " INSTALL_SONAR
if [[ "$INSTALL_SONAR" =~ ^[Yy]$ ]]; then
  echo ""
  echo "[Optional] SonarQube Power"
  copy_dir_if_missing "$SCRIPT_DIR/powers/sonarqube-testing" "$TARGET/powers/sonarqube-testing"
  echo ""
  echo "  Remember to edit powers/sonarqube-testing/mcp.json with your token and URL."
fi

echo ""
echo "Done. Open the project in Kiro and the toolkit is active."
echo ""
