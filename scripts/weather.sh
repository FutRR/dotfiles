#!/usr/bin/env bash

cache_file="/tmp/weather_strasbourg"
max_age=1800

if [ -f "$cache_file" ]; then
  age=$(( $(date +%s) - $(date -r "$cache_file" +%s) ))
  if [ "$age" -lt "$max_age" ]; then
    cat "$cache_file"
    exit 0
  fi
fi

curl -s "wttr.in/Strasbourg?format=%C%20|+%t%0A" > "$cache_file"
cat "$cache_file"