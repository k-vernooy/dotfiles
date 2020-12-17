#!/bin/bash

SONG=$1
MUSIC="$HOME/music"
DM=1
DT=1

. $HOME/dev/venv/bin/activate


if [ "$DM" -eq 1 ]; then
    youtube-dl -o "$MUSIC/%(title)s|%(id)s.%(ext)s" -x -- "$SONG"
fi
if [ "$DT" -eq 1 ]; then
    youtube-dl --write-thumbnail --skip-download -o "$MUSIC/thumbs/%(title)s|%(id)s.%(ext)s" -- "$SONG"

    oldFile=$(ls "$MUSIC/thumbs" | grep "$(echo "$1" | cut -d '=' -f 2)") 
    newFile="${oldFile%.*}.png"

    convert "$MUSIC/thumbs/$oldFile" "$MUSIC/thumbs/$newFile"
    rm "${MUSIC}/thumbs/${oldFile}"
fi


deactivate
