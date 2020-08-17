. ~/.bash_motd

export PATH=$PATH:/usr/local/go/bin
export EDITOR="vim"

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
