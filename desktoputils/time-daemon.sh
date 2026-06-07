#!/usr/bin/env sh

sleep 5

while true; do
    ~/.local/scripts/desktoputils/statusbar.sh

    # Calculate seconds until the next :00 or :30 mark
    SLEEP_TIME=$(( 1800 - $(date +%s) % 1800 ))

    # 3. Wait until the next interval
    sleep "$SLEEP_TIME"
done



