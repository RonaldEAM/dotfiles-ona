# When SSH-ing from Kitty, remote machines lack xterm-kitty terminfo
if [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]] && [[ "$TERM" == "xterm-kitty" ]]; then
  export TERM="xterm-256color"
fi

# Delete / backspace key bindings — SSH terminals vary in what they send
bindkey "^[[3~" delete-char
bindkey "^?" backward-delete-char
bindkey "^H"  backward-delete-char
