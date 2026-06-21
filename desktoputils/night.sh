#!/usr/bin/env sh

# configured to work on arch + labwc

gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface gtk-application-prefer-dark-theme true

# foot
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/foot/foot.ini"
sed -i 's/initial-color-theme=light*/initial-color-theme=dark/' "$CONFIG"

pkill -u "$USER" --signal=SIGUSR1 ^foot$

# clement bar and border colors:
rm ~/.config/clement/colors
ln ~/.config/clement/yellow_darkcolors ~/.config/clement/colors

# kde apps
kwriteconfig6 --file kdeglobals --group General --key ColorScheme BreezeDark
kwriteconfig6 --file kdeglobals --group KDE --key LookAndFeelPackage org.kde.breezedark.desktop

notify-send "Dark mode"
