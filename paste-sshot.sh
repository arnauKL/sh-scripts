#!/usr/bin/bash

# Script to copy the last screenshot taken into the "assets" folder
# so that it can be easily accessed in markdown, LaTeX, Typst, etc.
#
# First get the filename of the last image in the screenshots folder
#
# Then get the name of the current directory
# 
# Check for "assets" folder, if it does not exist, create it in the current directory
#
# Last, create a copy of the file into the "assets" folder
#
# Cleanup and exit (send notification?)
#

# Get last image in Pictures directory (aka, the last screenshot)
filename=$(ls -t1 $HOME/Pictures/ | head -n 1)

# Make the dir if it does not exist
if [ ! -d "$(pwd)/assets" ]; then
    mkdir $(pwd)/assets
fi

cp $HOME/Pictures/$filename $(pwd)/assets/$1

echo "Image $1 copied into $(pwd)/assets"
notify-send "Image copied" "$1 copied into $(pwd)/assets"
