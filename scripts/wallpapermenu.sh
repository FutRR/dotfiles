#!/usr/bin/env bash

FOLDER=~/Images/wallpapers/
SCRIPT=~/dotfiles/scripts/waybar_reload.sh

CACHE_FILE="/tmp/current_wallpaper.png"

menu() {
    if CHOICE=$(nsxiv -to "$FOLDER"/*); then
        [ -n "$CHOICE" ] && wal -i "$CHOICE" -o "$SCRIPT"
        cp "$CHOICE" "$CACHE_FILE"
    fi
}

case "$#" in
    0) menu;;
    1) if [ "$1" = "-r" ]; then
            RANDOM_WALL=$(find "$FOLDER" -type f -print0 | shuf -z -n 1 | xargs -0 echo)
            cp "$RANDOM_WALL" "$CACHE_FILE" && wal -i "$RANDOM_WALL" -o "$SCRIPT"
       else
           wal -i "$1" -o "$SCRIPT"
       fi;;
    *) exit 0;;
esac