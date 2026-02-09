#!/bin/bash

layout=$(niri msg -j windows)

focused_node=$(echo "$layout" | jq -r '.. | select(.is_focused? == true)')
focused_pid=$(echo "$focused_node" | jq -r '.pid')
app_id=$(echo "$focused_node" | jq -r '.app_id')

if [[ -z "$focused_pid" ]] || [[ "$focused_pid" == "null" ]]; then
    ghostty &
    notify-send "Error: No focused window found." "Terminal has been opened in home directory."
    exit 1
fi

# If not Ghostty, just open a default Ghostty
if [[ "$app_id" != *"ghostty"* ]]; then
    ghostty &
    exit 0
fi

child_pid=$(pgrep -P "$focused_pid" --newest)
target_pid=${child_pid:-$focused_pid}
cwd=$(readlink "/proc/$target_pid/cwd")

if [[ -d "$cwd" ]]; then
    ghostty --working-directory="$cwd" &
else
    # Fallback if directory resolution fails
    ghostty &
fi
