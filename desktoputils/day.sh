#!/usr/bin/env sh

# turn from dark into light mode
LIGHT_BG="$HOME/Pictures/wallpapers/palmtree.JPG"

ALACRITTY_THEME="$HOME/.config/alacritty/current-theme.toml"
LIGHT_ALACRITTY_THEME="$HOME/.config/alacritty-theme/themes/ashes_light.toml"

NIRI_THEME="$HOME/.config/niri/color.kdl"

# makes smooth transition
niri msg action do-screen-transition

# Handles both GTK and Qt
dconf write /org/gnome/desktop/interface/color-scheme "\"prefer-light\""

# Alacritty theme
cp $LIGHT_ALACRITTY_THEME $ALACRITTY_THEME


# Niri Background
echo 'layout { background-color "#e0e0e0"; }' > "$NIRI_THEME"

# Only switch bg if swaybg is running
echo $LIGHT_BG > /var/tmp/selected-bg
pkill swaybg && swaybg -i "$(cat /var/tmp/selected-bg)" -m fill
