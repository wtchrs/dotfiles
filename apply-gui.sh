#!/usr/bin/env sh

cp ./gui-settings/.xinitrc    ~/.xinitrc
cp ./gui-settings/.Xresources ~/.Xresources 

cp -r ./gui-settings/Scripts  ~
cp -r ./gui-settings/Pictures ~

cp -r ./gui-settings/.config/compton ~/.config
cp -r ./gui-settings/.config/dunst   ~/.config
cp -r ./gui-settings/.config/i3      ~/.config
cp -r ./gui-settings/.config/mpd     ~/.config
cp -r ./gui-settings/.config/polybar ~/.config
cp -r ./gui-settings/.config/ranger  ~/.config
