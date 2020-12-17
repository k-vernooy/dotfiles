#!/bin/bash

MUSIC="$HOME/music"


function get_music() {
    IFS=$'\n'
    for i in $(ls "$MUSIC" | grep -v 'thumbs'); do
        name="${i%.*}"
        echo -en "${i}\0icon\x1f${MUSIC}/thumbs/${name}.png\n"
    done
}


if [ -z "$@" ]; then
    echo -en "Shuffle\0icon\x1fmedia-playlist-shuffle\n"
    get_music
else
    if [ "$1" = "Shuffle" ]; then
        $HOME/scripts/music/mpv-controller.sh start shuffle &
    else
        $HOME/scripts/music/mpv-controller.sh start "${MUSIC}/$1" &
    fi
fi
