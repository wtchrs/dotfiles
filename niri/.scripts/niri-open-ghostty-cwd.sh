#!/bin/bash

layout=$(niri msg -j windows)

focused_node=$(echo "$layout" | jq -r '.. | select(.is_focused? == true)')
focused_pid=$(echo "$focused_node" | jq -r '.pid')
app_id=$(echo "$focused_node" | jq -r '.app_id')

# If no focused window or not Ghostty, just open a default Ghostty
if [[ -z "$focused_pid" ]] || [[ "$focused_pid" == "null" ]] || [[ "$app_id" != *"ghostty"* ]]; then
    ghostty &
    exit 0
fi

child_pid=$(pgrep -P "$focused_pid" --oldest)
target_pid=${child_pid:-$focused_pid}
cwd=$(readlink "/proc/$target_pid/cwd")

if [[ -d "$cwd" ]]; then
    ghostty --working-directory="$cwd" &
else
    # Fallback if directory resolution fails
    ghostty &
fi
