#!/bin/bash

echo -en "This is a rudimentary install script for my dotfiles... PLEASE don't use this without knowing exactly what it does. Do you wish to continue? (\e[31my\e[0m/\e[32mn\e[0m)"

read cont
if [[ "$cont" != "y" ]]; then
    exit 1
fi


# get the script's directory
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# link my config directory
for i in $(ls ${dir}/config); do
    ln -s ${dir}/config/${i} ${HOME}/.config/
done

# link my home directory
for i in $(ls ${dir}/home); do
    ln -s ${dir}/home/${i} ${HOME}/.${i}
done

ln -s ${dir}/scripts/ ${HOME}/

echo "You're on your own for installing the nonstandard stuff in /apps/, individual apps in that dir may have instructions if I've gotten around to it..."
