#!/bin/bash

# for the desktop make sure that udiskie is running.
# TODO: Maybe do this in the work laptop too?
if [ $HOSTNAME == "archdesktop" ]; then
    udiskie &
fi

# generate i3 config from the templates
exec ~/.local/bin/gen-i3-config.sh

# if Xresources is there load it
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

exec i3 -V >> ~/.i3/i3log 2>&1
