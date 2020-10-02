#!/bin/bash

# This script is used to control an mpv session
# connected to $socket. Can send signals
# to pause/play, rewind/fast-forward, advance/go back,
# and to restart the music process.
# Depends on socat and bc.
cmd=$1
socket=/tmp/mpv-socket
notifyText=""

# Note: sources bash profile because this program
#       relies on the 'mu' function, which plays
#       my music directory on shuffle.
. ~/.bash_profile > /dev/null 2>&1


# Add mpv socket command sender - takes property string
getProp() {
    echo "{ \"command\": [\"get_property\", \""$1"\"] }" | socat - $socket | jq .data
}

sendCmd() {
    echo "$1" | socat - "$socket"
}

# Get the truncated title
getTitle() {
    while [ "$(getProp seeking | tr -d '\n')" == "null" ]; do
        echo "waiting" > /dev/null
    done
    
    title=$(getProp 'media-title' | tr -d '"');
    if [ "${#title}" -gt 35 ]; then
        title="$(echo "$title" | cut -c 1-35)..."
    fi
    echo "$title"
}


# Apply different commands based on shell args
if [ "$cmd" = "skip" ]; then
    sendCmd "seek $2"
elif [ "$cmd" = "skipper" ]; then
    sendCmd "seek $2 relative-percent"
elif [ "$cmd" = "prev" ]; then
    sendCmd "playlist-prev"
elif [ "$cmd" = "next" ]; then
    sendCmd "playlist-next"
elif [ "$cmd" = "pause" ]; then
    sendCmd "cycle pause"
elif [ "$cmd" = "stop" ]; then
    pkill -f "mpv --input-ipc-server"
    notifyText="Music process killed"
elif [ "$cmd" = "start" ]; then
    pkill -f "mpv --input-ipc-server"
    if [ "$2" = "shuffle" ]; then
        mu > /dev/null 2>&1 &
    else
        mpv --input-ipc-server="${socket}" -- "${2}"  > /dev/null 2>&1 &
    fi
    sleep 0.5
elif [ "$cmd" = "vol" ]; then
    sendCmd "add volume $2"
elif [ "$cmd" = "info" ]; then
    notifyText="$(getTitle)"
fi


if [ "$notifyText" != "" ]; then
    notify-send "$notifyText" -a "Music" -u low -i gnome-music
fi
