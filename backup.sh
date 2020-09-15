#!/usr/bin/env bash

cp ~/.vimrc     ./.vimrc
cp ~/.tmux.conf ./.tmux.conf

cp ~/.xinitrc    ./gui-settings/.xinitrc
cp ~/.Xresources ./gui-settings/.Xresources

cp -r ~/Scripts  ./gui-settings
cp -r ~/Pictures ./gui-settings

cp -r ~/.config/compton ./gui-settings/.config
cp -r ~/.config/dunst   ./gui-settings/.config
cp -r ~/.config/i3      ./gui-settings/.config
cp -r ~/.config/mpd     ./gui-settings/.config
cp -r ~/.config/polybar ./gui-settings/.config
cp -r ~/.config/ranger  ./gui-settings/.config
