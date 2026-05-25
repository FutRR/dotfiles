#!/usr/bin/env bash

export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

battery_level=$(/usr/bin/acpi | grep -o '[0-9]\+%' | tr -d '%')
cache_file="/tmp/battery_level"
max_age=300

if acpi -b | grep -q "Charging"; then
  exit 0
fi

send() {
  local message="$1"
  local current_level="$2"
  local urgency="$3"
  local age=""
  local cached_level=""

  if [[ -f "$cache_file" && -s "$cache_file" ]]; then
    age=$(( $(date +%s) - $(stat -c %Y "$cache_file") ))
    cached_level=$(grep -oP '\d+(?=%)' < "$cache_file")
  fi

  if [[ -n "$age" && "$age" -lt "$max_age" &&
        -n "$cached_level" && -n "$current_level" &&
        "$cached_level" -eq "$current_level" ]]; then
    exit 0
  elif [[ -n "$message" ]]; then
    echo "${current_level}%" > "$cache_file"
    /usr/bin/notify-send -u "$urgency" "$message"
  else
    echo "Battery data unavailable"
  fi
}

if [[ -z "$battery_level" || ! "$battery_level" =~ ^[0-9]+$ ]]; then
  send "Battery data unavailable" "$battery_level" "critical"
  exit 1
fi

if [ "$battery_level" -le 10 ]; then
  send "Battery critical. Battery level is ${battery_level}%!" "$battery_level" "critical"
elif [ "$battery_level" -le 40 ]; then
  send "Battery low. Battery level is ${battery_level}%!" "$battery_level" "low"
fi