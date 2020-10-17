#!/usr/bin/env sh

wpdir="$HOME/Pictures/wallpaper"

c_err=$(tput setaf 9)
c_reset=$(tput sgr0)

if [ -f "$1" ]; then
  if [[ "$1" =~ .*\.jpg$ ]] || [[ "$1" =~ .*\.jpeg$ ]]; then
    rm -f "$wpdir/wallpaper.jpg" "$wpdir/wallpaper.png"
    cp "$1" "$wpdir/wallpaper.jpg"
    feh --bg-fill "$wpdir/wallpaper.jpg"
  elif [[ "$1" =~ .*\.png$ ]]; then
    rm -f "$wpdir/wallpaper.jpg" "$wpdir/wallpaper.png"
    cp "$1" "$wpdir/wallpaper.png"
    feh --bg-fill "$wpdir/wallpaper.png"
  else
    echo "$0: wrong file extension: ${c_err}$1${c_reset}" >&2
    echo "Retry with *.jpg or *.png" >&2
    exit 1
  fi
else
  echo "$0: no such file: ${c_err}$1${c_reset}" >&2
  exit 1
fi
