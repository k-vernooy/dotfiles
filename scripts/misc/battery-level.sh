#!/bin/bash

# Set path for running in a cron job
PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/local/go/bin:/home/kai/.local/bin'

# Set limit to shell argument
batteryLimit=$1

# Get the current battery level with acpi
batteryLevel=$(acpi | cut -d ' ' -f 4 | tr -d '%|,| ')
charging=$(acpi | cut -d ' ' -f 3 | tr -d ',| ')

# Must have the Xdus file to run in a cron job. If this is not
# necessary functionality, this can be ignored, otherwise one must
# run the /scripts/xdbus.sh script in this repository at startup,
# which is called by default from my i3/config file.
if [ -r "$HOME/.dbus/Xdbus" ]; then
  . "$HOME/.dbus/Xdbus"
fi

if [[ "$batteryLevel" -le "$batteryLimit" ]] && [[ "$charging" == "Discharging" ]]; then
    notify-send -a "Battery Warning" --urgency critical "Battery level at ${batteryLevel}%" -i abrt
fi
