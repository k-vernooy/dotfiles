export info='n user up cpu mem os wm sh term kern col n'
. ~/.bash_motd

export PATH=$PATH:/usr/local/go/bin:$HOME/.local/bin
export EDITOR="vim"

HISTSIZE=100000
HISTFILESIZE=600000

dwal() {
   wall $1 && wal -i $1
}


tmp_brightness() {
    echo "$1" | sudo tee /sys/class/backlight/radeon_bl0/brightness
}


md() {
    . ~/Venv/bin/activate
    youtube-dl -o "~/Music/%(title)s|%(id)s.%(ext)s" -x -- "$1"
    deactivate
}


pd() {
    . ~/Venv/bin/activate
    youtube-dl -o "~/Music/Podcasts/${1}/%(title)s.%(ext)s" -x "$2"
    deactivate
}


setGnomeDesktop() {
    gsettings set org.gnome.desktop.background picture-uri "file://${1}"
}


captains-log() {
   echo "$1|$2" >> Desktop/other/projects/ascii-trek/quotes/characters.txt
}


mkdcd() {
    mkdir $1
    cd $1
}


webp() {
    mkdir assets assets/css assets/js assets/img
    touch index.html assets/css/index.css
}


svim() {
    vim $1
    source $1
}


bashstat() {
    history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n10
}


mu() {
    mpv ~/Music/* --shuffle --input-ipc-server=/tmp/mpv-socket
}
