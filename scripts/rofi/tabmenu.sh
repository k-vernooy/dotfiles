#!/bin/bash

xdotool search --sync --syncsleep 50 --limit 1 --class Rofi keyup --delay 0 Tab key --delay 0 Tab keyup --delay 0 Super_L keydown --delay 0 Super_L&

rofi \
    -show window -theme powermenu \
    -kb-cancel "Super+Escape,Escape" \
    -kb-accept-entry "ISO_Left_Tab,!Super-Tab,!Super_L,!Super+Super_L,Return"\
    -kb-row-down "Super+Tab,Super+Down" \
    -kb-row-up "Super+ISO_Left_Tab,Super+Shift+Tab,Super+Up"&
