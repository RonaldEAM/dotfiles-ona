# Detect the main branch (main, master, trunk, etc.)
git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local ref
  for ref in refs/heads/main refs/heads/trunk refs/heads/master refs/remotes/origin/main refs/remotes/origin/master; do
    if command git show-ref -q --verify "$ref"; then
      echo "${ref##*/}"
      return 0
    fi
  done
  echo master
}

alias gst='git status'
alias gl='git pull'
alias gp='git push'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcm='git checkout $(git_main_branch)'
alias gfo='git fetch origin'
alias glo='git log --oneline --decorate'
alias gwta='git worktree add'
alias gwtls='git worktree list'
alias gwtrm='git worktree remove'
