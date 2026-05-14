#!/usr/bin/env bash
set -euo pipefail

if ! command -v claude &>/dev/null; then
  echo "==> claude not found, skipping plugin setup"
  exit 0
fi

echo "==> Setting up Claude Code plugins..."

# claude-plugins-official marketplace
if ! claude plugin marketplace list 2>/dev/null | grep -q "anthropics/claude-plugins-official"; then
  echo "==> Registering claude-plugins-official marketplace..."
  claude plugin marketplace add anthropics/claude-plugins-official
else
  claude plugin marketplace update claude-plugins-official
fi

# superpowers
if claude plugin list 2>/dev/null | grep -q "superpowers@claude-plugins-official"; then
  echo "==> superpowers already installed, skipping"
else
  echo "==> Installing superpowers..."
  claude plugin install superpowers@claude-plugins-official
fi

# caveman marketplace
if ! claude plugin marketplace list 2>/dev/null | grep -q "JuliusBrussee/caveman"; then
  echo "==> Registering caveman marketplace..."
  claude plugin marketplace add JuliusBrussee/caveman
else
  claude plugin marketplace update caveman
fi

if claude plugin list 2>/dev/null | grep -q "caveman@caveman"; then
  echo "==> caveman already installed, skipping"
else
  echo "==> Installing caveman..."
  claude plugin install caveman@caveman
fi

# humanizer skill
if ! command -v git &>/dev/null; then
  echo "==> git not found, skipping humanizer skill install"
else
  HUMANIZER_DIR="${HOME}/.claude/skills/humanizer"
  if [ -d "$HUMANIZER_DIR" ]; then
    echo "==> Updating humanizer skill..."
    git -C "$HUMANIZER_DIR" pull --ff-only
  else
    echo "==> Installing humanizer skill..."
    mkdir -p "${HOME}/.claude/skills"
    git clone https://github.com/blader/humanizer.git "$HUMANIZER_DIR"
  fi
fi

echo "==> Done."
