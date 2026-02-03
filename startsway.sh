#!/bin/sh

# https://wiki.alpinelinux.org/wiki/OpenRC#For_Xorg
# Should not be necessary if running elogind but is
if [ -z "$XDG_RUNTIME_DIR" ]; then
	XDG_RUNTIME_DIR="/tmp/$(id -u)-runtime-dir"
	mkdir -pm 0700 "$XDG_RUNTIME_DIR"
	export XDG_RUNTIME_DIR
fi
openrc -U default

# Start D-Bus session
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval  $(dbus-launch --sh-syntax --exit-with-session)
fi

brightnessctl set 100
dunst &

exec sway
