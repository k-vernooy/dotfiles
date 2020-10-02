#!/bin/bash

function get_music() {
    IFS=$'\n'
    for i in $(ls ~/Music | grep -v 'Podcasts\|Other\|thumbnails'); do
        name="${i%.*}"
        # name="t"
        echo -en "${i}\0icon\x1f${HOME}/Music/thumbnails/${name}.png\n"
    done
}

if [ -z "$@" ]; then
    echo -en "Shuffle\0icon\x1fmedia-playlist-shuffle\n"
    get_music
else
    if [ "$1" = "Shuffle" ]; then
        $HOME/Scripts/mpv-controller.sh start shuffle &
    else
        $HOME/Scripts/mpv-controller.sh start "${HOME}/Music/$1" &
    fi
fi
