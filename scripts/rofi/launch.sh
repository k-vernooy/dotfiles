#!/bin/bash

menu="$1"

if [ "$menu" = "music" ]; then
    rofi -modi 'Music:~/scripts/rofi/music.sh' -show Music -theme music-launcher
elif [ "$menu" = "filebrowser" ]; then
    rofi -modi "Filebrowser:~/scripts/rofi/filebrowser.sh $2" -show Filebrowser -theme music-launcher
    
elif [ "$menu" = "appmenu" ]; then
    rofi -show drun -theme clean
elif [ "$menu" = "powermenu" ]; then
#    rofi -modi 'Powermenu:~/scripts/rofi/powermenu.sh' -show Powermenu -theme powermenu
    rofi -modi 'Powermenu:~/scripts/rofi/powermenu.sh' -show Powermenu -theme powermenu -location 3 -xoffset -30 -yoffset 100
    
elif [ "$menu" = "tabmenu" ]; then
    ~/scripts/rofi/tabmenu.sh
fi
