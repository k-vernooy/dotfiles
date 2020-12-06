#!/bin/bash

cwd=$(pwd)
cd ~/Music/thumbnails

IFS=$'\n'
for i in $(ls | grep -v '.sh$'); do
    nf="$(echo "$i" | rev | cut -d '.' -f 2- | rev).png"
    convert "$i" "$nf"
done

cd "$cwd"
