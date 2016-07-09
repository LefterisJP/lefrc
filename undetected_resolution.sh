#!/bin/bash
# A script to add undetected resolution to an Xorg conf file

SCRIPT_NAME="undetected_resolution.sh"
CONTENTS="# For the optimus configuration
Section \"Module\"
    Load \"modesetting\"
EndSection
Section \"Monitor\"
    Identifier \"eDP-1\"
    #LINE
    Option \"PreferredMode\" #MODE
EndSection

Section \"Screen\"
    Identifier \"Screen0\"
    Monitor \"eDP-1\"
    DefaultDepth 24
    SubSection \"Display\"
        Modes #MODE
    EndSubSection
EndSection

# Some of these may require calibration depending on the laptop.
# This configuration is required due to my current laptop having Optimus
Section \"Device\"
    Identifier \"nvidia\"
    Driver \"nvidia\"
    VendorName \"Nvidia Corporation\"
    BoardName \"GeForce GT 730M\"
    BusID \"PCI:1:0:0\"
    Option \"AllowEmptyInitialConfiguration\"
EndSection"


if [ "$(id -u)" != "0" ]; then
    echo "${SCRIPT_NAME} must be ran as root";
    exit 1
fi


# for now only the given resolution, later customize
MODELINE=$(cvt 1920 1080 | sed -n '2 p')
MODE=$(echo $MODELINE | cut -d' ' -f2)


if [[ ! -f /etc/X11/xorg.conf.d/10-monitor.conf ]]; then
    # Create the conf file if it does not exist and populate it
    touch /etc/X11/xorg.conf.d/10-monitor.conf
    echo "$CONTENTS" > /etc/X11/xorg.conf.d/10-monitor.conf
    sed -i -e "s/#LINE/$MODELINE/g" /etc/X11/xorg.conf.d/10-monitor.conf
    sed -i -e "s/#MODE/$MODE/g" /etc/X11/xorg.conf.d/10-monitor.conf
else
    # If it exists simply add the option and also make it the preferred option
    sed -i "/Identifier \"eDP-1\"/a $MODELINE" /etc/X11/xorg.conf.d/10-monitor.conf
    sed -i "s/^.*Option \"PreferredMode\".*/    Option \"PreferredMode\" $MODE/" /etc/X11/xorg.conf.d/10-monitor.conf
fi

