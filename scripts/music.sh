#!/usr/bin/env bash

PLAYERCTL=$(which playerctl 2>/dev/null || echo /usr/bin/playerctl)

PLAYERS=$($PLAYERCTL -l 2>/dev/null) # list of players


case "$1" in
    playpause)
        $PLAYERCTL play-pause 2>/dev/null
        ;;
    next)
        $PLAYERCTL next 2>/dev/null
        ;;
    prev)
        $PLAYERCTL previous 2>/dev/null
        ;;
    *)

        for PLAYER in $PLAYERS; do
            [ "$(playerctl --player="$PLAYER" status 2>/dev/null)" != "Playing" ] && continue
                ICON=""
                echo "${ICON} $($PLAYERCTL -p "$PLAYER" metadata --format '{{ artist }} - {{ title }}')"
        done

        ICON=""
        echo "${ICON} $($PLAYERCTL -p chromium metadata --format '{{ artist }} - {{ title }}')"
        ;;
esac


    