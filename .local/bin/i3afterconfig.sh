#!/bin/bash

# for the laptop at work, setup the dual monitor setup
if [ $HOSTNAME == "archlenovo" ]; then
   xrandr --output HDMI1 --auto --right-of LVDS1
fi

# invoke feh to load the desktop background
feh --bg-scale ~/desktop_background.jpg
