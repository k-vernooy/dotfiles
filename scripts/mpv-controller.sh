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


if [ "$cmd" = "skip" ]; then
    # Skip forward or backward $2 seconds
    currentPos=$(echo '{ "command": ["get_property", "time-pos"] }' | socat - $socket | jq .data)
    newPos=$(echo $currentPos + $2 | bc -l)
    echo "{ \"command\": [\"set_property\", \"time-pos\", \""$newPos"\"] }" | socat - $socket
elif [ "$cmd" = "skipper" ]; then
    # Skip forward or backward $2 percent
    currentPos=$(echo '{ "command": ["get_property", "percent-pos"] }' | socat - $socket | jq .data)
    newPos=$(echo $currentPos + $2 | bc -l)
    echo "{ \"command\": [\"set_property\", \"percent-pos\", \""$newPos"\"] }" | socat - $socket
elif [ "$cmd" = "prev" ]; then
    echo 'playlist-prev' | socat - $socket
elif [ "$cmd" = "next" ]; then
    echo 'playlist-next' | socat - $socket
elif [ "$cmd" = "pause" ]; then
    echo '{"command": ["cycle", "pause"]}' | socat - $socket
    isPaused=$(echo '{"command": ["get_property", "pause"]}' | socat - $socket | jq .data)
    title=$(echo '{"command": ["get_property", "media-title"]}' | socat - $socket | jq .data)
    

    if [ "$isPaused" = "true" ]; then
        notify-send "Paused: $title" -a "Music" -u low
    else
        notify-send "Resumed: $title" -a "Music" -u low 
    fi
elif [ "$cmd" = "restart" ]; then
    pkill -f "$HOME/Music"
    mu > /dev/null 2>&1 &
fi
