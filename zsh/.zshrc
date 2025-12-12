#########################
# Colors
#########################

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BOLD=$(tput bold)
RESET=$(tput sgr0)

#########################
# PATH
#########################

export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="${HOME}/.local/share/pnpm"
if [[ ":$PATH:" != *":$PNPM_HOME:"* ]]; then
    export PATH="$PATH:$PNPM_HOME"
fi

#########################
# Shell Options & Editor
#########################

# Emacs keybindings
bindkey -e
bindkey '^H' backward-kill-word

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt appendhistory
setopt sharehistory
setopt incappendhistory

# Editor
if command -v nvim >/dev/null 2>&1; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

#########################
# Zinit
#########################

# Install Zinit if not installed
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Annexes
zinit light-mode for \
    zdharma-continuum/zinit-annex-readurl \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# Plugins
zinit snippet OMZP::command-not-found
zinit snippet OMZP::sudo

zinit wait lucid for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  blockf \
    zsh-users/zsh-completions \
  atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

#########################
# Starship Prompt
#########################

# Load starship if current session is not a TTY.
if [[ -t 1 ]]; then
  zinit ice as"command" from"gh-r" \
            atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
            atpull"%atclone" src"init.zsh"
  zinit light starship/starship
fi

# Apply different settings depending on terminal width.
set_starship_config_precmd() {
  if [ "$COLUMNS" -lt 75 ]; then
    export STARSHIP_CONFIG=${XDG_CONFIG_HOME:-${HOME}/.config}/starship_short.toml
  else
    export STARSHIP_CONFIG=${XDG_CONFIG_HOME:-${HOME}/.config}/starship.toml
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd set_starship_config_precmd

#########################
# fzf
#########################

zinit ice from"gh-r" as"program" atload"eval \"\$(fzf --zsh)\""
zinit light junegunn/fzf

if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

  _fzf_compgen_path() {
    fd --hidden --exclude .git . "$1"
  }
  
  # Use fd to generate the list for directory completion
  _fzf_compgen_dir() {
    fd --type=d --hidden --exclude .git . "$1"
  }
fi

#########################
# asdf
#########################

zinit ice as"command" from"gh-r"
zinit light asdf-vm/asdf
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

#########################
# Aliases
#########################

setopt completealiases
alias tmux="env TERM=tmux-256color tmux"

if command -v eza >/dev/null 2>&1; then
  alias ls="eza --icons"
  alias ll="ls -aal"
else
  alias ls="ls --color=auto -h"
  alias ll="ls -al"
fi

if command -v bat >/dev/null 2>&1; then
  alias cat="bat --paging=never"
elif command -v batcat > /dev/null 2>&1; then
  alias bat="batcat"
  alias cat="bat --paging=never"
fi
