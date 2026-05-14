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

# caveman
if ! claude plugin marketplace list 2>/dev/null | grep -q "^\s*❯ caveman"; then
  echo "==> Registering caveman marketplace..."
  claude plugin marketplace add JuliusBrussee/caveman
fi

if claude plugin list 2>/dev/null | grep -q "caveman@caveman"; then
  echo "==> caveman already installed, skipping"
else
  echo "==> Installing caveman..."
  claude plugin install caveman@caveman
fi

echo "==> Done."
