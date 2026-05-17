#!/usr/bin/env bash

set -euo pipefail

echo "== TensorGate agentic local gate =="

if [ ! -f "global.json" ]; then
  echo "ERROR: run from repository root (global.json not found)."
  exit 1
fi

if [ ! -f ".git/HEAD" ]; then
  echo "ERROR: not in a git repository."
  exit 1
fi

branch="$(git branch --show-current)"
echo "Branch: ${branch}"

if [[ "${branch}" == "main" ]]; then
  echo "ERROR: agentic development should not happen directly on main."
  exit 1
fi

echo "1) Ensure working tree is valid"
git status --short

echo "2) Run deterministic local preflight"
./scripts/preflight.sh

echo "3) Lightweight secret scan in tracked files"
if command -v gitleaks >/dev/null 2>&1; then
  gitleaks detect --source . --no-git --exit-code 1 >/dev/null
  echo "gitleaks: clean"
else
  echo "gitleaks not installed locally; rely on CI Secret Scan."
fi

echo "4) Optional docs scan hint"
echo "Run docs check in CI (markdown-lint + link-check)."

echo "5) Verify commit intent artifacts"
echo "- Ensure issue is linked in branch/PR plan."
echo "- Ensure acceptance criteria and risk checklist are addressed."

echo "Local gate passed."
