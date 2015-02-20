#!/bin/bash

# make sure udiskie is running, for usb auto detection
udiskie &

# start xbindkeys to setup my keybindings
xbindkeys

# for the desktop set the refresh rate
if [ $HOSTNAME == "archdesktop" ]; then
    # also set the 120HZ refresh rate
    xrandr --output DVI-I-1 --mode 0x281
fi

#for the laptop let's disable touchpad when typing
if [ $HOSTNAME == "archlenovo" ]; then
    # more info here: https://wiki.archlinux.org/index.php/Touchpad_Synaptics#Using_.xinitrc
    syndaemon -t -k -i 2 -d &
fi

# activate custom xkeymap configuration
test -f ~/.Xkeymap && xkbcomp ~/.Xkeymap $DISPLAY

# if Xresources is there load it
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# If there is an .Xmodmap load it
if [ -f ~/.Xmodmap ]; then
    xmodmap ~/.Xmodmap
fi

#--------------------------
# Start the window manager
#--------------------------
if [ -d /etc/X11/xinit/xinitrc.d ]; then
        for f in /etc/X11/xinit/xinitrc.d/*; do
                [ -x "$f" ] && . "$f"
        done
        unset f
fi
# i3 is the default window manager
session=${1:-i3}

case $session in
    awesome           ) exec awesome;;
    bspwm             ) exec bspwm;;
    catwm             ) exec catwm;;
    cinnamon          ) exec cinnamon-session;;
    dwm               ) exec dwm;;
    enlightenment     ) exec enlightenment_start;;
    ede               ) exec startede;;
    fluxbox           ) exec startfluxbox;;
    gnome             ) exec gnome-session;;
    gnome-classic     ) exec gnome-session --session=gnome-classic;;
    i3|i3wm           ) exec i3;;
    icewm             ) exec icewm-session;;
    jwm               ) exec jwm;;
    kde               ) exec startkde;;
    mate              ) exec mate-session;;
    monster|monsterwm ) exec monsterwm;;
    notion            ) exec notion;;
    openbox           ) exec openbox-session;;
    unity             ) exec unity;;
    xfce|xfce4        ) exec startxfce4;;
    xmonad            ) exec xmonad;;
    # No known session, try to run it as command
    *) exec $1;;
esac
