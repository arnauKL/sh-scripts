#!/usr/bin/env bash

# Wrapper to set volume and show a notification
# usage: "sh change-vol.sh up/down/mute"

# change volume with pactl

case "$1" in
  up)
    pactl set-sink-volume @DEFAULT_SINK@ +5%
    ;;
  down)
    pactl set-sink-volume @DEFAULT_SINK@ -5%
    ;;
  mute)
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    ;;
  *)
    echo "Usage: $0 {up|down|mute}"
    exit 1
    ;;
esac

#get the volume

#credit: 'oceanicc' on codeberg: https://codeberg.org/oceanicc/dots/src/branch/main/.local/scripts/volume
volume_full="$(wpctl get-volume @DEFAULT_SINK@)" # Volume: 0.07
vol="${volume_full##*: }"                   # 0.07

echo "vol: $vol"

[ "$vol" = "${vol##*\ }" ] && {     # 0.07 [MUTED] ?
    vol="${vol%%.*}${vol##*.}"      # 007
    #disp="${vol#${vol%%[!0]*}}"     # 007 # 00
    disp="${disp:}%"              # ''  ? 0 + %
} || unset vol

echo "vol: $vol"

# check if muted
muted=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

# notification
if [ "$muted" = "yes" ]; then
  notify-send -h string:x-canonical-private-synchronous:volume \
    " 󰝛 "
else
  notify-send -h int:value:$vol \
    -h string:x-canonical-private-synchronous:volume \
    "   $volume_full"
fi
