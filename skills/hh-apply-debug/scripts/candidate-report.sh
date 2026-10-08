#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "$repo_root" ]]; then
  echo "candidate-report: not inside a git repository" >&2
  exit 2
fi

cd "$repo_root"

echo "=== HH apply candidate report ==="
echo "repo: $repo_root"
echo "branch: $(git branch --show-current)"
echo "head: $(git rev-parse HEAD)"
echo

echo "=== working tree ==="
git status --short
echo

echo "=== changed files ==="
git diff --name-status
git diff --cached --name-status
echo

echo "=== diff stat ==="
git diff --stat
git diff --cached --stat
echo

echo "=== whitespace check ==="
git diff --check
git diff --cached --check

echo
echo "Attach the exact targeted test/E2E commands and their results to the HANDOFF."
