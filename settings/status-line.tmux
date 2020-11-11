#!/usr/bin/env bash

function uptime() {
  local upfmt upweek upday uphour upminute upsecond

  upsecond=$(cut -d " " -f 1 </proc/uptime)
  upweek=$(echo "$upsecond / 604800" | bc)
  upsecond=$(echo "$upsecond % 604800" | bc)
  upday=$(echo "$upsecond / 86400" | bc)
  upsecond=$(echo "$upsecond % 86400" | bc)
  uphour=$(echo "$upsecond / 3600" | bc)
  upsecond=$(echo "$upsecond % 3600" | bc)
  upminute=$(echo "$upsecond / 60" | bc)

  if [ "$upweek" -ne "0" ]; then
    upfmt="${upweek}w"
  fi

  if [ "$upday" -ne "0" ]; then
    if [ -z "$upfmt" ]; then
      upfmt="${upday}d"
    else
      upfmt="$upfmt ${upday}d"
    fi
  fi

  if [ "$uphour" -ne "0" ]; then
    if [ -z "$upfmt" ]; then
      upfmt="${uphour}h"
    else
      upfmt="$upfmt ${uphour}h"
    fi
  fi

  if [ -z "$upfmt" ] || [ "$upminute" -ne "0" ]; then
    if [ -z "$upfmt" ]; then
      upfmt="${upminute} min"
    else
      upfmt="$upfmt ${upminute}m"
    fi
  fi

  echo "$upfmt"
}

function main() {
  local fmt width=$1

  if [ "$width" -lt 80 ]; then
    fmt="#[fg=colour237,nobold]#[fg=colour248,bg=colour237,nobold]"
  elif [ "$width" -lt 120 ]; then
    fmt="#[fg=colour250,bold][#S] #[fg=colour245,nobold] up $(uptime)  \
$(cut -d " " -f 1-3 </proc/loadavg)#[fg=colour237,nobold] #[fg=colour248,bg=c\
olour237,nobold]"
  else
    fmt="SESSION #[fg=colour250,bold][#S] #[fg=colour245,nobold] up $(uptime)\
  $(cut -d " " -f 1-3 </proc/loadavg)#[fg=colour237,nobold] #[fg=colour247,b\
g=colour237,nobold] $(date -I)#[fg=colour241,bg=colour237,nobold] #[fg=colour\
252,bg=colour237,bold] $(date +"%I:%M %p")#[fg=colour248,bg=colour237,nobold] \
#[fg=colour16,bg=colour248,bold] #H "
  fi

  echo "$fmt"
}

main "$1"
