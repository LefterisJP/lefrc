#!/bin/zsh

# ask the user (me) if I want to replace something
function ask-for-replace () {
    while true; do
    yn="" # maybe stupid? So that vared does not echo back last value
    vared -cp "Do you wish to replace $1?" yn
    echo "\n"
    case $yn in
        [Yy]* ) cp etc/$1 $2; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.\n";;
    esac
    done
}

if [[ $UID == 0 || $EUID == 0 ]]; then

    # if emacs does not exist as a systemd service
    if [[ `systemctl status emacs@lefteris` =~ ".*Loaded: not-found.*" ]]; then
        cp etc/emacs@.service /etc/systemd/system/emacs@.service
    fi

    ask-for-replace "slim.conf" /etc/slim.conf
    ask-for-replace "dmenu_run" /usr/bin/dmenu_run

    echo "Done!"
else
    echo "Please run this script with super user privileges"
fi
