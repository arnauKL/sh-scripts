#!/bin/sh

# Toggle on/off the opacity setting in alacritty

# Create a backup (.bak), run the edit, then compare
sed 's/opacity=1.0/opacity=0.8/' ~/.config/alacritty/alacritty.toml > /tmp/alacritty.bak 

if cmp -s /home/ak/.config/alacritty/alacritty.toml /tmp/alacritty.bak; then
    sed -i 's/opacity=0.8/opacity=1.0/' ~/.config/alacritty/alacritty.toml
    rm /tmp/alacritty.bak
else
    sed -i 's/opacity=0.8/opacity=1.0/' ~/.config/alacritty/alacritty.toml
    mv /tmp/alacritty.bak ~/.config/alacritty/alacritty.toml
fi
