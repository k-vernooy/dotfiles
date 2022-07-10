#!/bin/bash

SUBDIR_STATUS="$HOME/scripts/rofi/filebrowser-subdir.txt"
SUBDIR=""

get_subdir() {
    SUBDIR=$(cat "$SUBDIR_STATUS" | tr -d '\n')
}


function get_files() {
    IFS=$'\n'

    get_subdir

    for i in $(ls "$1/$SUBDIR" | grep -v 'thumbs' | shuf); do
        name="${i%.*}"
        
        if [ -d "$1/$SUBDIR/$i" ]; then
            echo -en "${i%%|*}\0icon\x1ffolder-music\n"    
        elif [ -f "${1}/thumbs/${name}.png" ]; then
            echo -en "${i%%|*}\0icon\x1f${1}/thumbs/${name}.png\n"
        else
            echo -en "${i%%|*}\0icon\x1faudio-midi\n"
        fi
    done
}


if [ "$#" -eq 1 ] && [ -d "$1" ]; then
    echo "" > $SUBDIR_STATUS
    echo -en "Shuffle\0icon\x1fmedia-playlist-shuffle\n"
    get_files "$1"
elif [ "$#" -gt 1 ]; then
    get_subdir

    if [[ "$2" == *"Shuffle"* ]]; then
        shufArg=""
        if [[ "$2" == *":"* ]]; then
            shufArg="$(echo "$2" | cut -d ":" -f2)"
        fi
        
        #mpv --shuffle "$1/$SUBDIR" > /dev/null &
        $HOME/scripts/music/mpv-controller.sh start shuffle "$1/$shufArg" &
        echo "" > $SUBDIR_STATUS
    elif [[ "$2" == "Back" ]]; then
        SUBDIR="$(echo "$SUBDIR" | rev | cut -d '/' -f 2- | rev)"
        echo "$SUBDIR" > $SUBDIR_STATUS
    
        echo -en "Shuffle:$SUBDIR\0icon\x1fmedia-playlist-shuffle\n"
        
        if [ "$SUBDIR" != "" ]; then
            echo -en "Back\0icon\x1farrow-left\n"
        fi

        get_files "$1"
     elif [ -d "$1/$SUBDIR/$2" ]; then
        echo "$SUBDIR/$2" > $SUBDIR_STATUS
        get_subdir

        echo -en "Shuffle:$SUBDIR\0icon\x1fmedia-playlist-shuffle\n"
        echo -en "Back\0icon\x1farrow-left\n"
        get_files "$1"
    else
        file="$(find "$1/$SUBDIR" -name "$(printf '%q\n' "$2")*" -not -path "$1/thumbs/*")"
        $HOME/scripts/music/mpv-controller.sh start "$file" &
        echo "" > $SUBDIR_STATUS
    fi
fi
