#!/bin/bash

MUSIC="$HOME/music"


function get_music() {
    IFS=$'\n'
    for i in $(ls "$MUSIC/$1" | grep -v 'thumbs' | shuf); do
        name="${i%.*}"
        
        if [ -d "$MUSIC/$i" ]; then
            echo -en "${i%%|*}\0icon\x1ffolder-music\n"    
        elif [ -f "${MUSIC}/thumbs/${name}.png" ]; then
            echo -en "${i%%|*}\0icon\x1f${MUSIC}/thumbs/${name}.png\n"
        else
            echo -en "${i%%|*}\0icon\x1faudio-midi\n"
        fi
    done
}


if [ -z "$@" ]; then
    echo -en "Shuffle\0icon\x1fmedia-playlist-shuffle\n"
    get_music
else
    if [ "$1" = "Shuffle" ]; then
        $HOME/scripts/music/mpv-controller.sh start shuffle &
    elif [ -d "$MUSIC/$1" ]; then
        echo -en "Shuffle\0icon\x1fmedia-playlist-shuffle\n"
        get_music "$1"
    else
        file="$(find music/ -maxdepth 1 -name "$(printf '%q\n' "$1")*")"
        $HOME/scripts/music/mpv-controller.sh start "$file" &
    fi
fi
