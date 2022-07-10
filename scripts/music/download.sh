#!/bin/bash

SONG=$1
MUSIC="$HOME/music"

checkM="$2"
checkT="$3"
name='%(title)s'

if [ "$2" == "-n" ] || [ "$2" == "--name" ]; then
    name="$3"
    checkM="$4"
    checkT="$5"
fi

if [ -z "$checkM" ]; then DM=1; else DM="$checkM"; fi
if [ -z "$checkT" ]; then DT=1; else DT="$checkT"; fi


. $HOME/venv/bin/activate


if [ "$DM" -eq 1 ]; then
   yt-dlp -f "bestaudio" --extract-audio -o "$MUSIC/$name|%(id)s.%(ext)s" -- "$SONG"
fi
if [ "$DT" -eq 1 ]; then
    yt-dlp --write-thumbnail --skip-download -o "$MUSIC/thumbs/$name|%(id)s.%(ext)s" -- "$SONG"

    oldFile=$(ls "$MUSIC/thumbs" | grep -- "$(echo "$1" | cut -d '=' -f 2)") 
    echo "oldfile $oldFile" 
    mask="${oldFile%.*}-MASK.png"
    newFile="${oldFile%.*}.png"

    W=$(identify -format "%[w]" "$MUSIC/thumbs/$oldFile")
    H=$(identify -format "%[h]" "$MUSIC/thumbs/$oldFile")

    offsetX=0
    offsetY=0
    smallerDim=0

    if [ "$W" -lt "$H" ]; then
        offsetY=$(( ( $H - $W ) / 2))
        smallerDim=$W
    else
        offsetX=$(( ( $W - $H ) / 2))
        smallerDim=$H
    fi

    echo $W $H $offsetX $offsetY

    # can prob consolidate the cropping
    convert -size "$W"x"$H" xc:none -draw "roundrectangle $offsetX,$offsetY,$(($smallerDim + $offsetX)),$(($smallerDim + $offsetY)),$(echo "0.05 * $smallerDim" | bc),$(echo "0.08 * $smallerDim" | bc)" "$MUSIC/thumbs/$mask"
    convert "$MUSIC/thumbs/$oldFile" -matte "$MUSIC/thumbs/$mask" -compose DstIn -composite "$MUSIC/thumbs/$newFile"
    convert "$MUSIC/thumbs/$newFile" -crop "$smallerDim"x"$smallerDim"+"$offsetX"+"$offsetY" "$MUSIC/thumbs/$newFile"
    
    #703x470+3+5
    rm "${MUSIC}/thumbs/${oldFile}" "$MUSIC/thumbs/$mask"
fi


echo "tagging $(ls "$MUSIC" | grep -- "$(echo "$1" | cut -d '=' -f 2)")"
python3 ~/music/metadata/tag.py add "$MUSIC/$(ls "$MUSIC" | grep -- "$(echo "$1" | cut -d '=' -f 2)")"

deactivate
