# Export fet.sh info
export info='n user up cpu mem os wm sh term kern col n'

# Use gtk theme
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# Get message in terminal
. ~/.bash_motd

# Set env vars
export PATH=$PATH:/usr/local/go/bin:$HOME/.local/bin:$HOME/.cargo/bin
export EDITOR="vim"
export HISTSIZE=-1
export HISTFILESIZE=-1

md() {
    . ~/Venv/bin/activate
    youtube-dl -o "~/Music/%(title)s|%(id)s.%(ext)s" -x -- "$1"
    deactivate
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
    history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n15
}

mu() {
    mpv ~/Music/* --shuffle --input-ipc-server=/tmp/mpv-socket
}
