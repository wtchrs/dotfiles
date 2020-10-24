if not functions -q fundle
    eval (curl -sfL https://git.io/fundle-install)
end

eval fundle plugin 'oh-my-fish/plugin-sudope'
eval fundle plugin 'edc/bass'
eval fundle plugin 'manilarome/fishblocks'
eval fundle plugin 'h-matsuo/fish-color-scheme-switcher'

eval fundle init

eval scheme set monokai

set -g PATH $HOME/bin $HOME/.local/bin $PATH

# settings for fishblocks theme
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_showupstream informative
set -g __fish_git_prompt_showdirtystate yes
set -g __fish_git_prompt_char_stateseparator ' '
set -g __fish_git_prompt_char_cleanstate '✔'
set -g __fish_git_prompt_char_dirtystate '+'
set -g __fish_git_prompt_char_invalidstate '✖'
set -g __fish_git_prompt_char_stagedstate '●'
set -g __fish_git_prompt_char_stashstate '⚑'
set -g __fish_git_prompt_char_untrackedfiles '?'
set -g __fish_git_prompt_char_upstream_ahead ''
set -g __fish_git_prompt_char_upstream_behind ''
set -g __fish_git_prompt_char_upstream_diverged 'ﱟ'
set -g __fish_git_prompt_char_upstream_equal ''
set -g __fish_git_prompt_char_upstream_prefix ''''

# nvm load
set -q NVM_DIR; or set -gx NVM_DIR ~/.nvm
set -q nvm_prefix; or set -gx nvm_prefix $NVM_DIR
eval bass source $nvm_prefix/nvm.sh
