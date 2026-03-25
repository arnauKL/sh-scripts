#!/bin/sh

INTERNAL="eDP-1"

case "$1" in
    on)
        # Screen is currently OFF, turn it ON
        #xrandr --output "$INTERNAL" --auto # on x11
        wlr-randr --output "$INTERNAL" --on # on wayland
        echo $INTERNAL 'now on'
    ;;

    off)
        # Screen is currently ON, turn it OFF
        #xrandr --output "$INTERNAL" --off # on x11
        wlr-randr --output "$INTERNAL" --off # on wayland
        echo $INTERNAL 'now off'
    ;;

    toggle)
        # wayland only bcs idk hown to do this on xrandr
        wlr-randr --output "$INTERNAL" --toggle # on wayland
        echo $INTERNAL 'toggled'
    ;;

    *)
        echo 'usage: ' $0 ' [on/off(/toggle wayland only)]'
    ;;
esac
