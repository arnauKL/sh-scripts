#!/usr/bin/env sh

#https://github.com/BryceVandegrift/dotfiles/blob/master/.local/bin/webcam

mpv --untimed --no-cache --no-osc --no-input-default-bindings --profile=low-latency \
	--input-conf=/dev/null --no-config --title=webcam --aid=no --sid=no \
	"$(find /dev/video* 2>/dev/null | head -n 1)" >/dev/null 2>&1 || \
	notify-send "Cannot open webcam."
