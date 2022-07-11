#!/bin/bash

shopt -s extglob

# This script is used to control an mpv session
# connected to $socket. Can send signals
# to pause/play, rewind/fast-forward, advance/go back,
# and to restart the music process.
# Depends on socat and bc.
cmd=$1
socket=/tmp/mpv-socket

notifier="dunstify"

notifyText=""
img="gnome-music"

musicDir=~/music
thumbs="/thumbs"

# . ~/.bash_profile > /dev/null 2>&1


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
    
    title=$(getProp 'media-title' | tr -d '"' | rev | cut -d '|' -f2- | rev);
    if [ "${#title}" -gt 50 ]; then
        title="$(echo "$title" | cut -c 1-50)..."
    fi
    echo "$title"
}

getTitlePlain() {
    while [ "$(getProp seeking | tr -d '\n')" == "null" ]; do
        echo "waiting" > /dev/null
    done
    
    echo "$(getProp 'media-title' | tr -d '"')"
}


setupNotif() {
    notifyText="$(getTitle | iconv -c -t UTF-8)"

    title=$(getTitlePlain)
    secondHalf=$(echo "$title" | rev | cut -d '|' -f 1 | cut -d '.' -f2- | rev)

    echo "$title"
    find "${musicDir}${thumbs}/" -maxdepth 1 -name "*$(printf '%q\n' "$(echo "$title" | cut -d '|' -f1)" )*" -exec realpath {} \;

    img=$(find "${musicDir}${thumbs}/" -maxdepth 1 -name "*$(printf '%q\n' "$(echo "$title" | cut -d '|' -f1)" )*" -exec realpath {} \; | grep "$secondHalf" | grep '.png$')  
    progress="-h int:value:$(getProp 'percent-pos')"
}


# Apply different commands based on shell args
if [ "$cmd" = "skip" ]; then
    sendCmd "seek $2"
    setupNotif
elif [ "$cmd" = "skipper" ]; then
    sendCmd "seek $2 relative-percent"
    setupNotif
elif [ "$cmd" = "prev" ]; then
    sendCmd "playlist-prev"
elif [ "$cmd" = "next" ]; then
    sendCmd "playlist-next"
elif [ "$cmd" = "pause" ]; then
    sendCmd "cycle pause"
    setupNotif
elif [ "$cmd" = "stop" ]; then
    pkill -f "mpv --script=~/.config/mpv/scripts-manual/notify.lua"
    notifyText="Music process killed"
    progress=""
elif [ "$cmd" = "start" ]; then
    pkill -f "mpv --script=~/.config/mpv/scripts-manual/notify.lua"
    
    if [ "$2" = "shuffle" ]; then
        #playDir=~/music/!(*misc/)
        #if [ "$3" != "" ]; then
        #    playDir=~/music/$3/*
        #fi
        playDir="$3"
        mpv --script=~/.config/mpv/scripts-manual/notify.lua --input-ipc-server="${socket}" -- $playDir > /dev/null 2>&1 &
    else
        mpv --script=~/.config/mpv/scripts-manual/notify.lua --input-ipc-server="${socket}" -- "$2"  > /dev/null 2>&1 &
    fi
    
    # ...why is this here??
    # sleep 0.5
elif [ "$cmd" = "vol" ]; then
    sendCmd "add volume $2"
elif [ "$cmd" = "info" ]; then
    setupNotif
elif [ "$cmd" = "infotext" ]; then
    getTitle | iconv -c -t UTF-8
fi

echo "$notifyText" | grep -axv '.*'


if [ "$notifyText" != "" ]; then
    $notifier "$notifyText" $progress -h string:x-dunst-stack-tag:music -a "Composer" -u low -i "$img"
fi
