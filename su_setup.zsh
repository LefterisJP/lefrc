#!/bin/zsh

source /home/lefteris/.zsh_functions

if [[ $UID == 0 || $EUID == 0 ]]; then

    assert-dir-exists "/etc/systemd/system/timer-hourly.target.wants"
    assert-dir-exists "/etc/systemd/system/timer-daily.target.wants"
    assert-dir-exists "/etc/systemd/system/timer-weekly.target.wants"
    assert-dir-exists "/etc/systemd/system/timer-monthly.target.wants"
    assert-dir-exists "/etc/systemd/system/timer-yearly.target.wants"

    assert-dir-exists "/etc/systemd/system/lefteris@.service.d"


    ask-for-replace "lefteris_environment.conf" /etc/systemd/system/lefteris@.service.d/environment.conf
    ask-for-replace "slim.conf" /etc/slim.conf
    ask-for-replace "dmenu_run" /usr/bin/dmenu_run
    ask-for-replace "pam.d_login" /etc/pam.d/login
    ask-for-replace "pam.d_passwd" /etc/pam.d/passwd

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

    ask-for-replace "google-calendar-to-org.service" /etc/systemd/system/google-calendar-to-org.service
    ask-for-replace "org-sync.service" /etc/systemd/system/org-sync.service

    systemd-service-query-or-create "google-calendar-to-org"
    systemd-service-query-or-create "org-sync"

    # the above services run on the hourly timer so make sure it runs
    systemd-service-assert-enabled timer-hourly.timer

    ask-for-replace "dbus.socket" /etc/systemd/user/dbus.socket
    ask-for-replace "dbus.service" /etc/systemd/user/dbus.service
    systemctl --global enable dbus.socket

    echo "Done!"
else
    echo "Please run this script with super user privileges"
fi
