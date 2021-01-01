#!/bin/sh

# https://github.com/jaagr/polybar/wiki/User-contributed-modules

#The command for starting compton
#always keep the -b argument!

if pgrep -x "picom" > /dev/null
then
	killall picom
else
	picom --backend glx -cb --config ~/.config/compton/compton.conf
fi
