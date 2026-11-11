## ~/.zshrc

# --- path -------------------------------------------------------------------
# typeset -U keeps `path` deduped automatically; no need for the =~ guard
typeset -U path PATH
path=($HOME/.local/bin $HOME/bin $HOME/.spicetify $path)
export PATH

# --- drop-in configs --------------------------------------------------------
if [[ -d ~/.zshrc.d ]]; then
  for rc in ~/.zshrc.d/*(.N); do
    source "$rc"
  done
  unset rc
fi

# --- prompt -----------------------------------------------------------------
setopt PROMPT_SUBST

# hex -> truecolor escape, wrapped in %{ %} so zsh computes line width right
_c() { printf '%%{\e[38;2;%d;%d;%dm%%}' $((16#${1:0:2})) $((16#${1:2:2})) $((16#${1:4:2})) }

C_USER=$(_c c27861)  # accent
C_PATH=$(_c 79b1c3)  # type
C_GIT=$(_c 60766b)   # comment
C_OK=$(_c 67a29e)    # keyword
C_ERR=$(_c d45c54)   # red
C_RST='%f'

_git_branch() {
  local b
  b=$(git symbolic-ref --short HEAD 2>/dev/null) ||
    b=$(git rev-parse --short HEAD 2>/dev/null) || return
  printf ' %s' "$b"
}

PROMPT='${C_USER}%n ${C_PATH}%(4~|.../%3~|%~)${C_GIT}$(_git_branch)${C_RST}
%(?.${C_OK}.${C_ERR})❯${C_RST} '

# --- aliases ----------------------------------------------------------------
alias n='nvim'
alias c='clear'
alias ff='fastfetch'
alias l='ls -la'

HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS SHARE_HISTORY

autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

bindkey -e

# Navigation keys (Alacritty's escape codes)
bindkey '^[[1;5D' backward-word      # Ctrl+Left
bindkey '^[[1;5C' forward-word       # Ctrl+Right
bindkey '^[[H'    beginning-of-line  # Home
bindkey '^[[1~'   beginning-of-line
bindkey '^[OH'    beginning-of-line
bindkey '^[[F'    end-of-line        # End
bindkey '^[[4~'   end-of-line
bindkey '^[OF'    end-of-line
bindkey '^[[3~'   delete-char        # Delete

unset zle_bracketed_paste
