#!/bin/bash

playerctl=$(which playerctl 2>/dev/null || echo /usr/bin/playerctl)
player=$($playerctl -l 2>/dev/null | head -n 1)

case "$1" in
    playpause)
        $playerctl play-pause 2>/dev/null
        ;;
    next)
        $playerctl next 2>/dev/null
        ;;
    prev)
        $playerctl previous 2>/dev/null
        ;;
    *)

        if [ -n "$player" ]; then
            format=$($playerctl -p "$player" metadata --format "{{ artist }} - {{ title }}")
            status=$($playerctl -p "$player" status)

            case "$status" in
                Playing)
                    icon=""
                    ;;
                Paused)
                    icon=""
                    ;;
                Stopped)
                    icon=""
                    ;;
                *)
            esac

            if [ -n "$status" ] && [ -n "$format" ]; then
                echo "${icon} ${format}"
            else
                echo "En lecture"
            fi
        else
            echo ""
        fi
        ;;
esac


    