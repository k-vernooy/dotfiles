#!/bin/bash

subinc=5
subchange=$(echo "1 / $subinc" | bc -l)
delay=$(echo "(0.02 / $2)/$subinc" | bc -l)
opt=""


if [ "$1" == "inc" ]; then
    opt="-A"
else
    opt="-U"
fi


for i in $(seq $2); do
    for i in $(seq $subinc); do
        sudo light $opt "$subchange"
        sleep "$delay"
    done
done
