#!/bin/bash

# This script is used to control an mpv session
# connected to $socket. Can send signals
# to pause/play, rewind/fast-forward, advance/go back,
# and to restart the music process.
# Depends on socat and bc.
cmd=$1
socket=/tmp/mpv-socket


# Note: sources bash profile because this program
#       relies on the 'mu' function, which plays
#       my music directory on shuffle.
. ~/.bash_profile


# Add mpv socket command sender - takes property string
getProp() {
    echo "{ \"command\": [\"get_property\", \""$1"\"] }" | socat - $socket | jq .data
}

setProp() {
    echo "{ \"command\": [\"set_property\", \""$1"\", \""$2"\"] }" | socat - $socket
}

cycleProp() {
    echo "{ \"command\": [\"cycle\", \""$1"\"] }" | socat - $socket
}


# Get the truncated title
getTitle() {
    title=$(getProp 'media-title');
    if [ "${#title}" -gt 35 ]; then
        title="$(echo "$title" | cut -c 1-35)..."
    fi
    echo "$title"
}


# Set blank notification text
notifyText=""


# Apply different commands based on shell args
if [ "$cmd" = "skip" ]; then
    newPos=$(echo "$(getProp "time-pos")" + "$2" | bc -l)
    setProp "time-pos" "$newPos"
elif [ "$cmd" = "skipper" ]; then
    newPos=$(echo "$(getProp "percent-pos")" + "$2" | bc -l)
    setProp "percent-pos" "$newPos"
elif [ "$cmd" = "prev" ]; then
    echo 'playlist-prev' | socat - $socket
    notifyText="Playing $(getTitle)"
elif [ "$cmd" = "next" ]; then
    echo 'playlist-next' | socat - $socket
    notifyText="Playing $(getTitle)"
elif [ "$cmd" = "pause" ]; then
    cycleProp "pause"
    title=$(getTitle)
    if [ "$(getProp 'pause')" = "true" ]; then
        notifyText="Paused: $title"
    else
        notifyText="Resumed $title" 
    fi
elif [ "$cmd" = "restart" ]; then
    pkill -f "$HOME/Music"
    mu > /dev/null 2>&1 &
fi


if [ "$notifyText" != "" ]; then
    notify-send "$notifyText" -a "Music" -u low -i deepin-music
fi
