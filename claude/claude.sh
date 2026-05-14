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

# humanizer skill
HUMANIZER_DIR="${HOME}/.claude/skills/humanizer"
if [ -d "$HUMANIZER_DIR" ]; then
  echo "==> Updating humanizer skill..."
  git -C "$HUMANIZER_DIR" pull --ff-only
else
  echo "==> Installing humanizer skill..."
  mkdir -p "${HOME}/.claude/skills"
  git clone https://github.com/blader/humanizer.git "$HUMANIZER_DIR"
fi

echo "==> Done."
