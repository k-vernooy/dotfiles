#!/bin/bash

MUSIC="$HOME/music"
SUBDIR_STATUS="$HOME/scripts/rofi/music-subdir.txt"
SUBDIR=""


get_subdir() {
    SUBDIR=$(cat "$SUBDIR_STATUS" | tr -d '\n')
}


function get_music() {
    IFS=$'\n'
    get_subdir

    for i in $(ls "$MUSIC/$SUBDIR" | grep -v 'thumbs' | shuf); do
        name="${i%.*}"
        
        if [ -d "$MUSIC/$SUBDIR/$i" ]; then
            echo -en "${i%%|*}\0icon\x1ffolder-music\n"    
        elif [ -f "${MUSIC}/thumbs/${name}.png" ]; then
            echo -en "${i%%|*}\0icon\x1f${MUSIC}/thumbs/${name}.png\n"
        else
            echo -en "${i%%|*}\0icon\x1faudio-midi\n"
        fi
    done
}



if [ -z "$@" ]; then
    echo "" > $SUBDIR_STATUS
    echo -en "Shuffle\0icon\x1fmedia-playlist-shuffle\n"
    get_music
else
    get_subdir
    if [[ "$1" == *"Shuffle"* ]]; then
        shufArg=""
        if [[ "$1" == *":"* ]]; then
            shufArg="$(echo "$1" | cut -d ":" -f2)"
        fi
        $HOME/scripts/music/mpv-controller.sh start shuffle "$MUSIC/$shufArg" &
        echo "" > $SUBDIR_STATUS
    elif [[ "$1" == "Back" ]]; then
        SUBDIR="$(echo "$SUBDIR" | rev | cut -d '/' -f 2- | rev)"
        echo "$SUBDIR" > $SUBDIR_STATUS
    
        echo -en "Shuffle:$SUBDIR\0icon\x1fmedia-playlist-shuffle\n"
        
        if [ "$SUBDIR" != "" ]; then
            echo -en "Back\0icon\x1farrow-left\n"
        fi
        get_music
     elif [ -d "$MUSIC/$SUBDIR/$1" ]; then
        echo "$SUBDIR/$1" > $SUBDIR_STATUS

        get_subdir
        echo -en "Shuffle:$SUBDIR\0icon\x1fmedia-playlist-shuffle\n"
        echo -en "Back\0icon\x1farrow-left\n"
        get_music
    else
        file="$HOME/$(find "music/$SUBDIR" -name "$(printf '%q\n' "$1")*" -not -path "music/thumbs/*")"
        $HOME/scripts/music/mpv-controller.sh start "$file" "" &
        echo "" > $SUBDIR_STATUS
    fi
fi
