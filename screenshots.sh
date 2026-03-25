#!/usr/bin/env bash

# slurp selects geometry, grim takes the screenshot, satty annotates and saves
grim -g "$(slurp -c '#770000ff')" | satty --filename - --output-filename ~/Pictures/Screenshots/$(date '+%Y%m%d-%H:%M:%S').png
