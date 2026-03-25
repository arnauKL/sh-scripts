#!/usr/bin/env sh

niri msg action do-screen-transition
dconf write /org/gnome/desktop/interface/color-scheme "\"prefer-dark\""
