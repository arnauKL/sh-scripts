#!/usr/bin/env sh

# instead of a status bar, show info on a notification

BAT=$(cat /sys/class/power_supply/BAT0/capacity)
TIME=$(date +'%R')

notify-send --expire-time=10000 "   $TIME" "   $BAT%"
