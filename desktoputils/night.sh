#!/usr/bin/env sh

# configured to work on arch + labwc

# bg (swaybg)
#pkill swaybg; swaybg -i "$(cat /var/tmp/selected-bg)" -m fill &
#pkill swaybg; swaybg -c "#5a5a5a" & # neutral gray-ish
#pkill swaybg && swaybg -c "#3c3836" &

gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"

#pgrep -x waybar && pkill waybar && waybar &

# foot
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/foot/foot.ini"
sed -i 's/initial-color-theme=[0-9]*/initial-color-theme=1/' "$CONFIG"

pkill -u "$USER" --signal=SIGUSR1 ^foot$

notify-send "Dark mode"
