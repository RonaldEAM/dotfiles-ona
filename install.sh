#!/bin/bash

sudo chsh "$(id -un)" --shell "/usr/bin/zsh"

create_symlinks() {
    # Get the directory in which this script lives.
    script_dir=$(dirname "$(readlink -f "$0")")

    # Get a list of all files in this directory that start with a dot.
    files=$(find "$script_dir" -maxdepth 1 -type f -name ".*")

    # Create a symbolic link to each file in the home directory.
    for file in $files; do
        name=$(basename "$file")
        echo "Creating symlink to $name in home directory."
        rm -rf ~/"$name"
        ln -s "$script_dir/$name" ~/"$name"
    done
}

create_symlinks

# Install oh-my-zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions.git ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

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
