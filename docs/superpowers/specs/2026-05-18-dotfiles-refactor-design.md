# Dotfiles Refactor Design

**Date:** 2026-05-18  
**Goal:** Adopt the symlink-based pattern from edzhao-vanta/dotfiles — flat repo root, auto-discovered dot files symlinked to `$HOME`, zsh + oh-my-zsh.

---

## File Structure

**After refactor:**

```
dotfiles-ona/
├── .gitaliases     # git aliases (moved from shell/git.sh)
├── .zshrc          # copied from edzhao-vanta/dotfiles, plus source ~/.gitaliases
├── install.sh      # orchestrator (see below)
└── docs/           # unchanged
```

**Deleted:**
- `shell/git.sh`
- `shell/` directory
- `claude/claude.sh`
- `claude/` directory

---

## `.gitaliases`

Exact content of current `shell/git.sh` — the `git_main_branch` helper and all git aliases. No changes to the aliases themselves.

---

## `.zshrc`

Exact copy of `edzhao-vanta/dotfiles/.zshrc`, with one addition at the end:

```zsh
source ~/.gitaliases
```

Key elements from the reference:
- `export ZSH="$HOME/.oh-my-zsh"`
- `ZSH_THEME="devcontainers"`
- `plugins=(git zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting)`
- `fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src`
- `autoload -U compinit && compinit`
- `source $ZSH/oh-my-zsh.sh`
- `source /etc/profile.d/ona-secrets.sh`
- `DISABLE_AUTO_UPDATE=true` / `DISABLE_UPDATE_PROMPT=true`

---

## `install.sh`

Five ordered steps:

```bash
#!/bin/bash

# 1. Change default shell to zsh
sudo chsh "$(id -un)" --shell "/usr/bin/zsh"

# 2. Symlink all dot files from repo root to $HOME
create_symlinks() {
    script_dir=$(dirname "$(readlink -f "$0")")
    files=$(find "$script_dir" -maxdepth 1 -type f -name ".*")
    for file in $files; do
        name=$(basename "$file")
        echo "Creating symlink to $name in home directory."
        rm -rf ~/"$name"
        ln -s "$script_dir/$name" ~/"$name"
    done
}
create_symlinks

# 3. Install oh-my-zsh (if not already installed)
[ ! -d "$HOME/.oh-my-zsh" ] && \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# 4. Clone zsh plugins (same paths as reference)
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 5. Claude Code plugins (logic inlined from claude/claude.sh)
# ... existing claude.sh logic unchanged ...
```

---

## Key Behavioral Changes

| Before | After |
|---|---|
| Copies `shell/git.sh` to `~/.shell/git.sh` | Symlinks `.gitaliases` to `~/.gitaliases` |
| Appends `source` lines to `~/.bash_profile` | `.zshrc` already sources what it needs |
| Default shell: bash | Default shell: zsh |
| No oh-my-zsh | oh-my-zsh installed by `install.sh` |
| No zsh plugins | 4 plugins via oh-my-zsh custom dir |
| `append_once` helper | Removed (symlinks replace it) |

---

## Adding New Configs in the Future

Drop a new dot file in the repo root — `install.sh`'s `create_symlinks()` picks it up automatically on next run. No wiring needed.
