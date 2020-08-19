#================================
# Utilities and mirrors to macOS
#================================
alias open="xdg-open"
alias audio-reset="pulseaudio -k && sudo alsa force-reload"
alias copy='xclip -sel clip'
alias gogh="wget -O gogh https://git.io/vQgMr && chmod +x gogh && ./gogh && rm gogh"

alias l='ls'
alias ll='ls -alF'
alias la='ls -A'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//
;s/[;&|]\s*alert$//'\'')"'

alias i3-config="vim ~/.config/i3/config"

#=======================
# Music playing aliases
#=======================
alias wmht="mpv 'https://wmht.streamguys1.com/wmht1'"
alias mu="mpv ~/Music/* --shuffle"

#==========================================
# Navigational and terminal control aliases
#==========================================
alias dt="cd ~/Desktop"
alias e="exit"
alias c="clear"
alias bp="vim ~/.bash_profile && source ~/.bash_profile"
alias p="cd ~/Desktop/dev"
