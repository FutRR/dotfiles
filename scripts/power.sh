#!/usr/bin/env bash

chosen=$(echo -e "[Cancel]\nLogout\nShutdown\nReboot\nSuspend" | rofi -dmenu -i  -theme ~/.config/rofi/power.rasi)

if [[ $chosen = "Logout" ]]; then
	jwm -exit
elif [[ $chosen = "Shutdown" ]]; then
	shutdown now
elif [[ $chosen = "Reboot" ]]; then
	shutdown -r now
elif [[ $chosen = "Suspend" ]]; then
	hyprlock
fi