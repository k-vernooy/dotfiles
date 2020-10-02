#!/bin/bash


if [ -z "$@" ]; then
    echo -en "Shutdown\0icon\x1fsystem-shutdown\n"
    echo -en "Logout\0icon\x1fsystem-log-out\n"
    echo -en "Suspend\0icon\x1fsystem-suspend\n"
    echo -en "Reboot\0icon\x1fsystem-restart\n"
else
    if [ "$1" = "Shutdown" ]; then
        echo -en "Now\n30s\n1m"
    elif [ "$1" = "Exit" ]; then
        i3-msg exit
    elif [ "$1" = "Reboot" ]; then
        sudo reboot
    elif [ "$1" = "Suspend" ]; then
        system-ctl suspend
    fi
fi
