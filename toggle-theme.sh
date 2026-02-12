#!/usr/bin/env bash

if $(cat /var/tmp/light-theme) > /dev/null; then
    echo "light theme"
else
    echo "dark theme"
fi
# set dark theme
#gsettings set org.gnome.desktop.interface gtk-theme Adwaita

# set light theme
#gsettings set org.gnome.desktop.interface gtk-theme Breeze
