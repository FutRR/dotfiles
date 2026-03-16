#!/usr/bin/env bash

output=$(wpctl status | awk '/Sinks:/ {flag=1; next}/Sources:/ {flag=0}flag && match($0, /([0-9]+)\.\s+(.*)\s+\[vol/, a) {print a[1], a[2]}' | rofi -dmenu -i -theme ~/dotfiles/rofi/.config/rofi/audio.rasi )

id=$(echo "$output" | grep -oP '^[^0-9]*\K[0-9]+')

[ -z "$chosen" ] && wpctl set-default "$id"
