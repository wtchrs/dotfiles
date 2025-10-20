#!/usr/bin/env bash

CURRENT_RIGHT=$(tmux show-options -gqv status-right)
NEW_RIGHT="#[fg=grey]#(~/.scripts/tmux-uptime.sh)  #(~/.scripts/tmux-loadavg.sh) ${CURRENT_RIGHT}"
tmux set -g status-right "$NEW_RIGHT"
