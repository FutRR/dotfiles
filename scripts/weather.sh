#!/usr/bin/env bash

cache="/tmp/waybar_weather"
lock="/tmp/waybar_weather.lock"
max_age=1800

exec 200>"$lock"
flock -n 200 || { cat "$cache" 2>/dev/null; exit 0; }

now=$(date +%s)

if [ -f "$cache" ]; then
    age=$((now - $(stat -c %Y "$cache")))
else
    age=$max_age
fi

if [ "$age" -ge "$max_age" ]; then
    weather=$(curl -s -A "waybar-weather" -H "Accept-Language: fr" \
    "https://wttr.in/Strasbourg?format=%l:+%C+%t")

    if [[ -n "$weather" && "$weather" != *"processed"* ]]; then
        echo "$weather" > "$cache"
    fi
fi

cat "$cache" 2>/dev/null || echo "Weather unavailable"