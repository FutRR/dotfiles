#!/usr/bin/env bash

FOLDER=~/Images/wallpapers/
SCRIPT=~/dotfiles/scripts/pywal16.sh

menu() {
    if CHOICE=$(nsxiv -to "$FOLDER"/*); then
        [ -n "$CHOICE" ] && wal -i "$CHOICE" -o "$SCRIPT"
    fi
}

case "$#" in
    0) menu;;
    1) wal -i "$1" -o $SCRIPT;;
    *) exit 0;;
esac