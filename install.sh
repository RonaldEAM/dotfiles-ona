#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSHRC="$HOME/.zshrc"

echo "==> Setting up dotfiles..."

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
if [ ! -d "$ZSH_AUTOSUGGEST_DIR" ]; then
  echo "==> Installing zsh-autosuggestions..."
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_AUTOSUGGEST_DIR"
fi
append_once "source $ZSH_AUTOSUGGEST_DIR/zsh-autosuggestions.zsh"

echo "==> Done! Run: source ~/.zshrc"
