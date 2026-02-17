#!/usr/bin/env bash

FOLDER=~/Images/wallpapers/
SCRIPT=~/dotfiles/scripts/waybar_reload.sh

menu() {
    if CHOICE=$(nsxiv -to "$FOLDER"/*); then
        [ -n "$CHOICE" ] && wal -i "$CHOICE" -o "$SCRIPT"
    fi
}

case "$#" in
    0) menu;;
    1) if [ "$1" = "-r" ]; then
           wal -i "$FOLDER" -o $SCRIPT
       else
           wal -i "$1" -o $SCRIPT
       fi;;
    *) exit 0;;
esac