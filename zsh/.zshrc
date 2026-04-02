#########################
# Shell Options
#########################

# Emacs keybindings
bindkey -e
bindkey '^H' backward-kill-word

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=10000000

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt EXTENDED_HISTORY

setopt sharehistory
setopt incappendhistorytime

# path and fpath
typeset -U path
typeset -U fpath

path=("$HOME/.local/bin" $path)

# Editor
if (( $+commands[nvim] )); then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

# GPG
export GPG_TTY=$(tty)

# pnpm
export PNPM_HOME="${HOME}/.local/share/pnpm"
[[ -d $PNPM_HOME ]] && path+=("$PNPM_HOME")

# broot
[[ -f "$HOME/.config/broot/launcher/bash/br" ]] && source "$HOME/.config/broot/launcher/bash/br"

#########################
# Zinit
#########################

# Install Zinit if not installed
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname -- "$ZINIT_HOME")"
  (( $+commands[git] )) || return
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

# OMZ Plugins
zinit snippet OMZP::command-not-found
zinit snippet OMZP::sudo

#########################
# Starship Prompt
#########################

# Load starship if current session is in graphic or ssh.
if [[ -n "$DISPLAY" || -n "$WAYLAND_DISPLAY" || -n "$SSH_CONNECTION" ]]; then
  zinit ice \
      as"program" \
      from"gh-r" \
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

if (( $+commands[fd] )); then
  # Set custom commands
  export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

  _fzf_compgen_path() { fd --hidden --exclude .git . "$1" }
  _fzf_compgen_dir() { fd --type=d --hidden --exclude .git . "$1" }
fi

zinit ice from"gh-r" as"program" atload"source <(fzf --zsh)"
zinit light junegunn/fzf

# Load fzf-tab
zinit ice wait"0" lucid
zinit light Aloxaf/fzf-tab

zstyle ':fzf-tab:*' fzf-command fzf
zstyle ':fzf-tab:*' fzf-pad 4
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=always "$realpath"'
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no

#########################
# asdf
#########################

export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"

zinit ice \
    as"program" \
    from"gh-r" \
    atclone'./asdf completion zsh > _asdf' \
    atpull"%atclone" \
    atload'path=("$ASDF_DATA_DIR/shims" $path)'
zinit light asdf-vm/asdf

#########################
# Completions
#########################

zinit ice blockf
zinit light zsh-users/zsh-completions

# Load visual-aid plugins
zinit ice wait"0" lucid
zinit light zdharma-continuum/fast-syntax-highlighting
zinit ice wait"0" lucid atload"!_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

# Load no actual plugin, but execute only initialization
zinit ice atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay"
zinit light zdharma-continuum/null

#########################
# Aliases
#########################

if (( $+commands[eza] )); then
  alias ls="eza --icons"
  alias ll="ls -aal"
else
  alias ls="ls --color=auto -h"
  alias ll="ls -al"
fi

if (( $+commands[bat] )); then
  alias cat="bat --paging=never --theme=Nord"
elif (( $+commands[batcat] )); then
  alias bat="batcat"
  alias cat="bat --paging=never --theme=Nord"
fi
