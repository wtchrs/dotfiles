#!/usr/bin/env bash
# Before running this script,
# make sure you have "gtk-single-instance=false" set in your Ghostty config

set -euo pipefail

active_json="$(hyprctl -j activewindow 2>/dev/null || true)"

# Fallback if layout is empty or not a json
if ! jq -e . >/dev/null 2>&1 <<<"$active_json"; then
    ghostty &
    exit 0
fi

focused_pid="$(jq -r '.pid // empty' <<<"$active_json")"
app_class="$(jq -r '.class // .initialClass // empty' <<<"$active_json")"

# Fallback if no focused window or not Ghostty
if [[ -z "${focused_pid}" ]] || [[ "${app_class,,}" != *ghostty* ]]; then
    ghostty &
    exit 0
fi

child_pid="$(pgrep -P "$focused_pid" --oldest 2>/dev/null | head -n1 || true)"
target_pid="${child_pid:-$focused_pid}"

cwd="$(readlink -f "/proc/${target_pid}/cwd" 2>/dev/null || true)"

if [[ -n "$cwd" && -d "$cwd" ]]; then
    ghostty --working-directory="$cwd" &
else
    ghostty &
fi
