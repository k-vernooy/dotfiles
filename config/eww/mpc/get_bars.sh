#!/bin/bash

. ~/venv/bin/activate
TAGSCRIPT=~/music/metadata/tag.py

LENGTH=490
MINLENGTH=24

curFile="$(echo "{ \"command\": [\"get_property\", \""path"\"] }" | socat - /tmp/mpv-socket | jq .data | sed 's/\/\//\//g' | cut -c 2- | rev | cut -c 2- | rev)"
# duration=$(python3 "$TAGSCRIPT" get "DURATION" "$curFile" | cut -d "." -f1)
duration=$(~/scripts/music/mpv-controller.sh getmpv duration | cut -d '.' -f1)

type="$1"

ewwLengthPadded() {
    printf "%.0f" "$(echo "x=(($1 / $2) * $3); if(x<0) print \"0\"; if (x>=0) print x" | bc -l)"
}

ewwLength() {
    printf "%.0f" "$(echo "x=(($1 / $2) * $3) - 1; if(x<0) print \"0\"; if (x>=0) print x" | bc -l)"
}

curTime="$(~/scripts/music/mpv-controller.sh getmpv "playback-time" | cut -d "." -f1)"
timestamps="$(python3 "$TAGSCRIPT" get "TIMESTAMPS" "$curFile")"

lasttime=0

if [ "$timestamps" = "" ]; then
    if [ "$type" = "title" ]; then
        exit
    else
        prog=$(ewwLengthPadded "$curTime" "$duration" "$LENGTH")
        prog=$(( prog > MINLENGTH ? prog : MINLENGTH ))
    
        printf "(box :space-evenly false :orientation 'h' 
        '' (progress-segment :width $LENGTH :prog $prog ) )"
        exit
    fi
fi

timestamps="$(echo "$timestamps" | sort -n)
$duration"

if [ "$type" = "title" ]; then
    lasttitle="$(echo "$timestamps" | head -n1 | cut -d ':' -f2-)"
fi

firstgt="true"

if [ "$type" = "bar" ]; then
    printf  "(box :space-evenly false :orientation 'h' 
    ''"
fi

while IFS= read -r line; do
    time="$(echo "$line" | cut -d ":" -f1)"

    segdur=$((time - lasttime))
    seglength="$(ewwLengthPadded "$segdur" "$duration" "$LENGTH")"

    if [ "$seglength" -gt "0" ]; then
        seglength=$(( seglength > MINLENGTH ? seglength : MINLENGTH ))

        # echo "$seglength"
        # if [ "$seglength" -lt 13 ]; then
        #     #idk mate
        #     continue
        if [ "$time" -lt "$curTime" ]; then
            if [ "$type" = "bar" ]; then
                printf "(progress-segment :width $seglength :prog $((seglength - 2))) "
            fi
        elif [ "$time" -ge "$curTime" ] && [ "$firstgt" = "true" ]; then
            # pogress
            
            if [ "$type" = "bar" ]; then
                # prog="$( ewwLength $((curTime - lasttime)) $segdur $((seglength)) )"
                # printf "(progress-segment :width $seglength :prog $(( prog ))) "
                prog="$( ewwLength $((curTime - lasttime)) $segdur $((seglength - MINLENGTH)) )"
                printf "(progress-segment :width $seglength :prog $(( prog + MINLENGTH - 2 ))) "
            elif [ "$type" = "title" ]; then
                echo "$lasttitle"
            fi
            firstgt="false"
        else
            if [ "$type" = "bar" ]; then
                printf "(progress-segment :width $seglength :prog 0 :hidden true) "
            fi
            # echo "fullemptybar"
        fi
    fi

    lasttitle="$(echo "$line" | cut -d ":" -f2-)"
    lasttime="$time"
done <<< "$timestamps"

if [ "$type" = "bar" ]; then
    printf ")"
fi