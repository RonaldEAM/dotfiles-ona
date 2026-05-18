#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASH_PROFILE="$HOME/.bash_profile"

echo "==> Setting up dotfiles..."

# --- Default shell ---
if [ "$SHELL" != "/bin/bash" ]; then
  echo "==> Changing default shell to bash..."
  sudo chsh "$(id -un)" --shell "/bin/bash"
fi

append_once() {
  local line="$1"
  grep -qF "$line" "$BASH_PROFILE" 2>/dev/null || echo "$line" >> "$BASH_PROFILE"
}

# --- Git aliases ---
mkdir -p ~/.shell
cp "$DOTFILES_DIR/shell/git.sh" ~/.shell/git.sh
append_once 'source ~/.shell/git.sh'

# --- Claude Code plugins ---
bash "$DOTFILES_DIR/claude/claude.sh"

echo "==> Done! Run: source ~/.bash_profile"
