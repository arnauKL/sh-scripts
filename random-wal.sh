#!/usr/bin/env bash

# Get a random image from the in the WALLPAPER_DIR
# folder and save it to /var/tmp/selected-bg, then
# update bg

WALLPAPER_DIR="/home/ak/Images/MusicWallpapers/"
SELECTED_BG_FILE=/var/tmp/selected-bg

while true; do
    # randomly select 1
    SELECTED=$(ls -1 $WALLPAPER_DIR | shuf -n 1)
    
    # Your condition check
    if [ "$WALLPAPER_DIR$SELECTED" != "$(cat $SELECTED_BG_FILE)" ]; then
        break
    fi
done

# save to /var/tmp/selected-bg
echo $WALLPAPER_DIR$SELECTED > $SELECTED_BG_FILE

# restart swaybg
pkill swaybg && swaybg -i $(cat $SELECTED_BG_FILE) -m fill &

# notify user
notify-send "New wallpaper applied" "$SELECTED"
