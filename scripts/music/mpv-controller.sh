#!/bin/bash

shopt -s extglob

# This script is used to control an mpv session
# connected to $socket. Can send signals
# to pause/play, rewind/fast-forward, advance/go back,
# and to restart the music process.
# Depends on socat and bc.
cmd=$1

SOCKET=/tmp/mpv-socket
VENV="$HOME/venv"
MUSICDIR="$HOME/music"
NOTIFIER="dunstify"
TAGSCRIPT="$MUSICDIR/metadata/tag.py"

notifyText=""
notifyTitle=""
img="gnome-music"

thumbs="/thumbs"

. "$VENV/bin/activate"

# Add mpv socket command sender - takes property string
getMpvProp() {
    echo "{ \"command\": [\"get_property\", \""$1"\"] }" | socat - $SOCKET | jq .data
}

getMpvPath() {
    getMpvProp "path" | sed 's/\/\//\//g' | cut -c 2- | rev | cut -c 2- | rev
}

sendMpvCmd() {
    echo "$1" | socat - "$SOCKET"
}

# TITLE=""
# ARTIST=""
# COMPOSER=""

getMetadataProp() {
    # echo "$(getMpvPath)"
    python3 "$TAGSCRIPT" get "$1" "$(getMpvPath)" #| fold -s -w 20 | python3 ~/scripts/misc/center-multiline.py
    # TITLE="$(echo "$tags" | grep "TITLE" | cut -d ':' -f 2-)"
    # ARTIST="$(echo "$tags" | grep "ARTIST" | cut -d ':' -f 2-)"
    # COMPOSER="$(echo "$tags" | grep "COMPOSER" | cut -d ':' -f 2-)"
}


# Get the truncated title
getTitle() {
    while [ "$(getMpvProp seeking | tr -d '\n')" == "null" ]; do
        echo "waiting" > /dev/null
    done
    
    title=$(getMpvProp 'media-title' | tr -d '"' | rev | cut -d '|' -f2- | rev);
    if [ "${#title}" -gt 50 ]; then
        title="$(echo "$title" | cut -c 1-50)..."
    fi
    echo "$title"
}


getTitlePlain() {
    while [ "$(getMpvProp seeking | tr -d '\n')" == "null" ]; do
        echo "waiting" > /dev/null
    done
    
    echo "$(getMpvProp 'media-title' | tr -d '"')"
}


getThumb() {
    title=$(getTitlePlain)

    if [ "$title" != "" ]; then
        secondHalf=$(echo "$title" | rev | cut -d '|' -f 1 | cut -d '.' -f2- | rev)
        find "${MUSICDIR}${thumbs}/" -maxdepth 1 -name "*$(printf '%q\n' "$(echo "$title" | cut -d '|' -f1)" )*" -exec realpath {} \;
    fi
}


setupNotif() {
    # notifyText="$(getTitle | iconv -c -t UTF-8)"
    if [ "$(getMetadataProp "")" = "" ]; then
        notifyTitle="Music"
        notifyText="$(getTitle | iconv -c -t UTF-8)"
    else
        notifyTitle="$(getMetadataProp COMPOSER)"
        notifyText="$(getMetadataProp TITLE) - $(getMetadataProp ARTISTS)"
    fi
    title=$(getTitlePlain)
    secondHalf=$(echo "$title" | rev | cut -d '|' -f 1 | cut -d '.' -f2- | rev)

    # find "${MUSICDIR}${thumbs}/" -maxdepth 1 -name "*$(printf '%q\n' "$(echo "$title" | cut -d '|' -f1)" )*" -exec realpath {} \;

    img=$(find "${MUSICDIR}${thumbs}/" -maxdepth 1 -name "*$(printf '%q\n' "$(echo "$title" | cut -d '|' -f1)" )*" -exec realpath {} \; | grep "$secondHalf" | grep '.png$')  
    progress="-h int:value:$(getMpvProp 'percent-pos')"
}


# Apply different commands based on shell args
if [ "$cmd" = "seek" ]; then
    sendMpvCmd "seek $2"
    setupNotif
elif [ "$cmd" = "seek-percent" ]; then
    sendMpvCmd "seek $2 relative-percent"
    setupNotif
elif [ "$cmd" = "seek-chapter" ]; then
    exit
elif [ "$cmd" = "prev" ]; then
    sendMpvCmd "playlist-prev"
elif [ "$cmd" = "next" ]; then
    sendMpvCmd "playlist-next"
elif [ "$cmd" = "pause" ]; then
    sendMpvCmd "cycle pause"
    setupNotif
elif [ "$cmd" = "stop" ]; then
    pkill -f "mpv --script=~/.config/mpv/scripts-manual/notify.lua"
    notifyTitle="Music"
    notifyText="MPV process killed"
    progress=""
elif [ "$cmd" = "start" ]; then
    #pkill -f "mpv --script=~/.config/mpv/scripts-manual/notify.lua"
    
    if [ "$2" = "shuffle" ]; then
        #playDir=~/music/!(*misc/)
        #if [ "$3" != "" ]; then
        #    playDir=~/music/$3/*
        #fi
        playDir="$3"
        mpv --script=~/.config/mpv/scripts-manual/notify.lua --input-ipc-server="${SOCKET}" --shuffle -- "$playDir" > /dev/null 2>&1 &
    else
        echo "$2" > ~/toasters.txt
        mpv --script=~/.config/mpv/scripts-manual/notify.lua --input-ipc-server="${SOCKET}" -- "$2"  > /dev/null 2>&1 &
    fi
    
    # sleep 0.5
elif [ "$cmd" = "vol" ]; then
    sendMpvCmd "add volume $2"
elif [ "$cmd" = "notif" ]; then
    setupNotif
elif [ "$cmd" = "mpvtitle" ]; then
    getTitle | iconv -c -t UTF-8
elif [ "$cmd" = "get" ]; then
    getMetadataProp "$2"
elif [ "$cmd" = "getmpv" ]; then
    getMpvProp "$2"
elif [ "$cmd" = "thumb" ]; then
    getThumb
elif [ "$cmd" = "title" ]; then
    getTitle
fi


echo "$notifyText" | grep -axv '.*'


if [ "$notifyText" != "" ]; then
#    "$NOTIFIER" "$notifyText" $progress -h string:x-dunst-stack-tag:music -a "$(getMetadataProp COMPOSER)" -u low -i "$img"
    "$NOTIFIER" -a "$notifyTitle" "$notifyText" $progress -r 98294 -u low -i "$img"
fi
