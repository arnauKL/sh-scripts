#!/bin/sh

INTERNAL="eDP-1"

case "$1" in
    image)
        pkill swaybg; swaybg -i $(cat /var/tmp/selected-bg 2>/dev/null) -m fill 2>/dev/null &
    ;;
    gray)
        pkill swaybg; swaybg -c "#e0e0e0" 2>/dev/null &
    ;;

    off)
        pkill swaybg;
    ;;
    "")
        pkill swaybg || (swaybg -i $(cat /var/tmp/selected-bg 2>/dev/null) -m fill 2>/dev/null) &
    ;;
    *)
        echo 'usage: ' $0 ' [image/gray/off]'
    ;;
esac
