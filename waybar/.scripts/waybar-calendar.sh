#!/usr/bin/env sh

RULE="[float; size 250 250; center]"
COMMAND="alacritty -e ~/.config/waybar/scripts/calendar-internal.sh"

hyprctl dispatch exec "${RULE} ${COMMAND}"
