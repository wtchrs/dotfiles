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

# asdf
if ! command -v asdf >/dev/null 2>&1; then
  echo "\n${RED}Warning: ${RESET}${BOLD}asdf${RESET} not found. Visit https://github.com/asdf-vm/asdf/releases."
else
  export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
fi

# pnpm
export PNPM_HOME="${HOME}/.local/share/pnpm"
if [[ ":$PATH:" != *":$PNPM_HOME:"* ]]; then
    export PATH="$PNPM_HOME:$PATH"
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

#########################
# Starship Prompt
#########################

export STARSHIP_CONFIG=${XDG_CONFIG_HOME:-${HOME}/.config}/starship.toml
STARSHIP_INSTALL_DIR=${HOME}/.local/bin

install_starship() {
  echo "${YELLOW}Install Starship...${RESET}"
  mkdir -p $STARSHIP_INSTALL_DIR
  command sh <(curl -sS https://starship.rs/install.sh) -y --bin-dir $STARSHIP_INSTALL_DIR
}

update_starship() {
  if ! type starship >/dev/null; then
    install_starship
    return 0;
  fi

  INSTALLED_VERSION=$(starship --version | head -n 1 | awk '{print $2}')
  RELEASE_LATEST_VERSION=$(curl -s https://api.github.com/repos/starship/starship/releases/latest |
      grep 'tag_name' |
      sed -E 's/.*"v?([^"]+)".*/\1/')

  if [[ -z "$RELEASE_LATEST_VERSION" ]]; then
    echo "Unable to fetch latest version info."
    return 1
  fi

  LATEST_VERSION=$(printf '%s\n%s' "$INSTALLED_VERSION" "$LATEST_VERSION" | sort -rV | head -n 1)

  if [[ "$INSTALLED_VERSION" != "$LATEST_VERSION" ]]; then
    install_starship
  else
    echo "${YELLOW}Starship v${INSTALLED_VERSION}${RESET} is up to date."
  fi
}

# Install Starship if not installed.
if ! type starship > /dev/null; then
  install_starship
fi

# Load starship if current session is not a TTY.
[[ -t 1 ]] && eval "$(starship init zsh)"

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
if [ -x nvim ]; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

#########################
# Aliases
#########################

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
elif command -v batcat > /dev/null 2>&1; then
  alias bat="batcat"
  alias cat="bat --paging=never"
fi
