#!/bin/bash


lock=~/scripts/misc/backlight-lockfile

while [ -f "$lock" ]; do
    echo "process changing backlight already exists" > /dev/null
done

touch "$lock"


subinc=2
opt=""
subchange=$(echo "1/$subinc" | bc -l)

if [ "$1" == "inc" ]; then
    opt="-A"
else
    opt="-U"
fi

for i in $(seq $2); do
    for i in $(seq $subinc); do
        sudo light $opt "$subchange"
    done
done


rm "$lock"

