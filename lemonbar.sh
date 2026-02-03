#!/bin/sh

case "$1" in
    time)
        # Print the percentage
        while true; do
            echo " %{r} $(date +'%a %d %b, %R')  "
            sleep 30
        done
    ;;
    battery)
        # Print the percentage
        while true; do
            echo " %{r} $(cat /sys/class/power_supply/BAT0/capacity)%  "
            sleep 30
        done
    ;;
    *)
    exit 1
    ;;

esac

