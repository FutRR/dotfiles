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

            STATUS=$($PLAYERCTL -p "$PLAYER" status 2>/dev/null)

            case "$STATUS" in
                Playing)
                    ICON=""
                    ;;
                Paused)
                    ICON=""
                    ;;
                *)
                    ICON=""
                    ;;
            esac

            if [ "$STATUS" != "Playing" ] || [ -z "$($PLAYERCTL -p "$PLAYER" metadata --format '{{ album }}' 2>/dev/null)" ]; then
                echo "${ICON} $($PLAYERCTL -p "$PLAYER" metadata --format '{{ artist }} - {{ title }}')"    

                [[ "$($PLAYERCTL -p "$PLAYER" metadata 2>/dev/null)" == *"No player could handle this command"* ]] && echo "" && exit 0
            fi
                
        done

        echo "${ICON} $($PLAYERCTL -p chromium metadata --format '{{ artist }} - {{ title }}')"
        ;;
esac


    