#!/bin/bash


. ~/Venv/bin/activate

for i in $(ls ~/Music | grep -v 'Other\|Podcasts' | cut -d '|' -f 2 | sed -e 's/.opus//g'); do
    youtube-dl --write-thumbnail --skip-download -o "~/Music/thumbnails/%(title)s|%(id)s.%(ext)s" -- "$i"
done

deactivate
