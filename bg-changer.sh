#!/usr/bin/env sh

if [ -f $1 ]; then
    cp $1 $HOME/Pictures/wallpaper/wallpaper.jpg
    feh --bg-fill $HOME/Pictures/wallpaper/wallpaper.jpg
else
    echo There is no such file \"$1\"
fi


