. ~/.bash_motd

export PATH=$PATH:/usr/local/go/bin:$HOME/.local/bin
export EDITOR="vim"

tmp_brightness() {
    echo "$1" | sudo tee /sys/class/backlight/radeon_bl0/brightness
}

md() {
    . ~/Venv/bin/activate
    youtube-dl -o "~/Music/%(title)s.%(ext)s" -x "$1"
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


mkdcd() {
   mkdir $1
   cd $1
}
