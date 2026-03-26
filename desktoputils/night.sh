#!/usr/bin/env sh

# turn from light to dark mode
DARK_BG="$HOME/Pictures/wallpapers/IMG_6688.JPEG"

ALACRITTY_THEME="$HOME/.config/alacritty/current-theme.toml"
DARK_ALACRITTY_THEME="$HOME/.config/alacritty-theme/themes/zenburn.toml"

NIRI_THEME="$HOME/.config/niri/color.kdl"

niri msg action do-screen-transition
dconf write /org/gnome/desktop/interface/color-scheme "\"prefer-dark\""

cp $DARK_ALACRITTY_THEME $ALACRITTY_THEME

# Niri Background
echo 'layout { background-color "#2a2a2a"; }' > "$NIRI_THEME"

# Only switch bg if swaybg is running
echo $DARK_BG > /var/tmp/selected-bg
pkill swaybg && swaybg -i "$(cat /var/tmp/selected-bg)" -m fill
