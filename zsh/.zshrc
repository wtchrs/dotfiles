# Define colors and text attributes
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
BOLD=$(tput bold)
RESET=$(tput sgr0)

# Add path
export PATH="$HOME/.local/bin:$PATH"

### Zinit Settings {{{

# Install Zinit if not installed
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light-mode for \
    zdharma-continuum/zinit-annex-readurl \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

zinit snippet OMZP::command-not-found
zinit snippet OMZP::sudo

# fzf
zinit ice from"gh-r" as"program"
zinit light junegunn/fzf

# zinit ice wait"lucid" atload"zicompinit; zicdreplay" from"Aloxaf/fzf-tab"
# zinit snippet ':fzf-tab:*' fzf-command ftb-tmux-popup
zinit wait lucid for \
  atload"zicompinit; zicdreplay" Aloxaf/fzf-tab
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

zinit wait lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
 blockf \
    zsh-users/zsh-completions \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

### }}} END Zinit Settings

### Starship Prompt Settings {{{

export STARSHIP_CONFIG=${XDG_CONFIG_HOME:-${HOME}/.config}/starship.toml
STARSHIP_INSTALL_DIR=${HOME}/.local/bin

# Install Starship if not installed.
if ! type starship > /dev/null; then
  mkdir -p $STARSHIP_INSTALL_DIR
  command sh <(curl -sS https://starship.rs/install.sh) -y --bin-dir $STARSHIP_INSTALL_DIR
fi

# Load starship if current session is not a TTY.
if [[ "$(tty)" != /dev/tty* ]]; then
  eval "$(starship init zsh)"
fi

### }}} End Starship Prompt Settings

# Check if asdf is installed
if ! command -v asdf >/dev/null 2>&1; then
  echo "\n${RED}Warning: ${RESET}${BOLD}asdf${RESET} not found. Visit https://github.com/asdf-vm/asdf/releases."
else
  export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
fi

# for zsh emacs mode shortcuts
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

# Default editor
if [ -x nvim ]; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

# Aliases
setopt completealiases
alias tmux="env TERM=screen-256color tmux"

if command -v eza >/dev/null 2>&1; then
  alias ls="eza --icons"
  alias ll="ls -aal"
else
  alias ls="ls --color=auto -h"
  alias ll="ls -al"
fi

if command -v bat >/dev/null 2>&1; then
  alias cat="bat --paging=never"
fi

# pnpm
export PNPM_HOME="${HOME}/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
