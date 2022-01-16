#!/bin/bash

# Set path for running in a cron job
PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/local/go/bin:/home/kai/.local/bin'

# Must have the Xdus file to run in a cron job. If this is not
# necessary functionality, this can be ignored, otherwise one must
# run the /scripts/xdbus.sh script in this repository at startup,
# which is called by default from my i3/config file.
if [ -r "$HOME/.dbus/Xdbus" ]; then
  . "$HOME/.dbus/Xdbus"
fi


notify-send "$@"
