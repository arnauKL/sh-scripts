#!/usr/bin/env sh

# configured to work on arch + labwc

# bg (swaybg)
#pkill swaybg; swaybg -i "$(cat /var/tmp/selected-bg)" -m fill &
#pkill swaybg && swaybg -c "#e0e0e0" &

gsettings set org.gnome.desktop.interface color-scheme "prefer-light"
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"

# foot
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/foot/foot.ini"
sed -i 's/initial-color-theme=[0-9]*/initial-color-theme=2/' "$CONFIG"

pkill -u "$USER" --signal=SIGUSR2 ^foot$

notify-send "Light mode"
