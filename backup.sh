#!/usr/bin/env sh

cp ~/.tmux.conf ./settings/tmux.conf
cp ~/.zshrc ./settings/zshrc

cp ~/.xinitrc ./settings/xinitrc
cp ~/.Xresources ./settings/Xresources
cp ~/.imwheelrc ./settings/imwheelrc

cp -r ~/Scripts ./settings
cp -r ~/Pictures ./settings

cp -r ~/.config/alacritty ./settings/config
cp -r ~/.config/cava ./settings/config
cp -r ~/.config/compton ./settings/config
cp -r ~/.config/dunst ./settings/config
cp -r ~/.config/i3 ./settings/config
cp -r ~/.config/mpd ./settings/config
cp -r ~/.config/polybar ./settings/config
cp -r ~/.config/ranger ./settings/config
