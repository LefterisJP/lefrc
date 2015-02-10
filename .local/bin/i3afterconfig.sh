#!/bin/bash

# for laptop at work
if [ $HOSTNAME == "archlenovo" ]; then
   xrandr --output DisplayPort-1-0 --auto --right-of eDP-1-0
fi

# invoke feh to load the desktop background
feh --bg-scale ~/desktop_background.jpg
