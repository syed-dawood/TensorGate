#!/usr/bin/env bash
# Bootstrap local TensorGate development environment.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "==> TensorGate local setup ($REPO_ROOT)"

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1"
    return 1
  fi
}

require_cmd git
require_cmd gh
require_cmd dotnet

echo "==> Git remote"
git remote -v

echo "==> GitHub CLI auth"
gh auth status || {
  echo "Run: gh auth login"
  exit 1
}

echo "==> .NET SDK (global.json)"
if [[ -f global.json ]]; then
  cat global.json
fi
dotnet --info | head -n 20

echo "==> Restore/build preflight (bootstrap-safe)"
chmod +x scripts/preflight.sh 2>/dev/null || true
./scripts/preflight.sh

if ! command -v gitleaks >/dev/null 2>&1; then
  echo "==> Optional: install gitleaks for local secret scans"
  if command -v go >/dev/null 2>&1; then
    echo "  go install github.com/gitleaks/gitleaks/v8@latest"
  else
    echo "  See https://github.com/gitleaks/gitleaks#installing"
  fi
else
  echo "==> gitleaks: $(gitleaks version 2>/dev/null || echo installed)"
fi

if command -v npm >/dev/null 2>&1; then
  echo "==> Optional markdown lint (matches CI docs-quality)"
  echo "  npm install -g markdownlint-cli2"
else
  echo "==> npm not found; skip markdownlint-cli2 (CI still runs on PR)"
fi

echo ""
echo "Clone path: $REPO_ROOT"
echo "Before opening a PR: ./scripts/preflight.sh"
echo "Done."
