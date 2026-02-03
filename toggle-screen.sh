#!/bin/sh

INTERNAL="eDP-1"

case "$1" in
    on)
        # Screen is currently OFF, turn it ON
        xrandr --output "$INTERNAL" --auto
        echo $INTERNAL 'now on'
    ;;

    off)
        # Screen is currently ON, turn it OFF
        xrandr --output "$INTERNAL" --off
        echo $INTERNAL 'now off'
    ;;
    *)
        echo 'usage: ' $0 ' [on/off]'
    ;;
esac
