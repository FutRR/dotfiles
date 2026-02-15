#!/bin/bash

PLAYERCTL="$(which playerctl 2>/dev/null || echo /usr/bin/playerctl)"

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
        player=$($PLAYERCTL -l 2>/dev/null | head -n 1)

        if [ -n "$player" ]; then
            artist=$($PLAYERCTL -p "$player" metadata artist 2>/dev/null)
            title=$($PLAYERCTL -p "$player" metadata title 2>/dev/null)

            if [ -n "$artist" ] || [ -n "$title" ]; then
                echo " ${artist} - ${title}"
            else
                echo " En lecture"
            fi
        else
            echo ""
        fi
        ;;
esac


    # open)
    #     url=$("$PLAYERCTL" metadata xesam:url 2>/dev/null)
    #     if [ -n "$url" ]; then
    #         xdg-open "$url"
    #     fi
    #   ;;