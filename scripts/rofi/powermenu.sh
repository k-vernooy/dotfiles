#!/bin/bash


if [ -z "$@" ]; then
    echo -en "Suspend\0icon\x1fsystem-suspend\n"
    echo -en "Lock\0icon\x1fsystem-lock-screen\n"
    echo -en "Logout\0icon\x1fsystem-log-out\n"
    echo -en "Hibernate\0icon\x1fsystem-suspend-hibernate\n"
    echo -en "Reboot\0icon\x1fsystem-reboot\n"
    echo -en "Shutdown\0icon\x1fsystem-shutdown\n"
else
    if [ "$1" = "Shutdown" ]; then
        sudo shutdown now
    elif [ "$1" = "Logout" ]; then
        i3-msg exit
    elif [ "$1" = "Reboot" ]; then
        sudo reboot
    elif [ "$1" = "Suspend" ]; then
        systemctl suspend
    elif [ "$1" = "Lock" ]; then
        i3lock --nofork
        #sudo ~/.local/bin/betterlockscreen -l blur
    elif [ "$1" = "Hibernate" ]; then
        sudo systemctl hibernate
    fi
fi

