#!/bin/bash

oldFile=$1
mask="${oldFile%.*}-MASK.png"
newFile="${oldFile%.*}.png"
MUSIC=~/music/

WIDTH=100;

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