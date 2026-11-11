# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
  PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi
unset rc

# --- prompt -----------------------------------------------------------------
# hex -> truecolor escape, wrapped in \[ \] so bash computes line width right
_c() { printf '\[\e[38;2;%d;%d;%dm\]' "0x${1:0:2}" "0x${1:2:2}" "0x${1:4:2}"; }

C_USER=$(_c c27861) # accent
C_PATH=$(_c 79b1c3) # type
C_GIT=$(_c 60766b)  # comment
C_OK=$(_c 67a29e)   # keyword
C_ERR=$(_c d45c54)  # red
C_RST='\[\e[0m\]'

# truncate to the last 3 path components, prefixed with "..."
PROMPT_DIRTRIM=3

_git_branch() {
  local b
  b=$(git symbolic-ref --short HEAD 2>/dev/null) ||
    b=$(git rev-parse --short HEAD 2>/dev/null) || return
  printf ' %s' "$b"
}

_set_ps1() {
  local st=$?
  local mark
  ((st == 0)) && mark=$C_OK || mark=$C_ERR
  PS1="${C_USER}\u ${C_PATH}\w${C_GIT}$(_git_branch)${C_RST}\n${mark}❯${C_RST} "
}
PROMPT_COMMAND=_set_ps1

alias n='nvim'
alias c='clear'
alias ff='fastfetch'

export PATH=$PATH:$HOME/.spicetify
