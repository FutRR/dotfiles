#!/usr/bin/env bash

cache_file="/tmp/weather_strasbourg"
max_age=1800

if [ -f "$cache_file" ] && [ -n "$(cat "$cache_file")" ]; then
  age=$(( $(date +%s) - $(stat -c %Y "$cache_file") ))
  if [ "$age" -lt "$max_age" ]; then
    cat "$cache_file"
    exit 0
  fi
fi

weather=$(curl -H "Accept-Language: fr" https://wttr.in/Strasbourg?format="%l:+%C+%t\n")
if [ -n "$weather" ]; then
  echo "$weather" > "$cache_file"
  cat "$cache_file"
else
  if [ -f "$cache_file" ] && [ -n "$(cat "$cache_file")" ]; then
    cat "$cache_file"
  else
    echo "Weather data unavailable"
  fi
fi