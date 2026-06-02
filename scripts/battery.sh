#!/usr/bin/env bash

export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

cache_file="/tmp/battery_level"
max_age=300

acpi -b | grep -q "Charging" && exit 0

battery_level=$(acpi | grep -o '[0-9]\+%' | tr -d '%')

if [[ -z "$battery_level" || ! "$battery_level" =~ ^[0-9]+$ ]]; then
  notify-send -u critical "Battery data unavailable"
  exit 1
fi

if [[ -f "$cache_file" && -s "$cache_file" ]]; then
  age=$(( $(date +%s) - $(stat -c %Y "$cache_file") ))
  cached_level=$(< "$cache_file" tr -d '%')
  [[ "$age" -lt "$max_age" && "$cached_level" -eq "$battery_level" ]] && exit 0
fi

if [[ "$battery_level" -le 10 ]]; then
  urgency="critical" message="Battery critical"
elif [[ "$battery_level" -le 30 ]]; then
  urgency="low"    message="Battery low"
else
  exit 0
fi

echo "${battery_level}%" > "$cache_file"
notify-send -u "$urgency" "$message. Battery level is ${battery_level}%!"