#!/usr/bin/env sh

# configured to work on arch + labwc

gsettings set org.gnome.desktop.interface color-scheme "prefer-light"
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
gsettings set org.gnome.desktop.interface gtk-application-prefer-dark-theme false

# foot
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/foot/foot.ini"
sed -i 's/initial-color-theme=dark*/initial-color-theme=light/' "$CONFIG"

pkill -u "$USER" --signal=SIGUSR2 ^foot$

# clement bar and borders
rm ~/.config/clement/colors
ln ~/.config/clement/yellow_lightcolors ~/.config/clement/colors

# kde apps
kwriteconfig6 --file kdeglobals --group General --key ColorScheme BreezeLight
kwriteconfig6 --file kdeglobals --group KDE --key LookAndFeelPackage org.kde.breezelight.desktop

notify-send "Light mode"
