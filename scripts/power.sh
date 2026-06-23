#!/usr/bin/env bash

chosen=$(echo -e "[Cancel]\nLogout\nShutdown\nReboot\nSuspend" | rofi -dmenu -i  -theme ~/.config/rofi/power.rasi)

case $chosen in
	"Cancel")
		exit 0
		;;
	"Logout")
		jwm -exit
		;;
	"Shutdown")
		shutdown now
		;;
	"Reboot")
		shutdown -r now
		;;
	"Suspend")
		hyprlock
		;;
esac