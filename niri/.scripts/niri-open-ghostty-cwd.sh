#!/bin/bash
# Before running this script,
# make sure you have "gtk-single-instance=false" set in your Ghostty config

set -euo pipefail

layout=$(niri msg -j windows)

# Fallback if layout is empty or not a json
if ! jq -e . >/dev/null 2>&1 <<<"$layout"; then
    ghostty &
    exit 0
fi

focused_node=$(echo "$layout" | jq -r '.. | select(.is_focused? == true)')
focused_pid=$(echo "$focused_node" | jq -r '.pid // empty')
app_id=$(echo "$focused_node" | jq -r '.app_id // empty')

# Fallback if no focused window or not Ghostty
if [[ -z "$focused_pid" ]] || [[ "${app_id,,}" != *"ghostty"* ]]; then
    ghostty &
    exit 0
fi

child_pid=$(pgrep -P "$focused_pid" --oldest)
target_pid="${child_pid:-$focused_pid}"
cwd=$(readlink "/proc/${target_pid}/cwd")

if [[ -d "$cwd" ]]; then
    ghostty --working-directory="$cwd" &
else
    # Fallback if directory resolution fails
    ghostty &
fi
