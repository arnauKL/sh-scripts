#!/usr/bin/bash

# Get battery device (e.g., /org/freedesktop/UPower/devices/battery_BAT0)
BATTERY_PATH=$(upower -e | grep BAT0)

# Function to get current percentage
get_percentage() {
    upower -i "$BATTERY_PATH" | awk '/percentage:/ {gsub("%",""); print $2}'
}

# Listen for changes on the battery
gdbus monitor --system --dest org.freedesktop.UPower --object-path "$BATTERY_PATH" | while read -r line; do
    if echo "$line" | grep -q "PropertiesChanged"; then
        percent=$(get_percentage)
        if [ "$percent" -lt 20 ]; then
            notify-send -u critical "Battery low" "Battery is at ${percent}%"
        fi
        if [ "$percent" -lt 5 ]; then
            notify-send -u critical "Battery very low" "Battery is at ${percent}%, plug into AC."
        fi
    fi
done
