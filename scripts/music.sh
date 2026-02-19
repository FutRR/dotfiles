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
        ACTIVE_PLAYER=""
        PAUSED_PLAYER=""
        for PLAYER in $PLAYERS; do

            STATUS=$($PLAYERCTL -p "$PLAYER" status 2>/dev/null)

            if [[ "$STATUS" == "Playing" ]]; then
                ACTIVE_PLAYER="$PLAYER"
                break
            elif [[ "$STATUS" == "Paused" && -z "$PAUSED_PLAYER" ]]; then
                PAUSED_PLAYER="$PLAYER"
            fi

        done

        if [[ -n "$ACTIVE_PLAYER" ]]; then
            echo " $($PLAYERCTL -p "$ACTIVE_PLAYER" metadata --format '{{ artist }} - {{ title }}')"
        elif [[ -n "$PAUSED_PLAYER" ]]; then
            echo " $($PLAYERCTL -p "$PAUSED_PLAYER" metadata --format '{{ artist }} - {{ title }}')"
        else
            echo ""
        fi
        ;;
esac