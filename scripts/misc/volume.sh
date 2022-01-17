#!/bin/bash

ctl=/usr/bin/pulseaudio-ctl
lockfile=/home/kai/scripts/misc/volume-lockfile
iconDir="$HOME/.icons/tmp"

while [ -f "$lockfile" ]; do
    sleep 0.1;
done
touch "$lockfile"


getIcon() {
    status=$("$ctl" full-status)
    vol=$(echo "$status" | cut -d ' ' -f1)
    mute=$(echo "$status" | cut -d ' ' -f2)
    #echo $vol

    if [ "$mute" == "yes" ]; then
        echo "$iconDir/volume-level-muted.svg"
    else
        if [ "$vol" -eq 0 ]; then
            echo "$iconDir/volume-level-none.svg"
        elif [ "$vol" -lt 33 ]; then
            echo "$iconDir/volume-level-low.svg"
        elif [ "$vol" -lt 66 ]; then
            echo "$iconDir/volume-level-medium.svg"
        else
            echo "$iconDir/volume-level-high.svg"
        fi
    fi
}



val="5"
orig=$("$ctl" current | tr -d '%')
subinc=5


if [ "$1" == "mute" ]; then
    opt="mute"
    "$ctl" "$opt"
else
    if [ "$1" == "inc" ]; then
        opt="up"
        if ![ -z "$2" ]; then val="$2"; fi

    elif [ "$1" == "dec" ]; then
        opt="down"
        if ![ -z "$2" ]; then val="$2"; fi

    fi
    
    "$ctl" "$opt" "$val"
    
    # Fake the animated volume
    for i in $(seq "$val"); do
        operation="+"
        inverse="-"
        if [ "$1" == "dec" ]; then
            operation="-"
            inverse="+"
        fi

        current=$(( ($orig "$operation" $i) "$inverse" 1 ))
        if [ "$current" -lt 0 ]; then
            current=0
            rm "$lockfile"
            exit 1
        fi
        
        dunstify -i "$(getIcon)" -u low -h string:x-dunst-stack-tag:volume -a "Volume" "Volume at ${current}%" -h "int:value:${current}"
    done

fi

current=$("$ctl" current | tr -d '%')
dunstify -i "$(getIcon)" -u low -h string:x-dunst-stack-tag:volume -a "Volume" "Volume at $current" -h "int:value:${current}"


rm "$lockfile"
