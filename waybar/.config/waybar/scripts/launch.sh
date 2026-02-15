#!/bin/bash

CONFIG="$HOME/dotfiles/waybar/.config/waybar/config.jsonc"
STYLE="$HOME/dotfiles/waybar/.config/waybar/style.css"

killall waybar
waybar &

while inotifywait -e modify "$CONFIG" "$STYLE"; do
    killall waybar
    waybar  &
done