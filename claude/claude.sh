#!/usr/bin/env bash
set -euo pipefail

echo "==> Setting up Claude Code plugins..."

# superpowers
if claude plugin list 2>/dev/null | grep -q "superpowers@"; then
  echo "==> superpowers already installed, skipping"
else
  echo "==> Installing superpowers..."
  claude plugin install superpowers@claude-plugins-official
fi

echo "==> Done."
