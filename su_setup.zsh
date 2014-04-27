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

    if ! [[ -d "/etc/systemd/system/timer-hourly.target.wants" ]]; then
        mkdir /etc/systemd/system/timer-hourly.target.wants
    fi
    if ! [[ -d "/etc/systemd/system/timer-daily.target.wants" ]]; then
        mkdir /etc/systemd/system/timer-daily.target.wants
    fi
    if ! [[ -d "/etc/systemd/system/timer-weekly.target.wants" ]]; then
        mkdir /etc/systemd/system/timer-weekly.target.wants
    fi
    if ! [[ -d "/etc/systemd/system/timer-monthly.target.wants" ]]; then
        mkdir /etc/systemd/system/timer-monthly.target.wants
    fi
    if ! [[ -d "/etc/systemd/system/timer-yearly.target.wants" ]]; then
        mkdir /etc/systemd/system/timer-yearly.target.wants
    fi

    ask-for-replace "slim.conf" /etc/slim.conf
    ask-for-replace "dmenu_run" /usr/bin/dmenu_run

    ask-for-replace "timer-hourly.timer" /etc/systemd/system/timer-hourly.timer
    ask-for-replace "timer-hourly.target" /etc/systemd/system/timer-hourly.target
    ask-for-replace "timer-daily.timer" /etc/systemd/system/timer-daily.timer
    ask-for-replace "timer-daily.target" /etc/systemd/system/timer-daily.target
    ask-for-replace "timer-weekly.timer" /etc/systemd/system/timer-weekly.timer
    ask-for-replace "timer-weekly.target" /etc/systemd/system/timer-weekly.target
    ask-for-replace "timer-monthly.timer" /etc/systemd/system/timer-monthly.timer
    ask-for-replace "timer-monthly.target" /etc/systemd/system/timer-monthly.target
    ask-for-replace "timer-yearly.timer" /etc/systemd/system/timer-yearly.timer
    ask-for-replace "timer-yearly.target" /etc/systemd/system/timer-yearly.target

    # if emacs does not exist as a systemd service
    if [[ `systemctl status google-calendar-to-org` =~ ".*Loaded: not-found.*" ]]; then
        cp etc/google-calendar-to-org.service /etc/systemd/system/google-calendar-to-org.service
    fi

    echo "Done!"
else
    echo "Please run this script with super user privileges"
fi
