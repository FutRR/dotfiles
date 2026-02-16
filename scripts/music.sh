#!/usr/bin/env bash

playerctl=$(which playerctl 2>/dev/null || echo /usr/bin/playerctl)

players=$($playerctl -l 2>/dev/null)                            # list of players

first=$(echo "$players" | head -n 1)                            # 1st player
second=$(echo "$players" | head -n 2 | tail -n 1)               # 2nd player

album=$($playerctl -p "$first" metadata album 2>/dev/null)      # value of album metadata for 1st player

player=$([ -n "$album" ] && echo "$first" || echo "$second")    # if 1st player has no album (not music) then display the 2nd one
                                                                # ex: display music over youtube video


case "$1" in
    playpause)
        $playerctl -p "$player" play-pause 2>/dev/null
        ;;
    next)
        $playerctl -p "$player" next 2>/dev/null
        ;;
    prev)
        $playerctl -p "$player" previous 2>/dev/null
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


    