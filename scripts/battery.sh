#!/usr/bin/env bash

export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

battery_level=$(/usr/bin/acpi | grep -oP '(?<=, )\d+(?=%)')
cache_file="/tmp/battery_level"
max_age=300

send(){

  local message="$1"
  local current_level="$2"

  local age=""
  # Check if cache file exists and is not empty, then calculate its age
  if [[ -f "$cache_file" && -s "$cache_file" ]]; then
    age=$(( $(date +%s) - $(stat -c %Y "$cache_file") ))
  fi

  local cached_level=""
  # If cache file exists and is not empty, extract the cached battery level
  if [[ -f "$cache_file" && -s "$cache_file" ]]; then
    cached_level=$(grep -oP '\d+(?=%)' < "$cache_file")
  fi

  # If the cache is still valid and the battery level hasn't changed, resend the cached message
  if [[ -n "$age" && "$age" -lt "$max_age" &&
        -n "$cached_level" && -n "$current_level" &&
        "$cached_level" -eq "$current_level" ]]; then
    /usr/bin/notify-send "$(<"$cache_file")"
  # If the battery level has changed or the cache is too old, send a new notification and update the cache
  elif [[ -n "$message" ]]; then
    echo "$message" > "$cache_file"
    /usr/bin/notify-send "$message"
  else
      echo "Battery data unavailable"
  fi
}

# Validate battery level is a number and not empty
if [[ -z "$battery_level" || ! "$battery_level" =~ ^[0-9]+$ ]]; then
  send "Battery data unavailable"
  exit 1
fi

# Check if cache file exists and is not empty, then calculate its age
if [ -f "$cache_file" ] && [ -n "$(cat "$cache_file")" ]; then
  age=$(( $(date +%s) - $(stat -c %Y "$cache_file") ))
fi

# Send notifications based on battery level
if [ "$battery_level" -le 10 ]
then
  send "Battery critical. Battery level is ${battery_level}%!" "$battery_level"
elif [ "$battery_level" -le 40 ]
then
  send "Battery low. Battery level is ${battery_level}%!" "$battery_level"
fi