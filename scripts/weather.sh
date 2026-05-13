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
    weather=$(curl -s --fail --max-time 10 -A "waybar-weather" -H "Accept-Language: fr" \
    "https://wttr.in/Strasbourg?format=%C+%t")
curl_exit=$?

if [[ $curl_exit -ne 0 ]]; then
    : # curl failed (timeout, network error, or --fail triggered on 4xx/5xx)
elif [[ -z "$weather" ]]; then
    : # empty response
elif [[ "$weather" == *"processed"* || "$weather" == *"exceeded"* || "$weather" == *"error"* ]]; then
    : # known error strings in body
elif [[ ! "$weather" =~ ^[A-Za-z] ]]; then
    : # sanity check: valid response should start with a location name
else
    echo "$weather" > "$cache"
fi
fi

cat "$cache" 2>/dev/null || echo "Weather unavailable"