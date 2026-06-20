#!/usr/bin/env bash

network=$(nmcli -t -f SSID device wifi list | rofi -dmenu -i)

password=$(printf '\n' | rofi -dmenu -password -mesg "Entrer le mot de passe")

if [ -n "$network" ] && [ -n "$password" ]; then
  nmcli device wifi connect "$network" password "$password" || notify-send -u critical "Impossible de se connecter au réseau $network"
fi
