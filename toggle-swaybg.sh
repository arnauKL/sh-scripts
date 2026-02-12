#!/usr/bin/env bash

if pgrep "swaybg" > /dev/null; then
    pkill swaybg;
    notify-send "Background off" "swaybg killed"
else
    swaybg -i $(cat /var/tmp/selected-bg) -m fill &
    notify-send "Background restored" "$(cat /var/tmp/selected-bg)"
fi
