#!/bin/bash
# If you want to change it to zsh
# remember to change slim.conf login_cmd

# make sure udiskie is running, for usb auto detection
udiskie &
# for the desktop set the resolution 
if [ $HOSTNAME == "archdesktop" ]; then
    # also set the 120HZ resolution
    xrandr --output DVI-I-1 --mode 0x281
fi
#for the laptop let's disable touchpad when typing
if [ $HOSTNAME == "archlenovo" ]; then
    # more info here: https://wiki.archlinux.org/index.php/Touchpad_Synaptics#Using_.xinitrc
    syndaemon -t -k -i 2 -d &
fi

# activate custom xkeymap configuration
test -f ~/.Xkeymap && xkbcomp ~/.Xkeymap $DISPLAY

# generate i3 config from the templates
~/.local/bin/gen-i3-config.sh

# if Xresources is there load it
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"
# Start GNOME Keyring
eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
# You probably need to do this too:
export GPG_AGENT_INFO SSH_AUTH_SOCK


# used to have a log file. Removed it since it took too much space
# https://wiki.archlinux.org/index.php/i3
exec i3
