#!/usr/bin/env sh

cp ./settings/xinitrc ~/.xinitrc
cp ./settings/Xresources ~/.Xresources

cp -r ./settings/Scripts ~
cp -r ./settings/Pictures ~

cp -r ./settings/config/alacritty ~/.config
cp -r ./settings/config/cava ~/.config
cp -r ./settings/config/compton ~/.config
cp -r ./settings/config/dunst ~/.config
cp -r ./settings/config/i3 ~/.config
cp -r ./settings/config/mpd ~/.config
cp -r ./settings/config/polybar ~/.config
cp -r ./settings/config/ranger ~/.config
