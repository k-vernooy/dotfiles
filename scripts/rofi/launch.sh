#!/bin/bash

menu="$1"

if [ "$menu" = "music" ]; then
    rofi -modi 'Music:~/Scripts/rofi/rofi-music.sh' -show Music -theme music
elif [ "$menu" = "drun" ]; then
    rofi -show drun -theme clean
elif [ "$menu" = "powermenu" ]; then
    rofi -modi 'Powermenu:~/Scripts/rofi/rofi-powermenu.sh' -show Powermenu -theme powermenu
#    rofi -modi 'Powermenu:~/Scripts/rofi/rofi-powermenu.sh' -show Powermenu -theme powermenu -location 3 -xoffset -24 -yoffset 70
fi
