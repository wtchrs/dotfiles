#!/usr/bin/env bash

function uptime() {
  local format upweek upday uphour upminute upsecond

  upsecond=$(cut -d " " -f 1 </proc/uptime)
  upweek=$(echo "$upsecond / 604800" | bc)
  upsecond=$(echo "$upsecond % 604800" | bc)
  upday=$(echo "$upsecond / 86400" | bc)
  upsecond=$(echo "$upsecond % 86400" | bc)
  uphour=$(echo "$upsecond / 3600" | bc)
  upsecond=$(echo "$upsecond % 3600" | bc)
  upminute=$(echo "$upsecond / 60" | bc)

  if [ "$upweek" -ne "0" ]; then
    format="${upweek}w"
  fi

  if [ "$upday" -ne "0" ]; then
    if [ -z "$format" ]; then
      format="${upday}d"
    else
      format="$format ${upday}d"
    fi
  fi

  if [ "$uphour" -ne "0" ]; then
    if [ -z "$format" ]; then
      format="${uphour}h"
    else
      format="$format ${uphour}h"
    fi
  fi

  if [ -z "$format" ] || [ "$upminute" -ne "0" ]; then
    if [ -z "$format" ]; then
      format="${upminute} min"
    else
      format="$format ${upminute}m"
    fi
  fi

  echo "$format"
}

function main() {
  local format width=$1

  if [ "$width" -lt 60 ]; then
    format=""
  elif [ "$width" -lt 100 ]; then
    format="#[fg=colour250,bold][#S] #[fg=colour245,nobold] up $(uptime)  \
$(cut -d " " -f 1-3 </proc/loadavg)#[fg=colour237,nobold] #[fg=colour248,bg=c\
olour237,nobold]#[fg=colour16,bg=colour248,bold]"
  else
    format="SESSION #[fg=colour250,bold][#S] #[fg=colour245,nobold] up \
$(uptime)  $(cut -d " " -f 1-3 </proc/loadavg)#[fg=colour237,nobold] #[fg=co\
lour247,bg=colour237,nobold] $(date -I)#[fg=colour241,bg=colour237,nobold] #[\
fg=colour252,bg=colour237,bold] $(date +"%I:%M %p")#[fg=colour248,bg=colour237\
,nobold] #[fg=colour16,bg=colour248,bold] #H "
  fi

  echo "$format"
}

main "$1"
