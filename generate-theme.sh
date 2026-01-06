#!/usr/bin/env bash

# Script to generate colorschemes based on an image using
# wallust (modern pywal written in rust)
# Generates themes for all apps/daemons visible when using
# dwl, dwl-bar, mako, etc.

set -e
# set -e:  Exit immediately if a command exits with a non-zero status (set man page)

# Check user input (terrible)
case "$1" in
    "")
        echo "image filepath needed"
        exit
    ;;
    *)
    # wallust generates colorschemes from all the templates defined (mako, foot, etc)
    wallust pywal -i "$1"
    ;;
esac

dwl_dir="$HOME/Documentos/Projects/ak-DE/dwl-ak/dwl-colors.h"

# Generate dwl colors
wallust pywal -i "$1"

# set background color back to black
export BACKGROUND="#000000"

### dwl

# Copy colors.h file generated from the template to dwl dir
cp $HOME/.config/wallust/outputs/dwl-colors.h "$dwl_dir"

# Correct the color formatting; #00ff3355 --> 0x00ff3355
sed -i 's/ #/ 0x/g' "$dwl_dir"  # -i for inplace

# Recompile dwl and install
cd "$HOME/Documentos/Projects/ak-DE/dwl-ak/" && make clean && make && sudo make install

# tell when done
notify-send "Colorscheme updated" "Restart session to view (Alt+Shift+Q)"

