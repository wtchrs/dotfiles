#!/usr/bin/env sh

WHOAMI=$(whoami)
SESSION_NAME=${WHOAMI}

if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  tmux -2 attach-session -t "$SESSION_NAME"
else
  tmux -2 new-session -s "$SESSION_NAME"
fi
