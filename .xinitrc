#!/bin/bash

# make sure udiskie is running, for usb auto detection
udiskie &
# for the desktop set the resolution 
if [ $HOSTNAME == "archdesktop" ]; then
    # also set the 120HZ resolution
    xrandr --output DVI-I-1 --mode 0x281
fi

# generate i3 config from the templates
~/.local/bin/gen-i3-config.sh

# if Xresources is there load it
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

exec i3 -V >> ~/.i3/i3log 2>&1
