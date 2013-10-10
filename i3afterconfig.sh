#!/bin/bash

# for the laptop at work, setup the dual monitor setup
if [ $HOSTNAME == "archlenovo" ]; then
   xrandr --output HDMI1 --auto --right-of LVDS1
fi
