#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSHRC="$HOME/.zshrc"

echo "==> Setting up dotfiles..."

# --- Default shell ---
if [ "$SHELL" != "/usr/bin/zsh" ]; then
  echo "==> Changing default shell to zsh..."
  sudo chsh "$(id -un)" --shell "/usr/bin/zsh"
fi

append_once() {
  local line="$1"
  grep -qF "$line" "$ZSHRC" 2>/dev/null || echo "$line" >> "$ZSHRC"
}

# --- Git aliases ---
mkdir -p ~/.shell
cp "$DOTFILES_DIR/shell/git.sh" ~/.shell/git.sh
append_once 'source ~/.shell/git.sh'

# --- zsh-autosuggestions ---
ZSH_AUTOSUGGEST_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zsh-autosuggestions"
if ! command -v git &>/dev/null; then
  echo "==> git not found, skipping zsh-autosuggestions install"
elif [ ! -d "$ZSH_AUTOSUGGEST_DIR" ]; then
  echo "==> Installing zsh-autosuggestions..."
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_AUTOSUGGEST_DIR"
fi
# Use single quotes so XDG_DATA_HOME is evaluated at shell startup, not install time
append_once 'source ${XDG_DATA_HOME:-$HOME/.local/share}/zsh-autosuggestions/zsh-autosuggestions.zsh'

# --- Claude Code plugins ---
bash "$DOTFILES_DIR/claude/claude.sh"

echo "==> Done! Run: source ~/.zshrc"
