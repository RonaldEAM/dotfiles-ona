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


# Shared ona skills
if [ -n "$EFS_MOUNT_POINT" ] && [ -d "$EFS_MOUNT_POINT/.claude/skills" ]; then
  echo "==> Linking shared ona skills from EFS..."
  ln -sfn "$EFS_MOUNT_POINT/.claude/skills" "${HOME}/.claude/skills"
fi

echo "==> Done."
