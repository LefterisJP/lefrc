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

function systemd-service-query-or-create() {
    arg=$1
    # emacs is a special service so the service name is different
    if [[ $arg == emacs@lefteris ]]; then
        service_file=${arg%lefteris}
        service_file=${service_file}.service
    else
        service_file=${arg}.service
    fi

    status_result=$(systemctl status $arg)
    # echo $query
    # echo $status_result
    # echo "cp etc/${service_file} /etc/systemd/system/${service_file}"
    if [[ $status_result =~ ".*Loaded: not-found.*" ]]; then
        cp etc/$service_file /etc/systemd/system/$service_file
    fi
}

if [[ $UID == 0 || $EUID == 0 ]]; then

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

    systemd-service-query-or-create "google-calendar-to-org"
    systemd-service-query-or-create "org-sync"
    systemd-service-query-or-create "emacs@lefteris"

    # we are running things on the hourly timer for now, so make sure it's enabled
    systemctl enable timer-hourly.timer

    echo "Done!"
else
    echo "Please run this script with super user privileges"
fi
